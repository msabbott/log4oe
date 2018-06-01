 
 /*------------------------------------------------------------------------
    File        : Logger
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Tue May 29 20:09:03 BST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogLevel.
USING log4oe.Logger.ILogger.
USING log4oe.LogManager.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Logger:
    
    DEFINE PROTECTED STATIC PROPERTY DefaultLogger AS ILogger NO-UNDO
    PROTECTED GET.
    PROTECTED SET.
    
    METHOD PROTECTED STATIC VOID InitialiseDefaultLogger():
        
        IF NOT VALID-OBJECT(DefaultLogger) THEN
        DO:
            ASSIGN DefaultLogger = LogManager:getLogger().
        END.
        
    END METHOD.
    
    METHOD PUBLIC STATIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcMessage AS CHARACTER):
        
        InitialiseDefaultLogger().
        DefaultLogger:Log(INPUT piLogLevel, INPUT pcMessage).
        
    END METHOD.
    
    METHOD PUBLIC STATIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT peError AS Progress.Lang.Error):
        
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