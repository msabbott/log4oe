 
 /*------------------------------------------------------------------------
    File        : BasicLogger
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Wed May 30 16:55:57 BST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.Logger.AbstractLogger.
USING log4oe.Logger.ILogger.
BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Logger.BasicLogger INHERITS AbstractLogger IMPLEMENTS ILogger FINAL:
    
    /* This class is a basic child of AbstractLogger so that it can instantiated */

END CLASS.