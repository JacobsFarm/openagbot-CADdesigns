# simpleRTK 4 Dual back plate

Printed back plate for the ArduSimple simpleRTK 4 Dual (ZED-X20D, model `AS-RTK4-X20D-NH-00-R00`). The board
sits on 5 bosses with M3 heat inserts, one under each PCB screw hole, and drops between two rims along its long
sides. The short sides stay open for the SMA, USB-C and GHS connectors.

## Files

| File | What it is |
| --- | --- |
| `simplertk4_dual_backplate.scad` | OpenSCAD model of the back plate (committed) |
| `README.md` | this file (committed) |
| `AS-RTK4-X20D-NH-00-R00.step` | ArduSimple board model, as downloaded from the [simpleRTK 4 Dual product page](https://www.ardusimple.com/product/simplertk-4-dual/) (not committed) |
| `simplertk4_dual.stl` | the same board as STL, PCB corner at the origin and PCB underside at z = 0; used for the preview ghost (not committed) |
| `simplertk4_dual_backplate.stl` | exported back plate, ready to print (not committed) |

## Measured from the STEP model

- PCB 68.58 x 53.34 x 1.6 mm (Arduino shield outline, with the tab on the USB-C side)
- 5 screw holes Ø3.2 mm at (13.97, 2.54), (15.24, 50.80), (66.04, 35.56), (47.63, 43.43), (47.63, 12.95),
  measured from the lower-left PCB corner (SMA side at x = 0)
- On the underside, only the pins of the two header rows (1.3 mm) and the SMA connectors (1.55 mm, outside the
  board edge) stick out

## Design

- Plate 71.6 x 58.7 x 4 mm, 10.6 mm tall overall, volume 19.2 cm3
- Bosses Ø8 x 5 mm, so the PCB underside is 9 mm above the back of the plate and there is 5 mm of free space
  under the board
- M3 heat insert holes Ø4.0 mm, 7 mm deep (blind)
- Rims 2.4 mm thick, 0.3 mm clearance per side, flush with the top of the PCB, with a 0.6 mm lead-in chamfer
- Two 2.5 mm deep slots across the bosses under the header rows, because their pins would otherwise hit the boss
  at (47.63, 43.43)
- 2x M4 through holes (Ø4.5, 46 mm apart, counterbored Ø8.5 x 2.4 mm) to bolt the plate onto the DIN rail clip
  (`../Din rail clip/dins_clip_m4_insert`) or onto the backplate. Bolt the plate down first, then fit the board.

A collision check in FreeCAD of the plate against the full STEP model shows no overlap.

## Hardware

- 5x M3 heat insert
- 5x M3x6 bolt (through the PCB into the inserts)
- 2x M4x6 cylinder-head bolt to fix the plate on the DIN clip (longer bolts reach into the rail channel of the clip)

## Printing

Print as exported, with the plate flat on the bed. The bosses and rims point up, so no supports are needed.

## Rebuilding the STLs

STL files in `smart-panel/panel/parts/` are ignored by git. To export the plate again:

```
openscad -o simplertk4_dual_backplate.stl simplertk4_dual_backplate.scad
```

`show_board = true` shows the board in the preview (F5). That needs `simplertk4_dual.stl`, which is exported from the
STEP with FreeCAD (PCB lower-left corner moved to the origin, PCB underside at z = 0).
