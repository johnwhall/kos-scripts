@lazyglobal off.

runoncepath("lib/libtimeto").

function manAt {
  parameter where.
  return node(time:seconds + timeTo1(where), 0, 0, 0).
}
