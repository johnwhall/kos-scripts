@lazyglobal off.

function waitForExists {
  parameter p_fname.

  until false {
    local fs to list().
    list files in fs.
    for f in fs {
      if f:name = p_fname { return. }
    }

    wait 0.25.
  }
}

function waitForNotExists {
  parameter p_fname.

  until false {
    local fs to list().
    list files in fs.
    local done to true.
    for f in fs {
      if f:name = p_fname {
        set done to false.
      }
    }
    if done { return. }
    else { wait 0.25. }
  }
}

global g_libmainframe_nextRequestNum to 1.

function mainframeClean {
  run deleteifexists("libmainframe_result_done.txt").
  run deleteifexists("libmainframe_result_" + g_libmainframe_nextRequestNum + ".ks").
  run deleteifexists("libmainframe_request_done.txt").
  run deleteifexists("libmainframe_request.txt").
}

function mainframePrep {
  mainframeClean().
  log g_libmainframe_nextRequestNum to libmainframe_request.txt.
}

function mainframeFinish {
  log "done" to libmainframe_request_done.txt.

  waitForNotExists("libmainframe_request_done.txt").
  waitForExists("libmainframe_result_done.txt").

  if g_libmainframe_nextRequestNum = 1 {
    run libmainframe_result_1.ks.
  } else if g_libmainframe_nextRequestNum = 2 {
    run libmainframe_result_2.ks.
  } else {
    print "RAN OUT OF MAINFRAME CALLS".
    exit.
  }

  mainframeClean().
  set g_libmainframe_nextRequestNum to g_libmainframe_nextRequestNum + 1.

  return RETVAL.
}

function mainframeSquare {
  parameter p_x.

  mainframePrep().
  log "square" to libmainframe_request.txt.
  log p_x to libmainframe_request.txt.
  return mainframeFinish().
}

print mainframeSquare(3).
print mainframeSquare(6).
