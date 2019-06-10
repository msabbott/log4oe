
 /*------------------------------------------------------------------------
    File        : LogLevel
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Tue May 29 20:28:41 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LogLevel ABSTRACT:

    DEFINE PUBLIC STATIC PROPERTY ALL   AS INTEGER NO-UNDO INITIAL 7 GET.
    DEFINE PUBLIC STATIC PROPERTY TRACE AS INTEGER NO-UNDO INITIAL 6 GET.
    DEFINE PUBLIC STATIC PROPERTY DEBUG AS INTEGER NO-UNDO INITIAL 5 GET.
    DEFINE PUBLIC STATIC PROPERTY INFO  AS INTEGER NO-UNDO INITIAL 4 GET.
    DEFINE PUBLIC STATIC PROPERTY WARN  AS INTEGER NO-UNDO INITIAL 3 GET.
    DEFINE PUBLIC STATIC PROPERTY ERROR AS INTEGER NO-UNDO INITIAL 2 GET.
    DEFINE PUBLIC STATIC PROPERTY FATAL AS INTEGER NO-UNDO INITIAL 1 GET.
    DEFINE PUBLIC STATIC PROPERTY OFF   AS INTEGER NO-UNDO INITIAL 0 GET.
    
    METHOD PUBLIC STATIC CHARACTER getLogLevelDesc(INPUT piLogLevel AS INTEGER):
        
        DEFINE VARIABLE vcDesc AS CHARACTER NO-UNDO.
        
        CASE piLogLevel:
            
            WHEN 0 THEN
            DO:
                ASSIGN vcDesc = "OFF".
            END.
            
            WHEN 1 THEN
            DO:
                ASSIGN vcDesc = "FATAL".
            END.
            
            WHEN 2 THEN
            DO:
                ASSIGN vcDesc = "ERROR".
            END.
            
            WHEN 3 THEN
            DO:
                ASSIGN vcDesc = "WARN".
            END.
            
            WHEN 4 THEN
            DO:
                ASSIGN vcDesc = "INFO".
            END.
            
            WHEN 5 THEN
            DO:
                ASSIGN vcDesc = "DEBUG".
            END.
            
            WHEN 6 THEN
            DO:
                ASSIGN vcDesc = "TRACE".
            END.
            
            WHEN 7 THEN
            DO:
                ASSIGN vcDesc = "ALL".
            END.
            
            OTHERWISE
            DO:
                ASSIGN vcDesc = "?????".
            END.
            
        END CASE.
        
        RETURN vcDesc.
        
    END METHOD.

    METHOD PUBLIC STATIC CHARACTER getLogLevelFixedWidthDesc(INPUT piLogLevel AS INTEGER):
        
        RETURN SUBSTRING(log4oe.LogLevel:getLogLevelDesc(piLogLevel) + "     ", 1, 5).
        
    END METHOD.
    
    METHOD PUBLIC STATIC INTEGER getLogLevelFromText(INPUT pcLogLevel AS CHARACTER, INPUT piDefaultLevel AS INTEGER):
        
        DEFINE VARIABLE viLogLevel AS INTEGER NO-UNDO.
        
        ASSIGN viLogLevel = getLogLevelFromText(pcLogLevel).
        
        IF viLogLevel = ? OR viLogLevel < 0 THEN
        DO:
            ASSIGN viLogLevel = piDefaultLevel.
        END.
        
        RETURN viLogLevel.
        
    END METHOD.
    
    METHOD PUBLIC STATIC INTEGER getLogLevelFromText(INPUT pcLogLevel AS CHARACTER):
        
        DEFINE VARIABLE viLogLevel AS INTEGER NO-UNDO INITIAL -1.
        
        CASE(TRIM(pcLogLevel)):

            WHEN "ALL" THEN
            DO:
                ASSIGN viLogLevel = 7.
            END.

            WHEN "TRACE" THEN
            DO:
                ASSIGN viLogLevel = 6.
            END.
                
            WHEN "DEBUG" THEN
            DO:
                ASSIGN viLogLevel = 5.
            END.
                
            WHEN "INFO" OR WHEN "INFORMATION" THEN
            DO:
                ASSIGN viLogLevel = 4.
            END.
                
            WHEN "WARN" OR WHEN "WARNING" THEN
            DO:
                ASSIGN viLogLevel = 3.
            END.
                
            WHEN "ERROR" THEN
            DO:
                ASSIGN viLogLevel = 2.
            END.
                
            WHEN "FATAL" THEN
            DO:
                ASSIGN viLogLevel = 1.
            END.
                
            WHEN "OFF" THEN
            DO:
                ASSIGN viLogLevel = 0.
            END.
            
        END CASE.
        
        RETURN viLogLevel.
        
    END METHOD.
END CLASS.