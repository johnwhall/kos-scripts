@lazyglobal off.

runoncepath("lib/libnewton").
runoncepath("test/libtest").

runSimple("newtonsMethod({ parameter x. return x^2 - 612. }, { parameter x. return 2*x. }, 10)", 24.738633, 1e-6).
