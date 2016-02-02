@lazyglobal off.

run once libradtrig.
run once liblambert_callback_fy.
run once liblambert_callback_ftau.
run once liblambert_callback_anon1.
run once liblambert_callback_anon2.
run once libbrentsmethod.

local eps to 1e-10.

function fy {
  parameter p_x.
  return liblambert_callback_fy_function(p_x).
}

function ftau {
  parameter p_x.
  return liblambert_callback_ftau_function(p_x).
}

function relativeError {
  parameter p_a.
  parameter p_b.
  return abs(1 - p_a / p_b).
}

function lambertsProblem {
  // Converted from https://alexmoon.github.io/ksp/javascripts/lambert.js
  // Originally Based on Sun, F.T. "On the Minium Time Trajectory and Multiple Solutions of Lambert's Problem"
  // AAS/AIAA Astrodynamics Conference, Provincetown, Massachusetts, AAS 79-164, June 25-27, 1979
  parameter p_mu.
  parameter p_r1Vec.
  parameter p_r2Vec.
  parameter p_dt.
  parameter p_maxRevs.
  parameter p_prograde.

  local pro to 1.
  if not p_prograde {
    set pro to 0.
  }

  local r1 to p_r1Vec:mag.
  local r2 to p_r2Vec:mag.
  local deltaPos to p_r2Vec - p_r1Vec.
  local c to deltaPos:mag.
  local m to r1 + r2 + c.
  local n to r1 + r2 - c.
  local transferAngle to constant:pi * vang(p_r1Vec, p_r2Vec) / 180.

  if (p_r1Vec:x * p_r2Vec:y - p_r1Vec:y * p_r2Vec:x) * pro < 0 {
    set transferAngle to 2 * constant:pi - transferAngle.
  }

  local angleParameter to sqrt(n / m).
  if transferAngle > constant:pi {
    set angleParameter to -angleParameter.
  }
  set g_liblambert_callback_fy_angleParameter to angleParameter.

  local normalizedTime to 4 * p_dt * sqrt(p_mu / m^3).
  local parabolicNormalizedTime to 2 / 3 * (1 - angleParameter * angleParameter * angleParameter).
  set g_liblambert_callback_ftau_normalizedTime to normalizedTime.
  set g_liblambert_callback_ftau_parabolicNormalizedTime to parabolicNormalizedTime.

  local NRev to 0.

  function syncNRev {
    parameter p_NRev.
    set NRev to p_NRev.
    set g_liblambert_callback_ftau_NRev to NRev.
    set g_liblambert_callback_anon1_NRev to NRev.
    set g_liblambert_callback_anon2_NRev to NRev.
  }

  syncNRev(0).

  local sqrtMu to sqrt(mu).

  local invSqrtM to 1 / sqrt(m).
  local invSqrtN to 1 / sqrt(n).

//  print "r1 = " + r1.
//  print "r2 = " + r2.
//  print "deltaPos = " + deltaPos.
//  print "c = " + c.
//  print "m = " + m.
//  print "n = " + n.
//  print "transferAngle = " + transferAngle.
//  print "angleParameter = " + angleParameter.
//  print "normalizedTime = " + normalizedTime.
//  print "parabolicNormalizedTime = " + parabolicNormalizedTime.
//  print "sqrtMu = " + sqrtMu.
//  print "invSqrtM = " + invSqrtM.
//  print "invSqrtN = " + invSqrtN.

  local solutions to list().

  function pushSolution {
    parameter p_x.
    parameter p_y.
    parameter p_NRev.

    local vc to sqrtMu * (p_y * invSqrtN + p_x * invSqrtM).
    local vr to sqrtMu * (p_y * invSqrtN - p_x * invSqrtM).
    local ec to (vc / c) * deltaPos.
    local v1 to ec + (vr / r1) * p_r1Vec.
    local v2 to ec - (vr / r2) * p_r2Vec.
//    print "p_NRev = " + p_NRev.
//    print "transferAngle = " + transferAngle.
    solutions:add(list(v1, v2, p_NRev * 2 * constant:pi + transferAngle)).
  }

  function pushIfConverged {
    parameter p_ret.
    parameter p_NRev.
    if p_ret[0] {
      local x to p_ret[1].
      pushSolution(x, fy(x), NRev).
    }
  }

  if relativeError(normalizedTime, parabolicNormalizedTime) < 1e-6 {
    local x to 1.
    local y to 1.
    if angleParameter < 0 { set y to -1. }
    pushSolution(x, y, 0).
  } else if normalizedTime < parabolicNormalizedTime {
    local x1 to 1.
    local x2 to 2.
    until ftau(x2) < 0 {
      set x1 to x2.
      set x2 to x2 * 2.
    }
    local x to brentsMethod("liblambert_callback_ftau", x1, x2, 100, 1e-4)[1].
    pushSolution(x, fy(x), NRev).
  } else {
    local maxRevs to min(p_maxRevs, floor(normalizedTime / constant:pi)).
    local minimumEnergyNormalizedTime to radarccos(angleParameter) + angleParameter * sqrt(1 - angleParameter^2).

//    print "maxRevs = " + maxRevs.
//    print "minimumEnergyNormalizedTime = " + minimumEnergyNormalizedTime.

    local _i to 0.
    syncNRev(_i).
    until abs(_i) > abs(maxRevs) {
//      print "_i = " + _i.
//      print "NRev = " + NRev.
      local minimumNormalizedTime to 0.
      local xMT to 0.

      if NRev > 0 and NRev = maxRevs {
        if angleParameter = 1 {
          set xMT to 0.
          set minimumNormalizedTime to minimumEnergyNormalizedTime.
        } else if angleParameter = 0 {
          set xMT to brentsMethod("liblambert_callback_anon1", 0, 1, 100, 1e-4)[1].
          set minimumNormalizedTime to 2 / (3 * xMT).
        } else {
          set xMT to brentsMethod("liblambert_callback_anon2", 0, 1, 100, 1e-4)[1].
          set minimumNormalizedTime to (2 / 3) * (1 / xMT - angleParameter^3 / abs(fy(xMT))).
        }

        if relativeError(normalizedTime, minimumNormalizedTime) < 1e-6 {
          pushSolution(xMT, fy(xMT), (NRev+1) * 2 * constant:pi - transferAngle).
          break.
        } else if (normalizedTime < minimumNormalizedTime) {
          break.
        } else if (normalizedTime < minimumEnergyNormalizedTime) {
          local ret to brentsMethod("liblambert_callback_ftau", 0, xMT, 100, 1e-4).
          pushIfConverged(ret, NRev).

          set ret to brentsMethod("liblambert_callback_ftau", xMT, 1 - eps, 100, 1e-4).
          pushIfConverged(ret, NRev).
          break.
        }
      }

      if relativeError(normalizedTime, minimumEnergyNormalizedTime) < 1e-6 {
        pushSolution(0, fy(0), NRev).
        if NRev > 0 {
          local ret to brentsMethod("liblambert_callback_ftau", 1e-6, 1 - eps, 100, 1e-4).
          pushIfConverged(ret, NRev).
        }
      } else {
        if NRev > 0 or normalizedTime > minimumEnergyNormalizedTime {
//          print "A".
          local ret to brentsMethod("liblambert_callback_ftau", -1 + eps, 0, 100, 1e-4).
          pushIfConverged(ret, NRev).
        }
        if NRev > 0 or normalizedTime < minimumEnergyNormalizedTime {
//          print "B".
          local ret to brentsMethod("liblambert_callback_ftau", 0, 1 - eps, 100, 1e-4).
//          print ret.
          pushIfConverged(ret, NRev).
        }
      }

      set minimumEnergyNormalizedTime to minimumEnergyNormalizedTime + constant:pi.

      if maxRevs >= 0 {
        set _i to _i + 1.
      } else {
        set _i to _i - 1.
      }
      syncNRev(_i).
    }
  }
  return solutions.
}

function vecrot {
  parameter p_vec.
  parameter angleDeg.

  return V(p_vec:x * cos(angleDeg) - p_vec:y * sin(angleDeg), p_vec:x * sin(angleDeg) + p_vec:y * cos(angleDeg), p_vec:z).
}

local mu to 398603 * 1000^3.
local r1Vec to V(10000000, 0, 0).
local r2Vec to vecrot(1.6 * r1Vec, 100).
local i to 0.
until i >= 100 {
  print i.
  local sols to lambertsProblem(mu, r1Vec, r2Vec, 3072, 0, true).
  set i to i + 1.
}
//print sols.

//local r2Vec2 to vecrot(1.6 * r1Vec, 260).
//print r2Vec2.
//set sols to lambertsProblem(mu, r1Vec, r2Vec2, 31645, 3, false).
//print sols.
