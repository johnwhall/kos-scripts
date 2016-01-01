@lazyglobal off.

run once execnode.funs.ks.

parameter settleFuel.

local execNodeState to list().
execNodeStart(settleFuel, execNodeState).
wait until not execNodeContinue(execNodeState).
execNodeStop(execNodeState).
remove nextnode.
