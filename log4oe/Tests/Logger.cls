 /*------------------------------------------------------------------------
    File        : Logger
    Purpose     :
    Syntax      :
    Description : Unit tests for Logger class
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 15:17:01 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.Logger.
USING log4oe.LogLevel.
USING log4oe.LoggerFactory.
USING log4oe.Tests.Stubs.StubLoggerConfig.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.tests.Logger:

    DEFINE PUBLIC VARIABLE voConfig AS StubLoggerConfig NO-UNDO.

    @Before.
    METHOD PUBLIC VOID ConfigureConfigObject():
        IF NOT VALID-OBJECT(voConfig) THEN
        DO:
            ASSIGN voConfig = NEW StubLoggerConfig().
        END.
        voConfig:setLogLevel(LogLevel:INFO).
    END METHOD.

    @Before.
    METHOD PUBLIC VOID ConfigureFactory():
        ConfigureConfigObject().
        LoggerFactory:setConfig(INPUT voConfig).
    END METHOD.

    @After.
    METHOD PUBLIC VOID ResetLogger():
        Logger:ResetLogger().
    END METHOD.

    @After.
    METHOD PUBLIC VOID ResetFactoryConfiguration():
        LoggerFactory:ResetFactory().
        DELETE OBJECT voConfig NO-ERROR.
    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_ShouldLog():

        Logger:Log(LogLevel:WARN, "Message").
        Assert:AreEqual(voConfig:LogAppender:LoggedMessage, "Message").

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_ShouldNotLog():

        Logger:Log(LogLevel:DEBUG, "Message").
        Assert:AreNotEqual(voConfig:LogAppender:LoggedMessage, "Message").

    END METHOD.

    @Test.
    METHOD PUBLIC VOID LogError_ShouldLog():

        DEFINE VARIABLE voError AS Progress.Lang.AppError NO-UNDO.

        ASSIGN voError = NEW Progress.Lang.AppError().

        Logger:Log(LogLevel:WARN, voError).
        Assert:AreEqual(voConfig:LogAppender:LoggedError, voError).

    END METHOD.

    @Test.
    METHOD PUBLIC VOID LogError_ShouldNotLog():

        Logger:Log(LogLevel:DEBUG, NEW Progress.Lang.AppError()).
        Assert:IsNull(voConfig:LogAppender:LoggedError).

    END METHOD.

END CLASS.