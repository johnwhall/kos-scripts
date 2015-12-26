@lazyglobal off.

run once funs.

// call while coasting to apoapsis

parameter tgtApo. // not including body radius
parameter minPer. // not including body radius
parameter maxPer. // not including body radius
parameter useRCS.

clearscreen.
print "tgtApo  : " at (5, 10).
print "minPer  : " at (5, 11).
print "maxPer  : " at (5, 12).
print "useRCS  : " at (5, 13).
print "curApo  : " at (5, 14).
print "curPer  : " at (5, 15).
print "curPer  : " at (5, 15).
print "taAtmo  : " at (5, 16).
print "tAtmo   : " at (5, 17).

until ship:obt:apoapsis <= tgtApo {

  print "                    " at (15, 10).
  print "                    " at (15, 11).
  print "                    " at (15, 12).
  print "                    " at (15, 13).
  print "                    " at (15, 14).
  print "                    " at (15, 15).
  print tgtApo at (15, 10).
  print minPer at (15, 11).
  print maxPer at (15, 12).
  print useRCS at (15, 13).
  print ship:obt:apoapsis at (15, 14).
  print ship:obt:periapsis at (15, 15).

  // TODO: panels on, face sun

//  if ship:obt:periapsis > maxPer or ship:obt:periapsis < minPer {
//    local tgtSMA to (ship:obt:apoapsis + (minPer + maxPer)/2 + 2 * body:radius) / 2.
//    local v to sqrt(body:mu * (2 / (ship:obt:apoapsis + body:radius) - 1 / ship:obt:semimajoraxis)).
//    local tgtV to sqrt(body:mu * (2 / (ship:obt:apoapsis + body:radius) - 1 / tgtSMA)).
//    local dv to abs(tgtV - v).
//
//    if ship:obt:periapsis > maxPer { set dv to -1 * dv. }
//
//    print "creating node with deltav prograde of " + dv.
//    add node(time:seconds + eta:apoapsis, 0, 0, dv).
//
//    print "nextnode:prograde is " + nextnode:prograde.
//
//    if useRCS { run execNodeRCS. }
//    else { run execNode. }
//  }

  // TODO: Do this if using reaction wheels. With RCS it affects the periapsis too much and wastes fuel.
  //lock steering to ship:prograde.
  //wait until faceDiff() < 0.5.
  //unlock steering.

//  print ship:obt:semimajoraxis at (2, 30).
//  print ship:obt:eccentricity at (2, 31).
//  print body:atm:height at (2, 32).
//  print body:radius at (2, 33).
//  print (1 - ship:obt:eccentricity^2) at (2, 34).
//  print (ship:obt:eccentricity * (body:atm:height + body:radius)) at (2, 35).
//  print (ship:obt:semimajoraxis * (1 - ship:obt:eccentricity^2)) at (2, 36).
//  print (ship:obt:semimajoraxis * (1 - ship:obt:eccentricity^2) / (ship:obt:eccentricity * (body:atm:height + body:radius)) - 1) at (2, 37).
//
//  local a to ship:obt:semimajoraxis.
//  local e to ship:obt:eccentricity.
//  local r to body:atm:height + body:radius.
//  print (a * (1 - e^2)/(e*r) - 1) at (2, 38).
//  print ((-a*e^2 + a - r) / (r * e)) at (2, 39).
//
//  local trueAnomAtAtmoEntry to 360 - arccos((-a*e^2 + a - r) / (r * e)).
//
//  //local trueAnomAtAtmoEntry to 360 - arccos(ship:obt:semimajoraxis * (1 - ship:obt:eccentricity^2) / (ship:obt:eccentricity * (body:atm:height + body:radius)) - 1).
//  local timeToAtmoEntry to timeToTrueAnom(trueAnomAtAtmoEntry).
//  print "                    " at (15, 16).
//  print "                    " at (15, 17).
//  print trueAnomAtAtmoEntry at (15, 16).
//  print timeToAtmoEntry at (15, 17).
//
//  warpFor1(timeToAtmoEntry).

  warpFor1(eta:periapsis - 1200).
  set warp to 2.
  wait until warp = 0.
  wait 5.
  set warp to 3.

  wait until eta:periapsis > eta:apoapsis.
  wait until altitude > body:atm:height.
  wait 2.
  set warp to 0.
  wait 2.
}
