@lazyglobal off.

parameter tgt, turnTime, rcsIsp, rcsThrust, tgtDist, turnWithRCS is false.

runoncepath("lib/librendezvous").

rendezvous(tgt, turnTime, 0, tgtDist, turnWithRCS, true, rcsIsp, rcsThrust).
