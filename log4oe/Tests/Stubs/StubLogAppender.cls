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

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.Stubs.StubLogAppender IMPLEMENTS ILogAppender:
    
    DEFINE PRIVATE TEMP-TABLE ttAppenderProperty NO-UNDO
        FIELD PropertyName AS CHARACTER
        FIELD PropertyValue AS CHARACTER
        
            INDEX PriKey IS PRIMARY UNIQUE PropertyName ASCENDING.

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
   
    METHOD PUBLIC VOID setProperty(INPUT pcPropertyName AS CHARACTER, INPUT pcPropertyValue AS CHARACTER):
        
        FIND FIRST ttAppenderProperty
             WHERE ttAppenderProperty.PropertyName = pcPropertyName
                   EXCLUSIVE-LOCK NO-ERROR.
                   
        IF NOT AVAILABLE ttAppenderProperty THEN
        DO:
            CREATE ttAppenderProperty.
            ASSIGN ttAppenderProperty.PropertyName = pcPropertyName.
        END.
        
        ASSIGN ttAppenderProperty.PropertyValue = pcPropertyValue.
    END METHOD.
    
    METHOD PUBLIC CHARACTER getProperty(INPUT pcPropertyName AS CHARACTER):
        
        FIND FIRST ttAppenderProperty
             WHERE ttAppenderProperty.PropertyName = pcPropertyName
                   EXCLUSIVE-LOCK NO-ERROR.
                   
        IF AVAILABLE ttAppenderProperty THEN
        DO:
            RETURN ttAppenderProperty.PropertyValue. 
        END.
        
        RETURN ?.
        
    END METHOD.

END CLASS.