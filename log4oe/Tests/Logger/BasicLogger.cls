 /*------------------------------------------------------------------------
    File        : BasicLogger
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 17:11:58 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LogLevel.
USING log4oe.Logger.BasicLogger.
USING log4oe.Tests.Stubs.StubLoggerConfig.
USING log4oe.Tests.Stubs.StubLogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.Logger.BasicLogger:

    DEFINE PRIVATE VARIABLE voLogger AS BasicLogger NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateLogger():
        ASSIGN voLogger = NEW BasicLogger().
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteLogger():
        DELETE OBJECT voLogger NO-ERROR.
    END METHOD.

    @Test.
    METHOD PUBLIC VOID GetSetConfig():

        DEFINE VARIABLE voConfig AS StubLoggerConfig NO-UNDO.

        ASSIGN voConfig = NEW StubLoggerConfig().

        voLogger:setLoggerConfig(voConfig).

        Assert:AreEqual(voLogger:getLoggerConfig(), voConfig).

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_ShouldLog():

        DEFINE VARIABLE voConfig AS StubLoggerConfig NO-UNDO.
        DEFINE VARIABLE voAppender AS StubLogAppender NO-UNDO.

        ASSIGN voConfig   = NEW StubLoggerConfig()
               voAppender = NEW StubLogAppender().

        voConfig:setLogLevel(INPUT LogLevel:INFO).

        voLogger:setLoggerConfig(voConfig).
        voLogger:addLogAppender(INPUT voAppender).

        voLogger:Log(INPUT LogLevel:INFO, "Message").

        Assert:AreEqual(voAppender:LoggedMessage, "Message").

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
            DELETE OBJECT voAppender NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_ShouldNotLog():

        DEFINE VARIABLE voConfig AS StubLoggerConfig NO-UNDO.
        DEFINE VARIABLE voAppender AS StubLogAppender NO-UNDO.

        ASSIGN voConfig   = NEW StubLoggerConfig()
               voAppender = NEW StubLogAppender().

        voConfig:setLogLevel(INPUT LogLevel:INFO).

        voLogger:setLoggerConfig(voConfig).
        voLogger:addLogAppender(INPUT voAppender).

        voLogger:Log(INPUT LogLevel:DEBUG, "Message").

        Assert:IsNull(voAppender:LoggedMessage).

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
            DELETE OBJECT voAppender NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID LogError_ShouldLog():

        DEFINE VARIABLE voConfig   AS StubLoggerConfig       NO-UNDO.
        DEFINE VARIABLE voAppender AS StubLogAppender     NO-UNDO.
        DEFINE VARIABLE voError    AS Progress.Lang.AppError NO-UNDO.

        ASSIGN voConfig   = NEW StubLoggerConfig()
               voAppender = NEW StubLogAppender()
               voError    = NEW Progress.Lang.AppError().

        voConfig:setLogLevel(INPUT LogLevel:INFO).

        voLogger:setLoggerConfig(voConfig).
        voLogger:addLogAppender(INPUT voAppender).

        voLogger:Log(INPUT LogLevel:INFO, INPUT voError).

        Assert:AreEqual(voAppender:LoggedError, voError).

        FINALLY:
            DELETE OBJECT voConfig   NO-ERROR.
            DELETE OBJECT voAppender NO-ERROR.
            DELETE OBJECT voError    NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID LogError_ShouldNotLog():

        DEFINE VARIABLE voConfig   AS StubLoggerConfig       NO-UNDO.
        DEFINE VARIABLE voAppender AS StubLogAppender     NO-UNDO.
        DEFINE VARIABLE voError    AS Progress.Lang.AppError NO-UNDO.

        ASSIGN voConfig   = NEW StubLoggerConfig()
               voAppender = NEW StubLogAppender()
               voError    = NEW Progress.Lang.AppError().

        voConfig:setLogLevel(INPUT LogLevel:INFO).

        voLogger:setLoggerConfig(voConfig).
        voLogger:addLogAppender(INPUT voAppender).

        voLogger:Log(INPUT LogLevel:DEBUG, INPUT voError).

        Assert:IsNull(voAppender:LoggedError).

        FINALLY:
            DELETE OBJECT voConfig   NO-ERROR.
            DELETE OBJECT voAppender NO-ERROR.
            DELETE OBJECT voError    NO-ERROR.
        END FINALLY.

    END METHOD.

END CLASS.