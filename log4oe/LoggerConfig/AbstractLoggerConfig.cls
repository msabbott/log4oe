
 /*------------------------------------------------------------------------
    File        : AbstractLoggerConfig
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Tue May 29 21:20:03 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogLevel.
USING log4oe.LoggerConfig.ILoggerConfig.
USING log4oe.Logger.ILogger.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.AbstractLoggerConfig IMPLEMENTS ILoggerConfig ABSTRACT:

    DEFINE PROTECTED PROPERTY SubsystemName AS CHARACTER NO-UNDO
    PROTECTED GET.
    PROTECTED SET.

    DEFINE PROTECTED PROPERTY LoggingLevel AS INTEGER NO-UNDO
    PROTECTED GET.
    PROTECTED SET.

    METHOD PUBLIC VOID setSubsystemName(INPUT pcSubsystemName AS CHARACTER):
        SubsystemName = pcSubsystemName.
    END METHOD.

    METHOD PUBLIC CHARACTER getSubsystemName():
        RETURN SubsystemName.
    END METHOD.

    METHOD PUBLIC INTEGER getLogLevel():
        RETURN LoggingLevel.
    END METHOD.

    METHOD PUBLIC VOID setLogLevel(INPUT piLogLevel AS INTEGER):
        ASSIGN LoggingLevel = piLogLevel.
    END METHOD.

    METHOD PUBLIC VOID Initialise():
        // Do nothing
    END METHOD.

    METHOD PUBLIC VOID ConfigureLogger(INPUT poLogger AS ILogger):
        // Do nothing
    END METHOD.
END CLASS.