@lazyglobal off.

parameter port, manDist to 25.

runoncepath("lib/libfacediff").
runoncepath("lib/libsasrcsstack").

pushRCS(false).

clearVecDraws().
local highlightPort to highlight(port, rgb(0, 1, 1)).
set highlightPort:enabled to true.

lock steering to lookdirup(port:nodeposition, ship:facing:topvector).
wait until faceDiff(true) < 0.5.

local tgtDist to manDist.
local lock desiredPosition to port:nodeposition + tgtDist * port:portfacing:vector.

popRCS().
pushRCS(true).

local lastTime to time:seconds.
local lastDist to port:nodeposition:mag.
local lastTopDistVec to vxcl(ship:facing:vector, vxcl(ship:facing:starvector, desiredPosition)). 
local lock lastTopDist to lastTopDistVec:mag.
local lastStarDistVec to vxcl(ship:facing:vector, vxcl(ship:facing:topvector, desiredPosition)). 
local lock lastStarDist to lastStarDistVec:mag.

wait 0.05.

local curTime to time:seconds.
local curDist to port:nodeposition:mag.
local lock distRate to (curDist - lastDist) / (curTime - lastTime).
local curTopDistVec to vxcl(ship:facing:vector, vxcl(ship:facing:starvector, desiredPosition)). 
local lock topVel to (curTopDistVec - lastTopDistVec) / (curTime - lastTime).
local lock curTopDist to curTopDistVec:mag.
local lock topRate to (curTopDist - lastTopDist) / (curTime - lastTime).
local curStarDistVec to vxcl(ship:facing:vector, vxcl(ship:facing:topvector, desiredPosition)). 
local lock starVel to (curStarDistVec - lastStarDistVec) / (curTime - lastTime).
local lock curStarDist to curStarDistVec:mag.
local lock starRate to (curStarDist - lastStarDist) / (curTime - lastTime).

local desPosDraw to vecdraw(port:nodeposition, desiredPosition - port:nodeposition, rgb(1, 0, 0), "", 1, true, 0.2).
local topDistVecDraw to vecdraw(ship:position, V(0, 0, 0), rgb(0, 1, 0)).
local starDistVecDraw to vecdraw(ship:position, V(0, 0, 0), rgb(0, 0, 1)).

function dock_updateDists {
  set lastTime to curTime.
  set lastDist to curDist.
  set lastTopDistVec to curTopDistVec.
  set lastStarDistVec to curStarDistVec.

  set curTime to time:seconds.
  set curDist to port:nodeposition:mag.
  set curTopDistVec to vxcl(ship:facing:vector, vxcl(ship:facing:starvector, desiredPosition)). 
  set curStarDistVec to vxcl(ship:facing:vector, vxcl(ship:facing:topvector, desiredPosition)). 
}

function dock_updateVecDraws {
  parameter showTopStarVecs.

  set desPosDraw:start to port:nodeposition.
  set desPosDraw:vec to desiredPosition - port:nodeposition.

  if showTopStarVecs {
    set topDistVecDraw:start to ship:position.
    set topDistVecDraw:vec to curTopDistVec.
    set topDistVecDraw:show to true.
    set starDistVecDraw:start to ship:position.
    set starDistVecDraw:vec to curStarDistVec.
    set starDistVecDraw:show to true.
  } else {
    set topDistVecDraw:show to false.
    set starDistVecDraw:show to false.
  }
}

function dock_setFore {
  parameter tgtRate.
  set ship:control:fore to max(-1, min(1, 10 * (distRate -  tgtRate))).
  //print "curDist: " + curDist + " distRate: " + distRate + " tgtRate: " + tgtRate.
}

function dock_cancelTop {
  local topSign to -1.
  if vang(ship:facing:topvector, topVel) > 90 { set topSign to 1. }
  set ship:control:top to max(-1, min(1, topSign * 5 * topVel:mag)).
}

function dock_cancelStar {
  local starSign to -1.
  if vang(ship:facing:starvector, starVel) > 90 { set starSign to 1. }
  set ship:control:starboard to max(-1, min(1, starSign * 5 * starVel:mag)).
}

function dock_setTop {
  parameter tgtTopRate.
  local topScale to max(-1, min(1, 20 * (topRate - tgtTopRate))).
  local topSign to 1.
  if vang(ship:facing:topvector, curTopDistVec) > 90 { set topSign to -1.  }
  print "curTopDist: " + curTopDist + " top rate: " + topRate + " tgtTopRate: " + tgtTopRate + " top: " + (topSign * topScale).
  set ship:control:top to max(-1, min(1, topSign * topScale)).
}

function dock_setStar {
  parameter tgtStarRate.
  local starScale to max(-1, min(1, 20 * (starRate - tgtStarRate))).
  local starSign to 1.
  if vang(ship:facing:starvector, curStarDistVec) > 90 { set starSign to -1.  }
  print "curStarDist: " + curStarDist + " star rate: " + starRate + " tgtStarRate: " + tgtStarRate + " star: " + (starSign * starScale).
  set ship:control:starboard to max(-1, min(1, starSign * starScale)).
}

until abs(distRate) < 0.1 and abs(manDist - curDist) < 1 {
  // move to the maneuver distance
  dock_updateDists().
  dock_setFore(max(-2, min(2, (tgtDist - curDist) / 20))).
  dock_cancelTop().
  dock_cancelStar().
  dock_updateVecDraws(true).
  wait 0.05.
}

until desiredPosition:mag < 0.5 {
  // move to in front of the target docking port
  dock_updateDists().
  dock_setFore(max(-2, min(2, (tgtDist - curDist) / 20))).
  dock_setTop(-curTopDist / 50).
  dock_setStar(-curStarDist / 50).
  dock_updateVecDraws(true).
  wait 0.05.
}

until port:state <> "Ready" {
  // move in to dock
  dock_updateDists().
  dock_setFore(-0.1).
  dock_setTop(-curTopDist / 50).
  dock_setStar(-curStarDist / 50).
  dock_updateVecDraws(true).
  wait 0.05.
}

popRCS().
unlock steering.
set highlightPort:enabled to false.
clearVecDraws().
