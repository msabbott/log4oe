
 /*------------------------------------------------------------------------
    File        : Logger
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Tue May 29 20:09:03 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING log4oe.LogLevel.
USING log4oe.Logger.ILogger.
USING log4oe.LoggerFactory.
USING log4oe.LoggerConfig.Configuration.
USING log4oe.LoggerConfig.BasicConfiguration.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Logger:

    DEFINE PROTECTED STATIC PROPERTY DefaultLogger AS ILogger NO-UNDO
    PROTECTED GET.
    PROTECTED SET.
    
    DEFINE PROTECTED STATIC PROPERTY DefaultConfiguration AS Configuration NO-UNDO
    PROTECTED GET.
    PROTECTED SET.
    
    METHOD PROTECTED STATIC VOID InitialiseDefaultConfiguration():

        IF NOT VALID-OBJECT(DefaultConfiguration) THEN
        DO:
            DELETE OBJECT DefaultLogger NO-ERROR.
            ASSIGN DefaultConfiguration = NEW BasicConfiguration().
            DefaultConfiguration:Apply().
        END.
        
    END METHOD.

    METHOD PROTECTED STATIC VOID InitialiseDefaultLogger():

        IF NOT VALID-OBJECT(DefaultLogger) THEN
        DO:
            ASSIGN DefaultLogger = LoggerFactory:getLogger().
        END.

    END METHOD.

    METHOD PUBLIC STATIC VOID ResetLogger():

        DELETE OBJECT DefaultLogger NO-ERROR.
        DELETE OBJECT DefaultConfiguration NO-ERROR.

    END METHOD.

    METHOD PUBLIC STATIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcMessage AS CHARACTER):

        InitialiseDefaultConfiguration().
        InitialiseDefaultLogger().
        DefaultLogger:Log(INPUT piLogLevel, INPUT pcMessage).

    END METHOD.

    METHOD PUBLIC STATIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT peError AS Progress.Lang.Error):

        InitialiseDefaultConfiguration().
        InitialiseDefaultLogger().
        DefaultLogger:Log(INPUT piLogLevel, INPUT peError).

    END METHOD.

    METHOD PUBLIC STATIC VOID TRACE (INPUT pcMessage AS CHARACTER):
        log4oe.Logger:Log(INPUT LogLevel:TRACE, INPUT pcMessage).
    END METHOD.

    METHOD PUBLIC STATIC VOID TRACE (INPUT peError AS Progress.Lang.Error):
        log4oe.Logger:Log(INPUT LogLevel:TRACE, INPUT peError).
    END METHOD.

    METHOD PUBLIC STATIC VOID DEBUG (INPUT pcMessage AS CHARACTER):
        log4oe.Logger:Log(INPUT LogLevel:DEBUG, INPUT pcMessage).
    END METHOD.

    METHOD PUBLIC STATIC VOID DEBUG (INPUT peError AS Progress.Lang.Error):
        log4oe.Logger:Log(INPUT LogLevel:DEBUG, INPUT peError).
    END METHOD.

    METHOD PUBLIC STATIC VOID INFO (INPUT pcMessage AS CHARACTER):
        log4oe.Logger:Log(INPUT LogLevel:INFO, INPUT pcMessage).
    END METHOD.

    METHOD PUBLIC STATIC VOID INFO (INPUT peError AS Progress.Lang.Error):
        log4oe.Logger:Log(INPUT LogLevel:INFO, INPUT peError).
    END METHOD.

    METHOD PUBLIC STATIC VOID WARN (INPUT pcMessage AS CHARACTER):
        log4oe.Logger:Log(INPUT LogLevel:WARN, INPUT pcMessage).
    END METHOD.

    METHOD PUBLIC STATIC VOID WARN (INPUT peError AS Progress.Lang.Error):
        log4oe.Logger:Log(INPUT LogLevel:WARN, INPUT peError).
    END METHOD.

    METHOD PUBLIC STATIC VOID ERROR (INPUT pcMessage AS CHARACTER):
        log4oe.Logger:Log(INPUT LogLevel:ERROR, INPUT pcMessage).
    END METHOD.

    METHOD PUBLIC STATIC VOID ERROR (INPUT peError AS Progress.Lang.Error):
        log4oe.Logger:Log(INPUT LogLevel:ERROR, INPUT peError).
    END METHOD.

    METHOD PUBLIC STATIC VOID FATAL (INPUT pcMessage AS CHARACTER):
        log4oe.Logger:Log(INPUT LogLevel:FATAL, INPUT pcMessage).
    END METHOD.

    METHOD PUBLIC STATIC VOID FATAL (INPUT peError AS Progress.Lang.Error):
        log4oe.Logger:Log(INPUT LogLevel:FATAL, INPUT peError).
    END METHOD.

END CLASS.
