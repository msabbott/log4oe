 
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
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LogAppender.LogFileAppender: 

    DEFINE PRIVATE VARIABLE voAppender AS LogFileAppender.
    DEFINE PRIVATE VARIABLE vcFileName AS CHARACTER NO-UNDO INITIAL "testfile.out".

    @Before.
    METHOD PUBLIC VOID CreateAppender():

        ASSIGN voAppender = NEW LogFileAppender().
        voAppender:setProperty("filename", vcFileName).
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
    METHOD PUBLIC VOID Log():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.

        voAppender:Log(LogLevel:WARN, "Test Message").

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_WithSubsystem():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.
        
        voAppender:Log(LogLevel:WARN, "Subsystem Name", "Test Message").
        
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID Initialise_WithNoFilename():
        
        CreateAppenderWithNoFilename().
        
        voAppender:Initialise().
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID SetProperty_SetsFileName():
        voAppender:setProperty("filename", "test.log").
        Assert:AreEqual(voAppender:getOutputFileName(), "test.log").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID SetProperty_SetsBufferedTrue():
        voAppender:setProperty("buffered", "true").
        Assert:IsTrue(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "t").
        Assert:IsTrue(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "yes").
        Assert:IsTrue(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "y").
        Assert:IsTrue(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "1").
        Assert:IsTrue(voAppender:getBuffered()).
    END METHOD.

    @Test.    
    METHOD PUBLIC VOID SetProperty_SetsBufferedFalse():
        voAppender:setProperty("buffered", "false").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "f").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "no").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "n").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "0").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "not a boolean").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", "").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", " ").
        Assert:IsFalse(voAppender:getBuffered()).
        voAppender:setProperty("buffered", ?).
        Assert:IsFalse(voAppender:getBuffered()).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID SetProperty_SetsAppendTrue():
        voAppender:setProperty("append", "true").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", "t").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", "yes").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", "y").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", "1").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", "not a boolean").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", "").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", " ").
        Assert:IsTrue(voAppender:getAppend()).
        voAppender:setProperty("append", ?).
        Assert:IsTrue(voAppender:getAppend()).
    END METHOD.

    @Test.    
    METHOD PUBLIC VOID SetProperty_SetsAppendFalse():
        voAppender:setProperty("append", "false").
        Assert:IsFalse(voAppender:getAppend()).
        voAppender:setProperty("append", "f").
        Assert:IsFalse(voAppender:getAppend()).
        voAppender:setProperty("append", "no").
        Assert:IsFalse(voAppender:getAppend()).
        voAppender:setProperty("append", "n").
        Assert:IsFalse(voAppender:getAppend()).
        voAppender:setProperty("append", "0").
        Assert:IsFalse(voAppender:getAppend()).
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