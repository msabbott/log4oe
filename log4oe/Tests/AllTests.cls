 /*------------------------------------------------------------------------
    File        : AllTests
    Purpose     :
    Syntax      :
    Description : Test suite containing all unit tests
    Author(s)   : Mark Abbott
    Created     : Wed Mar 27 15:03:30 GMT 2019
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Runner.TestSuite.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.tests.AllTests INHERITS TestSuite:

  CONSTRUCTOR AllTests():

    /* Tests for packages */
    AddTest(NEW log4oe.Tests.LogAppender.AllTests()).
    AddTest(NEW log4oe.Tests.Logger.AllTests()).
    AddTest(NEW log4oe.Tests.LoggerConfig.AllTests()).

    /* Tests for root level objects */
    AddTest(NEW log4oe.Tests.Logger()).
    AddTest(NEW log4oe.Tests.LoggerFactory()).
    AddTest(NEW log4oe.Tests.LogLevel()).

  END CONSTRUCTOR.

END CLASS.