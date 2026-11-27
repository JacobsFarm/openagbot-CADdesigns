// DIN-rail carrier voor de NVIDIA Jetson Orin Nano 8 GB dev kit: basis + deksel + brede DIN-clip.
//
// - Basis: dikke vlakke bodem met een kom waar de plastic voetrand van de dev kit precies in valt.
//   Onder de PCB zit een luchtkamer met kanalen langs Y die aan de poortzijde onder de voetrand door
//   naar buiten komen, plus sleuven in de bodemhuid.
//   Onderop zit de brede DIN-clip (jetson_din_clip_w52.stl, ongeveer de helft van de kit lang),
//   vastgezet met 4x M4x10 inbus vanuit de kom. De koppen staan op de bodem van de luchtkamer,
//   helemaal onder de dev kit. In de 4 hoektorens zitten M4 heat inserts voor het deksel.
// - Deksel: kap over de hele kit met 4 hoekpilaren (M4x10 inbus van bovenaf door een diepe boring,
//   kop zit onderin de pilaar). Een schuine klemrand drukt de voetrand van de kit op 3 zijden
//   omlaag, dus de kit zelf hoeft niet geschroefd te worden.
//   Ventilatie: honingraat boven de koelventilator, sleuven in de twee kopse kanten (daar blaast de
//   koeler zijn lucht uit, de vinnen lopen langs X) en in de achterwand, en sleuven in de bodem.
//   De poortzijde (DC, DP, USB, Ethernet, USB-C) is helemaal open, boven de 40-pin header zit een
//   sleuf in de bovenkant voor een flatcable.
// - Klembeugel (part = "bracket"): versimpeld alternatief voor het deksel, alleen een U-vormig raam
//   dat de voetrand met dezelfde 4 bouten vastdrukt. Geen kap, de bovenkant van de kit blijft vrij.
//
// Assen = assen van ../jetson_orin_nano_board.stl: X = lange kant (103 mm), Y = 90.5 mm met de
// poorten aan de -Y kant, Z = omhoog met de PCB-onderkant op z = 0 en de onderkant van de voetrand op z = -4.9.
// De DIN-rail loopt langs X.
//
// Exporteren (vanuit deze map), STL's liggen dan al in printorientatie:
//   openscad --backend=manifold -D 'part="base"' -o jetson_carrier_base.stl jetson_orin_nano_din_carrier.scad
//   openscad --backend=manifold -D 'part="lid"' -o jetson_carrier_lid.stl  jetson_orin_nano_din_carrier.scad
//   openscad --backend=manifold -D 'part="bracket"' -o jetson_carrier_bracket.stl jetson_orin_nano_din_carrier.scad

// --- Render Options ---
part       = "assembly";   // "assembly", "base", "lid", "bracket", "base_asm", "lid_asm", "bracket_asm" (_asm = in kit-coordinaten, voor botsingscontrole)
cover      = "lid";        // Wat er in de assembly op de basis zit: "lid" (kap) of "bracket" (alleen klembeugel)
show_board = true;         // Dev kit als spook in de assembly (../jetson_orin_nano_board.stl)
show_clip  = true;         // DIN-clip in de assembly (jetson_din_clip_w52.stl, uit make_jetson_din_clip.py)
show_lid   = true;
explode    = 0;            // Deksel zoveel mm omhoog in de assembly

// --- Dev kit (gemeten aan jetson_orin_nano_board.stl) ---
kit_x0 = -5.5;  kit_x1 = 97.5;     // Buitenmaat van de plastic voetrand (103 x 90.5)
kit_y0 = -18.5; kit_y1 = 72.0;
kit_zb   = -4.9;                   // Onderkant voetrand (staat op de bodem van de kom)
kit_rim_top = 1.6;                 // Bovenkant voetrand = bovenkant PCB
kit_rim_w   = 1.2;                 // Breedte van de voetrand waar de klemrand op drukt
kit_h_max   = 29.87;               // Bovenkant koelventilator
fan_c       = [44, 42];            // Hart van de ventilator (Ø37)
hs_box      = [15, 22.5, 73, 61.5];// Koelblok x0, y0, x1, y1
header_box  = [90, 3.5, 94.5, 54.5]; // 40-pin header x0, y0, x1, y1
port_top    = 18.5;                // Hoogste poort (USB-stapel)

// --- Passing ---
clr      = 0.5;                    // Speling rondom de voetrand in de kom
pocket_r = 1.5;                    // Hoekradius van de kom

// --- M4 (alles M4x10 inbus, kop Ø7 x 4) ---
insert_D     = 4.8;                // Gat voor M4 heat insert (zelfde maat als de andere DIN-clips)
insert_depth = 8.5;
m4_D         = 4.5;                // Doorgaand gat
head_D       = 7.8;                // Verzinking / boring voor de kop (kop Ø7)
head_h       = 4.4;                // Diepte van de verzinking (kop 4 mm)

// --- Basis ---
z_bot     = -14.4;                 // Onderkant basis (vlak, ligt op het printbed)
z_wall    = -1.0;                  // Bovenkant zijwanden = onderkant deksel
z_front   = -2.0;                  // Bovenkant van de lage wand aan de poortzijde
front_wall = 2.5;                  // Dikte van die lage wand
tower_off = 5.5;                   // Hart hoektoren vanaf de hoek van de kom (x en y)
tower_r   = 6;                     // Straal hoektoren / deksel-pilaar
fillet    = 3;                     // Afronding van de binnenhoeken aan de poortzijde

// Luchtkamer in de bodem onder de PCB: kanalen langs Y die aan de poortzijde naar buiten komen
skin       = 2.5;                  // Bodemhuid onder de luchtkamer (hier zit de clip tegen)
plen       = [-2.5, -15.5, 94.5, 69.5]; // Luchtkamer x0, y0, x1, y1 (binnen de voetrand, die blijft rondom steunen)
rib_w      = 2.6;                  // Ribben tussen de kanalen
rib_drop   = 1;                    // Ribben zoveel onder de kombodem (lucht kan ook dwars stromen)
roof       = 1.5;                  // Dak boven de uitlaten aan de voorkant (daar staat de voetrand op)

// Bodemsleuven (in de kanalen links en rechts van de clip)
floor_slot_w = 4;
floor_slot_y = [-12, 62];

// --- DIN-clip (zie make_jetson_din_clip.py) ---
clip_W   = 52;                     // Breedte langs de rail
clip_row = 34;                     // Gatrijen langs de rail, hart-op-hart
clip_hx  = 23;                     // Gaten dwars op de rail (+-)
clip_top = 8;                      // Bovenvlak van het clipprofiel (y in de clip-STL)
clip_c   = [(kit_x0 + kit_x1) / 2, (kit_y0 + kit_y1) / 2];

// --- Deksel ---
lid_wall   = 3.5;                  // Wanddikte
top_t      = 3;                    // Dikte bovenplaat
z_lid_in   = kit_h_max + 1.6;      // Binnenkant bovenplaat (1.6 mm boven de ventilator)
z_lid_top  = z_lid_in + top_t;
pillar_floor = 4;                  // Materiaal onder de boutkop in de pilaar
front_open = port_top + 3;         // Poortzijde open tot deze hoogte
shelf_gap  = -0.3;                 // Klemrand t.o.v. de voetrand: negatief = zoveel voorspanning (bouten drukken de kit vast)
shelf_t    = 1.5;                  // Dikte van de klemrand aan de binnenkant (daarboven 45 graden naar de wand)

// Ventilatiesleuven in de wanden
vent_w     = 3.2;
vent_pitch = 6.5;
vent_z     = [15, 29];

// Honingraat in de bovenplaat
hex_r    = 3.4;                    // Omgeschreven straal van een zeshoek
hex_wall = 1.6;
hex_area = [10, 18, 78, 66];       // x0, y0, x1, y1 (rond de ventilator / het koelblok)

// --- Klembeugel (versimpeld deksel: alleen een U-vormig raam dat de voetrand vastdrukt) ---
br_top    = z_wall + pillar_floor + head_h;  // Bovenkant beugel: boutkop valt precies verzonken
br_r      = 2;                 // Hoekradius van de opening boven de PCB

header_slot = [87.5, 1.5, 97, 56.5]; // Sleuf boven de 40-pin header (flatcable)

label = "JETSON ORIN NANO";

$fn = 48;

// --- Derived ---
px0 = kit_x0 - clr; px1 = kit_x1 + clr;
py0 = kit_y0 - clr; py1 = kit_y1 + clr;
tx = [px0 - tower_off, px1 + tower_off];
ty = [py0 - tower_off, py1 + tower_off];
ox0 = tx[0] - tower_r; ox1 = tx[1] + tower_r;     // Buitenmaat
oy0 = ty[0] - tower_r; oy1 = ty[1] + tower_r;
fx0 = tx[0] + tower_r; fx1 = tx[1] - tower_r;     // Poortzijde tussen de torens
shelf_z = kit_rim_top + shelf_gap;
clip_holes = [for (a = [-1, 1], b = [-1, 1]) [clip_c[0] + a * clip_row / 2, clip_c[1] + b * clip_hx]];
// Kanalen zo verdeeld dat de 4 clipbouten midden in een kanaal zitten (kop op de bodem van de kamer)
z_plen    = z_bot + skin;
rib_top   = kit_zb - rib_drop;
z_exit    = kit_zb - roof;
chan_p    = clip_row / 3;
chan_x    = clip_c[0] - clip_row / 2;               // Hart van een kanaal (clipbout)
ribs      = [for (k = [-6 : 6]) let (x = chan_x + (k + 0.5) * chan_p)
                 if (x - rib_w / 2 > plen[0] + 1 && x + rib_w / 2 < plen[2] - 1) x];
floor_slot_x = [for (k = [-6 : 6]) let (x = chan_x + k * chan_p)
                 if (x - floor_slot_w / 2 > plen[0] && x + floor_slot_w / 2 < plen[2]
                     && abs(x - clip_c[0]) > clip_W / 2 + floor_slot_w / 2 + 0.3) x];

echo(str("Buitenmaat ", ox1 - ox0, " x ", oy1 - oy0, " mm, basis ", z_wall - z_bot,
         " mm hoog, deksel ", z_lid_top - z_wall, " mm, totaal ", z_lid_top - z_bot, " mm (zonder clip)"));
echo(str("Clipbout: ", 10 - skin, " mm in de clip, kanaal ", chan_p - rib_w, " mm breed, uitlaat ",
         z_exit - z_plen, " mm hoog, dekselbout: ",
         10 - pillar_floor, " mm in de insert"));

// ================= 2D =================
module outline() hull() for (x = tx, y = ty) translate([x, y]) circle(r = tower_r);

module pocket_2d()
    translate([px0 + pocket_r, py0 + pocket_r])
        offset(r = pocket_r) square([px1 - px0 - 2 * pocket_r, py1 - py0 - 2 * pocket_r]);

// Strook aan de poortzijde tussen de torens (laag in de basis, open in het deksel)
module front_band_2d() translate([fx0, oy0 - 1]) square([fx1 - fx0, py0 - oy0 + 1]);

// Basis: buitenmaat met de poortzijde ingekort tot de lage wand, binnenhoeken afgerond
module base_2d()
    offset(r = -fillet) offset(delta = fillet)
        difference() {
            outline();
            translate([fx0, oy0 - 1]) square([fx1 - fx0, py0 - front_wall - oy0 + 1]);
        }

// Kanalen tussen de ribben over y0..y1
module chan_2d(y0, y1)
    difference() {
        translate([plen[0], y0]) square([plen[2] - plen[0], y1 - y0]);
        for (x = ribs) translate([x - rib_w / 2, y0 - 1]) square([rib_w, y1 - y0 + 2]);
    }

module slot_2d(p0, p1, w) hull() { translate(p0) circle(d = w); translate(p1) circle(d = w); }

module hex_grid_2d() {
    s  = 2 * hex_r * cos(30) + hex_wall;    // Afstand tussen buren in een rij
    dy = s * sqrt(3) / 2;
    for (j = [0 : floor((hex_area[3] - hex_area[1]) / dy)])
        for (i = [-1 : ceil((hex_area[2] - hex_area[0]) / s)]) {
            x = hex_area[0] + i * s + (j % 2) * s / 2;
            y = hex_area[1] + j * dy;
            if (x - hex_r >= hex_area[0] && x + hex_r <= hex_area[2] && y + hex_r <= hex_area[3])
                translate([x, y]) rotate(30) circle(r = hex_r, $fn = 6);
        }
}

// ================= Basis =================
module base() {
    difference() {
        union() {
            translate([0, 0, z_bot]) linear_extrude(z_wall - z_bot) base_2d();
        }
        // Poortzijde: lage wand
        translate([0, 0, z_front]) linear_extrude(10) front_band_2d();
        // Kom voor de voetrand van de dev kit
        translate([0, 0, kit_zb]) linear_extrude(20) pocket_2d();
        // Luchtkamer: kanalen tussen de ribben, daarboven helemaal open tot de kombodem
        translate([0, 0, z_plen]) linear_extrude(rib_top - z_plen) chan_2d(plen[1], plen[3]);
        translate([0, 0, rib_top]) linear_extrude(kit_zb - rib_top + 1)
            translate([plen[0], plen[1]]) square([plen[2] - plen[0], plen[3] - plen[1]]);
        // Uitlaten aan de poortzijde: de kanalen lopen onder de voetrand door naar de voorkant
        translate([0, 0, z_plen]) linear_extrude(z_exit - z_plen) chan_2d(oy0 - 1, plen[1] + 1);
        // DIN-clip: 4x M4x10, kop op de bodem van de luchtkamer (onder de dev kit)
        for (h = clip_holes) translate([h[0], h[1], z_bot - 1]) cylinder(d = m4_D, h = skin + 2);
        // Heat inserts voor het deksel in de hoektorens (gat helemaal door)
        for (x = tx, y = ty) translate([x, y, z_bot - 1]) cylinder(d = insert_D, h = z_wall - z_bot + 2);
        // Ventilatiesleuven in de bodemhuid (in de kanalen naast de clip)
        translate([0, 0, z_bot - 1]) linear_extrude(skin + 2)
            for (x = floor_slot_x) slot_2d([x, floor_slot_y[0]], [x, floor_slot_y[1]], floor_slot_w);
    }
}

// ================= Deksel =================
// Klemrand langs een zijde: profiel in (n, z), n = afstand vanaf de buitenkant naar binnen.
module shelf_profile(n_in)
    polygon([[1, shelf_z], [n_in, shelf_z], [n_in, shelf_z + shelf_t],
             [lid_wall, shelf_z + shelf_t + (n_in - lid_wall)], [1, shelf_z + shelf_t + (n_in - lid_wall)]]);

module shelves() {
    // -X zijde
    translate([ox0, ty[0], 0]) rotate([90, 0, 0]) mirror([0, 0, 1])
        linear_extrude(ty[1] - ty[0]) shelf_profile(kit_x0 + kit_rim_w - ox0);
    // +X zijde
    translate([ox1, ty[0], 0]) mirror([1, 0, 0]) rotate([90, 0, 0]) mirror([0, 0, 1])
        linear_extrude(ty[1] - ty[0]) shelf_profile(ox1 - (kit_x1 - kit_rim_w));
    // +Y zijde (achterkant)
    translate([tx[0], oy1, 0]) rotate([90, 0, 90])
        linear_extrude(tx[1] - tx[0]) mirror([1, 0]) shelf_profile(oy1 - (kit_y1 - kit_rim_w));
}

module vent_slots_x(x) // sleuven door een kopse wand (normaal = X)
    for (y = [-12 : vent_pitch : 66])
        translate([x, y, 0]) rotate([0, 90, 0])
            linear_extrude(lid_wall + 2, center = true) slot_2d([-vent_z[0], 0], [-vent_z[1], 0], vent_w);

module vent_slots_y(y) // sleuven door de achterwand (normaal = Y)
    for (x = [2 : vent_pitch : 91])
        translate([x, y, 0]) rotate([90, 0, 0])
            linear_extrude(lid_wall + 2, center = true) slot_2d([0, vent_z[0]], [0, vent_z[1]], vent_w);

module lid() {
    difference() {
        union() {
            // Kap: wanden + bovenplaat
            difference() {
                translate([0, 0, z_wall]) linear_extrude(z_lid_top - z_wall) outline();
                translate([0, 0, z_wall - 1]) linear_extrude(z_lid_in - z_wall + 1) offset(r = -lid_wall) outline();
            }
            // Pilaren in de hoeken
            for (x = tx, y = ty) translate([x, y, z_wall]) cylinder(r = tower_r - 0.3, h = z_lid_top - z_wall);  // net binnen de buitenmaat (geen samenvallende vlakken)
            // Onderband op de zijwanden van de basis (niet aan de poortzijde)
            translate([0, 0, z_wall]) linear_extrude(shelf_z + shelf_t / 2 - z_wall)
                difference() { outline(); pocket_2d(); front_band_2d(); }
            // Klemranden op de voetrand
            shelves();
        }
        // Poortzijde open tussen de pilaren
        translate([fx0, oy0 - 1, z_wall - 1]) cube([fx1 - fx0, py0 - oy0 + 1 + 0.01, front_open - z_wall + 1]);
        // Boringen voor M4x10: kop onderin de pilaar, sleutel van bovenaf
        for (x = tx, y = ty) translate([x, y, 0]) {
            translate([0, 0, z_wall - 1]) cylinder(d = m4_D, h = pillar_floor + 2);
            translate([0, 0, z_wall + pillar_floor]) cylinder(d = head_D, h = z_lid_top - z_wall);
        }
        // Honingraat boven de ventilator
        translate([0, 0, z_lid_in - 1]) linear_extrude(top_t + 2) hex_grid_2d();
        // Sleuf boven de 40-pin header
        translate([0, 0, z_lid_in - 1]) linear_extrude(top_t + 2)
            translate([header_slot[0] + 2, header_slot[1] + 2])
                offset(r = 2) square([header_slot[2] - header_slot[0] - 4, header_slot[3] - header_slot[1] - 4]);
        // Ventilatie in de kopse kanten en de achterwand
        vent_slots_x(ox0 + lid_wall / 2);
        vent_slots_x(ox1 - lid_wall / 2);
        vent_slots_y(oy1 - lid_wall / 2);
        // Tekst in de voorkant (boven de poorten)
        translate([(ox0 + ox1) / 2, oy0 + 0.6, (front_open + z_lid_top) / 2]) rotate([90, 0, 0])
            linear_extrude(1) text(label, size = 5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
}

// ================= Klembeugel =================
// Zelfde voet, bouten en klemming als het deksel, maar zonder kap: een U-vormig raam over de wanden
// van de basis dat aan 3 zijden over de voetrand grijpt. De poortzijde is open.
module bracket_opening_2d()   // boven de PCB: tot de binnenkant van de voetrand, naar voren open
    translate([kit_x0 + kit_rim_w + br_r, kit_y0 - 20 + br_r])
        offset(r = br_r) square([kit_x1 - kit_x0 - 2 * kit_rim_w - 2 * br_r, kit_y1 - kit_y0 - kit_rim_w + 20 - 2 * br_r]);

module bracket() {
    difference() {
        union() {
            // Op de wanden van de basis
            translate([0, 0, z_wall]) linear_extrude(br_top - z_wall)
                difference() { outline(); pocket_2d(); front_band_2d(); }
            // Over de voetrand (klemvlak op shelf_z)
            translate([0, 0, shelf_z]) linear_extrude(br_top - shelf_z)
                difference() { outline(); bracket_opening_2d(); front_band_2d(); }
        }
        // M4x10: kop verzonken, 4 mm materiaal onder de kop
        for (x = tx, y = ty) translate([x, y, 0]) {
            translate([0, 0, z_wall - 1]) cylinder(d = m4_D, h = pillar_floor + 2);
            translate([0, 0, z_wall + pillar_floor]) cylinder(d = head_D, h = br_top);
        }
    }
}

// ================= Clip / board =================
// Clip-STL: profiel in XY (x dwars op de rail, bovenvlak y = 8 met de inserts), z langs de rail.
// Hier: clip-x -> kit-Y, clip-y -> kit-Z, clip-z -> kit-X, bovenvlak tegen de onderkant van de basis.
module clip_placed()
    multmatrix([[0, 0, 1, clip_c[0] - clip_W / 2],
                [1, 0, 0, clip_c[1]],
                [0, 1, 0, z_bot - clip_top],
                [0, 0, 0, 1]])
        import("jetson_din_clip_w52.stl");

module board_ghost() import("../jetson_orin_nano_board.stl");

// ================= Execution =================
if (part == "base") translate([0, 0, -z_bot]) base();
else if (part == "lid") translate([0, 0, z_lid_top]) rotate([180, 0, 0]) lid();   // bovenplaat op het bed
else if (part == "bracket") translate([0, 0, br_top]) rotate([180, 0, 0]) bracket();  // bovenkant op het bed
else if (part == "base_asm") base();
else if (part == "lid_asm") lid();
else if (part == "bracket_asm") bracket();
else {
    color("SteelBlue") base();
    if (show_lid) translate([0, 0, explode]) color("LightSteelBlue", 0.55)
        if (cover == "bracket") bracket(); else lid();
    if (show_clip) color("DarkOrange") clip_placed();
    if (show_board) %board_ghost();
}
