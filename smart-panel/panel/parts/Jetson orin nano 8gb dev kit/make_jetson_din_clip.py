# Brede DIN-rail clip voor de Jetson Orin Nano carrier (jetson_orin_nano_din_carrier.scad).
#
# Neemt het profiel van ../Din rail clip/dins_clip_m4_insert.step (60 x 16 mm), extrudeert het naar
# WIDTH mm langs de rail (ongeveer de helft van de 103 mm lange dev kit) en boort 4 M4 insert-gaten:
# 2 rijen (x = +-23, pitch 46 dwars op de rail, net als het origineel) x 2 posities langs de rail
# (z = WIDTH/2 +- ROW_PITCH/2). De carrier-basis zet de clip vast met 4x M4x10 inbus.
#
# Draaien (vanuit deze map):
#   "C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_jetson_din_clip.py').read())"

import os
import FreeCAD as App
import Part
import Mesh

WIDTH = 52.0        # Breedte langs de rail (origineel 12 mm)
ROW_PITCH = 34.0    # Hart-op-hart van de twee gatrijen langs de rail
HOLE_X = 23.0       # Hart van de insert-gaten dwars op de rail (+-), gelijk aan het origineel
HOLE_D = 4.8        # M4 heat insert (zelfde maat als de andere clips in het paneel)
HOLE_DEPTH = 8.5    # Vanaf de bovenkant (y = 8)
TOP_Y = 8.0
NAME = "jetson_din_clip_w%d" % round(WIDTH)

here = os.path.dirname(os.path.abspath(__file__)) if "__file__" in globals() else os.getcwd()
src = os.path.join(here, "..", "Din rail clip", "dins_clip_m4_insert.step")
shape = Part.Shape()
shape.read(src)

# Profiel = het platte vlak op z = 0 (de clip ligt in printorientatie, profiel in XY)
profile = [f for f in shape.Faces
           if f.Surface.__class__.__name__ == "Plane"
           and abs(f.BoundBox.ZMin) < 1e-6 and abs(f.BoundBox.ZMax) < 1e-6]
assert len(profile) == 1, "profielvlak op z = 0 niet gevonden"
body = profile[0].extrude(App.Vector(0, 0, WIDTH))

for z in (WIDTH / 2 - ROW_PITCH / 2, WIDTH / 2 + ROW_PITCH / 2):
    for x in (-HOLE_X, HOLE_X):
        hole = Part.makeCylinder(HOLE_D / 2, HOLE_DEPTH + 0.01,
                                 App.Vector(x, TOP_Y + 0.01, z), App.Vector(0, -1, 0))
        body = body.cut(hole)

body = body.removeSplitter()
assert body.isValid() and len(body.Solids) == 1

body.exportStep(os.path.join(here, NAME + ".step"))
mesh = Mesh.Mesh()
mesh.addFacets(body.tessellate(0.02))
mesh.write(os.path.join(here, NAME + ".stl"))

bb = body.BoundBox
print("%s: %.1f x %.1f x %.1f mm, volume %.2f cm3" % (NAME, bb.XLength, bb.YLength, bb.ZLength, body.Volume / 1000))
