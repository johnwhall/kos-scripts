#!/usr/bin/env python3

founds = []

with open('fly.log') as ifh:
  with open('fly.data', 'w') as ofh:
    first = True
    for line in ifh:
      parts = line.split()
      if not founds or parts[1] == founds[0]: ofh.write(('' if first else '\n') + parts[0])
      if parts[1] == 'update': parts[3] = str(float(parts[3]) * 10)
      if parts[1] == 'curRoll': parts[3] = str(float(parts[3]) * 10)
      ofh.write(' ' + parts[3])
      if parts[1] not in founds: founds.append(parts[1])
      first = False
