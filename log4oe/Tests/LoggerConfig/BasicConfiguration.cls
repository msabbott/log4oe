 
 /*------------------------------------------------------------------------
    File        : BasicConfiguration
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Fri Jun 21 13:52:14 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.BasicConfiguration.
USING log4oe.LoggerConfig.AppenderConfiguration.
USING log4oe.LoggerConfig.LoggerConfiguration.
USING log4oe.LogLevel.
USING log4oe.LogAppender.LogAppenderFactory.
USING log4oe.LoggerFactory.
USING log4oe.Tests.Stubs.StubLogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.BasicConfiguration:

    @Before.
    METHOD PUBLIC VOID ClearFactories():
        LoggerFactory:ResetFactory().
        LogAppenderFactory:ResetFactory().
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID DefaultLoggerIsConfigured():
        Assert:AreEqual(BasicConfiguration:DefaultLoggerName, "log4oe.defaultLogger").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID DefaultAppenderIsConfigured():
        Assert:AreEqual(BasicConfiguration:DefaultLogAppenderName, "log4oe.defaultAppender").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Constructor_SetsProperties():
        
        //Essentially testing that the constructor does not error
        
        DEFINE VARIABLE voConfig AS BasicConfiguration NO-UNDO.
        
        ASSIGN voConfig = NEW BasicConfiguration().
        
        Assert:IsNotNull(voConfig).
                
    END METHOD.
    
END CLASS.