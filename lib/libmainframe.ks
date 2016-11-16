@lazyglobal off.

function mainframeClean {
  run deleteifexists("libmainframe_request.txt").
  run deleteifexists("libmainframe_request_done.txt").
  run deleteifexists("libmainframe_result.json").
  run deleteifexists("libmainframe_result_done.txt").
}

function mainframeDo {
  log "" to "libmainframe_request_done.txt".

  // wait for response
  wait until archive:files:haskey("libmainframe_result_done.txt").
  wait 0.25. // wait for the mainframe to close the file before we delete it
  delete "libmainframe_result_done.txt".

  local resultLex to readjson("libmainframe_result.json").
  mainframeClean().

  return resultLex.
}

function mainframeSquare {
  parameter p_x.

  mainframeClean().
  log "square" to libmainframe_request.txt.
  log p_x to libmainframe_request.txt.
  return mainframeDo()["xSquared"].
}

function mainframeLambertOptimizeVecs {
  parameter p_mu.
  parameter p_r1.
  parameter p_v1.
  parameter p_r2.
  parameter p_v2.
  parameter p_tMin.
  parameter p_tMax.
  parameter p_tStep.
  parameter p_dtMin.
  parameter p_dtMax.
  parameter p_dtStep.
  parameter p_allowLob.

  mainframeClean().

  log "lambertoptimize" to libmainframe_request.txt.
  log p_mu to libmainframe_request.txt.

  log p_r1:x to libmainframe_request.txt.
  log p_r1:y to libmainframe_request.txt.
  log p_r1:z to libmainframe_request.txt.
  log p_v1:x to libmainframe_request.txt.
  log p_v1:y to libmainframe_request.txt.
  log p_v1:z to libmainframe_request.txt.

  log p_r2:x to libmainframe_request.txt.
  log p_r2:y to libmainframe_request.txt.
  log p_r2:z to libmainframe_request.txt.
  log p_v2:x to libmainframe_request.txt.
  log p_v2:y to libmainframe_request.txt.
  log p_v2:z to libmainframe_request.txt.

  log p_tMin to libmainframe_request.txt.
  log p_tMax to libmainframe_request.txt.
  log p_tStep to libmainframe_request.txt.

  log p_dtMin to libmainframe_request.txt.
  log p_dtMax to libmainframe_request.txt.
  log p_dtStep to libmainframe_request.txt.

  log p_allowLob to libmainframe_request.txt.

  return mainframeDo().
}

//print mainframeSquare(3).
//print mainframeSquare(6).
