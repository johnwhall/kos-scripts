@lazyglobal off.

function rollError {
  parameter desired.
  parameter current.

  local left to false.
  local minAbs to 360.

  // turn left without passing 360
  if desired > current and desired - current < minAbs {
    set minAbs to desired - current.
    set left to true.
  }

  // turn left, passing 360
  if current > desired and desired + 360 - current < minAbs {
    set minAbs to desired + 360 - current.
    set left to true.
  }

  // turn right without passing 0
  if current > desired and current - desired < minAbs {
    set minAbs to current - desired.
    set left to false.
  }

  // turn right, passing 0
  if desired > current and current + 360 - desired < minAbs {
    set minAbs to current + 360 - desired.
    set left to false.
  }

  if left {
    // turning left is better, call it positive error
    return minAbs.
  } else {
    // turning right is better, call it negative error
    return -minAbs.
  }
}

function calcPidIn {
  parameter desired.
  parameter current.

  if abs(current - desired) < abs(current + 360 - desired) {
    return current - desired.
  } else {
    return current + 360 - desired.
  }
}

print calcPidIn(300, 270).
print calcPidIn(300, 330).
print calcPidIn(300, 60).

//print rollError(330, 300).
//print rollError(30, 330).
//print rollError(30, 60).
//print rollError(330, 30).
//print rollError(0, 330).
//print rollError(0, 30).
//print rollError(30, 0).
//print rollError(330, 0).

local pid to pidloop(0.01, 0.001, 0, -1, 1).
set pid:setpoint to 0.

local desiredRoll to 120.

local stoptime to time:seconds + 30.
until time:seconds >= stoptime {
  //local pidIn to rollError(desiredRoll, ship:facing:roll).
  local pidIn to calcPidIn(desiredRoll, ship:facing:roll).
  local pidOut to pid:update(time:seconds, pidIn).
  print "roll: " + ship:facing:roll + ", pidIn: " + pidIn + ", pidOut: " + pidOut.
  set ship:control:roll to -pidOut.
  wait 0.05.
}
