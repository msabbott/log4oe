
/*------------------------------------------------------------------------
    File        : ILogAppender
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed May 30 14:55:44 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.ILoggerConfig.

INTERFACE log4oe.LogAppender.ILogAppender:

    METHOD PUBLIC VOID setLoggerConfig(INPUT poLoggerConfig AS ILoggerConfig).

    METHOD PUBLIC ILoggerConfig getLoggerConfig().

    METHOD PUBLIC VOID Initialise().

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcMessage AS CHARACTER).

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT peError AS Progress.Lang.Error).


END INTERFACE.