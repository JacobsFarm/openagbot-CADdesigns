// Back plate voor de ArduSimple simpleRTK 4 Dual (ZED-X20D), AS-RTK4-X20D-NH-00-R00.
// Het board ligt op 5 bossen met M3 heat inserts, onder elk schroefgat van de PCB.
// Langs de twee lange zijden staat een rand waar de PCB precies tussen valt.
// De korte zijden blijven open: daar zitten de SMA-, USB-C- en GHS-connectoren.
// Assen: X = lengte board (SMA-zijde bij x = 0), Y = breedte board, Z = van de plaat af.
// Oorsprong = linker onderhoek van de PCB (zoals in simplertk4_dual.stl, PCB-onderkant op z = 0).

// --- Render Options ---
show_plate = true;      // De printbare plaat
show_board = false;     // Toon het board als spook (simplertk4_dual.stl in deze map)

// --- simpleRTK 4 Dual (gemeten aan AS-RTK4-X20D-NH-00-R00.step) ---
pcb_t = 1.6;            // Dikte van de PCB
// PCB-omtrek (Arduino-shield vorm, met uitsteeklip aan de USB-zijde)
pcb_outline = [[0, 0], [66.04, 0], [66.04, 2.54], [68.58, 5.08], [68.58, 38.10],
               [66.04, 40.64], [66.04, 51.81], [64.52, 53.34], [0, 53.34]];
pcb_L = 68.58;          // Lengte inclusief lip
pcb_W = 53.34;          // Breedte (afstand tussen de twee randen)
// Schroefgaten Ø3.2 (M3)
pcb_holes = [[13.97, 2.54], [15.24, 50.80], [66.04, 35.56], [47.63, 43.43], [47.63, 12.95]];

// Twee header-rijen (MMS-110) waarvan de pinnen 1.3 mm onder de PCB uitsteken: [x0, x1, y0, y1]
pin_rows = [[45.35, 65.91, 16.19, 18.19], [45.35, 65.91, 38.19, 40.19]];
pin_clr   = 0.5;        // Speling rond de pinnen
pin_depth = 2.5;        // Diepte van de uitsparing onder de PCB-onderkant

// --- Plate ---
plate_t   = 4;          // Dikte van de plaat
margin_x  = 1.5;        // Plaat steekt zoveel voorbij de korte zijden van de PCB
R         = 3;          // Hoekradius van de plaat

// --- Bosses met M3 heat inserts ---
boss_h    = 5;          // Hoogte van de bossen boven de plaat = vrije ruimte onder de PCB
boss_D    = 8;          // Diameter van een boss
insert_D  = 4;          // Gat voor de M3 heat insert (zelfde als op de VESC-plaat)
insert_depth = 7;       // Diepte van het insert-gat vanaf de top van de boss (M3 insert 5.7 mm lang)

// --- Randen langs de lange zijden ---
rim_t     = 2.4;        // Wanddikte van de rand
rim_clr   = 0.3;        // Speling tussen PCB-rand en wand (per zijde)
rim_above = 0;          // Hoeveel de rand boven de PCB-bovenkant uitkomt (0 = gelijk)
rim_x0    = 0;          // Begin van de randen (x)
rim_x1_bottom = 66.04;  // Einde van de rand aan de y = 0 zijde
rim_x1_top    = 64.0;   // Einde van de rand aan de y = 53.34 zijde (voor de afgeschuinde hoek)
lead_in   = 0.6;        // Afschuining aan de binnenkant van de rand, om de PCB er makkelijk in te leggen

// --- M4 bevestiging van de plaat (op de DIN-rail clip met M4 inserts, of op de backplate) ---
m4_holes  = true;       // Twee M4 gaten in de plaat
m4_D      = 4.5;        // Doorgaand gat M4
m4_pitch  = 46;         // Hart-op-hart, gelijk aan de inserts van dins_clip_m4_insert
m4_head_D = 8.5;        // Verzinking voor de cilinderkop (onder de PCB)
m4_head_depth = 2.4;    // Diepte van de verzinking (kop steekt nog max. 1.6 mm uit, ruim onder de PCB)
m4_y      = 26.67;      // Y-positie (midden van het board, tussen de headers door)

// --- Resolution ---
$fn = 60;

// --- Derived ---
pcb_z   = plate_t + boss_h;                      // Onderkant PCB
rim_top = pcb_z + pcb_t + rim_above;             // Bovenkant van de randen
P_x0 = -margin_x;
P_x1 = pcb_L + margin_x;
P_y0 = -rim_clr - rim_t;
P_y1 = pcb_W + rim_clr + rim_t;
m4_x = [pcb_L/2 - m4_pitch/2, pcb_L/2 + m4_pitch/2];

// Voor andere bestanden die deze file met 'use <...>' laden (bv. ../../panel.scad)
function rtk4_plate_size()  = [P_x1 - P_x0, P_y1 - P_y0, rim_top];
function rtk4_plate_min()   = [P_x0, P_y0, 0];
function rtk4_board_z()     = pcb_z;

echo(str("Plaat: ", P_x1 - P_x0, " x ", P_y1 - P_y0, " x ", plate_t,
         " mm, totale hoogte ", rim_top, " mm, PCB-onderkant op z = ", pcb_z));

// --- Modules ---
module plate_profile() {
    translate([P_x0 + R, P_y0 + R])
        offset(r=R) square([P_x1 - P_x0 - 2*R, P_y1 - P_y0 - 2*R]);
}

// Rand langs een lange zijde. side = 0 -> y = 0 zijde, side = 1 -> y = pcb_W zijde.
module rim(side, x1) {
    y_in  = side == 0 ? -rim_clr : pcb_W + rim_clr;        // Binnenvlak van de wand
    y_out = side == 0 ? y_in - rim_t : y_in + rim_t;
    dir   = side == 0 ? 1 : -1;                            // Richting naar de PCB toe
    h = rim_top - plate_t;
    translate([rim_x0, 0, plate_t - 0.01])
        rotate([90, 0, 90])
            linear_extrude(x1 - rim_x0)
                // Profiel in (y, z): wand met afschuining aan de bovenkant binnenzijde
                polygon([[y_out, 0], [y_in, 0],
                         [y_in, h - lead_in], [y_in - dir*lead_in, h],
                         [y_out, h]]);
}

module back_plate() {
    difference() {
        union() {
            linear_extrude(plate_t) plate_profile();
            // Bossen onder de schroefgaten
            for (h = pcb_holes)
                translate([h[0], h[1], plate_t - 0.01])
                    cylinder(d=boss_D, h=boss_h + 0.01);
            // Randen langs de lange zijden
            rim(0, rim_x1_bottom);
            rim(1, rim_x1_top);
        }

        // M3 heat insert gaten (blind vanaf de top van de boss)
        for (h = pcb_holes)
            translate([h[0], h[1], pcb_z - insert_depth])
                cylinder(d=insert_D, h=insert_depth + 0.01);

        // Uitsparing voor de header-pinnen onder de PCB (raken anders de bossen)
        for (r = pin_rows)
            translate([r[0] - pin_clr, r[2] - pin_clr, pcb_z - pin_depth])
                cube([r[1] - r[0] + 2*pin_clr, r[3] - r[2] + 2*pin_clr, pin_depth + 0.01]);

        // M4 gaten met verzinking voor de kop aan de voorkant
        if (m4_holes)
            for (x = m4_x)
                translate([x, m4_y, 0]) {
                    translate([0, 0, -0.01]) cylinder(d=m4_D, h=plate_t + 0.02);
                    translate([0, 0, plate_t - m4_head_depth])
                        cylinder(d=m4_head_D, h=m4_head_depth + 0.01);
                }
    }
}

// Spook van het board: simplertk4_dual.stl heeft de PCB-onderkant op z = 0.
module board_ghost() {
    translate([0, 0, pcb_z]) import("simplertk4_dual.stl");
}

// --- Execution ---
if (show_plate) color("SteelBlue") back_plate();

// '%' = alleen in preview (F5); het board hoort niet in de render/export.
if (show_board) %board_ghost();
