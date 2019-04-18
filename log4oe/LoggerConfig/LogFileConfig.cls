 
 /*------------------------------------------------------------------------
    File        : LogFileConfig
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Wed Apr 17 16:11:35 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogLevel.
USING log4oe.LoggerConfig.AbstractLoggerConfig.
USING log4oe.LoggerConfig.ILoggerConfig.
USING log4oe.Logger.ILogger.
USING log4oe.LogAppender.LogFileAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.LogFileConfig INHERITS AbstractLoggerConfig IMPLEMENTS ILoggerConfig:
    
    DEFINE PROTECTED PROPERTY OutputDirectory AS CHARACTER NO-UNDO
    PROTECTED GET.
    PRIVATE SET.
    
    DEFINE PROTECTED PROPERTY DirectorySeparator AS CHARACTER NO-UNDO
    PROTECTED GET():
        IF OPSYS = "Unix" THEN
        DO:
            RETURN "/".
        END.
        ELSE
        DO:
            RETURN "~\".
        END.
    END GET.

    METHOD PUBLIC OVERRIDE VOID Initialise():
        
        setLogLevel(LogLevel:WARN).
        setOutputDirectory(".").

    END METHOD.

    METHOD PUBLIC OVERRIDE VOID ConfigureLogger(INPUT poLogger AS ILogger):

        DEFINE VARIABLE voAppender AS LogFileAppender NO-UNDO.

        poLogger:setLoggerConfig(THIS-OBJECT).

        ASSIGN voAppender = NEW LogFileAppender(INPUT OutputDirectory + poLogger:getLoggerName() + ".log").

        voAppender:setLoggerConfig(THIS-OBJECT).

        poLogger:addLogAppender(voAppender).

    END METHOD.
    
    METHOD PUBLIC CHARACTER getOutputDirectory():
        RETURN OutputDirectory.
    END METHOD.
    
    METHOD PUBLIC VOID setOutputDirectory(INPUT pcOutputDirectory AS CHARACTER):
        
        ASSIGN pcOutputDirectory = TRIM(pcOutputDirectory).
        
        IF pcOutputDirectory = "" OR pcOutputDirectory = ? THEN
        DO:
            ASSIGN pcOutputDirectory = ".".
        END.
        
        // Ensure there is a trailing slash
        IF SUBSTRING(pcOutputDirectory, LENGTH(pcOutputDirectory), 1) NE DirectorySeparator THEN
        DO:
            ASSIGN pcOutputDirectory = pcOutputDirectory + DirectorySeparator.
        END.
        
        ASSIGN OutputDirectory = pcOutputDirectory.
        
    END METHOD.

END CLASS.