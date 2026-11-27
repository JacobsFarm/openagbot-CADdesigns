# DIN-rail clip voor de Waveshare USB-HUB-4U (industriele 4-poorts USB hub, aluminium behuizing).
#
# De hub hangt op zijn zij aan de rail: de flens (onderkant van de hub) tegen de clip, de 4 USB-A poorten naar
# beneden en de USB-B / voedingsklem naar boven. De flens (86 x 45 mm, 2 mm dik) heeft 4 sleufgaten
# (3.6 mm breed, hart x = +-39.5, z = +-12.35 in het STEP-model), daar gaan 4x M3 doorheen in heat inserts
# in de bovenkant van de clip.
#
# Neemt het profiel van ../Din rail clip/dins_clip_m4_insert.step (60 x 16 mm), extrudeert het naar WIDTH mm
# langs de rail en legt er een extra plaat van TOP_EXTRA mm bovenop. Die is nodig omdat de M3-gaten dwars op de
# rail op +-12.35 liggen (vast door de hub), precies boven de holtes van het clipmechanisme waar het origineel maar
# 5 mm (y = 3..8) materiaal heeft. Met de extra plaat zit een blind insert-gat van HOLE_DEPTH mm volledig in
# massief materiaal.
#
# Assen in het resultaat (gelijk aan de andere clips, printorientatie):
#   x = dwars op de rail (60 mm, op het paneel verticaal; hub-as van USB-A naar USB-B)
#   y = van de rail af (rail-kant y = -8, bovenkant van de clip y = 8 + TOP_EXTRA)
#   z = langs de rail (0 .. WIDTH)
#
# Draaien (vanuit deze map):
#   "C:/Program Files/FreeCAD 1.1/bin/FreeCADCmd.exe" -c "exec(open(r'make_waveshare_din_clip.py').read())"

import os
import FreeCAD as App
import Part
import Mesh

WIDTH = 90.0        # Langs de rail: flens 86 mm + 2 mm rand per kant
TOP_EXTRA = 4.0     # Extra plaat bovenop het clipprofiel (bovenkant van y = 8 naar y = 12)
HOLE_ALONG = 39.5   # Hart van de M3 gaten langs de rail (+-), uit de flens van de hub
HOLE_ACROSS = 12.35 # Hart van de M3 gaten dwars op de rail (+-), midden van de sleufgaten
HOLE_D = 4.0        # M3 heat insert (zelfde maat als de VESC-plaat)
HOLE_DEPTH = 6.5    # Blind, vanaf de bovenkant; bodem op y = 5.5, 2.5 mm boven de holtes (y = 3)
TOP_Y = 8.0 + TOP_EXTRA
NAME = "waveshare_hub4u_din_clip"

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

# Extra plaat over de hele bovenkant (x = -30..30), iets in het profiel laten overlappen voor een schone fuse
slab = Part.makeBox(60.0, TOP_EXTRA + 0.5, WIDTH, App.Vector(-30.0, 7.5, 0))
body = body.fuse(slab)

for zc in (WIDTH / 2 - HOLE_ALONG, WIDTH / 2 + HOLE_ALONG):
    for x in (-HOLE_ACROSS, HOLE_ACROSS):
        hole = Part.makeCylinder(HOLE_D / 2, HOLE_DEPTH + 0.01,
                                 App.Vector(x, TOP_Y + 0.01, zc), App.Vector(0, -1, 0))
        body = body.cut(hole)

body = body.removeSplitter()
assert body.isValid() and len(body.Solids) == 1

body.exportStep(os.path.join(here, NAME + ".step"))
mesh = Mesh.Mesh()
mesh.addFacets(body.tessellate(0.02))
mesh.write(os.path.join(here, NAME + ".stl"))

bb = body.BoundBox
print("%s: %.1f x %.1f x %.1f mm, volume %.2f cm3" % (NAME, bb.XLength, bb.YLength, bb.ZLength, body.Volume / 1000))

# Controle: hub op de clip zetten en op botsingen testen (alleen als het STEP-model van de hub er is).
hub_path = os.path.join(here, "USB-UHB-4U Waveshare.STEP")
if os.path.exists(hub_path):
    hub = Part.Shape()
    hub.read(hub_path)
    # Losse kabelstekker in het model (ver buiten de hub, z < -95) niet meenemen
    parts = [s for s in hub.Solids if s.BoundBox.ZMin > -50]
    hub = Part.makeCompound(parts)
    # Hub: x langs flens (86), y = 0 flensonderkant, z = USB-A (-) naar USB-B (+).
    # Op de clip: hub-z -> clip-x (dwars), hub-x -> clip-z (langs de rail), hub-y -> clip-y (van de rail af).
    # Rotatie (det = +1): clip-x = hub-z, clip-y = hub-y + TOP_Y, clip-z = WIDTH/2 - hub-x
    m = App.Matrix(0, 0, 1, 0,
                   0, 1, 0, TOP_Y,
                   -1, 0, 0, WIDTH / 2,
                   0, 0, 0, 1)
    hub_placed = hub.transformGeometry(m)
    hb = hub_placed.BoundBox
    print("hub op clip: x %.1f..%.1f  y %.1f..%.1f  z %.1f..%.1f" % (hb.XMin, hb.XMax, hb.YMin, hb.YMax, hb.ZMin, hb.ZMax))
    overlap = sum(body.common(s).Volume for s in hub_placed.Solids)
    print("overlap clip/hub: %.3f mm3" % overlap)
    # Sleufgaten van de flens moeten boven de insert-gaten liggen
    for sx in (-39.5, 39.5):
        for sz in (-12.35, 12.35):
            v = m.multiply(App.Vector(sx, 0, sz))
            print("sleufgat hub (%.2f, %.2f) -> clip x %.2f z %.2f" % (sx, sz, v.x, v.z))
    # Hub mee exporteren als STL (vorm zoals in het STEP-model, zonder de losse kabelstekker)
    hm = Mesh.Mesh()
    hm.addFacets(hub.tessellate(0.05))
    hm.write(os.path.join(here, "waveshare_usb_hub_4u.stl"))
    hb0 = hub.BoundBox
    print("hub stl: %.1f x %.1f x %.1f mm, min (%.1f, %.1f, %.1f)"
          % (hb0.XLength, hb0.YLength, hb0.ZLength, hb0.XMin, hb0.YMin, hb0.ZMin))
