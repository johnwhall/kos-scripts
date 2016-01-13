@lazyglobal off.

run once liborbitalstate.

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

function mainframeLambertOptimize {
  parameter p_s1.
  parameter p_s2.
  parameter p_tMin.
  parameter p_tMax.
  parameter p_tStep.
  parameter p_dtMin.
  parameter p_dtMax.
  parameter p_dtStep.

  local b to p_s1:body.
  if p_s2:body <> b {
    print "bodies must be the same".
     exit.
  }

  mainframePrep().
  local rv1 to getECIVecs(p_s1:orbit).
  local rv2 to getECIVecs(p_s2:orbit).

  log "lambertoptimize" to libmainframe_request.txt.
  log b:mu to libmainframe_request.txt.

  log rv1[0]:x to libmainframe_request.txt.
  log rv1[0]:y to libmainframe_request.txt.
  log rv1[0]:z to libmainframe_request.txt.
  log rv1[1]:x to libmainframe_request.txt.
  log rv1[1]:y to libmainframe_request.txt.
  log rv1[1]:z to libmainframe_request.txt.

  log rv2[0]:x to libmainframe_request.txt.
  log rv2[0]:y to libmainframe_request.txt.
  log rv2[0]:z to libmainframe_request.txt.
  log rv2[1]:x to libmainframe_request.txt.
  log rv2[1]:y to libmainframe_request.txt.
  log rv2[1]:z to libmainframe_request.txt.

  log tMin to libmainframe_request.txt.
  log tMax to libmainframe_request.txt.
  log tStep to libmainframe_request.txt.

  log dtMin to libmainframe_request.txt.
  log dtMax to libmainframe_request.txt.
  log dtStep to libmainframe_request.txt.

  return mainframeFinish().
}

//print mainframeSquare(3).
//print mainframeSquare(6).
