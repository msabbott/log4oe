 /*------------------------------------------------------------------------
    File        : LoggerFactory
    Purpose     :
    Syntax      :
    Description : Unit tests for Logger class
    Author(s)   : Mark Abbott
    Created     : Thu Mar 28 17:12:01 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.Logger.ILogger.
USING log4oe.LogLevel.
USING log4oe.LoggerFactory.
USING log4oe.Tests.Stubs.StubLoggerConfig.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.tests.LoggerFactory:

    @After.
    METHOD PUBLIC VOID ResetFactoryConfiguration():
        LoggerFactory:ResetFactory().
    END METHOD.

    @Test.
    METHOD PUBLIC VOID DefaultLoggerNameIsSet():

        Assert:IsNotNull(LoggerFactory:ROOT_LOGGER_NAME).
        Assert:AreNotEqual(LoggerFactory:ROOT_LOGGER_NAME, "").

    END METHOD.

    @Test.
    METHOD PUBLIC VOID GetSetConfig():

        DEFINE VARIABLE voConfig AS StubLoggerConfig NO-UNDO.

        ASSIGN voConfig = NEW StubLoggerConfig().

        voConfig:setLogLevel(LogLevel:Info).

        LoggerFactory:setConfig(voConfig).

        Assert:AreEqual(LoggerFactory:getConfig(), voConfig).
    END METHOD.

    @Test.
    METHOD PUBLIC VOID GetLogger_ReturnsValidObject():

        Assert:IsTrue(VALID-OBJECT(LoggerFactory:getLogger())).

    END METHOD.

    @Test.
    METHOD PUBLIC VOID GetLogger_ReturnsSameObject():

        DEFINE VARIABLE voLogger AS ILogger NO-UNDO.

        ASSIGN voLogger = LoggerFactory:getLogger().

        Assert:AreEqual(LoggerFactory:getLogger(), voLogger).
    END METHOD.

    @Test.
    METHOD PUBLIC VOID GetLogger_LoggerNameIsSet():
        
        Assert:IsNotNull(LoggerFactory:getLogger():getLoggerName(), "Logger name is null").
        Assert:AreNotEqual(LoggerFactory:getLogger():getLoggerName(), "", "Logger name is blank").
        
    END METHOD.

    @Test.
    METHOD PUBLIC VOID ResetFactory_ResetsConfig():

        DEFINE VARIABLE voConfig AS StubLoggerConfig NO-UNDO.

        ASSIGN voConfig = NEW StubLoggerConfig().

        voConfig:setLogLevel(LogLevel:Info).

        LoggerFactory:setConfig(voConfig).

        LoggerFactory:ResetFactory().

        Assert:IsTrue(VALID-OBJECT(LoggerFactory:getConfig())).
        Assert:AreNotEqual(LoggerFactory:getConfig():GetClass():TypeName, "log4oe.Tests.Stubs.StubLoggerConfig").

    END METHOD.

END CLASS.