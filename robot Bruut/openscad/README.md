# Bruut OpenAgbot - OpenSCAD design

Parametric OpenSCAD design of robot Bruut. All dimensions are in millimetres and come from one file,
`config/parameters.scad`. Open `main_assembly_2wd.scad` or `main_assembly_4wd.scad` in OpenSCAD to see the robot.

## Architecture

Hierarchical parametric design with English `snake_case` names.

```
config  ->  parts  ->  assemblies  ->  main_assembly_*.scad
```

Each level only uses the level before it. `config` feeds `parts`, `parts` feed `assemblies`, and `assemblies` feed
the main assemblies, which are the root entry points.

## Folders

| Folder | Contents |
| --- | --- |
| `config/` | The central variables and settings, loaded by every other file in the project. |
| `parts/` | The geometry of each physical part (plates and beams). The `difference` logic for bolt holes lives here. |
| `assemblies/` | Combines parts into functional groups, such as a complete wheel unit or the chassis frame. |
| `templates/` | Drill templates and drill bushings, 3D-printable jigs for drilling the real parts. |
| `imports/` | External STL models (hub motor, tyre, reducer). Not all STLs are in git, see `imports/notes.txt`. |
| `accessories/` | Mounts for add-ons: Daheng camera and USB2CAN converter. |

## Files

| File | Responsibility |
| --- | --- |
| `config/parameters.scad` | Single source of truth for all dimensions: width, length, bolt diameters, drill patterns. |
| `parts/bracket_side_plate.scad` | Vertical axle holder for the motor bracket (laser-cut). |
| `parts/bracket_top_plate.scad` | Horizontal mounting plate for the wheel module (laser-cut). |
| `parts/chassis_beam_1.scad`, `chassis_beam_2.scad` | Steel hollow profiles with pre-calculated drill patterns for assembly. |
| `parts/main_base_plate.scad` | Primary connecting plate for the upper structure (laser-cut). |
| `parts/upright_wall.scad` | Vertical side walls including structural reinforcements (hulls). |
| `parts/protection_cover.scad` | Outer protective shell that covers the electronics and mechanical parts. |
| `assemblies/wheel_unit_asm.scad` | Hub motor with the top and side plates of the mounting bracket. |
| `assemblies/chassis_frame_asm.scad` | Beams, base plate and covers as the main structural frame. |
| `assemblies/chassis_beam_construct_asm.scad` | Chassis beams with the bracket top plates. |
| `assemblies/caster_wheel_asm.scad` | Caster wheel for the 2WD variant. |
| `main_assembly_2wd.scad`, `main_assembly_4wd.scad` | Visualisation: positions the wheel modules and the frame in 3D space. |

## Design rules

- Put `include <../config/parameters.scad>` at the top of every sub-file.
- Model every part centred (`center=true`) so symmetry and mirroring stay easy.
- Never hardcode dimensions. Derive everything from the variables in `parameters.scad`.
- Parts intended for DXF export sit exactly at Z=0 within their local module.

The full coding standards for contributors and AI assistants are in the repository's `AGENTS.md`.
