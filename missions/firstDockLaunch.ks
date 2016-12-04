@lazyglobal off.

runoncepath("lib/libwaitforlan").
runoncepath("lib/libwarpfor").
runoncepath("lib/libwaitforfacing").

local tgt to vessel("JSS").

waitForLan(tgt:obt:lan - 6).
runpath("launch", 5, 80, 75000, tgt:obt:inclination, 250000).

for mod in ship:modulesNamed("ModuleRTAntenna") {
  if mod:hasEvent("Activate") {
    mod:doEvent("Activate").
  }
}

panels on.
sas off.

ship:modulesnamed("ModuleDecouple")[0]:doEvent("Decouple").

// KSP seems to pick a random ship to switch to after decoupling, so don't deorbit automatically
//warpFor(500).
//lock steering to retrograde.
//rcs on.
//waitForFacing(5, false, true).
//set ship:control:fore to 1.
//wait 10.
//lock throttle to 1.
//wait until ship:obt:periapsis < 30000.
//lock throttle to 0.
//unlock steering.
//rcs off.
