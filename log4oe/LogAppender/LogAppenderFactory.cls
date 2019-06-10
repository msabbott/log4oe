 
 /*------------------------------------------------------------------------
    File        : LogAppenderFactory
    Purpose     : 
    Syntax      : 
    Description : Factory for creating log appenders
    Author(s)   : Mark Abbott
    Created     : Fri Jun 07 14:16:08 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LoggerConfig.AppenderConfiguration.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LogAppender.LogAppenderFactory:
    
    DEFINE PRIVATE STATIC TEMP-TABLE ttAppender NO-UNDO
        FIELD AppenderName AS CHARACTER
        FIELD Appender     AS Progress.Lang.Object

            INDEX idxName IS PRIMARY UNIQUE AppenderName ASCENDING.
        
    METHOD PUBLIC STATIC ILogAppender getAppender():
        RETURN getAppender(INPUT "").
    END METHOD.

    METHOD PUBLIC STATIC ILogAppender getAppender(INPUT pcAppenderName AS CHARACTER):
        RETURN getAppender(INPUT pcAppenderName, "log4oe.LogAppender.LogManagerAppender").
    END METHOD.
    
    METHOD STATIC PUBLIC ILogAppender getAppender(INPUT pcAppenderName AS CHARACTER, INPUT pcAppenderType AS CHARACTER):
        
        DEFINE VARIABLE voClass    AS Progress.Lang.Class  NO-UNDO.
        DEFINE VARIABLE voAppender AS ILogAppender         NO-UNDO.
        
        FIND ttAppender
             WHERE ttAppender.AppenderName = pcAppenderName
                   NO-LOCK NO-ERROR.
                   
        IF NOT AVAILABLE ttAppender THEN
        DO:
            CREATE ttAppender.
            ASSIGN ttAppender.AppenderName = pcAppenderName.
        END.
        
        IF NOT VALID-OBJECT(ttAppender.Appender) OR NOT ttAppender.Appender:GetClass():IsA("log4oe.LogAppender.LogManagerAppender") THEN
        DO:

            DELETE OBJECT ttAppender.Appender NO-ERROR.
            
            ASSIGN voClass = Progress.Lang.Class:GetClass(pcAppenderType).
            
            IF voClass = ? THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Invalid object type for Appender: " + pcAppenderType).
            END.
            
            IF NOT voClass:IsA("log4oe.LogAppender.ILogAppender") THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Request appender is not of type ~"log4oe.LogAppender.ILogAppender~": " + pcAppenderType).
            END.
            
            voAppender = DYNAMIC-NEW pcAppenderType ().
            
            ASSIGN ttAppender.Appender = voAppender.
        
        END.
        ELSE
        DO:
            ASSIGN voAppender = CAST(ttAppender.Appender, "log4oe.LogAppender.ILogAppender") NO-ERROR.
        END.
                
        RETURN voAppender.
        
    END METHOD.

    METHOD PUBLIC STATIC VOID ResetFactory():
        FOR EACH ttAppender EXCLUSIVE-LOCK:
            DELETE OBJECT ttAppender.Appender NO-ERROR.
            DELETE ttAppender.
        END.
    END METHOD.

END CLASS.