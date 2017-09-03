@lazyglobal off.

{
  runoncepath("lib/libsasrcsstack").
  runoncepath("lib/libantenna").

  local tgt to vessel("JSS").
  local manDist to 50.
  //run waitforlan(tgt:obt:lan - 6).
  //run launch(5, 75, 75000, tgt:obt:inclination, 300000).

  //wait 5.

  //ship:partstagged("payload decoupler")[0]:getModule("ModuleDecouple"):doEvent("Decouple").
  //wait 2.
  //set kuniverse:activevessel to ship.
  //wait 2.

  //panels on.
  //extendAntennae().

  //pushRCS(true).
  //runpath("faceSun").
  //popRCS().
  //wait 1.

  //stage.
  //wait 5.

  run rendezvous(tgt, 120, 10, manDist, true).
  run dock(tgt).
}
