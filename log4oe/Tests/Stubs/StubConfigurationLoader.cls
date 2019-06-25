 
 /*------------------------------------------------------------------------
    File        : StubConfigurationLoader
    Purpose     : 
    Syntax      : 
    Description : Stub for ConfigurationLoader class
    Author(s)   : Mark Abbott
    Created     : Tue Jun 25 17:09:51 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.ConfigurationLoader.
USING log4oe.LoggerConfig.IConfigurationLoader.
USING log4oe.LoggerConfig.IConfiguration.
USING log4oe.LoggerConfig.Configuration.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.Tests.Stubs.StubConfigurationLoader INHERITS ConfigurationLoader IMPLEMENTS IConfigurationLoader: 
    
    METHOD OVERRIDE PUBLIC VOID Initialise():
    END METHOD.
    
    METHOD OVERRIDE PUBLIC IConfiguration BuildConfiguration():
        config = NEW Configuration().
        RETURN config.
    END METHOD.

END CLASS.