@lazyglobal off.

function extendAntennae {
  for pm in ship:modulesNamed("ModuleRTAntenna") {
    if pm:hasEvent("activate") {
      pm:doEvent("activate").
    }
  }
}

function retractAntennae {
  for pm in ship:modulesNamed("ModuleRTAntenna") {
    if pm:hasEvent("deactivate") {
      pm:doEvent("deactivate").
    }
  }
}
