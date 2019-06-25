 
 /*------------------------------------------------------------------------
    File        : ConfigurationLoader
    Purpose     : 
    Syntax      : 
    Description : Unit tests for ConfigurationLoader class
    Author(s)   : Mark Abbott
    Created     : Tue Jun 25 17:08:33 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OEUnit.Assertion.*.
USING log4oe.LoggerConfig.ConfigurationLoader.
USING log4oe.Tests.Stubs.StubConfigurationLoader.
USING log4oe.LoggerConfig.IConfiguration.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.LoggerConfig.ConfigurationLoader: 

    DEFINE PRIVATE VARIABLE voLoader AS StubConfigurationLoader NO-UNDO.

    @Before.
    METHOD PUBLIC VOID CreateConfig():
        ASSIGN voLoader = NEW StubConfigurationLoader().
    END METHOD.

    @After.
    METHOD PUBLIC VOID DeleteConfig():
        DELETE OBJECT voLoader NO-ERROR.
    END METHOD.
    
    @Test.
    METHOD PUBLIC VOID getConfig_ReturnsSameConfig():
        
        DEFINE VARIABLE voConfig AS IConfiguration NO-UNDO.
        
        ASSIGN voConfig = voLoader:BuildConfiguration().
        
        Assert:AreEqual(voLoader:getConfiguration(), voConfig).
        
    END METHOD.
    

END CLASS.