@lazyglobal off.

function s2ydhms {
  parameter s.
  local y to floor(s / (60 * 60 * 24 * 365)).
  set s to mod(s, 60 * 60 * 24 * 365).
  local d to floor(s / (60 * 60 * 24)).
  set s to mod(s, 60 * 60 * 24).
  local h to floor(s / (60 * 60)).
  set s to mod(s, 60 * 60).
  local m to floor(s / 60).
  set s to mod(s, 60).
  return list(y, d, h, m, s).
}

function formatYdhms {
  parameter ydhms.
  local str to "".
  local doRest to false.

  local y to ydhms[0].
  local d to ydhms[1].
  local h to ydhms[2].
  local m to ydhms[3].
  local s to ydhms[4].

  if y <> 0 {
    set doRest to true.
    set str to str + y + "y ".
  }

  if doRest or d <> 0 {
    set doRest to true.
    set str to str + d + "d ".
  }

  if doRest or h <> 0 {
    set doRest to true.
    set str to str + h + "h ".
  }

  if doRest or m <> 0 {
    set doRest to true.
    set str to str + m + "m ".
  }

  set str to str + round(s, 2) + "s".

  return str.
}
