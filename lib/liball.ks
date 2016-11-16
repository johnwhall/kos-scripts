@lazyglobal off.

local prevPath to path().
cd("/lib").

local libs to list().
list files in libs.

cd(prevPath).

for lib in libs {
  if lib:isfile and (lib:extension = "ks" or lib:extension = "ksm") {
    runoncepath("/lib/" + lib).
  }
}
