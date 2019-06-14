 
 /*------------------------------------------------------------------------
    File        : Configuration
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Thu Jun 13 16:03:25 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.Configuration.
USING log4oe.LoggerConfig.AppenderConfiguration.
USING log4oe.LoggerConfig.LoggerConfiguration.
USING log4oe.LogLevel.
USING log4oe.LogAppender.LogAppenderFactory.
USING log4oe.LoggerFactory.
USING log4oe.Tests.Stubs.StubLogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.Configuration:   

    DEFINE PRIVATE VARIABLE voConfig AS Configuration NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateConfig():
        ASSIGN voConfig = NEW Configuration().
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteConfig():
        DELETE OBJECT voConfig NO-ERROR.
    END METHOD.
    
    @After.
    METHOD PUBLIC VOID ClearFactories():
        LoggerFactory:ResetFactory().
        LogAppenderFactory:ResetFactory().
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID LogLevelIsInitialised():
        Assert:AreEqual(voConfig:DefaultLogLevel, LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setDefaultLogLevel():
        voConfig:setDefaultLogLevel("ALL").
        Assert:AreEqual(voConfig:DefaultLogLevel, LogLevel:ALL).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setDefaultLogLevel_InvalidValue():
        voConfig:setDefaultLogLevel("Not a valid level").
        Assert:AreEqual(voConfig:DefaultLogLevel, LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setDefaultLogLevel_BlankValue():
        voConfig:setDefaultLogLevel("").
        Assert:AreEqual(voConfig:DefaultLogLevel, LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID setDefaultLogLevel_NullValue():
        voConfig:setDefaultLogLevel(?).
        Assert:AreEqual(voConfig:DefaultLogLevel, LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppender():
        voConfig:AddAppender("TestAppender1").
        voConfig:AddAppender("TestAppender2").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddAppender_WithDuplicateName():
        voConfig:AddAppender("TestAppender1").
        voConfig:AddAppender("TestAppender1").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppender_WithBlankName():
        voConfig:AddAppender("").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppender_WithNullName():
        DEFINE VARIABLE vcAppenderName AS CHARACTER NO-UNDO INITIAL ?.
        voConfig:AddAppender(vcAppenderName).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppender_WithType():
        voConfig:AddAppender("TestAppender1", "log4oe.Tests.Stubs.StubLogAppender").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddAppender_WithBlankType():
        voConfig:AddAppender("TestAppender1", "").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddAppender_WithInvalidType():
        voConfig:AddAppender("TestAppender1", "sklfsdlfjsldfkj").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddAppender_WithNonAppenderType():
        voConfig:AddAppender("TestAppender1", "Progress.Lang.Object").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddAppender_WithNullType():
        voConfig:AddAppender("TestAppender1", ?).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddAppender_WithAppenderConfiguration():
        DEFINE VARIABLE voAppenderConfig1 AS AppenderConfiguration NO-UNDO.
        DEFINE VARIABLE voAppenderConfig2 AS AppenderConfiguration NO-UNDO.
        
        ASSIGN voAppenderConfig1 = NEW AppenderConfiguration("TestAppender1", "log4oe.Tests.Stubs.StubLogAppender").
               voAppenderConfig2 = NEW AppenderConfiguration("TestAppender2", "log4oe.Tests.Stubs.StubLogAppender").
               
        voConfig:AddAppender(voAppenderConfig1).
        voConfig:AddAppender(voAppenderConfig2).
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddAppender_WithInvalidAppenderConfiguration():
        DEFINE VARIABLE voAppenderConfig AS AppenderConfiguration NO-UNDO.
        voConfig:AddAppender(voAppenderConfig).
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddAppender_WithDuplicateAppenderConfigurationName():
        DEFINE VARIABLE voAppenderConfig1 AS AppenderConfiguration NO-UNDO.
        DEFINE VARIABLE voAppenderConfig2 AS AppenderConfiguration NO-UNDO.
        
        ASSIGN voAppenderConfig1 = NEW AppenderConfiguration("TestAppender1", "log4oe.Tests.Stubs.StubLogAppender").
               voAppenderConfig2 = NEW AppenderConfiguration("TestAppender1", "log4oe.Tests.Stubs.StubLogAppender").
               
        voConfig:AddAppender(voAppenderConfig1).
        voConfig:AddAppender(voAppenderConfig2).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger():
        voConfig:AddLogger("TestLogger1").
        voConfig:AddLogger("TestLogger2").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddLogger_WithDuplicateName():
        voConfig:AddLogger("TestLogger1").
        voConfig:AddLogger("TestLogger1").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddLogger_WithBlankName():
        voConfig:AddLogger("").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddLogger_WithNullName():
        DEFINE VARIABLE vcLoggerName AS CHARACTER NO-UNDO INITIAL ?.
        voConfig:AddLogger(vcLoggerName).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithAppender():
        voConfig:AddLogger("TestLogger1", "TestAppender").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithDuplicatedAppender():
        voConfig:AddLogger("TestLogger1", "TestAppender").
        voConfig:AddLogger("TestLogger2", "TestAppender").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithBlankAppender():
        voConfig:AddLogger("TestLogger1", "").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithNullAppender():
        voConfig:AddLogger("TestLogger1", ?).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithLevel():
        DEFINE VARIABLE voLoggerConfig AS LoggerConfiguration NO-UNDO.
        voLoggerConfig = voConfig:AddLogger("TestLogger1", LogLevel:ALL, "TestAppender").
        Assert:AreEqual(voLoggerConfig:LoggerLevel, "ALL").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithInvalidLevel():
        DEFINE VARIABLE voLoggerConfig AS LoggerConfiguration NO-UNDO.
        voLoggerConfig = voConfig:AddLogger("TestLogger1", 999, "TestAppender").
        Assert:AreEqual(voLoggerConfig:LoggerLevel, "WARN").
        voLoggerConfig = voConfig:AddLogger("TestLogger2", -99, "TestAppender").
        Assert:AreEqual(voLoggerConfig:LoggerLevel, "WARN").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithNullLevel():
        DEFINE VARIABLE voLoggerConfig AS LoggerConfiguration NO-UNDO.
        voLoggerConfig = voConfig:AddLogger("TestLogger1", ?, "TestAppender").
        Assert:AreEqual(voLoggerConfig:LoggerLevel, "WARN").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithSubsystem():
        DEFINE VARIABLE voLoggerConfig AS LoggerConfiguration NO-UNDO.
        voLoggerConfig = voConfig:AddLogger("TestLogger1", LogLevel:ALL, "Test Subsystem", "TestAppender").
        Assert:AreEqual(voLoggerConfig:SubsystemName, "Test Subsystem").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithBlankSubsystem():
        DEFINE VARIABLE voLoggerConfig AS LoggerConfiguration NO-UNDO.
        voLoggerConfig = voConfig:AddLogger("TestLogger1", LogLevel:ALL, "", "TestAppender").
        Assert:IsNull(voLoggerConfig:SubsystemName).
        voLoggerConfig = voConfig:AddLogger("TestLogger2", LogLevel:ALL, "  ", "TestAppender").
        Assert:IsNull(voLoggerConfig:SubsystemName).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithNullSubsystem():
        DEFINE VARIABLE voLoggerConfig AS LoggerConfiguration NO-UNDO.
        voLoggerConfig = voConfig:AddLogger("TestLogger1", LogLevel:ALL, ?, "TestAppender").
        Assert:IsNull(voLoggerConfig:SubsystemName).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID AddLogger_WithType():
        DEFINE VARIABLE voLoggerConfig AS LoggerConfiguration NO-UNDO.
        voLoggerConfig = voConfig:AddLogger("TestLogger1", LogLevel:ALL, ?, "TestAppender", "log4oe.Tests.Stubs.StubLogger").
        Assert:AreEqual(voLoggerConfig:LoggerType, "log4oe.Tests.Stubs.StubLogger").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddLogger_WithInvalidType():
        voConfig:AddLogger("TestLogger1", LogLevel:ALL, ?, "TestAppender", "ssdfskfjsldkf").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddLogger_WithNonLoggerType():
        voConfig:AddLogger("TestLogger1", LogLevel:ALL, ?, "TestAppender", "Progress.Lang.Object").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddLogger_WithBlankType():
        voConfig:AddLogger("TestLogger1", LogLevel:ALL, ?, "TestAppender", "").
    END METHOD.
    
    @Test(expected='Progress.Lang.AppError').
    METHOD PUBLIC VOID AddLogger_WithNullType():
        voConfig:AddLogger("TestLogger1", LogLevel:ALL, ?, "TestAppender", ?).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Apply_InitialisesAppender():
        
        DEFINE VARIABLE voAppender AS StubLogAppender NO-UNDO.
        
        voConfig:AddAppender("TestAppender", "log4oe.Tests.Stubs.StubLogAppender").
        
        voConfig:Apply().
        
        ASSIGN voAppender = DYNAMIC-CAST(LogAppenderFactory:getAppender("TestAppender"), "log4oe.Tests.Stubs.StubLogAppender").
        
        Assert:IsTrue(voAppender:Initialised).
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Apply_SetsAppenderProperties():
        
        DEFINE VARIABLE voAppenderConfig AS AppenderConfiguration NO-UNDO.
        DEFINE VARIABLE voAppender       AS StubLogAppender       NO-UNDO.
        
        voAppenderConfig = voConfig:AddAppender("TestAppender", "log4oe.Tests.Stubs.StubLogAppender").
        
        voAppenderConfig:AddConfigurationProperty("TestProperty", "TestValue").
        
        voConfig:Apply().
        
        ASSIGN voAppender = DYNAMIC-CAST(LogAppenderFactory:getAppender("TestAppender"), "log4oe.Tests.Stubs.StubLogAppender").
        
        Assert:AreEqual(voAppender:getProperty("TestProperty"), "TestValue").
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Apply_ConfiguresLoggers():
        
        DEFINE VARIABLE voLogger AS log4oe.Tests.Stubs.StubLogger NO-UNDO.
        
        voConfig:AddAppender("TestAppender", "log4oe.Tests.Stubs.StubLogAppender").
        
        voConfig:AddLogger("TestLogger", LogLevel:WARN, "SubsystemName", "TestAppender", "log4oe.Tests.Stubs.StubLogger").
        
        voConfig:Apply().
        
        ASSIGN voLogger = DYNAMIC-CAST(LoggerFactory:getLogger("TestLogger"), "log4oe.Tests.Stubs.StubLogger").
        
        Assert:AreEqual(voLogger:CurrentLogLevel, LogLevel:WARN).
        Assert:AreEqual(voLogger:LoggerName, "TestLogger").
        Assert:AreEqual(voLogger:SubsystemName, "SubsystemName").

    END METHOD.
    
END CLASS.