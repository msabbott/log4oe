 /*------------------------------------------------------------------------
    File        : LogManagerAppender
    Purpose     :
    Syntax      :
    Description : Unit tests for the LogManagerAppender class
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 15:29:56 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LogAppender.LogManagerAppender.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LogAppender.LogManagerAppender:

    DEFINE PRIVATE VARIABLE voAppender AS LogManagerAppender.

    @Before.
    METHOD PUBLIC VOID CreateAppender():

        ASSIGN voAppender = NEW LogManagerAppender().
        voAppender:Initialise().

    END METHOD.

    @Before.
    METHOD PUBLIC VOID InitialiseLogManager():

        LOG-MANAGER:LOGFILE-NAME = "test.out".
        LOG-MANAGER:CLEAR-LOG().

    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteAppender():
        DELETE OBJECT voAppender NO-ERROR.
    END METHOD.

    @After.
    METHOD PUBLIC VOID CloseLogManager():
        LOG-MANAGER:CLOSE-LOG().
    END METHOD.

    @After.
    METHOD PUBLIC VOID RemoveTestLogFile():
        OS-DELETE "test.out".
    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.

        voAppender:Log(LogLevel:WARN, "Test Message").

    END METHOD.

    @Test.
    METHOD PUBLIC VOID Log_WithSubsystem():

        // Difficult to confirm what is logged with this. Test only confirms that
        // no error was raised by logging.

        voAppender:Log(LogLevel:WARN, "SubSystem", "Test Message").

    END METHOD.

END CLASS.
