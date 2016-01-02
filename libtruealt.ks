@lazyglobal off.

function trueAlt {
  if abs(altitude) < 0.05 or abs(altitude - alt:radar) / altitude > 0.05 {
    return alt:radar.
  } else {
    return altitude - ship:geoposition:terrainheight.
  }
}
