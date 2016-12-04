@lazyglobal off.

runoncepath("lib/libwaitforlan").

local turnTime to 30.
local ullageTime to 5.
local tgt to vessel("JSS").

for mod in ship:modulesNamed("ModuleEnginesRF") {
  if mod:hasEvent("Activate Engine") {
    mod:doEvent("Activate Engine").
  }
}

local manDist to 25.
runpath("rendezvous", tgt, 30, 5, manDist).
runpath("dock", tgt:dockingports[0], manDist).
