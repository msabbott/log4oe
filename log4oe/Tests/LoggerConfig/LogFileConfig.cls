 
 /*------------------------------------------------------------------------
    File        : LogFileConfig
    Purpose     : 
    Syntax      : 
    Description : Unit tests for LogFileConfig class
    Author(s)   : Mark Abbott
    Created     : Thu Apr 18 13:40:00 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.LogFileConfig.
USING log4oe.LogLevel.
USING log4oe.Tests.Stubs.StubLogger.
USING log4oe.LogAppender.ILogFileAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.LogFileConfig: 

    DEFINE PRIVATE VARIABLE voConfig AS LogFileConfig NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateConfig():
        ASSIGN voConfig = NEW LogFileConfig().
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteConfig():
        DELETE OBJECT voConfig NO-ERROR.
    END METHOD.

    @Test.
    METHOD PUBLIC VOID InitialiseSetsLogLevel():

        voConfig:Initialise().

        Assert:AreEqual(LogLevel:WARN, voConfig:getLogLevel()).

    END METHOD.

    @Test.
    METHOD PUBLIC VOID InitialiseSetsOutputDirectory():

        voConfig:Initialise().
        
        IF OPSYS = "Unix" THEN
        DO:
            Assert:AreEqual(voConfig:getOutputDirectory(), "./").
        END.
        ELSE
        DO:
            Assert:AreEqual(voConfig:getOutputDirectory(), ".~\").
        END.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID ConfigureLogger_SetsConfig():

        DEFINE VARIABLE voStubLogger AS StubLogger NO-UNDO.

        ASSIGN voStubLogger = NEW StubLogger().

        voConfig:ConfigureLogger(INPUT voStubLogger).

        Assert:AreEqual(voStubLogger:ConfigObject, voConfig).

        FINALLY:
            DELETE OBJECT voStubLogger NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID ConfigureLogger_SetsAppender():

        DEFINE VARIABLE voStubLogger AS StubLogger NO-UNDO.

        ASSIGN voStubLogger = NEW StubLogger().

        voConfig:ConfigureLogger(INPUT voStubLogger).

        Assert:IsTrue(VALID-OBJECT(voStubLogger:AppenderObject)).

        FINALLY:
            DELETE OBJECT voStubLogger NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID ConfigureLogger_SetsOutputFileName():

        DEFINE VARIABLE voStubLogger AS StubLogger       NO-UNDO.
        DEFINE VARIABLE voAppender   AS ILogFileAppender NO-UNDO.

        ASSIGN voStubLogger = NEW StubLogger().
        voStubLogger:setLoggerName("TestLogger").

        voConfig:ConfigureLogger(INPUT voStubLogger).

        Assert:IsTrue(VALID-OBJECT(voStubLogger:AppenderObject)).
        
        Assert:IsTrue(voStubLogger:AppenderObject:GetClass():IsA("log4oe.LogAppender.ILogFileAppender")).
        
        ASSIGN voAppender = CAST(voStubLogger:AppenderObject, "log4oe.LogAppender.ILogFileAppender").
        
        Assert:AreEqual(voAppender:getOutputFileName(), "TestLogger.log").

        FINALLY:
            DELETE OBJECT voStubLogger NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID SetGetSubsystemName():

        voConfig:setSubsystemName("Test Subsystem").

        Assert:AreEqual(voConfig:getSubsystemName(), "Test Subsystem").

    END METHOD.

    @Test.
    METHOD PUBLIC VOID SetGetLogLevel():

        voConfig:setLogLevel(INPUT 1).

        Assert:AreEqual(voConfig:getLogLevel(), 1).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID SetGetOutputDirectory():
        
        IF OPSYS = "Unix" THEN
        DO:
            voConfig:setOutputDirectory(INPUT "./logs/").
            Assert:AreEqual(voConfig:getOutputDirectory(), "./logs/").
        END.
        ELSE
        DO:
            voConfig:setOutputDirectory(INPUT ".\logs\").
            Assert:AreEqual(voConfig:getOutputDirectory(), ".~\logs~\").
        END.
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID SetGetOutputDirectory_SetsToCurrentDirWhenInvalid():
        
        IF OPSYS = "Unix" THEN
        DO:
            voConfig:setOutputDirectory(INPUT "./logs/").
            voConfig:setOutputDirectory(INPUT "").
            Assert:AreEqual(voConfig:getOutputDirectory(), "./").
            voConfig:setOutputDirectory(INPUT ?).
            Assert:AreEqual(voConfig:getOutputDirectory(), "./").
        END.
        ELSE
        DO:
            voConfig:setOutputDirectory(INPUT ".\logs\").
            voConfig:setOutputDirectory(INPUT "").
            Assert:AreEqual(voConfig:getOutputDirectory(), ".~\").
            voConfig:setOutputDirectory(INPUT ?).
            Assert:AreEqual(voConfig:getOutputDirectory(), ".~\").
        END.
        
    END METHOD.

END CLASS.