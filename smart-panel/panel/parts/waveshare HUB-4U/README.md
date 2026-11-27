# Waveshare USB-HUB-4U DIN rail clip

A DIN rail clip for the Waveshare USB-HUB-4U (industrial 4-port USB hub in an aluminium case). The hub hangs on its
side on the 35 mm rail: its mounting flange lies flat against the clip, the 4 USB-A ports point down and the USB-B /
power terminal points up. It is held by 4x M3 through the slots in the flange, into heat inserts in the top of the
clip. One printed part, no separate back plate.

## Files

| File | What it is |
| --- | --- |
| `README.md` | this file (committed) |
| `make_waveshare_din_clip.py` | FreeCAD script that builds the clip, exports the files below and checks the fit against the hub model (committed). Needs `../Din rail clip/dins_clip_m4_insert.step` |
| `USB-UHB-4U Waveshare.STEP` | manufacturer model of the hub, from Waveshare (not committed) |
| `waveshare_hub4u_din_clip.step` / `.stl` | the clip, ready to print (60 x 20 x 90 mm, 66.8 cm3), built by the script (not committed) |
| `waveshare_usb_hub_4u.stl` | the hub as STL, without the loose cable plug in the STEP (86 x 27.5 x 50 mm, min corner -43, 0, -25) (not committed) |

## Design

Measured from the STEP model: the case is 72.4 x 27.5 x 45 mm (49 mm with the end caps), with a 2 mm flange at the
bottom that is 86 mm wide. The flange has 4 slots, 3.6 mm wide, centred at ±39.5 mm along the flange and ±12.35 mm
across (each slot runs 6.6 mm in that direction).

- The profile of `../Din rail clip/dins_clip_m4_insert.step` (60 x 16 mm), extruded to **90 mm along the rail**
  (flange 86 mm + 2 mm per side).
- A **4 mm thicker top** (top at y = 12 instead of 8). The M3 holes have to sit at ±12.35 mm across the rail (set by
  the hub), right above the cavities of the clip mechanism, where the original profile only has 5 mm of material. With
  the extra plate the holes are blind and fully in solid material, with 2.5 mm under them.
- 4 insert holes **Ø4.0 x 6.5 mm deep** (M3 heat insert, same size as the VESC plate), at ±12.35 mm across the rail and
  5.5 / 84.5 mm along it (3.5 mm wall to the ends).
- The hole pattern is symmetric, so the hub can be mounted with the USB-A ports on either side of the release lip.
  Choose the side so the release lip stays reachable.
- The script places the hub on the clip and checks the overlap: 0 mm3, and the 4 slots line up with the 4 holes.

On the panel the hub takes 90 mm of rail and sticks out about 20 + 27.5 mm from the rail. Leave room under it for the
USB plugs and the bend of the cables.

## Hardware

- 4x M3 heat insert (Ø4.0 hole, up to 6 mm long)
- 4x M3x8 hex socket or pan head bolt (2 mm flange + 6 mm into the insert), with a washer, because the flange holes
  are slots

## Printing

- Print like the other clips: profile flat on the bed, 90 mm tall. The insert holes are horizontal in that
  orientation.
- PETG or ASA is recommended over PLA.
- A clip this wide has a much stiffer spring than the 12 mm original (about 7.5x). If it snaps on too hard, print one
  first or lower `WIDTH` in the script (it must stay at least about 88 mm, or the holes at ±39.5 mm get too close to
  the ends).

## Rebuilding

STL files are not committed (see the `.gitignore` in the repo root). Rebuild from this folder with:

```
"C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_waveshare_din_clip.py').read())"
```
