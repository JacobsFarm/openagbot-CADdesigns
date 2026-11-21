// ======================================================
// SMART PANEL - indeling componenten
// Paneel 600 x 600 x 200 mm buitenmaat, wand 25 mm -> binnen 550 x 550
// Pas pos / rot per component aan; controle staat in de console.
// ======================================================

panel_outer = [600, 600, 200];
wall        = 25;
inner_w = panel_outer[0] - 2*wall;   // 550
inner_h = panel_outer[1] - 2*wall;   // 550
inner_z = panel_outer[2];
margin  = 5;     // afstand tot rand
gap     = 5;     // afstand tussen componenten
show_parts = true;   // false = alleen blokken (snel)
show_box   = true;

// [naam, stl (undef = blok), pos[x,y], rot (0/90/270; VESC 270 = draden naar +Y), stl-min[x,y,z], afmeting[x,y,z]]
// Indeling: links boven Jetson | links onder HBS | rechts onder VESC (draden naar boven) | rechts boven overige boards
// HBS860H: echte STL, rechtop (stand=1): 150 breed x 54.5 dik x 108.9 hoog
// RTK_X20D: simpleRTK2b STL als stand-in voor het X20D-board
parts = [
    ["Jetson", "jetson_orin_nano_board.stl", [15,444], 0, 0, [-5.500,-18.877,-4.900], [103.0,90.9,34.8]],
    ["RTK_X20D", "simpleRTK2b_standin_x20d.stl", [290,375], 0, 0, [-40.000,-40.157,0.000], [80.0,80.2,11.5]],
    ["Innomaker_CAN", "usb2can_innomaker.stl", [455,300], 0, 0, [-15.462,-31.532,-2.250], [31.0,56.5,16.6]],
    ["HBS860H1", "hbs860h_driver.stl", [15,15], 0, 1, [-8.750,-11.400,-23.500], [150.0,54.5,108.9]],
    ["HBS860H2", "hbs860h_driver.stl", [15,85], 0, 1, [-8.750,-11.400,-23.500], [150.0,54.5,108.9]],
    ["HBS860H3", "hbs860h_driver.stl", [15,155], 0, 1, [-8.750,-11.400,-23.500], [150.0,54.5,108.9]],
    ["HBS860H4", "hbs860h_driver.stl", [15,225], 0, 1, [-8.750,-11.400,-23.500], [150.0,54.5,108.9]],
    ["Arduino_Uno1", "arduino_uno_r4_wifi.stl", [290,300], 0, 0, [-1.960,-0.000,-3.406], [70.5,53.3,14.5]],
    ["Arduino_Uno2", "arduino_uno_r4_wifi.stl", [370,300], 0, 0, [-1.960,-0.000,-3.406], [70.5,53.3,14.5]],
    ["VESC1", "vesc_classic.stl", [295,15], 270, 0, [-158.750,-23.750,-4.000], [208.0,47.5,18.6]],
    ["VESC2", "vesc_classic.stl", [355,15], 270, 0, [-158.750,-23.750,-4.000], [208.0,47.5,18.6]],
    ["VESC3", "vesc_classic.stl", [415,15], 270, 0, [-158.750,-23.750,-4.000], [208.0,47.5,18.6]],
    ["VESC4", "vesc_classic.stl", [475,15], 270, 0, [-158.750,-23.750,-4.000], [208.0,47.5,18.6]],
    ["Hoofdschakelaar", "hoofdschakelaar_aan_uit.stl", [390,375], 0, 0, [0.000,0.000,0.000], [33.0,20.0,45.0]]
];

// p = [naam, stl, pos, rot, stand, stl-min, afmeting]
function dim(p) = p[6];
function fx(p) = p[3]%180==90 ? dim(p)[1] : dim(p)[0];
function fy(p) = p[3]%180==90 ? dim(p)[0] : dim(p)[1];
function inside(p) = p[2][0] >= margin && p[2][1] >= margin
    && p[2][0]+fx(p) <= inner_w-margin && p[2][1]+fy(p) <= inner_h-margin
    && dim(p)[2] <= inner_z;
function overlap(a,b) = a[2][0] < b[2][0]+fx(b)+gap && b[2][0] < a[2][0]+fx(a)+gap
    && a[2][1] < b[2][1]+fy(b)+gap && b[2][1] < a[2][1]+fy(a)+gap;

for (i=[0:len(parts)-1]) {
    if (!inside(parts[i])) echo(str("BUITEN PANEEL: ", parts[i][0]));
    if (i < len(parts)-1) for (j=[i+1:len(parts)-1])
        if (overlap(parts[i],parts[j])) echo(str("OVERLAP: ", parts[i][0], " <-> ", parts[j][0]));
}
echo(str("Gebruikte Y: ", max([for (p=parts) p[2][1]+fy(p)]), " van ", inner_h,
         " | hoogste component: ", max([for (p=parts) dim(p)[2]]), " van ", inner_z));

if (show_box) %translate([-wall,-wall,-2]) difference() {
    cube([panel_outer[0], panel_outer[1], panel_outer[2]]);
    translate([wall,wall,2]) cube([inner_w, inner_h, panel_outer[2]]);
}
color("lightgrey") translate([0,0,-2]) cube([inner_w, inner_h, 2]);

// stand=1: component rechtop (zijkant naar beneden), footprint x * dikte
module place(p) {
    if (p[1] != undef && show_parts) {
        if (p[4]==1) translate([0, 0, dim(p)[2]]) rotate([-90,0,0]) translate(-p[5]) import(str("parts/", p[1]));
        else translate(-p[5]) import(str("parts/", p[1]));
    } else color(p[1]==undef ? "orange" : "steelblue") cube(dim(p));
}
for (p = parts) translate([p[2][0], p[2][1], 0])
    translate([p[3]==90 ? dim(p)[1] : 0, p[3]==270 ? dim(p)[0] : 0, 0]) rotate(p[3]) place(p);
