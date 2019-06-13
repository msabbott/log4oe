 
 /*------------------------------------------------------------------------
    File        : AppenderConfiguration
    Purpose     : 
    Syntax      : 
    Description : Configuration properties for Appenders
    Author(s)   : Mark Abbott
    Created     : Thu May 30 15:52:29 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.ILogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.AppenderConfiguration:
    
    DEFINE PRIVATE TEMP-TABLE ttAppenderProperty NO-UNDO
        FIELD PropertyName AS CHARACTER
        FIELD PropertyValue AS CHARACTER
        
            INDEX PriKey IS PRIMARY UNIQUE PropertyName ASCENDING.
    
    DEFINE PUBLIC PROPERTY AppenderName AS CHARACTER NO-UNDO INITIAL ?
    PUBLIC GET.
    PROTECTED SET.
    
    DEFINE PUBLIC PROPERTY AppenderType AS CHARACTER NO-UNDO INITIAL ?
    PUBLIC GET.
    PROTECTED SET.
    
	CONSTRUCTOR PUBLIC AppenderConfiguration (INPUT pcAppenderName AS CHARACTER, INPUT pcAppenderType AS CHARACTER):
		SUPER().
		
		CheckAppenderType(pcAppenderType).
		
		ASSIGN AppenderName = pcAppenderName
		       AppenderType = pcAppenderType.
		
	END CONSTRUCTOR.
	
	METHOD PRIVATE VOID CheckAppenderType(INPUT pcAppenderType AS CHARACTER):
	    
	    DEFINE VARIABLE voClass AS Progress.Lang.Class NO-UNDO.
	    
	    DO ON ERROR UNDO, THROW:
	            
           ASSIGN voClass = Progress.Lang.Class:GetClass(pcAppenderType).
           
           // Allow catch block to pickup any further errors from accessing an invalid object
           IF NOT voClass:IsA("log4oe.LogAppender.ILogAppender") THEN
           DO:
               // Throw any error - it will be caught in CATCH and converted to correct type
               UNDO, THROW NEW Progress.Lang.AppError().
           END.
        
           CATCH e AS Progress.Lang.Error :
               
               UNDO, THROW NEW Progress.Lang.AppError("Invalid Appender Type", -2). 
           		
           END CATCH.
           
        END. 
	    
	END METHOD.
	
	METHOD PUBLIC VOID AddConfigurationProperty(INPUT pcName AS CHARACTER, INPUT pcValue AS CHARACTER):
	    
	    FIND FIRST ttAppenderProperty
	         WHERE ttAppenderProperty.PropertyName = pcName
	               EXCLUSIVE-LOCK NO-ERROR.
	               
	    IF NOT AVAILABLE ttAppenderProperty THEN
	    DO:
	        CREATE ttAppenderProperty.
	        ASSIGN ttAppenderProperty.PropertyName = pcName.
	    END.
	    
	    ASSIGN ttAppenderProperty.PropertyValue = pcValue.
	    
	END METHOD.
	
	METHOD PUBLIC VOID ConfigureAppender(INPUT poAppender AS ILogAppender):
	    
	    IF VALID-OBJECT(poAppender) THEN
	    DO:
    	    FOR EACH ttAppenderProperty NO-LOCK
    	          ON ERROR UNDO, THROW:
    
                poAppender:setProperty(ttAppenderProperty.PropertyName, ttAppenderProperty.PropertyValue).
                	              
    	    END.
    	    
    	    // Initialise appender to ensure everything is setup correctly
    	    poAppender:Initialise().
        END.
        
	END METHOD.


END CLASS.