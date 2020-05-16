@lazyglobal off.

runoncepath("lib/libsecant").
runoncepath("test/libtest").

runSimple("secantMethod({ parameter x. return x^2 - 612. }, 10, 30, 1e-6, 5)", 24.738633, 1e-6).
