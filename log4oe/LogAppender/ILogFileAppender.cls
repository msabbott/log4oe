
/*------------------------------------------------------------------------
    File        : ILogFileAppender
    Purpose     : 
    Syntax      : 
    Description : Interface for LogAppenders that write to files directly
    Author(s)   : Mark Abbott
    Created     : Thu Apr 18 10:19:17 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE log4oe.LogAppender.ILogFileAppender:
    
    METHOD PUBLIC CHARACTER getOutputFileName().
  
END INTERFACE.