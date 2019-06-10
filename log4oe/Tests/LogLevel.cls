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
    
    @Test.
    METHOD PUBLIC VOID getLogLevelDesc_Valid():
        
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:ALL),   "ALL").
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:TRACE), "TRACE").
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:DEBUG), "DEBUG").
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:INFO),  "INFO").
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:WARN),  "WARN").
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:ERROR), "ERROR").
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:FATAL), "FATAL").
        Assert:AreEqual(LogLevel:getLogLevelDesc(LogLevel:OFF),   "OFF").
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID getLogLevelDesc_Invalid():
        
        Assert:AreEqual(LogLevel:getLogLevelDesc(-1), "?????").
        Assert:AreEqual(LogLevel:getLogLevelDesc(8),  "?????").
        Assert:AreEqual(LogLevel:getLogLevelDesc(?),  "?????").

    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID getLogLevelFixedWidthDesc_Valid():
        
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:ALL),   "ALL  ").
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:TRACE), "TRACE").
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:DEBUG), "DEBUG").
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:INFO),  "INFO ").
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:WARN),  "WARN ").
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:ERROR), "ERROR").
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:FATAL), "FATAL").
        Assert:AreEqual(LogLevel:getLogLevelFixedWidthDesc(LogLevel:OFF),   "OFF  ").
        
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:ALL)),   5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:TRACE)), 5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:DEBUG)), 5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:INFO)),  5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:WARN)),  5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:ERROR)), 5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:FATAL)), 5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(LogLevel:OFF)),   5).
        
    END METHOD.
    
    
    @Test.
    METHOD PUBLIC VOID getLogLevelFixedWidthDesc_Invalid():
        
        Assert:AreEqual(LogLevel:getLogLevelDesc(-1), "?????").
        Assert:AreEqual(LogLevel:getLogLevelDesc(8),  "?????").
        Assert:AreEqual(LogLevel:getLogLevelDesc(?),  "?????").
        
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(-1)), 5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(8)),  5).
        Assert:AreEqual(LENGTH(LogLevel:getLogLevelFixedWidthDesc(?)),  5).

    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID getLogLevelFromText_Valid():
        Assert:AreEqual(LogLevel:getLogLevelFromText("ALL"),   LogLevel:ALL).
        Assert:AreEqual(LogLevel:getLogLevelFromText("TRACE"), LogLevel:TRACE).
        Assert:AreEqual(LogLevel:getLogLevelFromText("DEBUG"), LogLevel:DEBUG).
        Assert:AreEqual(LogLevel:getLogLevelFromText("INFO"),  LogLevel:INFO).
        Assert:AreEqual(LogLevel:getLogLevelFromText("WARN"),  LogLevel:WARN).
        Assert:AreEqual(LogLevel:getLogLevelFromText("ERROR"), LogLevel:ERROR).
        Assert:AreEqual(LogLevel:getLogLevelFromText("FATAL"), LogLevel:FATAL).
        Assert:AreEqual(LogLevel:getLogLevelFromText("OFF"),   LogLevel:OFF).
        
        // Some additional "helpful" values
        Assert:AreEqual(LogLevel:getLogLevelFromText("INFORMATION"), LogLevel:INFO).
        Assert:AreEqual(LogLevel:getLogLevelFromText("WARNING"),     LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID getLogLevelFromText_Invalid():
        Assert:AreEqual(LogLevel:getLogLevelFromText("Does Not Exist"), -1).
        Assert:AreEqual(LogLevel:getLogLevelFromText(""),               -1).
        Assert:AreEqual(LogLevel:getLogLevelFromText("   "),            -1).
        Assert:AreEqual(LogLevel:getLogLevelFromText(?),                -1).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID getLogLevelFromText_ValidWithDefault():
        Assert:AreEqual(LogLevel:getLogLevelFromText("ALL",   LogLevel:OFF),   LogLevel:ALL).
        Assert:AreEqual(LogLevel:getLogLevelFromText("TRACE", LogLevel:OFF),   LogLevel:TRACE).
        Assert:AreEqual(LogLevel:getLogLevelFromText("DEBUG", LogLevel:OFF),   LogLevel:DEBUG).
        Assert:AreEqual(LogLevel:getLogLevelFromText("INFO",  LogLevel:OFF),   LogLevel:INFO).
        Assert:AreEqual(LogLevel:getLogLevelFromText("WARN",  LogLevel:OFF),   LogLevel:WARN).
        Assert:AreEqual(LogLevel:getLogLevelFromText("ERROR", LogLevel:OFF),   LogLevel:ERROR).
        Assert:AreEqual(LogLevel:getLogLevelFromText("FATAL", LogLevel:OFF),   LogLevel:FATAL).
        Assert:AreEqual(LogLevel:getLogLevelFromText("OFF",   LogLevel:FATAL), LogLevel:OFF).
        
        // Some additional "helpful" values
        Assert:AreEqual(LogLevel:getLogLevelFromText("INFORMATION", LogLevel:OFF), LogLevel:INFO).
        Assert:AreEqual(LogLevel:getLogLevelFromText("WARNING",     LogLevel:OFF), LogLevel:WARN).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID getLogLevelFromText_InvalidWithDefault():
        Assert:AreEqual(LogLevel:getLogLevelFromText("Does Not Exist", LogLevel:FATAL), LogLevel:FATAL).
        Assert:AreEqual(LogLevel:getLogLevelFromText("", LogLevel:FATAL),               LogLevel:FATAL).
        Assert:AreEqual(LogLevel:getLogLevelFromText("   ", LogLevel:FATAL),            LogLevel:FATAL).
        Assert:AreEqual(LogLevel:getLogLevelFromText(?, LogLevel:FATAL),                LogLevel:FATAL).
    END METHOD.

END CLASS.