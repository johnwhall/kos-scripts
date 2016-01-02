@lazyglobal off.

function secantMethodInitState {
  parameter p_maxIter.
  parameter p_convCrit.
  parameter p_x1.
  parameter p_fx1.
  parameter p_x2.
  parameter p_state.

  p_state:clear.
  p_state:add(p_x1).
  p_state:add(p_fx1).
  p_state:add(p_x2).
  p_state:add(0).
  p_state:add(p_maxIter).
  p_state:add(p_convCrit).
}

function secantMethodConverged {
  parameter p_fx.
  parameter p_state.

  local convCrit to p_state[5].

  return abs(p_fx) < convCrit.
}

function secantMethodPastMaxIter {
  parameter p_state.

  local iter to p_state[3].
  local maxIter to p_state[4].

  return iter > maxIter.
}

function secantMethodIter {
  parameter p_fx.
  parameter p_state.

  local xm1 to p_state[0].
  local fxm1 to p_state[1].
  local x to p_state[2].
  local iter to p_state[3].

  local xp1 to x - p_fx * (x - xm1) / (p_fx - fxm1).

  set p_state[0] to x.
  set p_state[1] to p_fx.
  set p_state[2] to xp1.
  set p_state[3] to iter + 1.

  return xp1.
}

//function f {
//  parameter x.
//  return x^2 - 612.
//}
//
//local state to list().
//secantMethodInitState(6, 1e-5, 10, f(10), 30, state).
//local x to 30.
//until secantMethodConverged(f(x), state) or secantMethodPastMaxIter(state) {
//  set x to secantMethodIter(f(x), state).
//}
//print x.
