 
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
    
    METHOD PRIVATE VOID CreateAppenderWithNoFilename():
        
        DELETE OBJECT voAppender NO-ERROR.
        
        ASSIGN voAppender = NEW LogFileAppender().
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Constructor_InitialisesFileNameToNull():
        
        CreateAppenderWithNoFilename().
        
        Assert:IsNull(voAppender:getOutputFileName()).
        
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
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID Initialise_WithNoFilename():
        
        CreateAppenderWithNoFilename().
        
        voAppender:Initialise().
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Buffered_DefaultsToFalse():
        Assert:IsFalse(voAppender:getBuffered()).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Append_DefaultsToTrue():
        Assert:IsTrue(voAppender:getAppend()).
    END METHOD.

END CLASS.