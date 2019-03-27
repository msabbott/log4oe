
/*------------------------------------------------------------------------
    File        : ILoggerConfig
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed May 30 14:41:32 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.Logger.ILogger.

INTERFACE log4oe.LoggerConfig.ILoggerConfig:

    METHOD PUBLIC VOID setSubsystemName(INPUT pcSubsystemName AS CHARACTER).

    METHOD PUBLIC CHARACTER getSubsystemName().

    METHOD PUBLIC INTEGER getLogLevel().

    METHOD PUBLIC VOID setLogLevel(INPUT piLogLevel AS INTEGER).

    METHOD PUBLIC VOID Initialise().

    METHOD PUBLIC VOID ConfigureLogger(INPUT poLogger AS ILogger).

END INTERFACE.