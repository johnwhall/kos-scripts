@lazyglobal off.

run once libfacediff.
run once libwarpfor.
run once libwaitforlan.
run once libmainframe.
run once liblambertoptimize.
run once libburntime.
run once libgenericburn.
run once libtimetotrueanom.

function burnToIntercept {
  parameter lambertResult.

  local t to lambertResult["t"].
  local pro to lambertResult["prograde"].
  local norm to lambertResult["normal"].
  local rad to lambertResult["radial"].
  local dt to lambertResult["dt"].

  print "t = " + t.
  print "pro = " + pro.
  print "norm = " + norm.
  print "rad = " + rad.
  print "dt = " + dt.

  add node(time:seconds + t, rad, norm, pro).

  // Burn for the Moon
  local turnTime to 30.
  local ullageTime to 0.
  local ts to 10.

  local bt to burnTime(nextnode:deltav:mag).
  local burnMidTime to time:seconds + nextnode:eta.

  function cb {
    local soirad to moon:soiradius.
    local moonrad to moon:radius.
    if not ship:orbit:hasnextpatch {
      // wait until we have an encounter
      return 1.
    } else {
      until ship:orbit:hasnextpatch { wait 0.05. }
      local per to ship:orbit:nextpatch:periapsis.
      if per > soirad / 2 {
        // wait until the patch becomes stable enough to measure
        return 1.
      } else {
        return (per + moonrad) / soirad.
      }
    }
  }

  genericBurn(nextnode:deltav, burnMidTime, bt, turnTime, ullageTime, ts, cb@).

  remove nextnode.
}

mainframeClean().

waitForLAN(0).

wait 10.

run launch(5, 55).

unlock steering.
sas off.

panels on.

local modRT to ship:partstitled("Reflectron KR-7")[0]:getModule("ModuleRTAntenna").
modRT:doEvent("activate").
modRT:setField("target", earth).

for p in ship:partstitled("Communotron 16") {
  local m to p:getModule("ModuleRTAntenna").
  m:doEvent("activate").
}

wait 10.

stage.

wait 45.

local es to list().
list engines in es.
es[0]:activate().

wait 1.

local tliResult to lambertOptimize(ship, moon, false).
burnToIntercept(tliResult).

if ship:orbit:nextpatch:periapsis > 0 {
  local tt120 to timeToTrueAnom(120).
  local tt270 to timeToTrueAnom(270).
  local corrResult to lambertOptimizeBounded(ship, moon, tt120, tt120, 0, tt270 - tt120, false).
  burnToIntercept(corrResult).
}

warpFor1(eta:transition - 10).
wait until ship:body = moon.

if ship:orbit:periapsis > 0 {
  lock steering to vcrs(vcrs(ship:orbit:position, ship:orbit:velocity:orbit), ship:orbit:velocity:orbit).
  wait until faceDiff() < 0.5.
  lock throttle to 1.
  wait until ship:orbit:periapsis < -1000.
  unlock throttle.
  unlock steering.
}

warpFor1(eta:periapsis - 15 * 60).
set warp to 1.
wait until altitude < 200000.
set warp to 0.
wait 1.

for p in ship:parts {
  for mName in p:modules {
    if mName = "ModuleScienceExperiment" {
      local m to p:getModule(mName).
      m:deploy().
      wait until m:hasData.
      m:transmit().
    }
  }
}
