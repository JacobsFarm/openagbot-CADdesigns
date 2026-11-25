# Innomaker USB2CAN clamp

Two-part clamp (bottom + top) that holds the Innomaker USB2CAN converter in the panel. It is the original
Innomaker case (`innomaker-USB2CAN-Bottom/Top`), adjusted for M4 heat inserts and with a built-in base plate.
The inside of the case is taken 1-to-1 from the original STLs, so the USB2CAN fits exactly as before.

## Files

| File | What it is |
| --- | --- |
| `usb2can_innomaker_clamp.scad` | OpenSCAD model of the adjusted clamp (committed) |
| `README.md` | this file (committed) |
| `innomaker-USB2CAN-Bottom.stl` / `-Top.stl` | original case; the `.scad` imports these (not committed) |
| `innomaker-USB2CAN-Bottom.step` / `-Top.step` | the same original case as STEP (not committed) |
| `usb2can_innomaker.stl` | model of the USB2CAN board itself, used for the preview ghost and `panel.scad` (not committed) |
| `usb2can_innomaker_clamp_bottom.stl` / `_top.stl` | exported clamp, ready to print (not committed) |

Only the `.scad` and this README are in git. The original STL files must be in this folder before you open the
`.scad`.

## Changes compared to the original

- **4 M4 clamp points.** M4 heat inserts (Ø4.8 mm hole) go into the bottom, and M4 bolts go through the top
  (Ø4.5 mm hole). The PCB holes are only Ø3 mm, so the M4 points sit in ears outside the board: two at the back,
  in the same place as the original screws, and two new ones next to the USB end.
- **Built-in base plate.** It is 4 mm thick, connects all four ears and has 2 mounting holes (Ø4.5 mm, 66 mm
  apart) to bolt the clamp onto a base.
- **Flush front and back.** Plate, ears and housing end flat on the USB side and on the DB9 side.
- **Original PCB screw holes closed.** The two original screw holes in the underside of the bottom are filled.
- **Top ears run full height**, so the top prints flat on its top face without overhangs.

## Hardware

- 4x M4 heat insert, pressed into the bottom from above
- 4x M4x16 bolt, from the top
- 2x M4 bolt to fix the plate on the base

## Printing

- Bottom: as exported, with the plate flat on the bed.
- Top: the export is already flipped, so its flat top face lies on the bed.

## Rebuilding the STLs

STL files in `smart-panel/panel/parts/` are ignored by git. To export them again (OpenSCAD 2021.01 or newer):

```
openscad -o usb2can_innomaker_clamp_bottom.stl -D "part=\"bottom\"" usb2can_innomaker_clamp.scad
openscad -o usb2can_innomaker_clamp_top.stl -D "part=\"top\"" usb2can_innomaker_clamp.scad
```

In OpenSCAD itself you choose the part with `part` (`"assembly"`, `"bottom"`, `"top"`), and `show_device = true`
shows the USB2CAN in the preview (F5). Ear positions, hole sizes and plate dimensions are parameters at the top of
the file.
