@lazyglobal off.

function eciVecsToKepElem {
  parameter mu, r, v.

  // Semi-major Axis
  local a to 1 / ((2 / r:mag) - (v:sqrmagnitude / mu)).

  // Eccentricity
  local h to vcrs(r, v).
  local eVec to vcrs(v, h) / mu - r:normalized.
  local e to eVec:mag.

  // Inclination
  local i to arccos(h:z / h:mag).

  // Longitude of Ascending Node
  local n to V(-h:y, h:x, 0).
  local lan to 0.
  if n:mag <> 0 {
    set lan to arccos(n:x / n:mag).
    if n:y < 0 { set lan to 360 - lan. }
  }

  // Argument of Periapsis
  local aop to 0.
  if n:mag <> 0 and e <> 0 {
    set aop to arccos(vdot(n, eVec) / (n:mag * e)).
    if eVec:z < 0 { set aop to 360 - aop. }
  }

  // True Anomaly
  local ta to 0.
  if e <> 0 {
    set ta to arccos(vdot(eVec, r) / (e * r:mag)).
    if vdot(r, v) < 0 { set ta to 360 - ta. }
  }

//  // Eccentric Anomaly
//  local ea to arccos((e + cos(ta)) / (1 + e * cos(ta))).
//  if 180 < ta and ta < 360 { set ea to 360 - ea. }
//
//  // Mean Anomaly
//  local ma to ea - e * sin(ea).

  // TODO: change ta to ma?
  return list(a, e, i, lan, aop, ta).
}

function kepElemToEciVecs {
  // Best reference I've found:
  // http://ccar.colorado.edu/ASEN5070/handouts/kep2cart_2002.doc
  parameter mu, elems.

  local a to elems[0].
  local e to elems[1].
  local i to elems[2].
  local lan to elems[3].
  local aop to elems[4].
  local ta to elems[5].

  local p to a * (1 - e^2).
  local r to p / (1 + e * cos(ta)).
  local h to sqrt(mu * p).

  local coslan to cos(lan).
  local sinlan to sin(lan).
  local cosaopta to cos(aop + ta).
  local sinaopta to sin(aop + ta).
  local cosi to cos(i).
  local sini to sin(i).

  local x to r * (coslan * cosaopta - sinlan * sinaopta * cosi).
  local y to r * (sinlan * cosaopta + coslan * sinaopta * cosi).
  local z to r * (sini * sinaopta).

  local sinta to sin(ta).
  local herpsinta to h * e * sinta / (r * p).
  local hr to h / r.

  local vx to x * herpsinta - hr * (coslan * sinaopta + sinlan * cosaopta * cosi).
  local vy to y * herpsinta - hr * (sinlan * sinaopta - coslan * cosaopta * cosi).
  local vz to z * herpsinta + hr * sini * cosaopta.

  return list(V(x, y, z), V(vx, vy, vz)).
}

function hlist {
  parameter l.
  local s to "(".
  for i in l {
    set s to s + round(i, 5) + ", ".
  }
  set s to s:substring(0, s:length - 2) + ")".
  return s.
}

function roundVec {
  parameter v.
  return"V(" + round(v:x, 5) + ", " + round(v:y, 5) + ", " + round(v:z, 5) + ")".
}

local tests to list().
tests:add(list(1, V(1, 0, 0), V(0, 1, 0), list(1, 0, 0, 0, 0, 0))).
tests:add(list(1, V(1, 0, 0), V(0, 0.5, 0.5), list(0.66667, 0.5, 45, 0, 180, 180))).
tests:add(list(1, V(1, 0, 0), V(0.5, 0.5, 0.5), list(0.8, 0.61237244, 45, 0, 215.26438968, 144.73561032))).
tests:add(list(1, V(0, 0, -1), V(0.5, 0, 0.5), list(0.66667, 0.79056942, 90, 0, 71.56505118, 198.43494882))).
tests:add(list(1, V(0, -1, 0), V(0.5, 0, 0.5), list(0.66667, 0.5, 45, 270, 180, 180))).

print "eciVecsToKepElem:".

for t in tests {
  local out to eciVecsToKepElem(t[0], t[1], t[2]).
  print "" + t[0] + ", " + t[1] + ", " + t[2] + ", " + hlist(t[3]) + " --> " + hlist(out).
  if hlist(t[3]) <> hlist(out) {
    print "FAIL!".
    exit.
  }
}

print "kepElemToEciVecs:".

for t in tests {
  local out to kepElemToEciVecs(t[0], t[3]).
  print "" + t[0] + ", " + t[1] + ", " + t[2] + ", " + hlist(t[3]) + " --> " + roundVec(out[0]) + ", " + roundVec(out[1]).
  if roundVec(t[1]) <> roundVec(out[0]) or roundVec(t[2]) <> roundVec(out[1]) {
    print "FAIL!".
    exit.
  }
}
