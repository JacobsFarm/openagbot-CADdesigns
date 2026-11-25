# Jetson Orin Nano 8 GB dev kit carrier

Printed carrier for the NVIDIA Jetson Orin Nano 8 GB dev kit. With it, the Jetson clips onto the 35 mm DIN rail in
the panel instead of being screwed to the backplate.

## Source

- Model by Nathan Litzinger (`@nlitz88_2513763` on Printables)
- [Jetson Orin Nano carrier with DIN rail mount](https://www.printables.com/model/1178594-jetson-orin-nano-carrier-with-din-rail-mount/files)

## Files

| File | What it is | Size (x, y, z mm) | Volume |
| --- | --- | --- | --- |
| `jetson-carrier-simple-lid-din-rail-mount-carrier-base.stl` | base the dev kit is screwed onto | 121.8 x 101.3 x 14 | 102 cm3 |
| `jetson-carrier-simple-lid-din-rail-mount-carrier-simple-lid.stl` | simple lid over the board | 121.8 x 101.3 x 5 | 16 cm3 |
| `jetson-carrier-simple-lid-din-rail-mount-m4-skinny-din-rail-mount.stl` | slim DIN rail clip, M4-mounted to the base | 18.1 x 74.9 x 15 | 8 cm3 |

The STL files are **not committed**: `smart-panel/panel/parts/**/*.stl` is in the `.gitignore` in the repo root.
Download them from the Printables link above and put them in this folder under the names in the table.

For a clip with M4 heat-insert holes, see `../Din rail clip/`.

## Mounting

1. Screw the dev kit onto the carrier base.
2. Mount the DIN rail clip on the back of the base with M4 screws.
3. Clip the whole thing onto the DIN rail in the panel (top left in `../../panel.scad`, where the Jetson sits).
4. Put the lid on.

Leave room around the heatsink fan and the USB/Ethernet ports for cables and airflow.

## Printing

- PETG or ASA is recommended over PLA: the Jetson gets warm and the panel can get hot in the sun.
- The clip has to flex, so print it with enough walls and keep it out of direct contact with the heatsink.
