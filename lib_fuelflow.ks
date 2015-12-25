@lazyglobal off.

function fuelflow_init {
  local dat to list(time:seconds, stage:resources).
  return dat.
}

function fuelflow_timeToBurnOut {
  parameter dat.

  local curTime to time:seconds.
  local curResList to stage:resources.
  local oldTime to dat[0].
  local oldResList to dat[1].
  local dt to curTime - oldTime.

  local minTTBO to 99999999.
  for curRes in curResList {
    if (curRes:name <> "ElectricCharge") {
      local oldRes to fuelflow_resByName(oldResList, curRes:name).
      if (oldRes <> -1) {
        local rate to (curRes:amount - oldRes:amount) / dt.
        if (rate < 0) {
          local ttbo to curRes:amount / abs(rate).
          set minTTBO to min(minTTBO, ttbo).
        }
      }
    }
  }

  set dat[0] to curTime.
  set dat[1] to curResList.

  return minTTBO.
}
  

function fuelflow_resByName {
  parameter resList.
  parameter name.

  for res in resList {
    if (res:name = name) {
      return res.
    }
  }

  return -1.
}
