
 /*------------------------------------------------------------------------
    File        : DSLogManagerAppender
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed May 30 15:06:42 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.AbstractLogAppender.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LogAppender.DSLogManagerAppender INHERITS AbstractLogAppender IMPLEMENTS ILogAppender:
    
    METHOD PUBLIC OVERRIDE VOID setProperty(INPUT pcPropertyName AS CHARACTER, INPUT pcPropertyValue AS CHARACTER):
        SUPER:setProperty(INPUT pcPropertyName, INPUT pcPropertyValue).
        
        CASE TRIM(pcPropertyName):
            
            WHEN "filename" THEN
            DO:
                IF DSLOG-MANAGER:LOGFILE-NAME = ? THEN
                DO:
                    ASSIGN DSLOG-MANAGER:LOGFILE-NAME = pcPropertyValue.
                END.
            END.
            
            WHEN "loglevel" THEN
            DO:
                setLogManagerLogLevel(LogLevel:getLogLevelFromText(pcPropertyValue, DSLOG-MANAGER:LOGGING-LEVEL)).
            END.
                        
        END.
        
    END METHOD.
    
    METHOD PRIVATE VOID setLogManagerLogLevel(INPUT piLogLevel AS INTEGER):
        
        DEFINE VARIABLE viLoggingLevel AS INTEGER NO-UNDO.
        
        ASSIGN viLoggingLevel = convertLogLevelToLogManagerLoggingLevel(piLogLevel).
        
        IF viLoggingLevel > DSLOG-MANAGER:LOGGING-LEVEL THEN
        DO:
            ASSIGN DSLOG-MANAGER:LOGGING-LEVEL = viLoggingLevel.
        END.
        
    END METHOD.
    
    METHOD PRIVATE INTEGER convertLogLevelToLogManagerLoggingLevel(INPUT piLogLevel AS INTEGER):
                
        CASE piLogLevel:
            
            WHEN LogLevel:OFF THEN
                RETURN 0.

            WHEN LogLevel:ERROR OR WHEN LogLevel:FATAL THEN
                RETURN 1.

            WHEN LogLevel:WARN THEN
                RETURN 2.

            WHEN LogLevel:INFO THEN
                RETURN 3.

            WHEN LogLevel:DEBUG OR WHEN LogLevel:TRACE OR WHEN LogLevel:ALL THEN
                RETURN 4.
                
            OTHERWISE
                RETURN -1.
            
        END CASE.
        
    END METHOD.

    METHOD PUBLIC OVERRIDE VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcSubsystem AS CHARACTER, INPUT pcMessage AS CHARACTER):
        
        ASSIGN pcMessage = "[" + LogLevel:getLogLevelFixedWidthDesc(piLogLevel) + "] " + pcMessage.

        IF pcSubsystem NE "" AND pcSubsystem NE ? THEN
        DO:
            DSLOG-MANAGER:WRITE-MESSAGE(pcMessage, pcSubsystem).
        END.
        ELSE IF VALID-OBJECT(Config) AND Config:getSubsystemName() NE "" AND Config:getSubsystemName() NE ? THEN
        DO:
            DSLOG-MANAGER:WRITE-MESSAGE(pcMessage, Config:getSubsystemName()).
        END.
        ELSE
        DO:
            DSLOG-MANAGER:WRITE-MESSAGE(pcMessage).
        END.

    END METHOD.

END CLASS.
