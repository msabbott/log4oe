 
 /*------------------------------------------------------------------------
    File        : LogFileAppender
    Purpose     : 
    Syntax      : 
    Description : Unit tests for LogFileAppender class
    Author(s)   : Mark Abbott
    Created     : Thu Apr 18 13:02:28 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LogAppender.LogFileAppender.
USING log4oe.LoggerConfig.LogFileConfig.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LogAppender.LogFileAppender: 

    DEFINE PRIVATE VARIABLE voAppender AS LogFileAppender.
    DEFINE PRIVATE VARIABLE vcFileName AS CHARACTER NO-UNDO INITIAL "testfile.out".

    @Before.
    METHOD PUBLIC VOID CreateAppender():

        ASSIGN voAppender = NEW LogFileAppender(INPUT vcFileName).
        voAppender:Initialise().

    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteAppender():
        DELETE OBJECT voAppender NO-ERROR.
    END METHOD.

    @After.
    METHOD PUBLIC VOID RemoveTestLogFile():
        OS-DELETE VALUE(vcFileName).
    END METHOD.

    @Test.
    METHOD PUBLIC VOID setLoggerConfig():

        DEFINE VARIABLE voConfig AS LogFileConfig NO-UNDO.

        ASSIGN voConfig = NEW LogFileConfig().

        voAppender:setLoggerConfig(INPUT voConfig).

        Assert:AreEqual(voAppender:getLoggerConfig(), voConfig).

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID setLoggerConfig_InvalidConfigIsIgnored():

        DEFINE VARIABLE voConfig AS LogFileConfig NO-UNDO.

        ASSIGN voConfig = NEW LogFileConfig().

        voAppender:setLoggerConfig(INPUT voConfig).
        voAppender:setLoggerConfig(INPUT ?).

        Assert:AreEqual(voAppender:getLoggerConfig(), voConfig).

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.

        DEFINE VARIABLE voConfig AS LogFileConfig NO-UNDO.

        ASSIGN voConfig = NEW LogFileConfig().

        voAppender:setLoggerConfig(INPUT voConfig).

        voAppender:Log(LogLevel:WARN, "Test Message").

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_WithSubsystem():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.

        DEFINE VARIABLE voConfig AS LogFileConfig NO-UNDO.

        ASSIGN voConfig = NEW LogFileConfig().

        voConfig:setSubsystemName("TestSubsys").

        voAppender:setLoggerConfig(INPUT voConfig).

        voAppender:Log(LogLevel:WARN, "Test Message").

        FINALLY:
            DELETE OBJECT voConfig NO-ERROR.
        END FINALLY.

    END METHOD.

END CLASS.