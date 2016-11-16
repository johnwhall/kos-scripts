@lazyglobal off.

parameter tgtLAN.

runoncepath("lib/libwaitforlan").

waitForLan(tgtLAN).
