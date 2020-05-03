@lazyglobal off.

function ignitedEngines {
  // TODO: work for other ships?  i.e. parameter shp is ship
  local engs to list().
  list engines in engs.

  local ign to list().
  for eng in engs {
    if (eng:ignition) { ign:add(eng). }
  }

  return ign.
}

function currentThrust {
  // TODO: work for other ships?  i.e. parameter shp is ship
  local engs to ignitedEngines().
  local t to 0.
  for eng in engs { set t to t + eng:thrust. }
  return t.
}

local function propStab {
  parameter m.
  local prop to m:getField("propellant").
  local parenOpenIdx to prop:find("(").
  local pctIdx to prop:find("%").
  local pctStr to prop:substring(parenOpenIdx + 1, pctIdx - parenOpenIdx - 1).
  return pctStr:toNumber() / 100.
}

function propellantStability {
  // TODO: This is not safe if a physics tick occurs between hasField and getField because the field might disappear.
  //       But I also don't want to artifically introduce a physics tick in a low-level helper function like this.
  parameter shp is ship.

  local minStability to 1.
  local mods to shp:modulesNamed("ModuleEnginesRF").
  for m in mods {
    if m:hasField("propellant") {
      set minStability to min(minStability, propStab(m)).
    }
  }

  return minStability.
}

function propellantStable {
  parameter shp is ship.
  return propellantStability(shp) = 1.
}
