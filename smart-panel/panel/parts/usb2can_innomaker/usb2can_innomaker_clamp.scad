// Innomaker USB2CAN klem: bodem + top, aangepast voor M4.
//
// De binnenkant (vak voor de print, USB-sleuf, DB9-opening, PCB-gaten) komt 1-op-1
// uit de originele innomaker-USB2CAN-Bottom/Top.stl, zodat de USB2CAN er precies in past.
// Aan de buitenkant is toegevoegd:
//   - 4 klempunten (oren) met M4: heat insert in de bodem, M4 bout van boven door de top.
//     De top-oren lopen tot de bovenkant door (vlak op het printbed, geen overhang).
//     De PCB-gaten zijn maar 3 mm, dus de M4 klemmen zitten in oren buiten de print.
//   - Bodem: ingebouwde ovale plaat die alle oren verbindt, met 2 gaten om hem op een bodemplaat vast te zetten.
//   - Voor- en achterkant: plaat, oren en kast lopen vlak (flush) door op y = y_front / y_rear.
//   - De 2 originele PCB-schroefgaten onderin de bodem zijn dicht.
// Assen (zoals de originele STL's): X = breedte, Y = lengte (USB naar +Y, DB9 naar -Y), Z = omhoog.
// Bodem ligt plat op z = -1.8, de top rust op z = 4.16.

// --- Render Options ---
part = "assembly";   // "assembly", "bottom", "top" (top wordt omgedraaid voor het printen)
show_device = false; // Toon de USB2CAN als spook (usb2can_innomaker.stl, alleen preview F5)

// --- Origineel (gemeten) ---
z_floor = -1.8;      // Onderkant bodem
z_split = 4.16;      // Waar de top op de bodem rust
z_top   = 17.55;     // Bovenkant top
pcb_z   = 2.48;      // Onderkant van de PCB in de klem

// Buitencontour van het origineel op z = -1 (uit de STL gehaald)
outline = [[12.815,6.061], [12.043,6.170], [11.625,6.185], [-12.043,6.170], [-12.459,6.125], [-13.276,5.948], [-13.673,5.816], [-14.433,5.468], [-15.137,5.016], [-15.462,4.754], [-16.054,4.162], [-16.555,3.493], [-16.955,2.759], [-17.248,1.976], [-17.425,1.159], [-17.485,0.325], [-17.485,-25.943], [-17.515,-26.710], [-17.660,-28.239], [-17.773,-28.999], [-18.083,-30.503], [-18.502,-31.981], [-18.751,-32.707], [-19.327,-34.131], [-20.006,-35.508], [-20.782,-36.833], [-21.653,-38.098], [-22.123,-38.706], [-23.126,-39.869], [-24.451,-41.199], [-24.669,-41.462], [-25.034,-42.039], [-25.296,-42.669], [-25.447,-43.334], [-25.483,-44.016], [-25.402,-44.694], [-25.207,-45.348], [-25.069,-45.660], [-24.714,-46.244], [-24.266,-46.758], [-23.737,-47.189], [-23.142,-47.524], [-22.499,-47.753], [-21.826,-47.869], [-21.485,-47.883], [21.485,-47.883], [21.826,-47.869], [22.499,-47.753], [23.142,-47.524], [23.446,-47.369], [24.011,-46.985], [24.266,-46.758], [24.714,-46.244], [25.069,-45.660], [25.207,-45.348], [25.402,-44.694], [25.457,-44.357], [25.480,-43.675], [25.447,-43.334], [25.386,-42.998], [25.179,-42.348], [25.034,-42.039], [24.669,-41.462], [24.451,-41.199], [23.126,-39.869], [22.123,-38.706], [21.653,-38.098], [20.782,-36.833], [20.006,-35.508], [19.327,-34.131], [18.751,-32.707], [18.502,-31.981], [18.083,-30.503], [17.773,-28.999], [17.574,-27.476], [17.485,-25.943], [17.485,0.325], [17.425,1.159], [17.351,1.571], [17.116,2.373], [16.768,3.133], [16.316,3.837], [15.769,4.469], [15.137,5.016], [14.433,5.468], [13.673,5.816]];

// --- M4 klempunten ---
// Achter: zelfde plek als de originele achterste schroeven. Voor: nieuwe oren naast de USB-kant.
ear_pts = [[-21.49, -43.88], [21.49, -43.88], [-23.5, -0.5], [23.5, -0.5]];
ear_R      = 5;      // Straal van het oog rond de M4
ear_web_x  = 17.0;   // Voor-oren: verbinding naar de zijwand begint bij deze |x|
y_front    = 6.185;  // Voorkant van het origineel (USB-kant); alles loopt hier vlak
y_rear     = -47.883; // Achterkant van het origineel (DB9-kant); alles loopt hier vlak
cavity_x   = 15.63;  // Binnenwand van het vak (achterste oren lopen hier tot aan door)
pcb_holes  = [[-11.43, 0], [11.43, 0]]; // Originele PCB-schroefgaten in de bodem: dichtgemaakt
front_fill_x = 9;    // Opvulling voorhoeken vanaf deze |x| (USB-sleuf zit binnen +/- 4.1)
z_ear      = 6.16;   // Deling bij de oren: bodem-oor loopt tot hier (ruimte voor de insert)
insert_D   = 4.8;    // Gat voor de M4 heat insert in de bodem (doorlopend, insert van boven indrukken)
bolt_D     = 4.5;    // Doorgaand gat voor de M4 bout in de top
fit        = 0.2;    // Speling tussen bodem-oor en top

// --- Bodemplaat (flens) ---
// Een doorlopende plaat (omhullende van de 4 oren en de 2 bevestigingsogen), loopt ovaal rond.
flange      = true;
flange_t    = 4;     // Dikte (vanaf z_floor)
flange_rim  = 1.5;   // Plaat steekt zoveel buiten de oren uit
mount_D     = 4.5;   // 2 bevestigingsgaten (M4)
mount_R     = 6;     // Straal van het oog rond een bevestigingsgat
mount_dx    = 33;    // Gaten op x = +/- mount_dx
mount_y     = -21.5; // Y van de gaten

$fn = 64;

bolt_len = z_top - z_floor;
echo(str("M4 bout van boven (z=", z_top, ") tot onderkant bodem is ", bolt_len, " mm -> gebruik M4x16"));

// --- 2D ---
module outline2d() polygon(outline);

front_ears = [for (p = ear_pts) if (p[1] > -30) p];
ear_outer_x = max([for (p = front_ears) abs(p[0])]) + ear_R;

module ear2d(p) {
    intersection() {
    hull() {
        translate(p) circle(r = ear_R);
        // Voor-oren: brug naar de zijwand en door tot de voorkant
        if (p[1] > -30) {
            translate([sign(p[0]) * ear_web_x - (p[0] < 0 ? 1 : 0), p[1] - ear_R]) square([1, 2 * ear_R]);
            translate([p[0] - ear_R, p[1]]) square([2 * ear_R, y_front - p[1]]);
        } else {
            // Achter-oren: blok tot de binnenwand en de achterkant, geen dunne randjes in de top
            translate([p[0] > 0 ? cavity_x : p[0], y_rear]) square([abs(p[0]) - cavity_x, p[1] + ear_R - y_rear]);
        }
    }
    translate([-100, y_rear]) square([200, y_front - y_rear]);
    }
}

// Voorhoeken tussen kast en voor-oren dichtmaken zodat de voorkant vlak doorloopt
module front_fill2d() {
    y0 = min([for (p = front_ears) p[1]]);
    difference() {
        for (s = [-1, 1])
            translate([s > 0 ? front_fill_x : -ear_outer_x, y0])
                square([ear_outer_x - front_fill_x, y_front - y0]);
        offset(delta = -0.3) outline2d();
    }
}

module ears2d() for (p = ear_pts) ear2d(p);

module flange2d() {
    difference() {
        intersection() {
            hull() {
                for (p = ear_pts) translate(p) circle(r = ear_R + flange_rim);
                for (s = [-1, 1]) translate([s * mount_dx, mount_y]) circle(r = mount_R);
                // Voorkant recht en vlak met de kast
                translate([-(ear_outer_x + flange_rim), y_front - 1]) square([2 * (ear_outer_x + flange_rim), 1]);
                // Achterkant (DB9) recht en vlak met de kast
                translate([-(ear_outer_x + flange_rim), y_rear]) square([2 * (ear_outer_x + flange_rim), 1]);
            }
            translate([-100, y_rear]) square([200, y_front - y_rear]);
        }
        offset(delta = -0.05) outline2d();       // binnen de contour blijft het origineel
        for (s = [-1, 1]) translate([s * mount_dx, mount_y]) circle(d = mount_D);
    }
}

// --- Parts ---
module bottom() render(convexity = 10) {
    difference() {
        union() {
            import("innomaker-USB2CAN-Bottom.stl", convexity = 10);
            translate([0, 0, z_floor]) linear_extrude(z_ear - z_floor) ears2d();
            // Voorhoeken alleen tot de deellijn, zodat de naad op de voorkant recht loopt
            translate([0, 0, z_floor]) linear_extrude(z_split - z_floor) front_fill2d();
            if (flange) translate([0, 0, z_floor]) linear_extrude(flange_t) flange2d();
            // Originele PCB-schroefgaten onderin dichtmaken (tot de PCB-steun)
            for (h = pcb_holes) translate([h[0], h[1], z_floor]) cylinder(d = 6.2, h = pcb_z - z_floor);
        }
        for (p = ear_pts) translate([p[0], p[1], z_floor - 1]) cylinder(d = insert_D, h = z_ear - z_floor + 2);
    }
}

module top() render(convexity = 10) {
    difference() {
        union() {
            import("innomaker-USB2CAN-Top.stl", convexity = 10);
            // Oren lopen door tot de bovenkant: vlak op het printbed
            translate([0, 0, z_ear]) linear_extrude(z_top - z_ear) ears2d();
            translate([0, 0, z_split]) linear_extrude(z_top - z_split) front_fill2d();
        }
        // Ruimte voor de bodem-oren
        translate([0, 0, z_split - 1]) linear_extrude(z_ear - z_split + 1) offset(r = fit) ears2d();
        for (p = ear_pts) translate([p[0], p[1], 0]) cylinder(d = bolt_D, h = z_top + 1);
    }
}

module device() translate([-0.04, -20.99, pcb_z]) import("usb2can_innomaker.stl");

// --- Execution ---
if (part == "bottom") color("SteelBlue") bottom();
else if (part == "top") translate([0, 0, z_top]) rotate([180, 0, 0]) color("Orange") top();
else {
    color("SteelBlue") bottom();
    color("Orange", 0.8) top();
}
if (show_device && part == "assembly") %device();
