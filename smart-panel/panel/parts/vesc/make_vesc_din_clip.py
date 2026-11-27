# DIN-rail houder voor 1 VESC Classic 100 V, in 1 printdeel: clip + plaat + randjes.
#
# De VESC hangt met zijn lengte dwars op de rail (op het paneel verticaal, draden naar boven of naar beneden) en
# ligt plat op een plaat die op het clipprofiel vast zit. Hij gaat vast met M3 bouten in heat inserts in de plaat.
# Aan beide korte kanten (op het paneel boven en onder) staat een randje, de VESC past daar tussen.
# Langs de rail is de houder aan beide kanten MARGIN mm breder dan de VESC, zodat VESC's die met hun houders
# tegen elkaar op de rail zitten elkaar niet raken (2 x MARGIN tussenruimte).
#
# Neemt het profiel van ../Din rail clip/dins_clip_m4_insert.step (60 x 16 mm) en extrudeert het over de hele
# breedte van de houder (WIDTH mm langs de rail), net als make_waveshare_din_clip.py.
#
# Maten van de VESC gemeten aan vesc_classic.stl (zelfde getallen als vesc_mount_plate.scad):
#   voet 99.8 lang (incl. 0.45 mm eindkap aan de draadkant) x 47.5 breed
#   2x M3 gat (Ø3.2 in de voet) op de diagonaal, hart-op-hart 93.7 in de lengte x 41.4 in de breedte,
#   precies in het midden van de voet. De draden komen pas 4.1 mm boven de onderkant van de voet uit de kast.
#
# Assen in het resultaat (gelijk aan de andere clips, printorientatie):
#   x = dwars op de rail (op het paneel verticaal) = lengte van de VESC
#   y = van de rail af (rail-kant y = -8, bovenkant clipprofiel y = 8, VESC ligt op y = PLATE_TOP)
#   z = langs de rail (0 .. WIDTH)
#
# Draaien (vanuit deze map):
#   "C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_vesc_din_clip.py').read())"

import os
import FreeCAD as App
import Part
import Mesh

# --- VESC Classic ---
VESC_LEN = 99.8         # Lengte van de voet (x)
VESC_WID = 47.5         # Breedte van de voet (langs de rail)
HOLE_DX = 93.7          # Hart-op-hart M3 in de lengte
HOLE_DY = 41.4          # Hart-op-hart M3 in de breedte
ALL_FOUR = True         # True = gaten op beide diagonalen (dan maakt het niet uit welke diagonaal jouw VESC heeft)

# --- Houder ---
MARGIN = 3.0            # Langs de rail: per kant breder dan de VESC
CLEAR = 0.5             # Speling per kant tussen de VESC en de randjes
PLATE_T = 6.0           # Dikte van de plaat bovenop het clipprofiel (genoeg voor een M3 heat insert)
RIM_T = 3.0             # Dikte van de randjes (in x)
RIM_H = 3.0             # Hoogte van de randjes boven de plaat; onder de draaduitgang (4.1 mm) blijven
HOLE_D = 4.0            # M3 heat insert (zelfde maat als de VESC-plaat), doorlopend door de plaat
NAME = "vesc_din_clip"

WIDTH = VESC_WID + 2 * MARGIN           # Langs de rail
IN_HALF = VESC_LEN / 2 + CLEAR          # Binnenkant randje, vanaf het midden
OUT_HALF = IN_HALF + RIM_T              # Buitenkant randje / plaat
PLATE_BOT = 8.0                         # Bovenkant van het clipprofiel
PLATE_TOP = PLATE_BOT + PLATE_T
RIM_TOP = PLATE_TOP + RIM_H

here = os.path.dirname(os.path.abspath(__file__)) if "__file__" in globals() else os.getcwd()
src = os.path.join(here, "..", "Din rail clip", "dins_clip_m4_insert.step")
shape = Part.Shape()
shape.read(src)

# Profiel = het platte vlak op z = 0 (de clip ligt in printorientatie, profiel in XY).
# Het vlak op z = 0 heeft de M4 insert-gaten van de originele clip niet, dus het profiel is schoon.
profile = [f for f in shape.Faces
           if f.Surface.__class__.__name__ == "Plane"
           and abs(f.BoundBox.ZMin) < 1e-6 and abs(f.BoundBox.ZMax) < 1e-6]
assert len(profile) == 1, "profielvlak op z = 0 niet gevonden"
body = profile[0].extrude(App.Vector(0, 0, WIDTH))

# Plaat over de hele lengte van de VESC + randjes, iets in het profiel laten overlappen voor een schone fuse
plate = Part.makeBox(2 * OUT_HALF, PLATE_T + 0.5, WIDTH, App.Vector(-OUT_HALF, PLATE_BOT - 0.5, 0))
body = body.fuse(plate)

# Randjes aan beide korte kanten van de VESC, over de hele breedte
for x0 in (-OUT_HALF, IN_HALF):
    rim = Part.makeBox(RIM_T, RIM_H + 0.5, WIDTH, App.Vector(x0, PLATE_TOP - 0.5, 0))
    body = body.fuse(rim)

# M3 insert-gaten, doorlopend door de plaat (ze liggen buiten het clipprofiel, |x| = 46.85 > 30)
holes = [(-HOLE_DX / 2, -HOLE_DY / 2), (HOLE_DX / 2, HOLE_DY / 2)]
if ALL_FOUR:
    holes += [(-HOLE_DX / 2, HOLE_DY / 2), (HOLE_DX / 2, -HOLE_DY / 2)]
for hx, hz in holes:
    assert abs(hx) - HOLE_D / 2 > 30.0, "M3 gat raakt het clipprofiel"
    hole = Part.makeCylinder(HOLE_D / 2, PLATE_T + 1.0,
                             App.Vector(hx, PLATE_TOP + 0.5, WIDTH / 2 + hz), App.Vector(0, -1, 0))
    body = body.cut(hole)

body = body.removeSplitter()
assert body.isValid() and len(body.Solids) == 1

body.exportStep(os.path.join(here, NAME + ".step"))
mesh = Mesh.Mesh()
mesh.addFacets(body.tessellate(0.02))
mesh.write(os.path.join(here, NAME + ".stl"))

bb = body.BoundBox
print("%s: %.1f x %.1f x %.1f mm, volume %.2f cm3" % (NAME, bb.XLength, bb.YLength, bb.ZLength, body.Volume / 1000))
print("binnenmaat tussen de randjes %.1f mm, plaat y = %.1f..%.1f, randjes tot y = %.1f"
      % (2 * IN_HALF, PLATE_BOT, PLATE_TOP, RIM_TOP))

# Controle: VESC op de houder zetten (alleen als vesc_classic.stl er is).
# In de STL: voet x = -50.55..49.25 (draden naar -x), y = -23.75..23.75, onderkant z = -4,
# M3 gaten (Ø3.2) op (-47.5, -20.7) en (46.2, 20.7).
# Op de houder (det = +1): x = sx + 0.65, y = sz + 4 + PLATE_TOP, z = WIDTH/2 - sy
vesc_path = os.path.join(here, "vesc_classic.stl")
if os.path.exists(vesc_path):
    m = App.Matrix(1, 0, 0, 0.65,
                   0, 0, 1, 4 + PLATE_TOP,
                   0, -1, 0, WIDTH / 2,
                   0, 0, 0, 1)
    vesc = Mesh.Mesh(vesc_path)
    vesc.transform(m)
    pts = [p for p in vesc.Points]
    low = [p for p in pts if p.y < RIM_TOP + 0.01]        # alles van de VESC op randhoogte
    xs = [p.x for p in low]
    zs = [p.z for p in pts]
    print("VESC op randhoogte: x %.2f..%.2f (randjes binnen +-%.2f)" % (min(xs), max(xs), IN_HALF))
    print("VESC langs de rail: z %.2f..%.2f (houder 0..%.1f, naastliggende VESC %.1f mm verder)"
          % (min(zs), max(zs), WIDTH, 2 * MARGIN))
    print("VESC onderkant y = %.2f (plaat %.2f)" % (min(p.y for p in pts), PLATE_TOP))
    wires = [p for p in pts if p.x < -IN_HALF - RIM_T]   # de draden, buiten de houder
    print("draden: laagste punt y = %.2f (randje tot %.2f)" % (min(p.y for p in wires), RIM_TOP))
    for sx, sy in ((-47.5, -20.7), (46.2, 20.7)):
        v = m.multiply(App.Vector(sx, sy, -4))
        d = min(((v.x - hx) ** 2 + (v.z - WIDTH / 2 - hz) ** 2) ** 0.5 for hx, hz in holes)
        print("M3 gat VESC (%.1f, %.1f) -> houder x %.2f z %.2f, afstand tot insert-gat %.3f mm" % (sx, sy, v.x, v.z, d))
    # VESC in houder-coordinaten mee exporteren, handig om samen te bekijken
    vesc.write(os.path.join(here, NAME + "_with_vesc_preview.stl"))
