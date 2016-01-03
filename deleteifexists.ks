@lazyglobal off.

parameter fname.

list files in fs.
for f in fs {
  if f:name = fname {
    delete f.
  }
}
