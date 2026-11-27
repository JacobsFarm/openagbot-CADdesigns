# Jetson Orin Nano 8 GB dev kit carrier

Printed carrier for the NVIDIA Jetson Orin Nano 8 GB dev kit. With it, the Jetson clips onto the 35 mm DIN rail in
the panel instead of being screwed to the backplate.

There are two versions in this folder:

- **Own design** (`jetson_orin_nano_din_carrier.scad`): a solid base with a wide DIN clip held by 4x M4, and a vented
  lid held by 4x M4. Recommended, see below.
- **Original** from Printables (the `jetson-carrier-simple-lid-*` files), kept for reference.

## Own design: base + lid + wide DIN clip

Built like the simpleRTK 4 Dual and Arduino R4 back plates: a printed carrier that bolts onto the DIN clip with M4
heat inserts in the clip (`../Din rail clip/`).

### Files

| File | What it is |
| --- | --- |
| `jetson_orin_nano_din_carrier.scad` | OpenSCAD model of the base and the lid, with an assembly preview (committed) |
| `make_jetson_din_clip.py` | FreeCAD script that extrudes the profile of `../Din rail clip/dins_clip_m4_insert.step` to a 52 mm wide clip with 4 insert holes (committed) |
| `jetson_din_clip_w52.step` / `.stl` | the wide DIN clip (60 x 16 x 52 mm, 25.8 cm3), built by the script (not committed) |
| `jetson_carrier_base.stl` | base, ready to print (127 x 114.5 x 13.4 mm, 93 cm3) (not committed) |
| `jetson_carrier_lid.stl` | lid, ready to print upside down (127 x 114.5 x 35.5 mm, 99 cm3) (not committed) |
| `jetson_carrier_bracket.stl` | clamp bracket, a simpler alternative to the lid, ready to print upside down (127 x 114.5 x 8.4 mm, 34 cm3) (not committed) |

### Design

All sizes are measured from `../jetson_orin_nano_board.stl` (the dev kit with its plastic foot rim, 103 x 90.5 mm,
rim 4.9 mm below the PCB, fan top 29.9 mm above the PCB underside).

- **Base**: flat 9.5 mm floor with a pocket (0.5 mm clearance per side) that the plastic foot rim of the dev kit drops
  into. The side walls hold the rim 3.9 mm high, the wall on the port side is lower (2.9 mm) so plugs stay free.
  M4 heat inserts (Ø4.8) in the 4 corner towers for the lid. The insert holes go all the way through the base.
- **Air chamber**: inside the foot rim the floor is hollowed out down to a 2.5 mm skin. 9 ribs split the chamber into
  channels along Y (8.7 mm wide) that run under the foot rim and come out at the port side as a row of 5.5 mm high
  exits. The ribs stop 1 mm below the pocket floor, so air can also flow across. 4 slots (4 mm wide) in the skin,
  left and right of the clip, let air in from below. The foot rim keeps resting on solid floor all around.
- **DIN clip**: the profile of the M4 clip, 52 mm wide along the rail (about half the length of the dev kit), with
  4 M4 insert holes: 46 mm across the rail (same as the other clips) x 34 mm along the rail. It sits centred under the
  base and is bolted on with 4x **M4x10** from inside the pocket. The holes sit in the middle of a channel, so the
  heads (Ø7 x 4) stand on the bottom of the air chamber, completely under the dev kit. Each bolt goes 7.5 mm into the
  clip.
- **Lid**: a hood over the whole dev kit, 1.6 mm above the fan. 4 corner pillars with a Ø7.8 bore from the top: the
  **M4x10** head sits at the bottom of the pillar (4 mm of material under the head, 6 mm into the insert), the hex
  key goes in from above. A 45° clamping edge on 3 sides reaches 0.3 mm below the top of the foot rim
  (`shelf_gap = -0.3`). Tightening the 4 bolts presses the rim onto the base, so the dev kit is clamped between base
  and lid and does not rattle, also when the carrier hangs on its side. It does not need its own screws.
- **Clamp bracket** (alternative to the lid): a U-shaped frame, 8.4 mm thick, that sits on the base walls and grips
  the foot rim on the same 3 sides with the same 0.3 mm preload, held by the same 4x M4x10 (heads flush in Ø7.8
  counterbores). No hood, so the top of the dev kit stays open. The port side is open.
- **Ventilation**: honeycomb above the fan, 13 slots in each short end (the heatsink fins run along X, so the fan
  blows its air out at the short ends), 14 slots in the back wall, and the air chamber under the PCB with its exits at
  the port side.
- **Openings**: the port side (DC jack, DisplayPort, 4x USB-A, Ethernet, USB-C) is fully open up to 21.5 mm above the
  PCB underside, between the pillars. Above the 40-pin header there is a 9.5 x 55 mm slot in the top for a ribbon
  cable. "JETSON ORIN NANO" is engraved in the front above the ports.
- Total height without the clip 48.9 mm. The clip adds 16 mm, plus the rail.

A collision check of the base and the lid against `../jetson_orin_nano_board.stl` finds no overlap except the
intended 0.3 mm preload where the clamping edge presses on the foot rim.

### Hardware

- 8x M4 heat insert (4 in the clip, 4 in the base)
- 8x M4x10 hex socket bolt (4 clip to base, 4 lid to base)

### Assembly

1. Press the 4 M4 inserts into the clip and the 4 into the corner towers of the base.
2. Bolt the clip under the base with 4x M4x10 from inside the pocket (the heads go into the channels).
3. Put the dev kit in the pocket, ports towards the low wall.
4. Put the lid (or the clamp bracket) on and bolt it down with 4x M4x10.
5. Clip the whole thing onto the DIN rail. The release lip of the clip is on one of the long sides of the base; turn the
   clip 180° on the base if you want it on the other side (the hole pattern is symmetric).

### Printing

- PETG or ASA is recommended over PLA: the Jetson gets warm and the panel can get hot in the sun.
- Base: as exported, floor on the bed. No supports: the air chamber is open at the top, and the exits at the port
  side only need 8.7 mm bridges.
- Clamp bracket: as exported, top on the bed. The step for each bolt head needs a short bridge. No supports.
- Lid: as exported, top plate on the bed. The clamping edges are 45°, the vent slots and pillar bores only need short
  bridges. No supports.
- Clip: as exported, profile flat on the bed. 52 mm wide gives a stiffer spring than the 12 mm original (about 4.3x);
  lower `WIDTH` in `make_jetson_din_clip.py` if it snaps on too hard.
- The lid presses 0.3 mm on the foot rim (`shelf_gap = -0.3`), so it stops just short of the base walls when the
  bolts are tight. If it does not clamp firmly enough, add a thin strip of foam or rubber on the rim. Do not go
  below about -0.4, or the rim and the PCB start to bend.

### Rebuilding the STLs

STL files in `smart-panel/panel/parts/` are ignored by git. The OpenSCAD file needs a recent build (2025 or newer,
for `--backend=manifold`):

```
openscad --backend=manifold -D 'part="base"' -o jetson_carrier_base.stl jetson_orin_nano_din_carrier.scad
openscad --backend=manifold -D 'part="lid"' -o jetson_carrier_lid.stl jetson_orin_nano_din_carrier.scad
openscad --backend=manifold -D 'part="bracket"' -o jetson_carrier_bracket.stl jetson_orin_nano_din_carrier.scad
"C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_jetson_din_clip.py').read())"
```

Open the `.scad` without `part` set (or `part = "assembly"`) to see the base, the lid, the clip and the dev kit
together. `explode` lifts the lid, `cover = "bracket"` shows the clamp bracket instead of the lid. The preview needs `jetson_din_clip_w52.stl` and `../jetson_orin_nano_board.stl`.

## Original: Printables carrier

### Source

- Model by Nathan Litzinger (`@nlitz88_2513763` on Printables)
- [Jetson Orin Nano carrier with DIN rail mount](https://www.printables.com/model/1178594-jetson-orin-nano-carrier-with-din-rail-mount/files)

### Files

| File | What it is | Size (x, y, z mm) | Volume |
| --- | --- | --- | --- |
| `jetson-carrier-simple-lid-din-rail-mount-carrier-base.stl` | base the dev kit is screwed onto | 121.8 x 101.3 x 14 | 102 cm3 |
| `jetson-carrier-simple-lid-din-rail-mount-carrier-simple-lid.stl` | simple lid over the board | 121.8 x 101.3 x 5 | 16 cm3 |
| `jetson-carrier-simple-lid-din-rail-mount-m4-skinny-din-rail-mount.stl` | slim DIN rail clip, M4-mounted to the base | 18.1 x 74.9 x 15 | 8 cm3 |

The STL files are **not committed**: `smart-panel/panel/parts/**/*.stl` is in the `.gitignore` in the repo root.
Download them from the Printables link above and put them in this folder under the names in the table.

### Mounting

1. Screw the dev kit onto the carrier base.
2. Mount the DIN rail clip on the back of the base with M4 screws.
3. Clip the whole thing onto the DIN rail in the panel (top left in `../../panel.scad`, where the Jetson sits).
4. Put the lid on.

Leave room around the heatsink fan and the USB/Ethernet ports for cables and airflow.
