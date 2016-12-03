@lazyglobal off.

function pplist {
  parameter lst.
  local s to "(".
  from { local i to 0. } UNTIL i >= lst:length STEP { set i to i + 1. } DO {
    if i <> 0 {
      set s to s + ", ".
    }
    set s to s + lst[i].
  }
  return s + ")".
}

function bruteForce {
  parameter f, xMin, xMax, xStep.

  local x to xMin:copy.
  local minVal to 999999999999999999.
  local minValX to x.

  local exhausted to false.
  until exhausted {
    local val to f(x).
    if val < minVal {
      set minVal to val.
      set minValX to x:copy.
//      print "set minValX to " +  pplist(x).
    }

    local stopValueSearch to false.
    from { local i to xMin:length - 1. } UNTIL i < 0 or stopValueSearch STEP { set i to i - 1. } DO {
      set x[i] to x[i] + xStep[i].
      if x[i] > xMax[i] {
        set x[i] to xMin[i].
      } else {
        set stopValueSearch to true.
      }
    }

    if not stopValueSearch and x[0] = xMin[0] {
      set exhausted to true.
    }
  }

  return lexicon("min", minVal, "x", minValX).
}

function bracketingMinimizationMethod {
  parameter f, xMin, xMax, numBrackets, tols.

  local res to lexicon().

  local stop to false.
  until stop {
    local xStep to list().
    from { local i to 0. } UNTIL i >= xMin:length STEP { set i to i + 1. } DO {
      xStep:add(max(tols[i], (xMax[i] - xMin[i]) / numBrackets[i])).
    }

//    print " ".
//    print "xMin: " + pplist(xMin).
//    print "xMax: " + pplist(xMax).
//    print "xStep: " + pplist(xStep).

    set res to bruteForce(f, xMin, xMax, xStep).

//    print "min: " + res["min"].
//    print "x: " + pplist(res["x"]).

    set stop to true.
    from { local i to 0. } UNTIL i >= xMin:length STEP { set i to i + 1. } DO {
//      print "Checking for stop: i = " + i + " xMax[i] = " + xMax[i] + " xMin[i] = " + xMin[i] + " tols[i] = " + tols[i].
      if (xMax[i] - xMin[i]) / 2 >= tols[i] {
        set stop to false.
      }
    }

    from { local i to 0. } UNTIL i >= xMin:length STEP { set i to i + 1. } DO {
//      print "Setting xMin[i]: i = " + i + " xMin[i] = " + xMin[i] + " res['x'][i] = " + res["x"][i] + " xStep[i] = " + xStep[i].
      set xMin[i] to max(xMin[i], res["x"][i] - xStep[i] / 2).
//      print "Setting xMax[i]: i = " + i + " xMax[i] = " + xMax[i] + " res['x'][i] = " + res["x"][i] + " xStep[i] = " + xStep[i].
      set xMax[i] to min(xMax[i], res["x"][i] + xStep[i] / 2).
    }
  }

  return res.
}

function bruteForce1 {
  parameter f, xMin, xMax, xStep.

  local x to xMin.
  local minVal to 999999999999999999.
  local minValX to x.

  until x > xMax {
    local val to f(x).
    if val < minVal {
      set minVal to val.
      set minValX to x.
    }

    set x to x + xStep.
  }

  return lexicon("min", minVal, "x", minValX).
}

function bracketingMinimizationMethod1 {
  parameter f, xMin, xMax, numBrackets, tol.

  local res to lexicon().

  local stop to false.
  until stop {
    local xStep to max(tol, (xMax - xMin) / numBrackets).

    set res to bruteForce1(f, xMin, xMax, xStep).
    set stop to (xMax - xMin) / 2 < tol.

    set xMin to max(xMin, res["x"] - xStep / 2).
    set xMax to min(xMax, res["x"] + xStep / 2).
  }

  return res.
}

//function p {
//  parameter x.
//  //local val to cos(x[0] - 15) + abs(x[0] - 15) / 10.
//  local val to (x[0] - 2)^2 + 3 + (x[1]+4)^2 * x[0]^2.
////  print "f" + pplist(x) + " = " + val.
//  return val.
//}
//
//bruteForce(p@, list(-3, 0, 3), list(10, 9, 3), list(3, 3, 1)).
//local startTime to time:seconds.
//print bracketingMinimizationMethod(p@, list(-15, -15), list(15, 15), list(5, 5), list(0.01, 0.01)).
//print "time taken: " + (time:seconds - startTime).
