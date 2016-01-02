@lazyglobal off.

function isp {
  local es to list().
  list engines in es.

  local tSum to 0.
  local bSum to 0.

  for e in es {
    if (e:ignition) {
      set tSum to tSum + e:maxthrust.
      set bSum to bSum + (e:maxthrust / e:visp).
    }
  }

  return tSum / bSum.
}
