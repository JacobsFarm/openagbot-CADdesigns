# panel

Layout study for the electronics panel ("smart panel") of the robot: do all boards fit, and where do they go?
Everything is in millimetres.

## The panel

The brief (originally `panel is 600x600x200.txt`) is an enclosure of **600 x 600 x 200 mm**, with an inner floor of
**550 x 550 mm** (25 mm wall, set by `panel_outer` and `wall` in `panel.scad`).

## Parts

What the panel has to hold, and which model in [`parts/`](parts) represents it:

| Qty | Part | Model in `parts/` |
| --- | --- | --- |
| 1 | NVIDIA Jetson Nano Orin 8 GB dev kit | `jetson_orin_nano_board.stl` |
| 1 | Innomaker USB2CAN converter, with the CAN bus line (the line itself is not drawn) | `usb2can_innomaker.stl` |
| 4 | HBS860H stepper motor controllers | `hbs860h_driver.stl` |
| 2 | Arduino UNO boards | `arduino_uno_r4_wifi.stl` |
| 2 or 4 | [VESC Classic 100 V](https://www.vesclabs.com/product/vesc-classic-100v/) boards (the layout uses 4, the worst case) | `vesc/vesc_classic.stl` |
| 1 | RTK board (ZED-X20D) | `simpleRTK2b_standin_x20d.stl`, a stand-in |
| 1 | Main switch, mounted in the panel | `hoofdschakelaar_aan_uit.stl`, a guess |

## Layout

Top view, +Y is the top of the panel:

```
+-----------------------+-----------------------+
| Jetson Orin Nano      | RTK board             |
|                       | 2x Arduino UNO        |
|                       | USB2CAN, main switch  |
+-----------------------+-----------------------+
| 4x HBS860H, standing  | 4x VESC, wires up     |
| (fans to the front)   | (towards +Y)          |
+-----------------------+-----------------------+
```

- **HBS860H** drivers stand on their side (150 wide, 54.5 thick, 108.9 high), with 15 mm between them for cooling.
- **VESCs** are rotated so their three wires point towards the top of the panel.
- The tallest part is 108.9 mm, so there is 90 mm headroom under the 200 mm lid height.
- Large free areas remain between the four zones for the CAN line, power wiring and fuses.

## Using `panel.scad`

Open it in OpenSCAD. Parameters at the top:

| Parameter | Meaning |
| --- | --- |
| `panel_outer`, `wall` | outer size and wall thickness, inner size is derived |
| `margin` | minimum distance from a part to the wall (5 mm) |
| `gap` | minimum distance between two parts (5 mm) |
| `show_parts` | `true` imports the real STLs, `false` draws plain blocks (fast) |
| `show_box` | draws the 600 x 600 x 200 mm enclosure as a transparent ghost |

Each entry in `parts` is `[name, stl, [x, y], rotation, standing, stl-min, size]`. To move a part, change `[x, y]`
(lower-left corner of its footprint). `rotation` is 0, 90 or 270 degrees about the vertical axis, `standing` is 1 for
a part that stands on its side.

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
