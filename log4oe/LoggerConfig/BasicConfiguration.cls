 
 /*------------------------------------------------------------------------
    File        : BasicConfiguration
    Purpose     : Implements a basic out-of-the-box configuration
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Fri Jun 14 16:48:07 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.IConfiguration.
USING log4oe.LoggerConfig.Configuration.
USING log4oe.LoggerConfig.AppenderConfiguration.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.BasicConfiguration INHERITS Configuration IMPLEMENTS IConfiguration:
    
    DEFINE PUBLIC STATIC PROPERTY DefaultLogAppenderName AS CHARACTER NO-UNDO INITIAL "log4oe.defaultAppender" GET.
    DEFINE PUBLIC STATIC PROPERTY DefaultLoggerName      AS CHARACTER NO-UNDO INITIAL "log4oe.defaultLogger"   GET.
    
	CONSTRUCTOR PUBLIC BasicConfiguration():
	    
	    DEFINE VARIABLE voAppender AS AppenderConfiguration NO-UNDO.
	    
		SUPER().
		
		DefaultLogLevel = LogLevel:WARN.
		
		voAppender = AddAppender(log4oe.LoggerConfig.BasicConfiguration:DefaultLogAppenderName, "log4oe.LogAppender.LogManagerAppender").
		voAppender:AddConfigurationProperty("filename", "messages.log").
		voAppender:AddConfigurationProperty("loglevel", LogLevel:getLogLevelDesc(DefaultLogLevel)).
		AddLogger(log4oe.LoggerConfig.BasicConfiguration:DefaultLoggerName, DefaultLogLevel, log4oe.LoggerConfig.BasicConfiguration:DefaultLogAppenderName).
		
	END CONSTRUCTOR.

END CLASS.