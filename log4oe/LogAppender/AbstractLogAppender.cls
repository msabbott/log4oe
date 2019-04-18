
 /*------------------------------------------------------------------------
    File        : AbstractLogAppender
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed May 30 15:01:10 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LoggerConfig.ILoggerConfig.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LogAppender.AbstractLogAppender IMPLEMENTS ILogAppender ABSTRACT:

    DEFINE PROTECTED PROPERTY Config AS ILoggerConfig NO-UNDO
    PROTECTED GET.
    PROTECTED SET.

    METHOD PUBLIC VOID setLoggerConfig(INPUT poLoggerConfig AS ILoggerConfig):

        IF VALID-OBJECT(poLoggerConfig) THEN
        DO:
            ASSIGN Config = poLoggerConfig.
        END.

    END METHOD.

    METHOD PUBLIC ILoggerConfig getLoggerConfig():
        RETURN Config.
    END METHOD.

    METHOD PUBLIC VOID Initialise():
        // Do nothing
    END METHOD.

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcMessage AS CHARACTER):
        UNDO, THROW NEW Progress.Lang.AppError("Method not implemented in AbstractLogAppender").
    END METHOD.

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT peError AS Progress.Lang.Error):

        DEFINE VARIABLE viMessage AS INTEGER NO-UNDO.

        THIS-OBJECT:Log(piLogLevel, 'Error trapped with type ' + peError:GetClass():TypeName).
        THIS-OBJECT:Log(piLogLevel, 'Severity: ' + STRING(peError:Severity)).

        DO viMessage = 1 TO peError:NumMessages:
            THIS-OBJECT:Log(piLogLevel, peError:GetMessage(viMessage) + ' (' + STRING(peError:GetMessageNum(viMessage)) + ')').
        END.

        IF peError:CallStack NE ? THEN
        DO:
            THIS-OBJECT:Log(piLogLevel, 'Call Stack: ' + peError:CallStack).
        END.

    END METHOD.

END CLASS.