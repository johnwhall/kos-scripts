@lazyglobal off.

runoncepath("lib/libmath").
runoncepath("test/libtest").

runSimple("vangs360(V(1, 0, 0), V(         1,          0, 0), V(0, 0, 1))", 0).
runSimple("vangs360(V(1, 0, 0), V( sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, 1))", 45).
runSimple("vangs360(V(1, 0, 0), V(         0,          1, 0), V(0, 0, 1))", 90).
runSimple("vangs360(V(1, 0, 0), V(-sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, 1))", 135).
runSimple("vangs360(V(1, 0, 0), V(        -1,          0, 0), V(0, 0, 1))", 180).
runSimple("vangs360(V(1, 0, 0), V(-sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, 1))", 225).
runSimple("vangs360(V(1, 0, 0), V(         0,         -1, 0), V(0, 0, 1))", 270).
runSimple("vangs360(V(1, 0, 0), V( sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, 1))", 315).

runSimple("vangs360(V(         1,          0, 0), V(1, 0, 0), V(0, 0, 1))", 0).
runSimple("vangs360(V( sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", 315).
runSimple("vangs360(V(         0,          1, 0), V(1, 0, 0), V(0, 0, 1))", 270).
runSimple("vangs360(V(-sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", 225).
runSimple("vangs360(V(        -1,          0, 0), V(1, 0, 0), V(0, 0, 1))", 180).
runSimple("vangs360(V(-sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", 135).
runSimple("vangs360(V(         0,         -1, 0), V(1, 0, 0), V(0, 0, 1))", 90).
runSimple("vangs360(V( sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", 45).

runSimple("vangs360(V(1, 0, 0), V(         1,          0, 0), V(0, 0, -1))", 0).
runSimple("vangs360(V(1, 0, 0), V( sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, -1))", 315).
runSimple("vangs360(V(1, 0, 0), V(         0,          1, 0), V(0, 0, -1))", 270).
runSimple("vangs360(V(1, 0, 0), V(-sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, -1))", 225).
runSimple("vangs360(V(1, 0, 0), V(        -1,          0, 0), V(0, 0, -1))", 180).
runSimple("vangs360(V(1, 0, 0), V(-sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, -1))", 135).
runSimple("vangs360(V(1, 0, 0), V(         0,         -1, 0), V(0, 0, -1))", 90).
runSimple("vangs360(V(1, 0, 0), V( sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, -1))", 45).

runSimple("vangs360(V(         1,          0, 0), V(1, 0, 0), V(0, 0, -1))", 0).
runSimple("vangs360(V( sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", 45).
runSimple("vangs360(V(         0,          1, 0), V(1, 0, 0), V(0, 0, -1))", 90).
runSimple("vangs360(V(-sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", 135).
runSimple("vangs360(V(        -1,          0, 0), V(1, 0, 0), V(0, 0, -1))", 180).
runSimple("vangs360(V(-sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", 225).
runSimple("vangs360(V(         0,         -1, 0), V(1, 0, 0), V(0, 0, -1))", 270).
runSimple("vangs360(V( sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", 315).

runSimple("vangs180(V(1, 0, 0), V(         1,          0, 0), V(0, 0, 1))", 0).
runSimple("vangs180(V(1, 0, 0), V( sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, 1))", 45).
runSimple("vangs180(V(1, 0, 0), V(         0,          1, 0), V(0, 0, 1))", 90).
runSimple("vangs180(V(1, 0, 0), V(-sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, 1))", 135).
runSimple("vangs180(V(1, 0, 0), V(        -1,          0, 0), V(0, 0, 1))", 180).
runSimple("vangs180(V(1, 0, 0), V(-sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, 1))", -135).
runSimple("vangs180(V(1, 0, 0), V(         0,         -1, 0), V(0, 0, 1))", -90).
runSimple("vangs180(V(1, 0, 0), V( sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, 1))", -45).

runSimple("vangs180(V(         1,          0, 0), V(1, 0, 0), V(0, 0, 1))", 0).
runSimple("vangs180(V( sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", -45).
runSimple("vangs180(V(         0,          1, 0), V(1, 0, 0), V(0, 0, 1))", -90).
runSimple("vangs180(V(-sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", -135).
runSimple("vangs180(V(        -1,          0, 0), V(1, 0, 0), V(0, 0, 1))", 180).
runSimple("vangs180(V(-sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", 135).
runSimple("vangs180(V(         0,         -1, 0), V(1, 0, 0), V(0, 0, 1))", 90).
runSimple("vangs180(V( sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, 1))", 45).

runSimple("vangs180(V(1, 0, 0), V(         1,          0, 0), V(0, 0, -1))", 0).
runSimple("vangs180(V(1, 0, 0), V( sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, -1))", -45).
runSimple("vangs180(V(1, 0, 0), V(         0,          1, 0), V(0, 0, -1))", -90).
runSimple("vangs180(V(1, 0, 0), V(-sqrt(2)/2,  sqrt(2)/2, 0), V(0, 0, -1))", -135).
runSimple("vangs180(V(1, 0, 0), V(        -1,          0, 0), V(0, 0, -1))", 180).
runSimple("vangs180(V(1, 0, 0), V(-sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, -1))", 135).
runSimple("vangs180(V(1, 0, 0), V(         0,         -1, 0), V(0, 0, -1))", 90).
runSimple("vangs180(V(1, 0, 0), V( sqrt(2)/2, -sqrt(2)/2, 0), V(0, 0, -1))", 45).

runSimple("vangs180(V(         1,          0, 0), V(1, 0, 0), V(0, 0, -1))", 0).
runSimple("vangs180(V( sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", 45).
runSimple("vangs180(V(         0,          1, 0), V(1, 0, 0), V(0, 0, -1))", 90).
runSimple("vangs180(V(-sqrt(2)/2,  sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", 135).
runSimple("vangs180(V(        -1,          0, 0), V(1, 0, 0), V(0, 0, -1))", 180).
runSimple("vangs180(V(-sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", -135).
runSimple("vangs180(V(         0,         -1, 0), V(1, 0, 0), V(0, 0, -1))", -90).
runSimple("vangs180(V( sqrt(2)/2, -sqrt(2)/2, 0), V(1, 0, 0), V(0, 0, -1))", -45).
