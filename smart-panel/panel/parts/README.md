# parts

Component models that `../panel.scad` imports to check whether everything fits in the panel.

**The STL files in this folder are not committed** (ignored by the `.gitignore` in the repo root): together they are about 90 MB, and several are
manufacturer models. Copy them in yourself under the exact names below, or `panel.scad` cannot show the real shapes
(set `show_parts = false` to get plain blocks instead).

| File | Component | Used for | Bounding box (x, y, z mm) |
| --- | --- | --- | --- |
| `jetson_orin_nano_board.stl` | NVIDIA Jetson Orin Nano 8 GB dev kit | main computer | 103 x 90.9 x 34.8 |
| `hbs860h_driver.stl` | HBS860H closed-loop stepper driver | 4x, one per steering/wheel stepper | 150 x 108.9 x 54.5 |
| `vesc_classic.stl` | VESC Classic 100 V (including its wires) | 4x (2 or 4 depending on build) | 208 x 47.5 x 18.6 |
| `arduino_uno_r4_wifi.stl` | Arduino UNO R4 WiFi | 2x | 70.5 x 53.3 x 14.5 |
| `usb2can_innomaker.stl` | Innomaker USB2CAN converter | CAN bus to the VESCs | 31 x 56.5 x 16.6 |
| `simpleRTK2b_standin_x20d.stl` | ArduSimple simpleRTK2B | **stand-in** for the ZED-X20D RTK board | 80 x 80.2 x 11.5 |
| `hoofdschakelaar_aan_uit.stl` | on/off switch | **guess** for the main switch | 33 x 20 x 45 |

The bounding boxes are those of the STL as exported, before `panel.scad` rotates a part. The VESC box includes the
three wires that stick out of one short end.

## Adding a part

1. Put the STL here and add a row to the table above.
2. Measure its bounding box and minimum corner (the part's offset from the origin).
3. Add a line to the `parts` list in `../panel.scad`.
