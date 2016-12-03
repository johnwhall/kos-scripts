@lazyglobal off.

runoncepath("lib/libwarpfor").

function myWarpTo {
  parameter where, lead.

  if where = "per" or where = "periapsis" {
    local lastTT to eta:periapsis - lead.
    if lastTT < 0 { set lastTT to lastTT + ship:obt:period. }

    function tt {
      local curTT to eta:periapsis - lead.
      if curTT < 0 { set curTT to curTT + ship:obt:period. }
      if curTT > lastTT {
        return 0.
      } else {
        set lastTT to curTT.
        return curTT.
      }
    }

    warpUntilZero(tt@).
  } else if where = "apo" or where = "apoapsis" {
    local lastTT to eta:apoapsis - lead.
    if lastTT < 0 { set lastTT to lastTT + ship:obt:period. }

    function tt {
      local curTT to eta:apoapsis - lead.
      if curTT < 0 { set curTT to curTT + ship:obt:period. }
      if curTT > lastTT {
        return 0.
      } else {
        set lastTT to curTT.
        return curTT.
      }
    }

    warpUntilZero(tt@).
  }
}
