
/*------------------------------------------------------------------------
    File        : ILogger
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Tue May 29 20:52:15 BST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LoggerConfig.ILoggerConfig.

INTERFACE log4oe.Logger.ILogger:
    
    METHOD PUBLIC VOID setLoggerConfig(INPUT poLoggerConfig AS ILoggerConfig).
    
    METHOD PUBLIC ILoggerConfig getLoggerConfig().
    
    METHOD PUBLIC VOID addLogAppender(INPUT poAppender AS ILogAppender).

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT peError AS Progress.Lang.Error).

    METHOD PUBLIC VOID TRACE (INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID TRACE (INPUT peError AS Progress.Lang.Error).

    METHOD PUBLIC VOID DEBUG (INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID DEBUG (INPUT peError AS Progress.Lang.Error).

    METHOD PUBLIC VOID INFO (INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID INFO (INPUT peError AS Progress.Lang.Error).

    METHOD PUBLIC VOID WARN (INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID WARN (INPUT peError AS Progress.Lang.Error).

    METHOD PUBLIC VOID ERROR (INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID ERROR (INPUT peError AS Progress.Lang.Error).

    METHOD PUBLIC VOID FATAL (INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID FATAL (INPUT peError AS Progress.Lang.Error).
  
END INTERFACE.