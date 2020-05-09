@lazyglobal off.

function substl {
  parameter picture, args is list().
  local argIdx to 0.
  from { local i to picture:find("{}"). } until i < 0 step { set i to picture:findat("{}", i). } do {
    set picture to picture:remove(i, 2):insert(i, "" + args[argIdx]).
    set argIdx to argIdx + 1.
  }
  return picture.
}

function subst {
  parameter picture, arg1 is 0, arg2 is 0, arg3 is 0, arg4 is 0, arg5 is 0, arg6 is 0, arg7 is 0, arg8 is 0, arg9 is 0.
  return substl(picture, list(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)).
}

function join {
  parameter joinStr, args is list().
  local str to "".
  for arg in args {
    if str:length > 0 { set str to str + joinStr + arg. }
    else set str to "" + arg.
  }
  return str.
}

function s2ydhms {
  parameter s.

  local began to false.
  local str to "".
  if s < 0 {
    set str to "-".
    set s to -s.
  }

  local years to floor(s / 31536000). // TODO: leap years? This should match whatever MechJeb does
  if years > 0 {
    set str to str + years + "y ".
    set s to mod(s, 31536000).
    set began to true.
  }

  local days to floor(s / 86400).
  if days > 0 or began {
    set str to str + padLeft(days, choose 2 if began else 0, "0") + "d ".
    set s to mod(s, 86400).
    set began to true.
  }

  local hours to floor(s / 3600).
  if hours > 0 or began {
    set str to str + padLeft(hours, choose 2 if began else 0, "0") + "h ".
    set s to mod(s, 3600).
    set began to true.
  }

  local mins to floor(s / 60).
  if mins > 0 or began {
    set str to str + padLeft(mins, choose 2 if began else 0, "0") + "m ".
    set s to mod(s, 60).
    set began to true.
  }

  local secsWhole to round(floor(s)).
  local secsFrac to round(100 * (s - secsWhole)).
  set str to str + padLeft(secsWhole, 2, "0") + "." + padLeft(secsFrac, 2, "0") + "s".
  return str.
}

function padLeft {
  parameter str, tgtWidth, padChar.
  local str to "" + str.
  local pad to "".
  until str:length + pad:length >= tgtWidth { set pad to pad + padChar. }
  return pad + str.
}
