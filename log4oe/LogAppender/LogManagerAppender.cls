
 /*------------------------------------------------------------------------
    File        : LogManagerAppender
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed May 30 15:03:41 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.AbstractLogAppender.
USING log4oe.LogAppender.ILogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LogAppender.LogManagerAppender INHERITS AbstractLogAppender IMPLEMENTS ILogAppender:

    METHOD PUBLIC OVERRIDE VOID Log(INPUT piLogLevel AS INTEGER, INPUT pcMessage AS CHARACTER):

        IF Config:getSubsystemName() NE "" AND Config:getSubsystemName() NE ? THEN
        DO:
            LOG-MANAGER:WRITE-MESSAGE(pcMessage, Config:getSubsystemName()).
        END.
        ELSE
        DO:
            LOG-MANAGER:WRITE-MESSAGE(pcMessage).
        END.

    END METHOD.

END CLASS.