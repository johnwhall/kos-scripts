@lazyglobal off.

function ignitedEngines {
  local ignited to list().

  local es to list().
  list engines in es.

  for e in es {
    if (e:ignition) {
      ignited:add(e).
    }
  }

  return ignited.
}

function atZeroThrust {
  local es to list().
  list engines in es.

  for e in es {
    if (e:ignition and e:thrust <> 0) {
      return false.
    }
  }

  return true.
}

function atFullThrust {
  local es to list().
  list engines in es.

  for e in es {
    if (e:ignition and e:thrust / e:availablethrust < 0.95) {
      return false.
    }
  }

  return true.
}

function currentThrust {
  local igEngs to ignitedEngines().
  local T to 0.
  for eng in igEngs {
    set T to T + eng:thrust.
  }
  return T.
}

function currentTWR {
  local T to currentThrust().
  local gHere to body:mu / (body:radius + altitude)^2.
  return T / (gHere * mass).
}
