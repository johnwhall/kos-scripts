@lazyglobal off.

function printField {
  parameter fieldSpec, value.

  local label to fieldSpec[0].
  local labelWidth to fieldSpec[1].
  local labelAlign to fieldSpec[2].
  local valueWidth to fieldSpec[3].
  local valueAlign to fieldSpec[4].
  local col to fieldSpec[5].
  local line to fieldSpec[6].

  print "":padleft(labelWidth + 1 + valueWidth) at(col, line).

  set label to label:substring(0, min(labelWidth, label:length)).
  local paddedLabel to label:padleft(labelWidth).
  if labelAlign = "l" { set paddedLabel to label:padright(labelWidth). }
  print paddedLabel at(col, line).

  local stringValue to "" + value.
  set stringValue to stringValue:substring(0, min(valueWidth, stringValue:length)).
  local paddedValue to stringValue:padleft(valueWidth).
  if valueAlign = "l" { set paddedValue to stringValue:padright(valueWidth). }
  print paddedValue at(col + labelWidth + 1, line).
}
