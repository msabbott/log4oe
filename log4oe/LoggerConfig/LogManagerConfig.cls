
 /*------------------------------------------------------------------------
    File        : LogManagerConfig
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Tue May 29 21:12:45 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogLevel.
USING log4oe.LoggerConfig.ILoggerConfig.
USING log4oe.LoggerConfig.AbstractLoggerConfig.
USING log4oe.Logger.ILogger.
USING log4oe.LogAppender.LogManagerAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.LogManagerConfig INHERITS AbstractLoggerConfig IMPLEMENTS ILoggerConfig:

    METHOD PUBLIC OVERRIDE VOID Initialise():

        CASE LOG-MANAGER:LOGGING-LEVEL:

            WHEN 0 THEN
               setLogLevel(LogLevel:OFF).

            WHEN 1 THEN
               setLogLevel(LogLevel:ERROR).

            WHEN 2 THEN
               setLogLevel(LogLevel:WARN).

            WHEN 3 THEN
               setLogLevel(LogLevel:INFO).

            WHEN 4 THEN
               setLogLevel(LogLevel:DEBUG).

        END CASE.

    END METHOD.

    METHOD PUBLIC OVERRIDE VOID ConfigureLogger(INPUT poLogger AS ILogger):

        DEFINE VARIABLE voAppender AS LogManagerAppender NO-UNDO.

        poLogger:setLoggerConfig(THIS-OBJECT).

        ASSIGN voAppender = NEW LogManagerAppender().

        voAppender:setLoggerConfig(THIS-OBJECT).

        poLogger:addLogAppender(voAppender).

    END METHOD.

END CLASS.