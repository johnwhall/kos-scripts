@lazyglobal off.

run once libfacediff.
run once libwarpfor.
run once libwaitforlan.
run once libmainframe.
run once liblambertoptimize.
run once libburntime.
run once genericburn.funs.ks.
run once libtimetotrueanom.

function burnToIntercept {
  parameter lambertResult.

  local t to lambertResult[0].
  local pro to lambertResult[1].
  local norm to lambertResult[2].
  local rad to lambertResult[3].
  local dt to lambertResult[4].

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

  local bt to burnTime1(nextnode:deltav:mag).
  local burnMidTime to time:seconds + nextnode:eta.

  genericBurnWait(burnMidTime, bt, turnTime).

  local state to list().
  genericBurnStart(nextnode:deltav, burnMidTime, bt, turnTime,
                   ullageTime, ts, nextnode:deltav:mag, state).

  lock steering to lookdirup(nextnode:deltav, ship:facing:topvector).

  wait until ship:orbit:transition = "ENCOUNTER".

  local lastPeriapsis to ship:orbit:nextpatch:periapsis.
  wait 0.05.

  until ship:orbit:hasnextpatch { wait 0.05.  }
  local curPeriapsis to ship:orbit:nextpatch:periapsis.
  until curPeriapsis > lastPeriapsis {
    set lastPeriapsis to curPeriapsis.
    wait 0.05.
    until ship:orbit:hasnextpatch { wait 0.05.  }
    set curPeriapsis to ship:orbit:nextpatch:periapsis.
  }

  genericBurnStop(state).

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
