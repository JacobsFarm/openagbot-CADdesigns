# DIN rail clip

DIN rail clip for mounting parts on the 35 mm DIN rail in the panel. 
## Source

- Model by Nathan Litzinger (`@nlitz88_2513763` on Printables)
- [DIN rail mount](https://www.printables.com/model/64242-din-rail-clip/files)

## Files

| File | What it is |
| --- | --- |
| `dins_clip.step` | original model as downloaded (two Ø3.2 mm holes) |
| `dins_clip.igs` | the same original model in IGES format (also Ø3.2 mm) |
| `make_dins_clip_m4.py` | FreeCAD script that widens the holes and exports the files below |
| `dins_clip_m4_insert.step` | adjusted model: holes widened to Ø4.8 mm for M4 heat inserts |
| `dins_clip_m4_insert.stl` | the adjusted model as STL, ready to print (not committed, see below) |

## Adjustment

The two holes on top of the clip (at x = ±23 mm, 8.5 mm deep) go from Ø3.2 mm to Ø4.8 mm, so an M4 heat
insert can be pressed in. The rest of the clip is unchanged.

## Printing

- Size: 60 x 16 x 12 mm, volume 5.8 cm3
- The STL already lies in print orientation: the clip profile flat on the bed, 12 mm tall. The insert holes are
  horizontal in that orientation.
- PETG or ASA is recommended over PLA for a clip that has to flex and may get warm in the panel.

## Rebuilding the STL

STL files in `smart-panel/panel/parts/` are ignored by git, so after a fresh checkout you need to generate it again:

```
"C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" make_dins_clip_m4.py
```
