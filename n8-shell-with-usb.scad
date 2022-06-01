// Krikzz Everdrive N8 Famicom shell, with optional USB cutout
//
// Licensed under CC-BY by Blackchamber (https://www.thingiverse.com/Blackchamber)
// Copyright 2022, Bastien Nocera <hadess@hadess.net>

show_front = 1;
show_pcb = 1;
show_back = 1;
with_usb = 1;

include <NopSCADlib-copypaste.scad>;

// USB port cutout
module usb_cutout() {
    if (with_usb) {
        translate([-130, -10.4, 8])
        usb_miniA(cutout = true);
    } else {
        // otherwise the difference() might cause problems
        cube([0, 0, 0]);
    }
}

// Front shell without cutout
module _front_shell() {
    color("Yellow")
    union() {
        translate([0, -69/2, 0])
        import("original/N8FCplateFinal-front_fixed.stl");

        // add a support post where one exists in the official shell
        translate([0, -8.8, 2.1])
        cylinder(d = 2.15, h = 4.8);
    }
}
module front_shell() {
    difference() {
        _front_shell();
        usb_cutout();
    }
}

// PCB
module pcb() {
    board_width = 100.5;
    board_height = 51.8;
    board_thickness = 1.5;
    edge_width = 77.42;
    edge_height = 62.15-51.8;
    usd_height = 14.93;
    usd_width = 14.58;
    usd_thickness = 1.9;
    
    translate([-(board_width/2), -board_height-4.2, 7.1])
    union() {
        rotate([0, 0, 180])
        translate([-9.4/2, 9/2-board_height+1.75, board_thickness])
        usb_miniA();
        rotate([0, 0, 180])
        translate([-usd_height/2, usd_width/2-board_height+9.36, -usd_thickness])
        uSD([usd_height, usd_width, usd_thickness]);
        color("darkgreen")
        cube([board_width, board_height, board_thickness]);
        color("Gold")
        translate([(board_width-edge_width)/2, -edge_height, 0])
        cube([edge_width, edge_height, board_thickness]);
    }
}

// Back shell
module _back_shell() {
    color("Blue")
    rotate([180, 0, 180])
    translate([0, -94.25, -16.02])
    import("original/N8FCplateFinal-back_fixed.stl");
}
module back_shell() {
    difference() {
        _back_shell();
        usb_cutout();
    }
}

if (show_front) front_shell();
if (show_pcb) pcb();
if (show_back) back_shell();