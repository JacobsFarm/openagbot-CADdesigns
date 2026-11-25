# panel

Layout study for the electronics panel ("smart panel") of the robot: do all boards fit, and where do they go?
Everything is in millimetres.

## The panel

The enclosure is a **VEVOR NEMA Steel Case, 24 x 24 x 8 inch (60 x 60 x 20 cm)**: carbon steel, NEMA 4X, IP66,
with a mounting plate. Product page: [vevor.com, item 010590231787](https://www.vevor.com/electrical-enclosure-c_10749/vevor-steel-electrical-box-electrical-enclosure-box-24x24x8-carbon-steel-ip65-p_010590231787).

Measured inside the panel: **550 mm wide (X) x 565 mm high (Y)**, set by `inner_w` and `inner_h` in `panel.scad`.
The depth is taken as 200 mm from the original brief (`panel is 600x600x200.txt`); the outer size is not measured, the
transparent enclosure is just the inner size plus a 25 mm wall.

All positions below are measured from the **inside bottom-left corner** of the panel, +X to the right, +Y up.

## Parts

What the panel has to hold, and which model in [`parts/`](parts) represents it:

| Qty | Part | Model in `parts/` |
| --- | --- | --- |
| 1 | NVIDIA Jetson Nano Orin 8 GB dev kit | `jetson_orin_nano_board.stl` |
| 1 | Innomaker USB2CAN converter, with the CAN bus line (the line itself is not drawn) | `usb2can_innomaker.stl` |
| 4 | HBS860H stepper motor controllers | `hbs860h_driver.stl` |
| 2 | Arduino UNO boards | `arduino_uno_r4_wifi.stl` |
| 2 or 4 | [VESC Classic 100 V](https://www.vesclabs.com/product/vesc-classic-100v/) boards (the layout uses 4, the worst case) | `vesc/vesc_classic.stl`, on the printed bracket `vesc/vesc_mount_plate.scad` |
| 1 | RTK board (ZED-X20D) | `simpleRTK2b_standin_x20d.stl`, a stand-in |
| 1 | Main switch, mounted in the panel | `hoofdschakelaar_aan_uit.stl`, a guess |

## Layout

Top view, +Y is the top of the panel:

```
+-----------------------+-----------------------+
| Jetson Orin Nano      | VESC bracket, 4x VESC |
|                       | (wires down, to -Y)   |
|                       |                       |
+-----------------------+-----------------------+
| 4x HBS860H, standing  | RTK board, main switch|
| (fans to the front)   | 2x Arduino UNO,USB2CAN|
+-----------------------+-----------------------+
```

- **HBS860H** drivers stand on their side (150 wide, 54.5 thick, 108.9 high), with 15 mm between them for cooling.
- **VESCs** sit on the printed bracket in the top-right corner, with their three wires pointing down into the panel
  (they cannot point up: the wires stick out 108 mm past the VESC and would hit the top wall).

### VESC bracket (top right)

The bracket is `parts/vesc/vesc_mount_plate.scad` (248 x 117.8 x 10 mm), turned 180 degrees so the wires point down,
5 mm (`margin`) from the right and top wall. `panel.scad` reads the plate size and hole positions from that file, so
these numbers follow it if the plate changes; it also prints them in the console (`M5 gat bracket`, `VESC bracket`).

| What | X (from left) | Y (from bottom) | From right wall | From top wall |
| --- | --- | --- | --- | --- |
| Plate, left / right edge | 297.0 / 545.0 | | 253.0 / 5.0 | |
| Plate, bottom / top edge | | 442.2 / 560.0 | | 122.8 / 5.0 |
| Plate centre | 421.0 | 501.1 | 129.0 | 63.9 |
| M5 hole, top right | 483.5 | 548.0 | 66.5 | 17.0 |
| M5 hole, bottom right | 483.5 | 454.2 | 66.5 | 110.8 |
| M5 hole, top left | 358.5 | 548.0 | 191.5 | 17.0 |
| M5 hole, bottom left | 358.5 | 454.2 | 191.5 | 110.8 |
| Lowest wire end | | 343.0 | | 222.0 |

- The 4 M5 holes in the backplate are **125.0 mm** apart horizontally and **93.8 mm** vertically (centre to centre).
- Total footprint of bracket + VESCs + wires: 248 x 217 mm, 28.6 mm deep (10 mm plate + 18.6 mm VESC).
- The wire end is where the wires stop in `vesc_classic.stl`, not where real cables end: leave room below for the
  bend towards the motors and the power distribution.

### Other boards (bottom right)

| Part | X, Y of lower-left corner |
| --- | --- |
| Arduino UNO 1 / 2 | 290, 15 / 370, 15 |
| Innomaker USB2CAN | 455, 15 |
| RTK board | 290, 90 |
| Main switch | 390, 90 |
| Jetson Orin Nano | 15, 444 |
| HBS860H 1 to 4 | 15, 15 / 85 / 155 / 225 |
- The tallest part is 108.9 mm, so there is 90 mm headroom under the 200 mm lid height.
- Large free areas remain between the four zones for the CAN line, power wiring and fuses.

## Using `panel.scad`

Open it in OpenSCAD. Parameters at the top:

| Parameter | Meaning |
| --- | --- |
| `inner_w`, `inner_h`, `inner_z` | measured inner size (550 x 565) and depth (200) |
| `margin` | minimum distance from a part to the wall (5 mm) |
| `gap` | minimum distance between two parts (5 mm) |
| `show_parts` | `true` imports the real STLs, `false` draws plain blocks (fast) |
| `show_box` | draws the enclosure as a transparent ghost |

Each entry in `parts` is `[name, stl, [x, y], rotation, standing, stl-min, size]`. To move a part, change `[x, y]`
(lower-left corner of its footprint). `rotation` is 0, 90 or 270 degrees about the vertical axis, `standing` is 1 for
a part that stands on its side. The VESC bracket has `"bracket"` as its model and is placed by `bracket_pos`.

### Fit check

On every render the console reports `BUITEN PANEEL` (outside the panel, margin included) and `OVERLAP` (closer than
`gap` to another part), plus the used depth and the tallest part. No message means everything fits. The check works on
footprints and height only: it does not cover cable routing, connector clearance, mounting holes or airflow.

Quick check without STLs:

```powershell
openscad -D show_parts=false -o out.stl panel.scad
```

## Known assumptions

- The RTK board is the simpleRTK2B model, standing in for the ZED-X20D, which has no model yet.
- The main switch model (`aan uit.stl`) is a guess, not a measured part.
- The HBS860H STL is the manufacturer model: check the real driver against it before drilling.

## Files

| Path | What |
| --- | --- |
| `panel.scad` | the layout and fit check |
| [`parts/`](parts) | component STLs (not committed, see its README) |
