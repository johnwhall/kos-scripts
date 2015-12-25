@lazyglobal off.

parameter fromVol.
parameter toVol.

switch to fromVol.
local lst to false.
list files in lst.

switch to toVol.
for f in lst {
  print "copy " + f:name + " from " + fromVol + ".".
  copy f:name from fromVol.
}
