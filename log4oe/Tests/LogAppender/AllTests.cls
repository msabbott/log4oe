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

CLASS log4oe.tests.LogAppender.AllTests INHERITS TestSuite:

  CONSTRUCTOR AllTests():
    /* Tests for packages */

    /* Tests for this package objects */
    AddTest(NEW log4oe.Tests.LogAppender.DSLogManagerAppender()).
    AddTest(NEW log4oe.Tests.LogAppender.LogFileAppender()).
    AddTest(NEW log4oe.Tests.LogAppender.LogManagerAppender()).

  END CONSTRUCTOR.

END CLASS.