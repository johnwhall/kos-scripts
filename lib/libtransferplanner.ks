@lazyglobal off.

runoncepath("lib/libmath").
runoncepath("lib/liborbit").
runoncepath("lib/liblambert").

function doCalc {
  parameter obt1, obt2, minDprt, maxDprt, nDprtPoints, minTof, maxTof, nTofPoints, includeCaptureDV.
  print "doCalc: dprt: " + minDprt + "-" + maxDprt + "/" + nDprtPoints + " (res " + ((maxDprt - minDprt) / nDprtPoints) + ") " + minTof + "-" + maxTof + "/" + nTofPoints + " (res " + ((maxTof - minTof) / nTofPoints) + ")".
  local bdy to choose obt2:orbit:body if obt2:isType("Orbital") else obt2:body.

  local res to lexicon("success", false).
  local iDprt to 0.
  local iTof to 0.
  until iDprt >= nDprtPoints {
    local dprt to lerp(minDprt, maxDprt, iDprt / (nDprtPoints - 1)).

    until iTof >= nTofPoints {
      local tof to lerp(minTof, maxTof, iTof / (nTofPoints - 1)).
      local arvl to dprt + tof.

      //local parkObtDprt to predictOrbit(dprt, obt1).
      //local tgtObtArvl to predictOrbit(arvl, obt2).
      local parkPosDprt to predictPosition(dprt, obt1).
      local parkVelDprt to predictVelocity(dprt, obt1).
      local tgtPosArvl to predictPosition(arvl, obt2).
      local tgtVelArvl to predictVelocity(arvl, obt2).

      local lbRes to lancasterBlanchard(bdy:mu, parkPosDprt - bdy:position, tgtPosArvl - bdy:position, tof, 0).
      if lbRes:converged {
        local dv to (parkVelDprt:orbit - lbRes:v1Vec):mag.
        if includeCaptureDV { set dv to dv + (tgtVelArvl:orbit - lbRes:v2Vec):mag. }
        if not res:success or dv < res:dv { set res to lexicon("success", true, "dv", dv, "dprt", dprt, "tof", tof). }
      }

      set iTof to iTof + 1.
    }

    set iDprt to iDprt + 1.
  }

  return res.
}

local includeCaptureDV to false.
local curTime to 0.
local parkObt to predictOrbit(curTime, makeOrbit(28.6, 0, earth:radius + 200000, moon:orbit:lan, 0, 0, 0, earth)).
//local moonObt to predictOrbit(curTime, moon:orbit).
//local moonObt to orbitAt(moon, time(curTime)).
//print time(curTime):seconds.
//print time:seconds.
//dumpOrbit(moon:orbit).
//dumpOrbit(moonObt).
//local ut to moon:orbit:period / 2.
//print "cur position: " + moon:position.
//print "cur obt position: " + moon:orbit:position.
//print "pred position: " + positionAt(moon, time(ut)).
//print "pred obt position: " + orbitAt(moon, time(ut)):position.

local minDprt to curTime.
local maxDprt to curTime + synodicPeriod(parkObt, moon:orbit).
local nDprtPoints to 10.

local minTof to 2 * 24 * 60 * 60.
local maxTof to 8 * 24 * 60 * 60.
local nTofPoints to 10.

local res to doCalc(parkObt, moon, minDprt, maxDprt, nDprtPoints, minTof, maxTof, nTofPoints, includeCaptureDV).
print "Local best dprt: " + res:dprt + " tof: " + res:tof + " dv: " + res:dv.

local dDprt to (maxDprt - minDprt) / nDprtPoints.
local dTof to (maxTof - minTof) / nTofPoints.
set res to doCalc(parkObt, moon, max(minDprt, res:dprt - dDprt / 2), min(maxDprt, res:dprt + dDprt / 2), nDprtPoints, max(minTof, res:tof - dTof / 2), min(maxTof, res:tof + dTof / 2), nTofPoints, includeCaptureDV).
print "Local best dprt: " + res:dprt + " tof: " + res:tof + " dv: " + res:dv.

local dDprt to (maxDprt - minDprt) / (nDprtPoints^2).
local dTof to (maxTof - minTof) / (nTofPoints^2).
set res to doCalc(parkObt, moon, max(minDprt, res:dprt - dDprt / 2), min(maxDprt, res:dprt + dDprt / 2), nDprtPoints, max(minTof, res:tof - dTof / 2), min(maxTof, res:tof + dTof / 2), nTofPoints, includeCaptureDV).
print "Local best dprt: " + res:dprt + " tof: " + res:tof + " dv: " + res:dv.

print "Global best dprt: " + res:dprt + " tof: " + res:tof + " dv: " + res:dv.
