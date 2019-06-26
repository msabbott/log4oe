 
 /*------------------------------------------------------------------------
    File        : XMLConfigurationLoader
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Fri Jun 21 16:33:30 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.ConfigurationLoader.
USING log4oe.LoggerConfig.IConfigurationLoader.
USING log4oe.LoggerConfig.Configuration.
USING log4oe.LoggerConfig.IConfiguration.
USING log4oe.LoggerConfig.AppenderConfiguration.
USING log4oe.LoggerConfig.LoggerConfiguration.
USING log4oe.LogLevel.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.XMLConfigurationLoader INHERITS ConfigurationLoader IMPLEMENTS IConfigurationLoader:
    
    DEFINE PROTECTED PROPERTY FileName AS CHARACTER NO-UNDO
    PROTECTED GET. 
    PROTECTED SET.
    
    DEFINE PROTECTED PROPERTY XMLDocument AS HANDLE NO-UNDO
    PROTECTED GET.
    PROTECTED SET.
    
    METHOD PUBLIC VOID setFileName(INPUT pcFileName AS CHARACTER):
        
        IF pcFileName = ? OR pcFileName = "" THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Invalid file name provided").
        END.
        
        ASSIGN FileName = pcFileName.
    END METHOD.
    
    METHOD OVERRIDE PUBLIC VOID Initialise():
        
        DELETE OBJECT config      NO-ERROR.
        DELETE OBJECT XMLDocument NO-ERROR.
        
        ASSIGN config = NEW Configuration().
        
        CREATE X-DOCUMENT XMLDocument.
        
    END METHOD.
    
    METHOD PUBLIC OVERRIDE IConfiguration BuildConfiguration():
        
        DEFINE VARIABLE vlLoadResult       AS LOGICAL NO-UNDO.
        DEFINE VARIABLE vhRootElement      AS HANDLE  NO-UNDO.
        DEFINE VARIABLE vhAppendersElement AS HANDLE  NO-UNDO.
        DEFINE VARIABLE vhLoggersElement   AS HANDLE  NO-UNDO.
        DEFINE VARIABLE vhCurrentElement   AS HANDLE  NO-UNDO.
        DEFINE VARIABLE viLoop             AS INTEGER NO-UNDO.
        
        Initialise().
        
        IF FILENAME = ? OR TRIM(FileName) = "" THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("XML file name has not been provided").
        END.
        
        DO ON ERROR UNDO, THROW:
            
            // Need to use "NO-ERROR" and assign result into logical, as the LOAD process still
            // logs an error even if the CATCH block is in place
            ASSIGN vlLoadResult = XMLDocument:LOAD("FILE", FileName, FALSE) NO-ERROR.
        
            IF NOT vlLoadResult THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("").
            END.

            CATCH e AS Progress.Lang.Error :
                
                UNDO, THROW NEW Progress.Lang.AppError("Could not open XML file " + FileName).
            		
            END CATCH.
        
        END.
        
        CREATE X-NODEREF vhRootElement.
        CREATE X-NODEREF vhCurrentElement.
        
        XMLDocument:GET-DOCUMENT-ELEMENT(vhRootElement).
        
        // If there is a global loglevel attribute set
        IF LOOKUP("loglevel", vhRootElement:ATTRIBUTE-NAMES) > 0 THEN
        DO:
            config:setDefaultLogLevel(vhRootElement:GET-ATTRIBUTE("loglevel")).
        END.
        
        RootElementChildLoop:
        DO viLoop = 1 TO vhRootElement:NUM-CHILDREN:
            
            // Fetch child node
            IF NOT vhRootElement:GET-CHILD(vhCurrentElement, viLoop) THEN NEXT RootElementChildLoop.
            
            // Ignore text or comment nodes
            IF vhCurrentElement:SUBTYPE = "COMMENT" OR vhCurrentElement:SUBTYPE = "TEXT" THEN NEXT RootElementChildLoop.
            
            // Process element
            CASE vhCurrentElement:LOCAL-NAME:
                
                WHEN "Appenders" THEN
                DO:
                    IF VALID-HANDLE(vhAppendersElement) THEN
                    DO:
                        UNDO, THROW NEW Progress.Lang.AppError("Duplicated Appenders section encountered").
                    END.
                    
                    ASSIGN vhAppendersElement = vhCurrentElement.
                    
                    ProcessAppendersNode(vhAppendersElement).
                END.
                
                WHEN "Loggers" THEN
                DO:
                    IF VALID-HANDLE(vhLoggersElement) THEN
                    DO:
                        UNDO, THROW NEW Progress.Lang.AppError("Duplicated Loggers section encountered").
                    END.
                    
                    ASSIGN vhLoggersElement = vhCurrentElement. 
                    
                    ProcessLoggersNode(vhLoggersElement).
                END.
                 
                OTHERWISE
                DO:
                    UNDO, THROW NEW Progress.Lang.AppError("Unexpected element '" + vhCurrentElement:NAME + "' encountered.").
                END.
                
            END CASE.
            
        END.
        
        RETURN config.       
       
    END METHOD.
    
    METHOD PRIVATE VOID ProcessAppendersNode(INPUT phAppendersNode AS HANDLE):
        
        DEFINE VARIABLE vhCurrentElement AS HANDLE  NO-UNDO.
        DEFINE VARIABLE viLoop           AS INTEGER NO-UNDO.
        
        CREATE X-NODEREF vhCurrentElement.
        
        AppendersElementLoop:
        DO viLoop = 1 TO phAppendersNode:NUM-CHILDREN:
            
            IF NOT phAppendersNode:GET-CHILD(vhCurrentElement, viLoop) THEN NEXT AppendersElementLoop.
            
            // Ignore text or comment nodes
            IF vhCurrentElement:SUBTYPE = "COMMENT" OR vhCurrentElement:SUBTYPE = "TEXT" THEN NEXT AppendersElementLoop.
            
            CASE vhCurrentElement:LOCAL-NAME:
                
                WHEN "Appender" THEN
                DO:
                    ProcessAppenderNode(vhCurrentElement).
                END.
                
            END CASE.
            
        END.
        
    END METHOD.
    
    METHOD PRIVATE VOID ProcessAppenderNode(INPUT phAppenderNode AS HANDLE):
        
        DEFINE VARIABLE vcType            AS CHARACTER             NO-UNDO.
        DEFINE VARIABLE vcName            AS CHARACTER             NO-UNDO.
        DEFINE VARIABLE voAppenderConfig  AS AppenderConfiguration NO-UNDO.
        DEFINE VARIABLE vhPropertyElement AS HANDLE                NO-UNDO.
        DEFINE VARIABLE viPropertyLoop    AS INTEGER               NO-UNDO.
        
        CREATE X-NODEREF vhPropertyElement.
        
        // Check that name attribute is set
        IF LOOKUP("name", phAppenderNode:ATTRIBUTE-NAMES) = 0 OR phAppenderNode:GET-ATTRIBUTE("name") = "" OR phAppenderNode:GET-ATTRIBUTE("name") = ? THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Required 'name' attribute not set on appender").
        END.
        ELSE
        DO:
            ASSIGN vcName = TRIM(phAppenderNode:GET-ATTRIBUTE("name")).
        END.
        
        // If a type is set, extract it and confirm it exists
        IF LOOKUP("type", phAppenderNode:ATTRIBUTE-NAMES) = 0 THEN
        DO:
            ASSIGN vcType = "log4oe.LogAppender.LogManagerAppender".
        END.
        ELSE
        DO:
            ASSIGN vcType = GetFullTypeName(phAppenderNode:GET-ATTRIBUTE("type"), "log4oe.LogAppender", "Appender").
            
            IF vcType = ? THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Appender type of '" + phAppenderNode:GET-ATTRIBUTE("type") + "' not found").
            END.
        END.
        
        // Add appender to configuration
        ASSIGN voAppenderConfig = config:AddAppender(vcName, vcType).
        
        // Loop through child elements to process any properties
        AppenderPropertiesElementLoop:
        DO viPropertyLoop = 1 TO phAppenderNode:NUM-CHILDREN:
            
            IF NOT phAppenderNode:GET-CHILD(vhPropertyElement, viPropertyLoop) THEN NEXT AppenderPropertiesElementLoop.
            
            // Ignore text or comment nodes
            IF vhPropertyElement:SUBTYPE = "COMMENT" OR vhPropertyElement:SUBTYPE = "TEXT" THEN NEXT AppenderPropertiesElementLoop.
            
            CASE vhPropertyElement:LOCAL-NAME:
                
                WHEN "Property" THEN
                DO:
                    ProcessAppenderPropertyNode(voAppenderConfig, vhPropertyElement).
                END.
                
            END CASE.
            
        END.
        
    END METHOD.
    
    METHOD PRIVATE VOID ProcessAppenderPropertyNode(INPUT poAppenderConfig AS AppenderConfiguration, INPUT phPropertyName AS HANDLE):
        
        DEFINE VARIABLE vcName  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE vcValue AS CHARACTER NO-UNDO.
        
        // Check that require properties exist
        IF LOOKUP("name", phPropertyName:ATTRIBUTE-NAMES) = 0 OR phPropertyName:GET-ATTRIBUTE("name") = "" OR phPropertyName:GET-ATTRIBUTE("name") = ? THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Required 'name' attribute not set on appender property").
        END.
        ELSE
        DO:
            ASSIGN vcName = TRIM(phPropertyName:GET-ATTRIBUTE("name")).
        END.
        
        IF LOOKUP("value", phPropertyName:ATTRIBUTE-NAMES) = 0 OR phPropertyName:GET-ATTRIBUTE("value") = ? THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Required 'value' attribute not set on appender property").
        END.
        ELSE
        DO:
            ASSIGN vcValue = TRIM(phPropertyName:GET-ATTRIBUTE("value")).
        END.
        
        poAppenderConfig:AddConfigurationProperty(vcName, vcValue).
        
    END METHOD.
    
    METHOD PRIVATE VOID ProcessLoggersNode(INPUT phLoggersNode AS HANDLE):
        
        DEFINE VARIABLE vhCurrentElement AS HANDLE  NO-UNDO.
        DEFINE VARIABLE viLoop           AS INTEGER NO-UNDO.
        
        CREATE X-NODEREF vhCurrentElement.
        
        LoggersElementLoop:
        DO viLoop = 1 TO phLoggersNode:NUM-CHILDREN:
            
            IF NOT phLoggersNode:GET-CHILD(vhCurrentElement, viLoop) THEN NEXT LoggersElementLoop.
            
            // Ignore text or comment nodes
            IF vhCurrentElement:SUBTYPE = "COMMENT" OR vhCurrentElement:SUBTYPE = "TEXT" THEN NEXT LoggersElementLoop.
            
            CASE vhCurrentElement:LOCAL-NAME:
                
                WHEN "Logger" THEN
                DO:
                    ProcessLoggerNode(vhCurrentElement).
                END.
                
            END CASE.
            
        END.
    END METHOD.
    
    METHOD PRIVATE VOID ProcessLoggerNode(INPUT phLoggerNode AS HANDLE):
        
        DEFINE VARIABLE vcType               AS CHARACTER           NO-UNDO.
        DEFINE VARIABLE vcName               AS CHARACTER           NO-UNDO.
        DEFINE VARIABLE vcSubsystemName      AS CHARACTER           NO-UNDO.
        DEFINE VARIABLE viLevel              AS INTEGER             NO-UNDO.
        DEFINE VARIABLE voLoggerConfig       AS LoggerConfiguration NO-UNDO.
        DEFINE VARIABLE vhAppenderRefElement AS HANDLE              NO-UNDO.
        DEFINE VARIABLE viAppenderRefLoop    AS INTEGER             NO-UNDO.
        
        CREATE X-NODEREF vhAppenderRefElement.
        
        // Check that name attribute is set
        IF LOOKUP("name", phLoggerNode:ATTRIBUTE-NAMES) = 0 OR phLoggerNode:GET-ATTRIBUTE("name") = "" OR phLoggerNode:GET-ATTRIBUTE("name") = ? THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Required 'name' attribute not set on logger").
        END.
        ELSE
        DO:
            ASSIGN vcName = TRIM(phLoggerNode:GET-ATTRIBUTE("name")).
        END.
        
        // If a type is set, extract it and confirm it exists
        IF LOOKUP("type", phLoggerNode:ATTRIBUTE-NAMES) = 0 THEN
        DO:
            ASSIGN vcType = "log4oe.Logger.BasicLogger".
        END.
        ELSE
        DO:
            ASSIGN vcType = GetFullTypeName(phLoggerNode:GET-ATTRIBUTE("type"), "log4oe.Logger", "Logger").
            
            IF vcType = ? THEN
            DO:
                UNDO, THROW NEW Progress.Lang.AppError("Logger type of '" + phLoggerNode:GET-ATTRIBUTE("type") + "' not found").
            END.
        END.
        
        // Extract a subsystem name if set
        IF LOOKUP("subsystem", phLoggerNode:ATTRIBUTE-NAMES) = 0 THEN
        DO:
            ASSIGN vcSubsystemName = ?.
        END.
        ELSE
        DO:
            ASSIGN vcSubsystemName = TRIM(phLoggerNode:GET-ATTRIBUTE("subsystem")).
        END.
        
        
        // If a level is set, extract it and convert it
        IF LOOKUP("level", phLoggerNode:ATTRIBUTE-NAMES) NE 0 THEN
        DO:
            ASSIGN viLevel = LogLevel:getLogLevelFromText(phLoggerNode:GET-ATTRIBUTE("level"), config:DefaultLogLevel).
        END.
        ELSE
        DO:
            ASSIGN viLevel = config:DefaultLogLevel.
        END.
        
        // Add appender to configuration
        ASSIGN voLoggerConfig = config:AddLogger(vcName, viLevel, vcSubsystemName, ?).
        
        // Loop through child elements to process AppenderRefs
        LoggerAppenderRefElementLoop:
        DO viAppenderRefLoop = 1 TO phLoggerNode:NUM-CHILDREN:
            
            IF NOT phLoggerNode:GET-CHILD(vhAppenderRefElement, viAppenderRefLoop) THEN NEXT LoggerAppenderRefElementLoop.
            
            // Ignore text or comment nodes
            IF vhAppenderRefElement:SUBTYPE = "COMMENT" OR vhAppenderRefElement:SUBTYPE = "TEXT" THEN NEXT LoggerAppenderRefElementLoop.
            
            CASE vhAppenderRefElement:LOCAL-NAME:
                
                WHEN "AppenderRef" THEN
                DO:
                    ProcessLoggerAppenderRefNode(voLoggerConfig, vhAppenderRefElement).
                END.
                
            END CASE.
            
        END.
        
    END METHOD.
    
    METHOD PRIVATE VOID ProcessLoggerAppenderRefNode(INPUT poLoggerConfig AS LoggerConfiguration, INPUT phAppenderRefElement AS HANDLE):
        
        DEFINE VARIABLE vcRef AS CHARACTER NO-UNDO.
        
        // Check that require properties exist
        IF LOOKUP("ref", phAppenderRefElement:ATTRIBUTE-NAMES) = 0 OR phAppenderRefElement:GET-ATTRIBUTE("ref") = "" OR phAppenderRefElement:GET-ATTRIBUTE("ref") = ? THEN
        DO:
            UNDO, THROW NEW Progress.Lang.AppError("Required 'ref' attribute not set on AppenderRef element").
        END.
        ELSE
        DO:
            ASSIGN vcRef = TRIM(phAppenderRefElement:GET-ATTRIBUTE("ref")).
        END.
        
        poLoggerConfig:AddAppenderName(vcRef).
        
    END METHOD.
    
    METHOD PRIVATE Progress.Lang.Class ClassExists(INPUT pcTypeName AS CHARACTER):
        
        DEFINE VARIABLE vhClass AS Progress.Lang.Class NO-UNDO.
        
        DO ON ERROR UNDO, THROW:
            
            ASSIGN vhClass = Progress.Lang.Class:GetClass(pcTypeName).
        
            CATCH e AS Progress.Lang.Error :
                
               ASSIGN vhClass = ?.
                    
            END CATCH.
        
        END.
        
        RETURN vhClass.
        
    END METHOD.
    
    METHOD PRIVATE CHARACTER GetFullTypeName(INPUT pcTypeName AS CHARACTER, INPUT pcTypePackage AS CHARACTER, INPUT pcSuffix AS CHARACTER):
        
        DEFINE VARIABLE vhClass AS Progress.Lang.Class NO-UNDO.
               
        ASSIGN vhClass = ClassExists(pcTypeName).
        
        IF vhClass = ? THEN
        DO:
            ASSIGN vhClass = ClassExists(TRIM(pcTypePackage, ".") + "." + pcTypeName).
        END.
        
        IF vhClass = ? THEN
        DO:
            ASSIGN vhClass = ClassExists(TRIM(pcTypePackage, ".") + "." + pcTypeName + pcSuffix).
        END.
        
        IF NOT VALID-OBJECT(vhClass) THEN
        DO:
            RETURN ?.
        END.
        
        RETURN vhClass:TypeName.
        
    END METHOD.

END CLASS.