# DIN rail clip

DIN rail clip for mounting parts on the 35 mm DIN rail in the panel. 
## Source

- Model by Nathan Litzinger (`@nlitz88_2513763` on Printables)
- [DIN rail mount](https://www.printables.com/model/64242-din-rail-clip/files)

## Files

Only this README and `make_dins_clip_wide.py` are in git. The clip itself is a third-party model, so the STEP
files are not committed: download the original from the Printables link above and make the M4 version yourself
(see [Adjustment](#adjustment)).

| File | What it is | In git |
| --- | --- | --- |
| `dins_clip.step` | original model as downloaded from Printables (two Ø3.2 mm holes) | no |
| `dins_clip_m4_insert.step` | adjusted model: holes widened to Ø4.8 mm for M4 heat inserts. Input for all clip scripts (here, `../Jetson orin nano 8gb dev kit/make_jetson_din_clip.py` and `../waveshare HUB-4U/make_waveshare_din_clip.py`) | no |
| `dins_clip_m4_insert.stl` | the adjusted model as STL, ready to print | no |
| `make_dins_clip_wide.py` | FreeCAD script that extrudes the M4 clip profile to a wider clip (`WIDTHS`, default 40 and 53.34 mm) | yes |
| `dins_clip_m4_insert_w40.step` / `.stl` | wide clip (60 x 16 x 40 mm) for the Arduino UNO R4 and simpleRTK 4 Dual back plates, built by the script | no |
| `dins_clip_m4_insert_w53.step` / `.stl` | extra: clip as wide as the simpleRTK 4 Dual PCB (60 x 16 x 53.34 mm), built by the script | no |

## Wide version (Arduino R4 / simpleRTK 4 Dual)

The back plates of the Arduino and the RTK board are 58.7 mm along the rail (PCB 53.34 mm), so the 12 mm clip lets them rock.
`make_dins_clip_wide.py` takes the profile of `dins_clip_m4_insert.step`, extrudes it to 40 mm (and, as an extra, 53.34 mm: the width of the
simpleRTK 4 Dual PCB) and drills
the two Ø4.8 mm insert holes again at x = ±23 mm (pitch 46, the same as the M4 holes in both back plates),
centred in the width. Volume 20.0 cm3 (40 mm) and 26.7 cm3 (53.34 mm). A wider clip also has a stiffer spring (about 3.3x at 40 mm, 4.4x at 53.34 mm); change
`WIDTHS` if it snaps on too hard. Rebuild with:

```
"C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_dins_clip_wide.py').read())"
```

## Adjustment

The two holes on top of the clip (at x = ±23 mm, 8.5 mm deep) go from Ø3.2 mm to Ø4.8 mm, so an M4 heat
insert can be pressed in. The rest of the clip is unchanged. Do this in FreeCAD on `dins_clip.step` (Part
workbench: cut two Ø4.8 x 8.5 mm cylinders at the hole centres) and save the result as `dins_clip_m4_insert.step`
and `dins_clip_m4_insert.stl`. The script that did this originally is not kept.

## Printing

- Size: 60 x 16 x 12 mm, volume 5.8 cm3
- The STL already lies in print orientation: the clip profile flat on the bed, 12 mm tall. The insert holes are
  horizontal in that orientation.
- PETG or ASA is recommended over PLA for a clip that has to flex and may get warm in the panel.

## After a fresh checkout

1. Download `dins_clip.step` from Printables into this folder.
2. Make `dins_clip_m4_insert.step` / `.stl` as described under [Adjustment](#adjustment).
3. Run `make_dins_clip_wide.py` (command above) for the wide clips.
