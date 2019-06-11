 /*------------------------------------------------------------------------
    File        : StubLogAppender
    Purpose     :
    Syntax      :
    Description : Stub for LogAppender class
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 16:46:37 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.ILogAppender.
USING log4oe.LoggerConfig.ILoggerConfig.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.Stubs.StubLogAppender IMPLEMENTS ILogAppender:

    DEFINE PUBLIC PROPERTY ConfigObject AS ILoggerConfig NO-UNDO
    PUBLIC GET.
    PUBLIC SET.

    DEFINE PUBLIC PROPERTY Initialised AS LOGICAL NO-UNDO INITIAL FALSE
    PUBLIC GET.
    PRIVATE SET.
    
    DEFINE PUBLIC PROPERTY LoggedLevel AS INTEGER NO-UNDO
    PUBLIC GET.
    PRIVATE SET.

    DEFINE PUBLIC PROPERTY LoggedError AS Progress.Lang.Error NO-UNDO
    PUBLIC GET.
    PRIVATE SET.

    DEFINE PUBLIC PROPERTY LoggedMessage AS CHARACTER NO-UNDO INITIAL ?
    PUBLIC GET.
    PRIVATE SET.

    DEFINE PUBLIC PROPERTY LoggedSubsystemName AS CHARACTER NO-UNDO INITIAL ?
    PUBLIC GET.
    PRIVATE SET.

    METHOD PUBLIC VOID Initialise():
        ASSIGN Initialised = TRUE.
    END METHOD.

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcMessage AS CHARACTER):
        THIS-OBJECT:Log(piLogLevel, ?, pcMessage).
    END METHOD.
    
    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcSubsystemName AS CHARACTER, INPUT pcMessage AS CHARACTER):
        ASSIGN LoggedMessage       = pcMessage
               LoggedSubsystemName = pcSubsystemName
               LoggedLevel         = piLogLevel.
    END METHOD.

    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT peError AS Progress.Lang.Error):
        THIS-OBJECT:Log(piLogLevel, ?, peError).
    END METHOD.
    
    METHOD PUBLIC VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcSubsystemName AS CHARACTER, INPUT peError AS Progress.Lang.Error):
        ASSIGN LoggedError         = peError
               LoggedSubsystemName = pcSubsystemName
               LoggedLevel         = piLogLevel.
    END METHOD.

    METHOD PUBLIC ILoggerConfig getLoggerConfig():
        RETURN ConfigObject.
    END METHOD.

    METHOD PUBLIC VOID setLoggerConfig(INPUT poLoggerConfig AS ILoggerConfig):
        ConfigObject = poLoggerConfig.
    END METHOD.
    
    METHOD PUBLIC VOID setProperty(INPUT pcPropertyName AS CHARACTER, INPUT pcPropertyValue AS CHARACTER):
    END METHOD.

END CLASS.