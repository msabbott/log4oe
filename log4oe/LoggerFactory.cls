
 /*------------------------------------------------------------------------
    File        : LoggerFactory
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed May 30 11:59:20 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.Logger.ILogger.
USING log4oe.Logger.
USING log4oe.LoggerConfig.ILoggerConfig.
USING log4oe.LoggerConfig.LogManagerConfig.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerFactory:

    DEFINE PRIVATE STATIC TEMP-TABLE ttLogger NO-UNDO
        FIELD LoggerName AS CHARACTER
        FIELD Logger     AS Progress.Lang.Object

            INDEX idxName IS PRIMARY UNIQUE LoggerName ASCENDING.

    DEFINE PRIVATE STATIC PROPERTY Config AS ILoggerConfig NO-UNDO
    PRIVATE GET.
    PRIVATE SET.

    DEFINE PUBLIC STATIC PROPERTY ROOT_LOGGER_NAME AS CHARACTER NO-UNDO INITIAL "log4oeDefaultLogger"
    GET.

    METHOD PUBLIC STATIC VOID setConfig(INPUT poConfig AS ILoggerConfig):
        Config = poConfig.
    END METHOD.

    METHOD PUBLIC STATIC ILoggerConfig getConfig():

        IF NOT VALID-OBJECT(Config) THEN
        DO:
            ASSIGN Config = NEW LogManagerConfig().
        END.

        RETURN Config.
    END METHOD.

    METHOD PUBLIC STATIC ILogger getLogger():
        RETURN getLogger(INPUT "").
    END METHOD.

    METHOD PUBLIC STATIC ILogger getLogger(INPUT pcLoggerName AS CHARACTER):

        RETURN getLogger(INPUT pcLoggerName, "log4oe.Logger.BasicLogger").

    END METHOD.

    METHOD PROTECTED STATIC ILogger getLogger(INPUT pcLoggerName AS CHARACTER, INPUT pcLoggerClass AS CHARACTER):

        DEFINE VARIABLE voLogger AS ILogger NO-UNDO.

        IF pcLoggerName = ? OR pcLoggerName = "" THEN
        DO:
            ASSIGN pcLoggerName = ROOT_LOGGER_NAME.
        END.

        FIND FIRST ttLogger
             WHERE ttLogger.LoggerName = pcLoggerName
                   EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE ttLogger THEN
        DO:
            CREATE ttLogger.
            ASSIGN ttLogger.LoggerName = pcLoggerName.
        END.

        /* Check that the logger object is a valid-object */
        IF NOT VALID-OBJECT(ttLogger.Logger) OR NOT ttLogger.Logger:GetClass():IsA("log4oe.Logger.ILogger") THEN
        DO:
            voLogger = DYNAMIC-NEW pcLoggerClass ().
            ASSIGN ttLogger.Logger = voLogger.

            /* Configure the logger */
            getConfig():ConfigureLogger(voLogger).

            RETURN voLogger.
        END.
        ELSE
        DO:
            ASSIGN voLogger = CAST(ttLogger.Logger, "log4oe.Logger.ILogger") NO-ERROR.

            RETURN voLogger.
        END.

    END METHOD.

END CLASS.