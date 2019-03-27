 /*------------------------------------------------------------------------
    File        : LogLevel
    Purpose     : 
    Syntax      : 
    Description : Unit tests for LogLevel class
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 15:19:27 GMT 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LogLevel: 
    
    @Test.
    METHOD PUBLIC VOID ConfirmLogLevelValues():
        Assert:AreEqual(LogLevel:ALL,   7, "LogLevel:ALL should be 7, but was not.").
        Assert:AreEqual(LogLevel:TRACE, 6, "LogLevel:TRACE should be 6, but was not.").
        Assert:AreEqual(LogLevel:DEBUG, 5, "LogLevel:DEBUG should be 5, but was not.").
        Assert:AreEqual(LogLevel:INFO,  4, "LogLevel:INFO should be 4, but was not.").
        Assert:AreEqual(LogLevel:WARN,  3, "LogLevel:WARN should be 3, but was not.").
        Assert:AreEqual(LogLevel:ERROR, 2, "LogLevel:ERROR should be 2, but was not.").
        Assert:AreEqual(LogLevel:FATAL, 1, "LogLevel:FATAL should be 1, but was not.").
        Assert:AreEqual(LogLevel:OFF,   0, "LogLevel:OFF should be 0, but was not.").
    END METHOD.

END CLASS.