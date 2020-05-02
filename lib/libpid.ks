@lazyglobal off.

// Values from https://ksp-kos.github.io/KOS/tutorials/pidloops.html#tuning-a-pid-loop

function createPIDClassic {
  parameter ku.
  parameter tu.

  local kp to 0.6 * ku.
  local ki to 2 * kp / tu.
  local kd to kp * tu / 8.

  return pidloop(kp, ki, kd).
}

function createPIDSomeOvershoot {
  parameter ku.
  parameter tu.

  local kp to 0.33 * ku.
  local ki to 2 * kp / tu.
  local kd to kp * tu / 3.

  return pidloop(kp, ki, kd).
}

function createPIDNoOvershoot {
  parameter ku.
  parameter tu.

  local kp to 0.2 * ku.
  local ki to 2 * kp / tu.
  local kd to kp * tu / 3.

  return pidloop(kp, ki, kd).
}

local colWidth to 22.

local pad to {
  parameter val.
  parameter width is colWidth.
  return ("" + val):padright(width).
}.

function logPIDHeader {
  parameter logFile.

  log "# " +
      pad("TIME", colWidth -2) + " " +
      pad("MISSIONTIME") + " " +
      pad("KP") + " " +
      pad("KI") + " " +
      pad("KD") + " " +
      pad("SETPOINT") + " " +
      pad("MINOUTPUT") + " " +
      pad("MAXOUTPUT") + " " +
      pad("INPUT") + " " +
      pad("ERROR") + " " +
      pad("OUTPUT") + " " +
      pad("PTERM") + " " +
      pad("ITERM") + " " +
      pad("DTERM") + " " +
      pad("ERRORSUM") + " " +
      pad("CHANGERATE") to logFile.
}

function logPID {
  parameter pid.
  parameter logFile.

  log pad(time:seconds) + " " +
      pad(missiontime) + " " +
      pad(pid:kp) + " " +
      pad(pid:ki) + " " +
      pad(pid:kd) + " " +
      pad(pid:setpoint) + " " +
      pad(pid:minoutput) + " " +
      pad(pid:maxoutput) + " " +
      pad(pid:input) + " " +
      pad(pid:error) + " " +
      pad(pid:output) + " " +
      pad(pid:pterm) + " " +
      pad(pid:iterm) + " " +
      pad(pid:dterm) + " " +
      pad(pid:errorsum) + " " +
      pad(pid:changerate) to logFile.
}
