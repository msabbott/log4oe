 
 /*------------------------------------------------------------------------
    File        : AppenderConfiguration
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Tue Jun 11 17:37:33 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.AppenderConfiguration.
USING log4oe.Tests.Stubs.StubLogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.AppenderConfiguration: 

    DEFINE PRIVATE VARIABLE voConfig AS AppenderConfiguration NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateConfig():
        ASSIGN voConfig = NEW AppenderConfiguration("TestAppenderName", "log4oe.Tests.Stubs.StubLogAppender").
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteConfig():
        DELETE OBJECT voConfig NO-ERROR.
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Constructor_SetsProperties():
        Assert:AreEqual(voConfig:AppenderName, "TestAppenderName").
        Assert:AreEqual(voConfig:AppenderType, "log4oe.Tests.Stubs.StubLogAppender").
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID Constructor_BlankType():
        NEW AppenderConfiguration("TestAppenderName", "").
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID Constructor_InvalidType():
        NEW AppenderConfiguration("TestAppenderName", "asdfasfsadf").
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID Constructor_NonAppenderType():
        NEW AppenderConfiguration("TestAppenderName", "Progress.Lang.Object").
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID Constructor_NullType():
        NEW AppenderConfiguration("TestAppenderName", ?).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddConfigurationProperty_DoesNotError():
        // Not much can be tested here. Just checking that it does not error.
        voConfig:AddConfigurationProperty("Test", "Test").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddConfigurationProperty_DuplicateDoesNotError():
        // Not much can be tested here. Just checking that it does not error.
        voConfig:AddConfigurationProperty("Test", "Test").
        voConfig:AddConfigurationProperty("Test", "Test").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureAppender():
        // Not much can be tested here. Just checking that it does not error. 
        DEFINE VARIABLE voStubLogAppender AS StubLogAppender NO-UNDO.
        
        ASSIGN voStubLogAppender = NEW StubLogAppender().
        
        voConfig:ConfigureAppender(voStubLogAppender).
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureAppender_SetProperties():
        
        DEFINE VARIABLE voStubLogAppender AS StubLogAppender NO-UNDO.
        
        ASSIGN voStubLogAppender = NEW StubLogAppender().
        
        voConfig:AddConfigurationProperty("TestProperty1", "TestValue1").
        voConfig:AddConfigurationProperty("TestProperty2", "TestValue2").
        voConfig:AddConfigurationProperty("TestProperty2", "TestValueChanged").
        
        voConfig:ConfigureAppender(voStubLogAppender).
        
        Assert:AreEqual(voStubLogAppender:getProperty("TestProperty1"), "TestValue1").
        Assert:AreEqual(voStubLogAppender:getProperty("TestProperty2"), "TestValueChanged").
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureAppender_InitialisesAppender():
        
        DEFINE VARIABLE voStubLogAppender AS StubLogAppender NO-UNDO.
        
        ASSIGN voStubLogAppender = NEW StubLogAppender().
        
        voConfig:ConfigureAppender(voStubLogAppender).
        
        Assert:IsTrue(voStubLogAppender:Initialised).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureAppender_InvalidAppender():
        // Not much can be tested here. Just checking that it does not error.
        voConfig:ConfigureAppender(?).
    END METHOD.

END CLASS.