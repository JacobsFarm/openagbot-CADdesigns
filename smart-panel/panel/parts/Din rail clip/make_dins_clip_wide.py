# Bredere DIN-rail clip voor de back plates van de Arduino UNO R4 WiFi en de simpleRTK 4 Dual.
#
# Neemt het profiel van dins_clip_m4_insert.step (60 x 16 mm, 12 mm geextrudeerd), extrudeert het
# naar WIDTH mm en boort de twee M4 insert-gaten (x = +-23, pitch 46) opnieuw in het midden van de breedte.
# Pitch 46 past op de M4 gaten van arduino_uno_r4_wifi_backplate.scad en simplertk4_dual_backplate.scad.
#
# Draaien:
#   "C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_dins_clip_wide.py').read())"
# (vanuit deze map; FreeCADCmd met alleen een scriptpad blijft op Windows soms hangen)

import os
import FreeCAD as App
import Part
import Mesh

# Breedtes langs de rail (origineel 12 mm). Elke breedte geeft een eigen STEP + STL.
# 53.34 = PCB-breedte van de simpleRTK 4 Dual (en de Arduino UNO R4).
WIDTHS = [40.0, 53.34]
HOLE_X = 23.0           # Hart van de insert-gaten (+-), gelijk aan het origineel
HOLE_D = 4.8            # M4 heat insert
HOLE_DEPTH = 8.5        # Vanaf de bovenkant (y = 8)
TOP_Y = 8.0

here = os.path.dirname(os.path.abspath(__file__)) if "__file__" in globals() else os.getcwd()
src = os.path.join(here, "dins_clip_m4_insert.step")
shape = Part.Shape()
shape.read(src)

# Profiel = het platte vlak op z = 0 (de clip ligt in printorientatie, profiel in XY)
profile = [f for f in shape.Faces
           if f.Surface.__class__.__name__ == "Plane"
           and abs(f.BoundBox.ZMin) < 1e-6 and abs(f.BoundBox.ZMax) < 1e-6]
assert len(profile) == 1, "profielvlak op z = 0 niet gevonden"
profile = profile[0]

for WIDTH in WIDTHS:
    name = "dins_clip_m4_insert_w%d" % round(WIDTH)
    # Het vlak op z = 0 heeft de insert-gaten niet (die liggen op z = 3.6..8.4), dus het profiel is schoon.
    body = profile.extrude(App.Vector(0, 0, WIDTH))

    for x in (-HOLE_X, HOLE_X):
        hole = Part.makeCylinder(HOLE_D / 2, HOLE_DEPTH + 0.01,
                                 App.Vector(x, TOP_Y + 0.01, WIDTH / 2), App.Vector(0, -1, 0))
        body = body.cut(hole)

    body = body.removeSplitter()
    assert body.isValid() and len(body.Solids) == 1

    body.exportStep(os.path.join(here, name + ".step"))
    mesh = Mesh.Mesh()
    mesh.addFacets(body.tessellate(0.02))
    mesh.write(os.path.join(here, name + ".stl"))

    bb = body.BoundBox
    print("%s: %.1f x %.1f x %.1f mm, volume %.2f cm3" % (name, bb.XLength, bb.YLength, bb.ZLength, body.Volume / 1000))
