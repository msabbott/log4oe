 
 /*------------------------------------------------------------------------
    File        : LoggerConfiguration
    Purpose     : 
    Syntax      : 
    Description : Logger configuration properties
    Author(s)   : Mark Abbott
    Created     : Thu May 30 15:55:36 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogLevel.
USING log4oe.Logger.ILogger.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LogAppender.LogAppenderFactory.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.LoggerConfiguration:
    
    DEFINE PROTECTED TEMP-TABLE ttAppenderName NO-UNDO
        FIELD AppenderName AS CHARACTER
        INDEX NameKey IS PRIMARY UNIQUE AppenderName ASCENDING.
    
    DEFINE PUBLIC PROPERTY LoggerName AS CHARACTER NO-UNDO INITIAL ?
    PUBLIC GET.
    PUBLIC SET. 
    
    DEFINE PUBLIC PROPERTY LoggerType AS CHARACTER NO-UNDO INITIAL "log4oe.Logger.BasicLogger"
    PUBLIC GET.
    PUBLIC SET.
    
    DEFINE PUBLIC PROPERTY LoggerLevel AS CHARACTER NO-UNDO INITIAL "WARN"
    PUBLIC GET.
    PUBLIC SET.
    
    DEFINE PUBLIC PROPERTY SubsystemName AS CHARACTER NO-UNDO INITIAL ?
    PUBLIC GET.
    PUBLIC SET.
    
    METHOD PUBLIC VOID AddAppenderName(INPUT pcAppenderName AS CHARACTER):
        
        IF NOT CAN-FIND(FIRST ttAppenderName WHERE ttAppenderName.AppenderName = pcAppenderName) THEN
        DO:
            CREATE ttAppenderName.
            ASSIGN ttAppenderName.AppenderName = pcAppenderName.
        END.
        
    END METHOD.
    
    METHOD PUBLIC VOID ConfigureLogger(INPUT pcLogger AS ILogger):
        
        IF VALID-OBJECT(pcLogger) THEN
        DO:
            pcLogger:setLoggerName(LoggerName).
            pcLogger:setLogLevel(LogLevel:getLogLevelFromText(LoggerLevel, LogLevel:WARN)).
            pcLogger:setSubsystemName(SubsystemName).
            
            FOR EACH ttAppenderName NO-LOCK
                  ON ERROR UNDO, THROW:
                      
                pcLogger:addLogAppender(LogAppenderFactory:getAppender(ttAppenderName.AppenderName)).
            END.
        END.
        
    END METHOD.

END CLASS.