@lazyglobal off.

function initMovAvg {
  parameter p_periods.
  return list(p_periods, 0, queue()).
}

function movAvg {
  parameter p_state.
  parameter p_val.

  local sum to p_state[1] * p_state[2]:length + p_val.
  p_state[2]:push(p_val).
  if p_state[2]:length > p_state[0] {
    local popVal to p_state[2]:pop().
    set sum to sum - popVal.
  }

  set p_state[1] to sum / p_state[2]:length.
  return p_state[1].
}

