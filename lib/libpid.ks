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

function createPIDNoOvershoot {
  parameter ku.
  parameter tu.

  local kp to 0.2 * ku.
  local ki to 2 * kp / tu.
  local kd to kp * tu / 3.

  return pidloop(kp, ki, kd).
}
