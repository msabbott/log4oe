
 /*------------------------------------------------------------------------
    File        : LogManagerConfig
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 16:31:30 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.LogManagerConfig.
USING log4oe.LogLevel.
USING log4oe.Tests.Stubs.StubLogger.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.LogManagerConfig:

    DEFINE PRIVATE VARIABLE voConfig AS LogManagerConfig NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateConfig():
        ASSIGN voConfig = NEW LogManagerConfig().
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteConfig():
        DELETE OBJECT voConfig NO-ERROR.
    END METHOD.

    @Test.
    METHOD PUBLIC VOID InitialiseInterpretsLogLevel():

        DEFINE VARIABLE viExpectedLogLevel AS INTEGER NO-UNDO.

        voConfig:Initialise().

        CASE LOG-MANAGER:LOGGING-LEVEL:

            WHEN 0 THEN
               ASSIGN viExpectedLogLevel = LogLevel:OFF.

            WHEN 1 THEN
               ASSIGN viExpectedLogLevel = LogLevel:ERROR.

            WHEN 2 THEN
               ASSIGN viExpectedLogLevel = LogLevel:WARN.

            WHEN 3 THEN
               ASSIGN viExpectedLogLevel = LogLevel:INFO.

            WHEN 4 THEN
               ASSIGN viExpectedLogLevel = LogLevel:DEBUG.

        END CASE.

        Assert:AreEqual(viExpectedLogLevel, voConfig:getLogLevel()).

    END METHOD.

    @Test.
    METHOD PUBLIC VOID ConfigureLogger_SetsConfig():

        DEFINE VARIABLE voStubLogger AS StubLogger NO-UNDO.

        ASSIGN voStubLogger = NEW StubLogger().

        voConfig:ConfigureLogger(INPUT voStubLogger).

        Assert:AreEqual(voStubLogger:ConfigObject, voConfig).

        FINALLY:
            DELETE OBJECT voStubLogger NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID ConfigureLogger_SetsAppender():

        DEFINE VARIABLE voStubLogger AS StubLogger NO-UNDO.

        ASSIGN voStubLogger = NEW StubLogger().

        voConfig:ConfigureLogger(INPUT voStubLogger).

        Assert:IsTrue(VALID-OBJECT(voStubLogger:AppenderObject)).

        FINALLY:
            DELETE OBJECT voStubLogger NO-ERROR.
        END FINALLY.

    END METHOD.

    @Test.
    METHOD PUBLIC VOID SetGetSubsystemName():

        voConfig:setSubsystemName("Test Subsystem").

        Assert:AreEqual(voConfig:getSubsystemName(), "Test Subsystem").

    END METHOD.

    @Test.
    METHOD PUBLIC INTEGER SetGetLogLevel():

        voConfig:setLogLevel(INPUT 1).

        Assert:AreEqual(voConfig:getLogLevel(), 1).
    END METHOD.

END CLASS.
