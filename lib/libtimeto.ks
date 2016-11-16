@lazyglobal off.

runoncepath("lib/libtimetotrueanom").

function timeTo1 {
  parameter where, allowed is list("anode", "dnode", "apo", "per").

  local mappedWhere to where.
  if where = "apoapsis" {
    set mappedWhere to "apo".
  } else if list("peri", "periapsis"):contains(where) { 
    set mappedWhere to "per".
  }

  if not allowed:contains(mappedWhere) {
    print mappedWhere + " not in allowed list: " + allowed.
    exit.
  }

  if (where = "anode") {
    return timeToTrueAnom(360 - ship:obt:argumentofperiapsis).
  } else if (where = "dnode") {
    return timeToTrueAnom(abs(180 - ship:obt:argumentofperiapsis)).
  } else if (where = "apo" or where = "apoapsis") {
    return eta:apoapsis.
  } else if (where = "per" or where = "peri" or where = "periapsis") {
    return eta:periapsis.
  } else {
    print "disallowed where should have been caught earlier".
    exit.
  }
}
