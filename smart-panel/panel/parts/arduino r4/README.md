# Arduino UNO R4 WiFi back plate

Printed back plate for the Arduino UNO R4 WiFi, built the same way as the simpleRTK 4 Dual plate
(`../simpleRTK 4 Dual`). The board sits on 4 bosses with M3 heat inserts, one under each PCB screw hole, and drops
between two rims along its long sides. The short sides stay open for USB-C, the DC jack and the Qwiic connector.

## Files

| File | What it is |
| --- | --- |
| `arduino_uno_r4_wifi_backplate.scad` | OpenSCAD model of the back plate (committed) |
| `README.md` | this file (committed) |
| `Arduino UNO R4 WIFI (modified).step` | Arduino board model (58 MB), from the Arduino UNO R4 WiFi product documentation (not committed) |
| `arduino_uno_r4_wifi_board.stl` | the same board as STL, PCB corner at the origin and PCB underside at z = 0; used for the preview ghost (not committed) |
| `arduino_uno_r4_wifi_backplate.stl` | exported back plate, ready to print (not committed) |

## Measured from the STEP model

- PCB 68.58 x 53.34 x 1.6 mm (UNO outline, same as the simpleRTK 4 Dual)
- 4 screw holes Ø3.2 mm at (13.97, 2.54), (15.24, 50.80), (66.04, 7.62), (66.04, 35.56), measured from the
  lower-left PCB corner (USB/DC side at x = 0)
- On the underside, header pins (1.4 to 1.6 mm), the DC jack pins (1.9 mm) and one part at (16.7..20.7,
  32.3..34.3) of 2.34 mm stick out

## Design

- Plate 71.6 x 58.7 x 4 mm, 10.6 mm tall overall, volume 19.1 cm3
- Bosses Ø8 x 5 mm, so there is 5 mm of free space under the board
- M3 heat insert holes Ø4.0 mm, 7 mm deep (blind)
- Rims 2.4 mm thick, 0.3 mm clearance per side, flush with the top of the PCB, with a 0.6 mm lead-in chamfer
- 3 mm deep pockets under everything that sticks out under the PCB (`pin_rows`), so header pins never touch a
  boss or rim. Small notches in the bosses at (13.97, 2.54) and (66.04, 35.56) come from these.
- 2x M4 through holes (Ø4.5, 46 mm apart, counterbored Ø8.5 x 2.4 mm), in the same place as on the RTK plate, to
  bolt the plate onto the DIN rail clip (`../Din rail clip/dins_clip_m4_insert`) or onto the backplate. Bolt the
  plate down first, then fit the board.

A collision check in FreeCAD of the plate against the full STEP model shows no overlap.

## Hardware

- 4x M3 heat insert
- 4x M3x6 bolt (through the PCB into the inserts)
- 2x M4x6 cylinder-head bolt to fix the plate on the DIN clip (longer bolts reach into the rail channel of the clip)

## Printing

Print as exported, with the plate flat on the bed. The bosses and rims point up, so no supports are needed.

## Rebuilding the STLs

STL files in `smart-panel/panel/parts/` are ignored by git. To export the plate again:

```
openscad -o arduino_uno_r4_wifi_backplate.stl arduino_uno_r4_wifi_backplate.scad
```

`show_board = true` shows the board in the preview (F5). That needs `arduino_uno_r4_wifi_board.stl`, which is
exported from the STEP with FreeCAD (PCB underside moved to z = 0).
