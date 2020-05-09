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

local function singleIsp {
  parameter e, situation.
  if situation = "current" { return e:isp. }
  else if situation = "sealevel" { return e:slisp. }
  else if situation = "vacuum" { return e:visp. }
  else { print "unknown situation: " + situation. exit. }
}

function specificImpulse {
  parameter engineList is ignitedEngines().
  parameter situation is "current". // "sealevel", "current", or "vacuum"

  local t to 0.
  local b to 0.

  for e in engineList {
    set t to t + e:availablethrust.
    set b to b + e:availablethrust / singleIsp(e, situation).
  }

  return t / b.
}

function burnTime {
  parameter Δv, isp is specificImpulse(), T is ship:availablethrust, m is ship:mass.
  local ve to isp * constant:g0.
  return (m * ve / T) * (1 - constant:e^(-Δv / ve)).
}
