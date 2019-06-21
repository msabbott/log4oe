 
 /*------------------------------------------------------------------------
    File        : Configuration
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Thu May 30 15:44:06 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.IConfiguration.
USING log4oe.LoggerConfig.AppenderConfiguration.
USING log4oe.LoggerConfig.LoggerConfiguration.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LogAppender.LogAppenderFactory.
USING log4oe.Logger.ILogger.
USING log4oe.LoggerFactory.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.Configuration IMPLEMENTS IConfiguration:
    
    DEFINE PUBLIC PROPERTY DefaultLogLevel AS INTEGER NO-UNDO INITIAL 3
    PUBLIC GET.
    PROTECTED SET.
    
    DEFINE PROTECTED TEMP-TABLE ttAppender NO-UNDO
        FIELD Appender AS Progress.Lang.Object
        FIELD AppenderName AS CHARACTER
            INDEX NameKey IS PRIMARY UNIQUE AppenderName ASCENDING.
            
    DEFINE PROTECTED TEMP-TABLE ttLogger NO-UNDO
        FIELD Logger AS Progress.Lang.Object
        FIELD LoggerName AS CHARACTER
            INDEX NameKey IS PRIMARY UNIQUE LoggerName ASCENDING.
            
    METHOD PUBLIC VOID setDefaultLogLevel(INPUT pcLogLevel AS CHARACTER):
        IF pcLogLevel NE ? AND pcLogLevel NE "" THEN
        DO:
            ASSIGN DefaultLogLevel = LogLevel:getLogLevelFromText(pcLogLevel, DefaultLogLevel).
        END.
    END METHOD.
        
    METHOD PUBLIC AppenderConfiguration AddAppender(INPUT pcName AS CHARACTER):
        RETURN AddAppender(pcName, "log4oe.LogAppender.LogManagerAppender").
    END METHOD.
        
    METHOD PUBLIC AppenderConfiguration AddAppender(INPUT pcName AS CHARACTER, INPUT pcType AS CHARACTER):
        
        RETURN AddAppender(INPUT NEW AppenderConfiguration(pcName, pcType)).
        
    END METHOD.
    
    METHOD PUBLIC AppenderConfiguration AddAppender(INPUT pcAppender AS AppenderConfiguration):
        
        IF NOT VALID-OBJECT(pcAppender) THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Invalid Appender object").
        END.
        
        IF CAN-FIND(FIRST ttAppender
                    WHERE ttAppender.AppenderName = pcAppender:AppenderName) THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Appender already exists with this name", -1).
        END.

        CREATE ttAppender.
        ASSIGN ttAppender.Appender     = pcAppender
               ttAppender.AppenderName = pcAppender:AppenderName.
               
        RETURN pcAppender.
        
    END METHOD.
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER):
        RETURN AddLogger(pcName, ?).
    END METHOD.
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT pcAppenderRef AS CHARACTER):
        RETURN AddLogger(pcName, DefaultLogLevel, pcAppenderRef).
    END METHOD.
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT piLevel AS INTEGER, INPUT pcAppenderRef AS CHARACTER):
        RETURN AddLogger(pcName, piLevel, ?, pcAppenderRef).
    END METHOD.
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT piLevel AS INTEGER, INPUT pcSubsystemName AS CHARACTER, INPUT pcAppenderRef AS CHARACTER):
        RETURN AddLogger(pcName, piLevel, pcSubsystemName, pcAppenderRef, "log4oe.Logger.BasicLogger").
    END METHOD.
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT piLevel AS INTEGER, INPUT pcSubsystemName AS CHARACTER, INPUT pcAppenderRef AS CHARACTER, INPUT pcType AS CHARACTER):
        
        DEFINE VARIABLE voLogger AS LoggerConfiguration NO-UNDO.
        
        ASSIGN voLogger               = NEW LoggerConfiguration()
               voLogger:LoggerName    = pcName
               voLogger:LoggerType    = pcType
               voLogger:LogLevel      = piLevel
               voLogger:SubsystemName = pcSubsystemName.
               
        IF pcAppenderRef NE ? AND pcAppenderRef NE "" THEN
        DO:               
            voLogger:AddAppenderName(pcAppenderRef).
        END.
               
        AddLogger(voLogger).
        
        RETURN voLogger.
               
    END METHOD.
    
    METHOD PUBLIC VOID AddLogger(INPUT pcLogger AS LoggerConfiguration):
        
        IF VALID-OBJECT(pcLogger) THEN
        DO:
            IF pcLogger:LoggerName EQ ? OR pcLogger:LoggerName EQ "" THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Logger must have a name specified", -1).
            END.
               
            IF pcLogger:LogLevel = ? OR pcLogger:LogLevel < 0 OR pcLogger:LogLevel > LogLevel:ALL THEN
            DO:
                ASSIGN pcLogger:LogLevel = DefaultLogLevel.
            END.
            
            IF TRIM(pcLogger:SubsystemName) = "" THEN
            DO:
                ASSIGN pcLogger:SubsystemName = ?.
            END.
            
            // Check the class is of the correct type
            CheckLoggerType(pcLogger:LoggerType).
        
            FIND FIRST ttLogger
                 WHERE ttLogger.LoggerName = pcLogger:LoggerName
                       EXCLUSIVE-LOCK NO-ERROR.
                       
            IF AVAILABLE ttLogger THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Logger already exists with this name", -1).
            END.
            
            CREATE ttLogger.
            ASSIGN ttLogger.Logger     = pcLogger
                   ttLogger.LoggerName = pcLogger:LoggerName.
        END.
       
    END METHOD.
    
    METHOD PRIVATE VOID CheckLoggerType(INPUT pcLoggerType AS CHARACTER):
        
        DEFINE VARIABLE voLoggerClass AS Progress.Lang.Class NO-UNDO.
        
        DO ON ERROR UNDO, THROW:
            
            ASSIGN voLoggerClass = Progress.Lang.Class:GetClass(pcLoggerType).
            
            IF NOT voLoggerClass:IsA("log4oe.Logger.ILogger") THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Logger type is not valid", -1).
            END.
        
            CATCH e AS Progress.Lang.Error :
                
                UNDO, THROW NEW Progress.Lang.AppError("Logger type is not valid", -1).
                    
            END CATCH.
        
        END.
        
    END METHOD.
    
    METHOD PUBLIC VOID Apply():
        
        DEFINE VARIABLE voAppender  AS ILogAppender          NO-UNDO.
        DEFINE VARIABLE voLogger    AS ILogger               NO-UNDO.
        DEFINE VARIABLE voAppConfig AS AppenderConfiguration NO-UNDO.
        DEFINE VARIABLE voLogConfig AS LoggerConfiguration   NO-UNDO.
        
        // Create the Appenders first so that they are available for loggers
        FOR EACH ttAppender NO-LOCK
              ON ERROR UNDO, THROW:
                  
            voAppConfig = DYNAMIC-CAST(ttAppender.Appender, "log4oe.LoggerConfig.AppenderConfiguration").

            IF VALID-OBJECT(voAppConfig) THEN
            DO:
                voAppender = LogAppenderFactory:getAppender(voAppConfig:AppenderName, voAppConfig:AppenderType).
                voAppConfig:ConfigureAppender(voAppender).
            END.
            ELSE
            DO:
                DELETE ttAppender.
            END.
        END.
        
        FOR EACH ttLogger NO-LOCK
              ON ERROR UNDO, THROW:
                  
            voLogConfig = DYNAMIC-CAST(ttLogger.Logger, "log4oe.LoggerConfig.LoggerConfiguration").

            IF VALID-OBJECT(voLogConfig) THEN
            DO:
                voLogger = LoggerFactory:getLogger(voLogConfig:LoggerName, voLogConfig:LoggerType).
                voLogConfig:ConfigureLogger(voLogger).
            END.
            ELSE
            DO:
                DELETE ttLogger.
            END.                 
        END.
        
    END METHOD.

END CLASS.