@lazyglobal off.

run once libtimetotrueanom.

function timeTo1 {
  parameter where.

  local nodeEta to 0.
  if (where = "anode") {
    return timeToTrueAnom(360 - ship:obt:argumentofperiapsis).
  } else if (where = "dnode") {
    return timeToTrueAnom(abs(180 - ship:obt:argumentofperiapsis)).
  } else if (where = "apo" or where = "apoapsis") {
    return eta:apoapsis.
  } else if (where = "per" or where = "peri" or where = "periapsis") {
    return eta:periapsis.
  } else {
    print "Invalid where: " + where.
    exit.
  }
}

function manAt {
  parameter where.
  return node(time:seconds + timeTo1(where), 0, 0, 0).
}
