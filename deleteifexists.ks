@lazyglobal off.

parameter fname.

local fs to list().
list files in fs.
for f in fs {
  if f:name = fname {
    delete f.
  }
}
