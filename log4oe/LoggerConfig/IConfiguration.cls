
/*------------------------------------------------------------------------
    File        : IConfiguration
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Fri Jun 14 17:09:45 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.AppenderConfiguration.
USING log4oe.LoggerConfig.LoggerConfiguration.

INTERFACE log4oe.LoggerConfig.IConfiguration: 
    
    DEFINE PUBLIC PROPERTY DefaultLogLevel AS INTEGER NO-UNDO PUBLIC GET.
    
    METHOD PUBLIC VOID setDefaultLogLevel(INPUT pcLogLevel AS CHARACTER).
        
    METHOD PUBLIC AppenderConfiguration AddAppender(INPUT pcName AS CHARACTER).
        
    METHOD PUBLIC AppenderConfiguration AddAppender(INPUT pcName AS CHARACTER, INPUT pcType AS CHARACTER).
    
    METHOD PUBLIC AppenderConfiguration AddAppender(INPUT pcAppender AS AppenderConfiguration).
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER).
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT pcAppenderRef AS CHARACTER).
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT piLevel AS INTEGER, INPUT pcAppenderRef AS CHARACTER).
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT piLevel AS INTEGER, INPUT pcSubsystemName AS CHARACTER, INPUT pcAppenderRef AS CHARACTER).
    
    METHOD PUBLIC LoggerConfiguration AddLogger(INPUT pcName AS CHARACTER, INPUT piLevel AS INTEGER, INPUT pcSubsystemName AS CHARACTER, INPUT pcAppenderRef AS CHARACTER, INPUT pcType AS CHARACTER).
    
    METHOD PUBLIC VOID AddLogger(INPUT pcLogger AS LoggerConfiguration).
    
    METHOD PUBLIC VOID Apply().
  
END INTERFACE.