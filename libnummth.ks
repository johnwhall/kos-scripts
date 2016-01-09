@lazyglobal off.

// Next Available FunNum: 5

function evaluateInputFunction {
  parameter funNum.
  parameter x.

  if funNum = 1 { run nummthfun1(x). return RETVAL. }
  else if funNum = 2 { run nummthfun2(x). return RETVAL. }
  else if funNum = 3 { run nummthfun3(x). return RETVAL. }
  else if funNum = 4 { run nummthfun4(x). return RETVAL. }
}
