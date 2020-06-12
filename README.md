# SAS
GTA: San Andreas Splitmode for SA:MP

Server is currently running at `leaty.net:7777`, as a throwback for some good old lagshot fighting.

May have some indentation irregularities due to automated windows to unix conversion.

## Build
Can be built using https://github.com/pawn-lang/compiler v.3.10.10 on Linux.

May require the "require a semicolon to end each statement" switch. E.g.
```
pawncc SAS.pwn -\; -i/path-to-include-dir
```

## Contributors
I did my best to fill in here, but it is very likely I missed something.

### Directly
* iou/leaty
* Kase
* Lithirm

### Indirectly

#### Lots and lots of inspiration from
* LVP - Now open source at: https://github.com/LVPlayground/playground

#### Ramping feature originally taken from LVP
* Jay

#### sscanf plugin pwn code
* Y_Less, the original creator
* Emmet\_, for his efforts in maintaining it for almost a year

### Others
* Matthias for helping out in general

## Dependencies
### Plugins
* irc.dll/.so
* mysql.dll/.so
* streamer.dll/.so
### Includes
* a_http.inc
* a_irc.inc
* a_mysql.inc
* a_npc.inc
* a_objects.inc
* a_players.inc
* a_sampdb.inc
* a_samp.inc
* a_vehicles.inc
* bodyparts.inc
* core.inc
* datagram.inc
* Dini.inc
* dudb.inc
* dutils.inc
* file.inc
* float.inc
* irc.inc
* IsPlayerLAdmin.inc
* lethaldudb2.inc
* md5.inc
* seif_cursor.inc
* streamer.inc
* string.inc
* time.inc
