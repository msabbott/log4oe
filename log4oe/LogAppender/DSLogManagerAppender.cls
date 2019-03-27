
 /*------------------------------------------------------------------------
    File        : DSLogManagerAppender
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mark Abbott
    Created     : Wed May 30 15:06:42 BST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING log4oe.LogAppender.AbstractLogAppender.
USING log4oe.LogAppender.ILogAppender.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS log4oe.LogAppender.DSLogManagerAppender INHERITS AbstractLogAppender IMPLEMENTS ILogAppender:

    METHOD PUBLIC OVERRIDE VOID Log(INPUT pcMessage AS CHARACTER):

        IF Config:getSubsystemName() NE "" AND Config:getSubsystemName() NE ? THEN
        DO:
            DSLOG-MANAGER:WRITE-MESSAGE(pcMessage).
        END.
        ELSE
        DO:
            DSLOG-MANAGER:WRITE-MESSAGE(pcMessage, Config:getSubsystemName()).
        END.

    END METHOD.

END CLASS.
