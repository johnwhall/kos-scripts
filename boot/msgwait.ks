@lazyglobal off.

wait until not core:messages:empty.
local msg to core:messages:pop().
runpath(msg:content).
set core:bootfilename to "".
