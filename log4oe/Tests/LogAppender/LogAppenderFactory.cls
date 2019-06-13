 
 /*------------------------------------------------------------------------
    File        : LogAppenderFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Mon Jun 10 16:50:16 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LogAppender.LogAppenderFactory.
USING log4oe.LogAppender.ILogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LogAppender.LogAppenderFactory: 

    @After.
    METHOD PUBLIC VOID ResetFactoryConfiguration():
        LogAppenderFactory:ResetFactory().
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID GetAppender_ReturnsValidObject():
        Assert:IsTrue(VALID-OBJECT(LogAppenderFactory:getAppender())).
    END METHOD.

    @Test.
    METHOD PUBLIC VOID GetAppender_ReturnsSameObject():
        Assert:AreEqual(LogAppenderFactory:getAppender(), LogAppenderFactory:getAppender()).
    END METHOD.

    @Test.
    METHOD PUBLIC VOID GetAppender_ReturnsSameObject_NotDefaultType():
        
        DEFINE VARIABLE voAppender1 AS ILogAppender NO-UNDO.
        DEFINE VARIABLE voAppender2 AS ILogAppender NO-UNDO.
        
        voAppender1 = LogAppenderFactory:getAppender("TestAppender", "log4oe.Tests.Stubs.StubLogAppender").
        voAppender2 = LogAppenderFactory:getAppender("TestAppender", "log4oe.Tests.Stubs.StubLogAppender").
        
        Assert:AreEqual(voAppender1, voAppender2).
        
    END METHOD.

    @Test.
    METHOD PUBLIC VOID ResetFactory_ResetsObjects():
        
        DEFINE VARIABLE voAppender AS ILogAppender NO-UNDO.
        
        ASSIGN voAppender = LogAppenderFactory:getAppender().
        
        LogAppenderFactory:ResetFactory().
        
        Assert:IsFalse(VALID-OBJECT(voAppender)).
        
    END METHOD.

END CLASS.