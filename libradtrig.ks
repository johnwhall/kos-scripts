@lazyglobal off.

function radsin {
  parameter p_x.
  return sin(180 * p_x / constant:pi).
}

function radcos {
  parameter p_x.
  return cos(180 * p_x / constant:pi).
}

function radtan {
  parameter p_x.
  return tan(180 * p_x / constant:pi).
}

function radarcsin {
  parameter p_x.
  return constant:pi * arcsin(p_x) / 180.
}

function radarccos {
  parameter p_x.
  return constant:pi * arccos(p_x) / 180.
}

function radarctan {
  parameter p_x.
  return constant:pi * arctan(p_x) / 180.
}

function radarccot {
  parameter p_x.
  return 0.5 * constant:pi - radarctan(p_x).
}

function radarccoth {
  parameter p_x.
  return 0.5 * ln((p_x + 1) / (p_x - 1)).
}

//print radsin(constant:pi / 6).
//print radcos(constant:pi / 3).
//print radtan(constant:pi / 4).
//print radarcsin(0.5) / constant:pi.
//print radarccos(0.5) / constant:pi.
//print radarctan(1) / constant:pi.
//print radarccot(0).
//print radarctan(0).
