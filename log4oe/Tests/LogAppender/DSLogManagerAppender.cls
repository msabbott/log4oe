 /*------------------------------------------------------------------------
    File        : LogManagerAppender
    Purpose     :
    Syntax      :
    Description : Unit tests for the LogManagerAppender class
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 15:29:56 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LogAppender.DSLogManagerAppender.
USING log4oe.LoggerConfig.DSLogManagerConfig.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LogAppender.DSLogManagerAppender:

    DEFINE PRIVATE VARIABLE voAppender AS DSLogManagerAppender.

    @Before.
    METHOD PUBLIC VOID CreateAppender():

        ASSIGN voAppender = NEW DSLogManagerAppender().
        voAppender:Initialise().

    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteAppender():
        DELETE OBJECT voAppender NO-ERROR.
    END METHOD.

    @Test.
    METHOD PUBLIC VOID setLoggerConfig():

        DEFINE VARIABLE voConfig AS DSLogManagerConfig NO-UNDO.

        ASSIGN voConfig = NEW DSLogManagerConfig().

        voAppender:setLoggerConfig(INPUT voConfig).

        Assert:AreEqual(voAppender:getLoggerConfig(), voConfig).

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID setLoggerConfig_InvalidConfigIsIgnored():

        DEFINE VARIABLE voConfig AS DSLogManagerConfig NO-UNDO.

        ASSIGN voConfig = NEW DSLogManagerConfig().

        voAppender:setLoggerConfig(INPUT voConfig).
        voAppender:setLoggerConfig(INPUT ?).

        Assert:AreEqual(voAppender:getLoggerConfig(), voConfig).

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test. @Ignore. // Requires a DataServer connection in order for tests to complete
    METHOD PUBLIC VOID Log():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.

        DEFINE VARIABLE voConfig AS DSLogManagerConfig NO-UNDO.

        ASSIGN voConfig = NEW DSLogManagerConfig().

        voAppender:setLoggerConfig(INPUT voConfig).

        voAppender:Log(LogLevel:INFO, "Test Message").

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test. @Ignore. // Requires a DataServer connection in order for tests to complete
    METHOD PUBLIC VOID Log_WithSubsystem():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.

        voAppender:Log(LogLevel:INFO, "Subsystem Name", "Test Message").
        
    END METHOD.

END CLASS.
