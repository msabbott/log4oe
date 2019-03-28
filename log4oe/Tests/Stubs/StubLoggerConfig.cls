 /*------------------------------------------------------------------------
    File        : StubLoggerConfig
    Purpose     :
    Syntax      :
    Description : Stub class for LoggerConfig
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 17:26:18 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.ILoggerConfig.
USING log4oe.Tests.Stubs.StubLogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.Stubs.StubLoggerConfig IMPLEMENTS ILoggerConfig:

    DEFINE PUBLIC PROPERTY Initialised AS LOGICAL NO-UNDO INITIAL FALSE
    PUBLIC GET.
    PRIVATE SET.

    DEFINE PUBLIC PROPERTY LogAppender AS StubLogAppender NO-UNDO
    PUBLIC GET.
    PRIVATE SET.

    DEFINE PUBLIC PROPERTY LogLevel AS INTEGER NO-UNDO INITIAL -1
    PUBLIC GET.
    PUBLIC SET.

    DEFINE PUBLIC PROPERTY SubsystemName AS CHARACTER NO-UNDO
    PUBLIC GET.
    PUBLIC SET.

    METHOD PUBLIC VOID ConfigureLogger( INPUT poLogger AS log4oe.Logger.ILogger ):

        poLogger:setLoggerConfig(THIS-OBJECT).

        ASSIGN LogAppender = NEW StubLogAppender().

        LogAppender:setLoggerConfig(THIS-OBJECT).

        poLogger:addLogAppender(LogAppender).
    END METHOD.

    METHOD PUBLIC VOID Initialise():
        ASSIGN Initialised = TRUE.
    END METHOD.

    METHOD PUBLIC INTEGER getLogLevel():
        RETURN LogLevel.
    END METHOD.

    METHOD PUBLIC CHARACTER getSubsystemName():
        RETURN SubsystemName.
    END METHOD.

    METHOD PUBLIC VOID setLogLevel(INPUT piLogLevel AS INTEGER):
        LogLevel = piLogLevel.
    END METHOD.

    METHOD PUBLIC VOID setSubsystemName(INPUT pcSubsystemName AS CHARACTER):
        SubsystemName = pcSubsystemName.
    END METHOD.

END CLASS.