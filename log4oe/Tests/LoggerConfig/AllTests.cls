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

CLASS log4oe.tests.LoggerConfig.AllTests INHERITS TestSuite:

  CONSTRUCTOR AllTests():
    /* Tests for packages */

    /* Tests for this package objects */
    AddTest(NEW log4oe.Tests.LoggerConfig.AppenderConfiguration()).
    AddTest(NEW log4oe.Tests.LoggerConfig.BasicConfiguration()).
    AddTest(NEW log4oe.Tests.LoggerConfig.Configuration()).
    AddTest(NEW log4oe.Tests.LoggerConfig.DSLogManagerConfig()).
    AddTest(NEW log4oe.Tests.LoggerConfig.LogFileConfig()).
    AddTest(NEW log4oe.Tests.LoggerConfig.LoggerConfiguration()).
    AddTest(NEW log4oe.Tests.LoggerConfig.LogManagerConfig()).

  END CONSTRUCTOR.

END CLASS.