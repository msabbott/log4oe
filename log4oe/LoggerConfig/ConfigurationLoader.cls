 
 /*------------------------------------------------------------------------
    File        : ConfigurationLoader
    Purpose     : 
    Syntax      : 
    Description : Base class for loading configuration data
    Author(s)   : Mark Abbott
    Created     : Fri Jun 21 16:24:36 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.IConfigurationLoader.
USING log4oe.LoggerConfig.IConfiguration.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LoggerConfig.ConfigurationLoader IMPLEMENTS IConfigurationLoader ABSTRACT:
    
    DEFINE PROTECTED PROPERTY config AS IConfiguration NO-UNDO
    PROTECTED GET.
    PROTECTED SET.
    
    METHOD PUBLIC ABSTRACT VOID Initialise().
    
    METHOD PUBLIC ABSTRACT IConfiguration BuildConfiguration().
    
    METHOD PUBLIC IConfiguration getConfiguration():
        RETURN config.
    END METHOD. 
    
END CLASS.