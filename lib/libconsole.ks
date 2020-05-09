@lazyglobal off.

runoncepath("lib/libstring").

local ROW_OFFSET to 3.

function initConsole {
  parameter cols, labels, options is lexicon().

  if cols <> 1 and cols <> 2 { print "Invalid col count: " + cols. exit. }
  clearscreen.

  local this to lexicon().
  local vCenter to terminal:width / 2.

  local colStarts to list(0).
  local colEnds to list(terminal:width - 1).
  if cols = 2 {
    set colStarts to list(0, vCenter + 2).
    set colEnds to list(vCenter - 1, terminal:width - 1).
  }

  local hDivFull to repeatString("=", terminal:width).
  local hDivs to list(repeatString("=", colEnds[0] - colStarts[0] + 1)).
  if cols = 2 { hDivs:add(repeatString("=", colEnds[1] - colStarts[1] + 2)). }

  local row to 0.
  local col to 0.
  set this:items to lexicon().

  for label in labels {
    local parts to label:split(":").
    if label:contains(":") { set label to parts[0] + ":". }
    else set label to parts[0].

    if label = "=" { print hDivs[col] at (colStarts[col] - 1, row + ROW_OFFSET). }
    else if label <> "" {
      local item to lexicon().
      this:items:add(label, item).
      set item:line to row + ROW_OFFSET.
      set item:colStart to colStarts[col].
      set item:colEnd to colEnds[col].
      set item:valStart to item:colStart + label:length + 1.
      set item:valWidth to item:colEnd - item:valStart.

      if parts:length > 1 { set item:decimalPlaces to parts[1]:toNumber(). }

      print label at (item:colStart, item:line).
    }

    set col to mod(col + 1, cols).
    if col = 0 { set row to row + 1. }
  }

  if col = 0 { set row to row - 1. }

  print hDivFull at (0, ROW_OFFSET - 1).
  print hDivFull at (0, row + ROW_OFFSET + 1).
  if cols = 2 { for r in range(row + 1) { print "|" at (vCenter, r + ROW_OFFSET). } }

  return this.
}

function updateConsole {
  parameter this, updates.

  for label in updates:keys {
    local item to this:items[label].
    local val to updates[label].
    local valStr to "" + val.

    if val:typename = "Scalar" {
      if item:hasKey("decimalPlaces") {
        set valStr to formatDecimal(val, 0, item:decimalPlaces, item:decimalPlaces).
      }
    }

    set valStr to valStr:padLeft(item:valWidth).
    if valStr:length > item:valWidth { set valStr to valStr:substring(0, item:valWidth). }
    print valStr at (item:valStart, item:line).
  }
}

//local cons to initConsole(2, list("Pitch:2", "Heading:2",
//                                  "Roll:2")).
//
//runoncepath("lib/libcompass").
//until false {
//   updateConsole(cons, lexicon("Heading:", head(),
//                               "Pitch:", pitch(),
//                               "Roll:", roll())).
//   wait 0.001.
//}
