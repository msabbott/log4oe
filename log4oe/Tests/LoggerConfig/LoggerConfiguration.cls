 
 /*------------------------------------------------------------------------
    File        : LoggerConfiguration
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Thu Jun 13 15:35:50 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.LoggerConfiguration.
USING log4oe.Tests.Stubs.StubLogger.
USING log4oe.LogLevel.
USING log4oe.LogAppender.LogAppenderFactory.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.LoggerConfiguration:  

    DEFINE PRIVATE VARIABLE voConfig AS LoggerConfiguration NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateConfig():
        ASSIGN voConfig = NEW LoggerConfiguration().
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteConfig():
        DELETE OBJECT voConfig NO-ERROR.
    END METHOD.

    @After.
    METHOD PUBLIC VOID ResetAppenderFactory():
        LogAppenderFactory:ResetFactory().
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID PropertiesAreInitialised():
        
        Assert:IsNull(voConfig:LoggerName).
        Assert:AreEqual(voConfig:LoggerType, "log4oe.Logger.BasicLogger").
        Assert:AreEqual(voConfig:LogLevel, LogLevel:WARN).
        Assert:IsNull(voConfig:SubsystemName).
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setLogLevel():
        voConfig:setLogLevel("ALL").
        Assert:AreEqual(voConfig:LogLevel, LogLevel:ALL).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setLogLevel_InvalidValue():
        voConfig:setLogLevel("Not a valid level").
        Assert:AreEqual(voConfig:LogLevel, LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setLogLevel_BlankValue():
        voConfig:setLogLevel("").
        Assert:AreEqual(voConfig:LogLevel, LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setLogLevel_NullValue():
        voConfig:setLogLevel(?).
        Assert:AreEqual(voConfig:LogLevel, LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppenderName():
        voConfig:AddAppenderName("TestAppender").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppenderName_Duplicate():
        voConfig:AddAppenderName("TestAppender").
        voConfig:AddAppenderName("TestAppender").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppenderName_Null():
        voConfig:AddAppenderName(?).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppenderName_BlankString():
        voConfig:AddAppenderName("").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureLogger():
        // Testing that no errors are raised
        DEFINE VARIABLE voLogger AS StubLogger NO-UNDO.
        
        ASSIGN voLogger = NEW StubLogger().
        
        voConfig:ConfigureLogger(voLogger).
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureLogger_PropertiesSet():
        
        DEFINE VARIABLE voLogger AS StubLogger NO-UNDO.
        
        ASSIGN voLogger               = NEW StubLogger()
               voConfig:LogLevel      = LogLevel:ALL
               voConfig:LoggerName    = "Test LoggerName"
               voConfig:SubsystemName = "Test SubsystemName".
        
        voConfig:ConfigureLogger(voLogger).
        
        Assert:AreEqual(voLogger:CurrentLogLevel, LogLevel:ALL).
        Assert:AreEqual(voLogger:LoggerName, voConfig:LoggerName).
        Assert:AreEqual(voLogger:SubsystemName, voConfig:SubsystemName).
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureLogger_AppendersSet():
        
        DEFINE VARIABLE voLogger AS StubLogger NO-UNDO.
        
        ASSIGN voLogger = NEW StubLogger().
        
        voConfig:AddAppenderName("TestAppender1").
        voConfig:AddAppenderName("TestAppender2").
        
        voConfig:ConfigureLogger(voLogger).
        
        Assert:AreEqual(voLogger:countLogAppenders(), 2).
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID ConfigureLogger_InvalidLogger():
        // Testing that no errors are raised
        voConfig:ConfigureLogger(?).
    END METHOD.

END CLASS.