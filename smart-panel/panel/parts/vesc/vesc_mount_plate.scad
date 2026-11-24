// VESC mount plate: 4x VESC Classic 100 V op een 3D-geprinte plaat.
// De plaat gaat met M5 bouten op de backplate van de schakelkast,
// daarna gaan de VESC's er aan de voorkant op met M3 bouten in heat inserts.
// Assen: X = breedte plaat, Y = lengte VESC (draden wijzen naar +Y), Z = van backplate af.

// --- Render Options ---
show_plate = true;      // De printbare plaat
show_vesc  = false;     // Toon de VESC's als spook (vesc_classic.stl in deze map)

// --- VESC Classic (gemeten aan vesc_classic.stl) ---
vesc_len   = 99.8;      // Lengte van de aluminium voet (zonder draden)
vesc_wid   = 47.5;      // Breedte van de voet
vesc_hole_dx = 93.7;    // Hart-op-hart M3 gaten in de lengte
vesc_hole_dy = 41.4;    // Hart-op-hart M3 gaten in de breedte
mirror_holes = false;   // true = de andere diagonaal (als jouw VESC gespiegeld is)
vesc_clearance = 1;     // Speling rondom de VESC

// --- Plate ---
plate_t   = 8;          // Dikte van de plaat (dik genoeg voor de heat insert, VESC ligt plat)
n_vesc     = 4;         // Aantal VESC's naast elkaar
m5_strip   = 20;        // Breedte van een strook met M5 gaten (tussen VESC 1-2 en 3-4)
small_gap  = 6;         // Breedte van een strook zonder gaten (tussen VESC 2-3)
side_margin = 5;        // Rand links en rechts (zonder gaten)
end_margin = 8;         // Rand boven en onder de VESC
R = 4;                  // Hoekradius van de plaat

// --- M5 holes (plaat op backplate) ---
// M5 gaten zitten in de strook tussen VESC 1-2, 3-4, 5-6 ... (paren)
m5_D       = 5.5;       // Doorgaand gat M5
washer_D   = 16;        // Verzinking voor de sluitring (0 = geen)
washer_depth = 1.3;     // Diepte van de verzinking voor de ring
m5_edge    = 12;        // Afstand van M5 gat tot boven-/onderrand

// --- M3 heat inserts (VESC op plaat) ---
insert_D   = 4.1;       // Gat voor de M3 heat insert

// --- Resolution ---
$fn = 60;

// --- Derived ---
bay_w = vesc_wid + 2*vesc_clearance;           // Vak per VESC (X)
bay_l = vesc_len + 2*vesc_clearance;           // Vak per VESC (Y)
// Strook tussen VESC i en i+1: na elk paar een M5 strook, anders een smalle strook
function gap_has_m5(i) = i % 2 == 0;
gaps = [for (i = [0:n_vesc-2]) gap_has_m5(i) ? m5_strip : small_gap];
function sum(v, n) = n <= 0 ? 0 : v[n-1] + sum(v, n-1);
P_W = 2*side_margin + n_vesc*bay_w + sum(gaps, n_vesc-1);  // Totale breedte
P_L = bay_l + 2*end_margin;                    // Totale lengte
top_z = plate_t;                               // VESC ligt plat op de plaat

// Middelpunten van de VESC's
vesc_x = [for (i = [0:n_vesc-1]) -P_W/2 + side_margin + i*bay_w + sum(gaps, i) + bay_w/2];

// X-posities van de M5 kolommen (midden van elke M5 strook)
m5_cols = [for (i = [0:n_vesc-2]) if (gap_has_m5(i)) (vesc_x[i] + vesc_x[i+1])/2];
m5_rows = [-(P_L/2 - m5_edge), P_L/2 - m5_edge];

// M3 gaten per VESC (lokaal, VESC lengte langs Y)
s = mirror_holes ? -1 : 1;
m3_holes = [[-s*vesc_hole_dy/2,  vesc_hole_dx/2],
            [ s*vesc_hole_dy/2, -vesc_hole_dx/2]];

echo(str("Plaat: ", P_W, " x ", P_L, " x ", plate_t, " mm, VESC ligt op z = ", top_z));

// --- Modules ---
module plate_profile() {
    offset(r=R) square([P_W - 2*R, P_L - 2*R], center=true);
}

module mount_plate() {
    difference() {
        linear_extrude(plate_t) plate_profile();

        // M3 heat insert gaten (doorlopend door de hele plaat)
        for (vx = vesc_x, h = m3_holes)
            translate([vx + h[0], h[1], -1])
                cylinder(d=insert_D, h=plate_t + 2);

        // M5 doorgaande gaten met verzinking voor de ring
        for (x = m5_cols, y = m5_rows)
            translate([x, y, 0]) {
                translate([0, 0, -1]) cylinder(d=m5_D, h=plate_t + 2);
                // Verzinking voor de sluitring aan de voorkant
                if (washer_D > 0 && washer_depth > 0)
                    translate([0, 0, plate_t - washer_depth])
                        cylinder(d=washer_D, h=washer_depth + 1);
            }
    }
}

// Spook van de VESC: STL-voet loopt van x -50.05..48.75, onderkant op z = -4.
module vesc_ghost() {
    rotate([0, 0, 270]) translate([0.65, 0, 4]) import("vesc_classic.stl");
}

// --- Execution ---
if (show_plate) color("SteelBlue") mount_plate();

// '%' = alleen in preview (F5); de VESC STL is niet gesloten en hoort niet in de render/export.
if (show_vesc)
    for (vx = vesc_x)
        %translate([vx, 0, top_z])
            mirror(mirror_holes ? [1, 0, 0] : [0, 0, 0])
                vesc_ghost();
