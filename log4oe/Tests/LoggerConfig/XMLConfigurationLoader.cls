 
 /*------------------------------------------------------------------------
    File        : XMLConfigurationLoader
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Mark Abbott
    Created     : Tue Jun 25 16:57:00 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.XMLConfigurationLoader.
USING log4oe.LoggerConfig.IConfiguration.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.XMLConfigurationLoader:

    DEFINE PRIVATE VARIABLE voLoader AS XMLConfigurationLoader NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateConfig():
        ASSIGN voLoader = NEW XMLConfigurationLoader().
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteConfig():
        DELETE OBJECT voLoader NO-ERROR.
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Initialise():
        
        // Checking that no errors are thrown
        voLoader:setFileName("Tests/Data/XMLConfigLoaderTests.xml").
        voLoader:Initialise().
        
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID Initialise_NoFileName():
        // Checking that no errors are thrown
        voLoader:Initialise().
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID SetFileName():
        // Checking that no errors are thrown
        voLoader:setFileName("Tests/Data/XMLConfigLoaderTests.xml").
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID SetFileName_InvalidFileName():
        voLoader:setFileName("ThisFileDoesNotExist.xml").
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID SetFileName_BlankFileName():
        voLoader:setFileName("").
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID SetFileName_NullFileName():
        voLoader:setFileName(?).
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID BuildConfiguration():
        
        DEFINE VARIABLE voConfig AS IConfiguration NO-UNDO.
                
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests.xml").
        voLoader:Initialise().
        ASSIGN voConfig = voLoader:BuildConfiguration().
        
        Assert:IsTrue(VALID-OBJECT(voConfig)).
        
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_NoFileName():
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_InvalidFileName():
        voLoader:setFileName("ThisFileDoesNotExist.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_NotAnXMLFile():
        voLoader:setFileName("log4oe/Tests/Data/TextFile.txt").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_BlankFile():
        voLoader:setFileName("log4oe/Tests/Data/BlankFile.txt").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_MultipleAppenders():
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests-multipleAppenders.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_MultipleLoggers():
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests-multipleLoggers.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_NoAppenderName():
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests-noAppenderName.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_NoLoggerName():
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests-noLoggerName.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_NoAppenderPropName():
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests-noAppenderPropName.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_NoAppenderPropValue():
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests-noAppenderPropValue.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.
    
    @Test(expected="Progress.Lang.AppError").
    METHOD PUBLIC VOID BuildConfiguration_NoAppenderRefRef():
        voLoader:setFileName("log4oe/Tests/Data/XMLConfigLoaderTests-noAppenderRefRef.xml").
        voLoader:Initialise().
        voLoader:BuildConfiguration().
    END METHOD.

END CLASS.