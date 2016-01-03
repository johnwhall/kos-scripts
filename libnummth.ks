@lazyglobal off.

// Next Available FunNum: 3

function evaluateInputFunction {
  parameter funNum.
  parameter x.

  if funNum = 1 { run nummthfun1(x). return RETVAL. }
  else if funNum = 2 { run nummthfun2(x). return RETVAL. }
}
