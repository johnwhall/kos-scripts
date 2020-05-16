@lazyglobal off.

for testSuite in list("testlibmath", "testlibnewton", "testlibsecant", "testlibstring", "testlibtimeto") {
  print "Running test suite " + testSuite.
  runpath("test/" + testSuite).
}
