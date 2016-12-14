@lazyglobal off.

parameter tgt, turnTime, ullageTime, tgtDist, turnWithRCS is false.

runoncepath("lib/librendezvous").

rendezvous(tgt, turnTime, ullageTime, tgtDist, turnWithRCS).
