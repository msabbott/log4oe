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
USING log4oe.LogAppender.LogAppenderFactory.
USING log4oe.LoggerConfig.BasicConfiguration.
USING log4oe.Tests.Stubs.StubLogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.tests.Logger:

    DEFINE PUBLIC VARIABLE voAppender AS StubLogAppender  NO-UNDO.
    
    @Before.
    METHOD PUBLIC VOID PreconfigureAppender():
        voAppender = DYNAMIC-CAST(LogAppenderFactory:getAppender(BasicConfiguration:DefaultLogAppenderName, "log4oe.Tests.Stubs.StubLogAppender"),
                                  "log4oe.Tests.Stubs.StubLogAppender").
    END METHOD.

    @After.
    METHOD PUBLIC VOID ResetLogger():
        Logger:ResetLogger().
    END METHOD.

    @After.
    METHOD PUBLIC VOID ResetFactoryConfiguration():
        LoggerFactory:ResetFactory().
        LogAppenderFactory:ResetFactory().
    END METHOD.
    
    @AfterClass.
    METHOD PUBLIC VOID DeleteLogFile():
        OS-DELETE VALUE("messages.log").
    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_ShouldLog():

        Logger:Log(LogLevel:WARN, "Message").
        Assert:AreEqual(voAppender:LoggedMessage, "Message").
        Assert:AreEqual(voAppender:LoggedLevel, LogLevel:WARN).

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_ShouldNotLog():

        Logger:Log(LogLevel:DEBUG, "Message").
        Assert:AreNotEqual(voAppender:LoggedMessage, "Message").

    END METHOD.

    @Test.
    METHOD PUBLIC VOID LogError_ShouldLog():

        DEFINE VARIABLE voError AS Progress.Lang.AppError NO-UNDO.

        ASSIGN voError = NEW Progress.Lang.AppError().

        Logger:Log(LogLevel:WARN, voError).
        Assert:AreEqual(voAppender:LoggedError, voError).
        Assert:AreEqual(voAppender:LoggedLevel, LogLevel:WARN).

    END METHOD.

    @Test.
    METHOD PUBLIC VOID LogError_ShouldNotLog():

        Logger:Log(LogLevel:DEBUG, NEW Progress.Lang.AppError()).
        Assert:IsNull(voAppender:LoggedError).

    END METHOD.

END CLASS.