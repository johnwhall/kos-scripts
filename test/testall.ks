@lazyglobal off.

for testSuite in list("testlibmath", "testlibnewton", "testlibstring", "testlibtimeto") {
  print "Running test suite " + testSuite.
  runpath("test/" + testSuite).
}
