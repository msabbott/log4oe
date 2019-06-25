
/*------------------------------------------------------------------------
    File        : IConfigurationLoader
    Purpose     : 
    Syntax      : 
    Description : Interface for configuration loader classes
    Author(s)   : Mark Abbott
    Created     : Fri Jun 21 16:26:51 BST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LoggerConfig.IConfiguration.

INTERFACE log4oe.LoggerConfig.IConfigurationLoader:
    
    METHOD PUBLIC VOID Initialise().
    
    METHOD PUBLIC IConfiguration BuildConfiguration().
    
    METHOD PUBLIC IConfiguration getConfiguration(). 
  
END INTERFACE.