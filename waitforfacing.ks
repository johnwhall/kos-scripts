@lazyglobal off.

parameter tgtDiff, includeRoll, stabilizeAtEnd.

runoncepath("lib/libwaitforfacing").

waitForFacing(tgtDiff, includeRoll, stabilizeAtEnd).
