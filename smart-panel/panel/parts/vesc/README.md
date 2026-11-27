# VESC Classic mounts

Two printed ways to mount the VESC Classic 100 V motor controllers in the panel:

1. **Mount plate** (`vesc_mount_plate.scad`): one plate for several VESCs side by side, bolted to the cabinet
   backplate with M5.
2. **DIN rail holder** (`make_vesc_din_clip.py`): one holder per VESC that clips onto the 35 mm DIN rail. Clip,
   plate and rims are one printed part.

Both use the same VESC dimensions and the same M3 heat inserts, so a VESC fits either one.

## Files

Only our own sources are committed (see the `.gitignore` in the repo root). The VESC model and all exported
STL/STEP files stay local.

| File | What it is | In git |
| --- | --- | --- |
| `README.md` | this file | yes |
| `vesc_mount_plate.scad` | OpenSCAD model of the mount plate (version 1) | yes |
| `make_vesc_din_clip.py` | FreeCAD script that builds the DIN rail holder (version 2) and checks the fit | yes |
| `vesc_classic.stl` | model of the VESC Classic 100 V including its wires (208 x 47.5 x 18.6 mm). Third-party model, copy it in yourself. Used by `show_vesc` in the `.scad`, by the fit check in the script and by `../../panel.scad` | no |
| `vesc_mount_plate.stl` | the mount plate, exported from OpenSCAD | no |
| `vesc_din_clip.step` / `.stl` | the DIN rail holder, built by the script | no |

The script also needs `../Din rail clip/dins_clip_m4_insert.step` (also not in git, see the README in that folder
for how to make it).

## VESC dimensions

Measured from `vesc_classic.stl`, the same numbers in both versions:

- Aluminium base 99.8 x 47.5 mm (the length includes a 0.45 mm end cap on the wire side).
- 2x M3 hole (Ø3.2 in the base) on one diagonal, 93.7 mm apart along the length and 41.4 mm across, centred on
  the base.
- The three wires leave the case at one short end, 4.1 mm above the bottom of the base.

## Version 1: mount plate

A plate for `n_vesc` VESCs side by side (default 4: 248 x 117.8 x 10 mm), for mounting straight onto the cabinet
backplate.

- Bolts to the backplate with 4x M5 (Ø5.5 holes), in the strips between VESC 1-2 and 3-4, each with a
  Ø16 x 1.3 mm recess for the washer.
- Each VESC lies flat on the plate and screws on with 2x M3 into heat inserts (Ø4.0 holes straight through).
  `mirror_holes = true` switches to the other diagonal if your VESC has its holes there.
- The two M5 strips also have 3x M4 insert holes each (Ø4.8, at y = -25, 0, 25) to mount something on top later.
- `show_vesc = true` shows the VESCs on the plate in the OpenSCAD preview.

Choose this when the VESCs go together in one block on the backplate and you want them fixed solidly.

## Version 2: DIN rail holder

One holder per VESC (106.8 x 25 x 53.5 mm, 63.2 cm3), on the profile of the DIN rail clip.

- The VESC stands with its length across the rail (vertical on the panel). The wires can point up or down.
- **Clip:** the profile of `dins_clip_m4_insert.step` (60 x 16 mm), extruded over the full width of the holder.
- **Plate:** 6 mm thick, on top of the clip profile, as long as the VESC plus the rims.
- **M3 holes:** Ø4.0 for heat inserts, straight through the plate, on **both** diagonals. Your VESC only uses 2 of
  them, but it fits whichever diagonal it has. The holes sit outside the clip profile, so they don't hit the clip
  mechanism.
- **Rims:** at both short ends of the VESC (top and bottom on the panel), 3 mm thick and 3 mm high, 100.8 mm apart
  on the inside (0.5 mm play per side). They stay below the wires.
- **Width along the rail:** 3 mm wider than the VESC on each side (47.5 + 2 x 3 = 53.5 mm). With the holders
  against each other on the rail, the VESCs sit 6 mm apart and don't touch.
- The script places `vesc_classic.stl` on the holder and prints the checks: the M3 holes line up (0.000 mm),
  the VESC is ±49.9 mm at rim height against ±50.4 mm inside the rims, and the wires leave the case 1.15 mm above
  the rims.
- The release lip of the clip sits under the overhang of the plate. You can still reach it with a screwdriver
  from the side.

Choose this when the VESCs go on the DIN rail, can be added or removed one at a time, or have to share the
rail with other parts.

Settings at the top of the script: `MARGIN` (extra width per side, 3 mm), `CLEAR` (play to the rims),
`PLATE_T`, `RIM_T`, `RIM_H` and `ALL_FOUR` (holes on both diagonals).

## Hardware

| | Mount plate (per 4 VESCs) | DIN rail holder (per VESC) |
| --- | --- | --- |
| M3 heat insert (Ø4.0 hole) | 8x | 2x |
| M3 bolt (base + insert) | 8x | 2x |
| M5 bolt + washer to the backplate | 4x | - |
| M4 heat insert (optional, for later) | up to 6x | - |

## Printing

- PETG or ASA is recommended over PLA, because it can get warm in the panel.
- **Mount plate:** flat on the bed, the side the VESCs go on facing up.
- **DIN rail holder:** like the other clips, with the profile flat on the bed and 53.5 mm tall. The M3 holes are
  horizontal in that orientation. A clip this wide has a stiffer spring than the 12 mm original (about 4.5x).
  If it snaps onto the rail too hard, lower `MARGIN` in the script.

## Rebuilding

- **Mount plate:** open `vesc_mount_plate.scad` in OpenSCAD, render (F6) and export `vesc_mount_plate.stl`.
- **DIN rail holder:** run this from this folder:

```
"C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_vesc_din_clip.py').read())"
```
