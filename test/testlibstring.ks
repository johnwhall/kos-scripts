@lazyglobal off.

runoncepath("lib/libstring").
runoncepath("test/libtest").

local qt to char(34).

runSimple("substl('hello goodbye')":replace("'", qt), "hello goodbye").
runSimple("substl('hello {} goodbye {}', list('one', 'three'))":replace("'", qt), "hello one goodbye three").

runSimple("subst('hello goodbye')":replace("'", qt), "hello goodbye").
runSimple("subst('hello {} goodbye {}', 'one', 'three')":replace("'", qt), "hello one goodbye three").

runSimple("join(', ', list(1, 2, 3))":replace("'", qt), "1, 2, 3").
runSimple("join(', ', list())":replace("'", qt), "").
runSimple("join(', ', list(1))":replace("'", qt), "1").

runSimple("padLeft('3', 2, '0')":replace("'", qt), "03").
runSimple("padLeft('3', 1, '0')":replace("'", qt), "3").
runSimple("padLeft('', 1, '0')":replace("'", qt), "0").
runSimple("padLeft('', 0, '0')":replace("'", qt), "").
runSimple("padLeft('33', 1, '0')":replace("'", qt), "33").

runSimple("s2ydhms(0)", "00.00s").
runSimple("s2ydhms(1.01)", "01.01s").
runSimple("s2ydhms(1.15)", "01.15s").
runSimple("s2ydhms(15.00)", "15.00s").
runSimple("s2ydhms(15.009)", "15.01s").
runSimple("s2ydhms(15.001)", "15.00s").
runSimple("s2ydhms(1 * 60 + 1)", "1m 01.00s").
runSimple("s2ydhms(15 * 60 + 1)", "15m 01.00s").
runSimple("s2ydhms(1 * 3600 + 1 * 60 + 1)", "1h 01m 01.00s").
runSimple("s2ydhms(15 * 3600 + 1 * 60 + 1)", "15h 01m 01.00s").
runSimple("s2ydhms(1 * 86400 + 1 * 3600 + 1 * 60 + 1)", "1d 01h 01m 01.00s").
runSimple("s2ydhms(15 * 86400 + 1 * 3600 + 1 * 60 + 1)", "15d 01h 01m 01.00s").
runSimple("s2ydhms(150 * 86400 + 1 * 3600 + 1 * 60 + 1)", "150d 01h 01m 01.00s").
runSimple("s2ydhms(1 * 31536000 + 1 * 86400 + 1 * 3600 + 1 * 60 + 1)", "1y 01d 01h 01m 01.00s").
runSimple("s2ydhms(15 * 31536000 + 1 * 86400 + 1 * 3600 + 1 * 60 + 1)", "15y 01d 01h 01m 01.00s").
runSimple("s2ydhms(15 * 31536000 + 0 * 86400 + 0 * 3600 + 0 * 60 + 0)", "15y 00d 00h 00m 00.00s").
runSimple("s2ydhms(-(15 * 31536000 + 1 * 86400 + 1 * 3600 + 1 * 60 + 1))", "-15y 01d 01h 01m 01.00s").
