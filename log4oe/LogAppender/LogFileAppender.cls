 
 /*------------------------------------------------------------------------
    File        : LogFileAppender
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Wed Apr 17 15:46:14 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.AbstractLogAppender.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LogAppender.ILogFileAppender.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LogAppender.LogFileAppender INHERITS AbstractLogAppender IMPLEMENTS ILogAppender, ILogFileAppender: 
    
    DEFINE PRIVATE PROPERTY OutputFileName AS CHARACTER NO-UNDO INITIAL ?
    PRIVATE GET.
    PRIVATE SET.
    
    DEFINE PRIVATE PROPERTY LogFileOpen AS LOGICAL NO-UNDO INITIAL FALSE
    PRIVATE GET.
    PRIVATE SET.
    
    DEFINE PRIVATE PROPERTY Buffered AS LOGICAL NO-UNDO INITIAL FALSE
    PRIVATE GET.
    PRIVATE SET.
    
    DEFINE PRIVATE PROPERTY Append AS LOGICAL NO-UNDO INITIAL TRUE
    PRIVATE GET.
    PRIVATE SET.
    
    DEFINE PRIVATE STREAM OutputFile.
    
    CONSTRUCTOR LogFileAppender(INPUT pcOutputFileName AS CHARACTER):
        SUPER().  
        OutputFileName = pcOutputFileName.      
    END CONSTRUCTOR.
    
    CONSTRUCTOR LogFileAppender():
        SUPER().
    END CONSTRUCTOR.
    
    DESTRUCTOR LogFileAppender():
        
        CloseStream().
        
    END DESTRUCTOR.
    
    METHOD PUBLIC OVERRIDE VOID Initialise():
        
        OpenStream().
        
    END METHOD.
    
    METHOD PRIVATE VOID OpenStream():
        
        IF TRIM(OutputFileName) = "" OR OutputFileName = ? THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Output file name is not set of LogFileAppender").
        END.
        
        IF NOT Buffered AND Append THEN
        DO:
            OUTPUT STREAM OutputFile TO VALUE(OutputFileName) UNBUFFERED APPEND.
        END.
        ELSE IF NOT Buffered AND NOT Append THEN
        DO:
            OUTPUT STREAM OutputFile TO VALUE(OutputFileName) UNBUFFERED.
        END.
        ELSE IF Buffered AND Append THEN
        DO:
            OUTPUT STREAM OutputFile TO VALUE(OutputFileName) APPEND.
        END.
        ELSE
        DO:
            OUTPUT STREAM OutputFile TO VALUE(OutputFileName).
        END.
        
        LogFileOpen = TRUE.
        
    END METHOD.
    
    METHOD PRIVATE VOID CloseStream():
        IF LogFileOpen THEN
        DO:
            OUTPUT STREAM OutputFile CLOSE.
            LogFileOpen = FALSE.
        END.
    END METHOD.
    
    METHOD PUBLIC OVERRIDE VOID setProperty(INPUT pcPropertyName AS CHARACTER, INPUT pcPropertyValue AS CHARACTER):
        SUPER:setProperty(INPUT pcPropertyName, INPUT pcPropertyValue).
        
        CASE TRIM(pcPropertyName):
            
            WHEN "filename" THEN
            DO:
                setOutputFileName(pcPropertyValue).
            END.
            
            WHEN "buffered" THEN
            DO:
                setBuffered(pcPropertyValue = "y" OR pcPropertyValue = "yes" OR pcPropertyValue = "true" OR pcPropertyValue = "t" OR pcPropertyValue = "1").
            END.
            
            WHEN "append" THEN
            DO:
                setAppend(NOT(pcPropertyValue = "n" OR pcPropertyValue = "no" OR pcPropertyValue = "false" OR pcPropertyValue = "f" OR pcPropertyValue = "0")).
            END.
            
        END.
        
    END METHOD.
    
    METHOD PRIVATE VOID setOutputFileName(INPUT pcOutputFileName AS CHARACTER):
        ASSIGN OutputFileName = pcOutputFileName.
    END METHOD.
    
    METHOD PUBLIC CHARACTER getOutputFileName():
        RETURN OutputFileName.
    END METHOD.
    
    METHOD PRIVATE VOID setBuffered(INPUT plBuffered AS LOGICAL):
        ASSIGN Buffered = plBuffered.
    END METHOD.
    
    METHOD PUBLIC LOGICAL getBuffered():
        RETURN Buffered.
    END METHOD.
    
    METHOD PRIVATE VOID setAppend(INPUT plAppend AS LOGICAL):
        ASSIGN Append = plAppend.
    END METHOD.
    
    METHOD PUBLIC LOGICAL getAppend():
        RETURN Append.
    END METHOD.
    
    METHOD PUBLIC OVERRIDE VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcSubsystemName AS CHARACTER, INPUT pcMessage AS CHARACTER):
        
        DEFINE VARIABLE vdtzNow AS DATETIME-TZ NO-UNDO.
        
        ASSIGN vdtzNow = NOW.
        
        /* Double check if stream is open */
        IF NOT LogFileOpen THEN
        DO:
            OpenStream().
        END.
        
        IF pcSubsystemName EQ "" OR pcSubsystemName EQ ? AND VALID-OBJECT(Config) AND Config:getSubsystemName() NE "" AND Config:getSubsystemName() NE ? THEN
        DO:
            ASSIGN pcSubsystemName = Config:getSubsystemName().
        END.
        
        PUT STREAM OutputFile UNFORMATTED
            "[" ISO-DATE(vdtzNow) "] "
            IF pcSubsystemName NE "" AND pcSubsystemName NE ? THEN
                "[" + pcSubsystemName + "] "
            ELSE
                ""
            "[" + LogLevel:getLogLevelFixedWidthDesc(INPUT piLogLevel) + "] "
            pcMessage
            SKIP.
        
    END METHOD.

END CLASS.