//
// NopSCADlib Copyright Chris Palmer 2018
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// This file is part of NopSCADlib.
//
// NopSCADlib is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// NopSCADlib is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with NopSCADlib.
// If not, see <https://www.gnu.org/licenses/>.
//

//
//! PCBs and perfboard with optional components. The shape can be a rectangle with optionally rounded corners or a polygon for odd shapes like Arduino.
//
panel_clearance = 0.2; 

module translate_z(z)                                                               //! Shortcut for Z only translations
    translate([0, 0, z]) children();

eps = 1/128;     // small fudge factor to stop CSG barfing on coincident faces.

module usb_miniA(cutout = false) { //! Draw USB mini A connector
    l = 9.2;
    iw1 = 7.0;
    iw2 = 6.0;
    ih1 = 1.05;
    ih2 = 1.0;
    h = 4.0;
    t = 0.4;

    module D() {
        hull() {
            translate([-iw1 / 2, h - t - ih1])
                square([iw1, ih1]);

            translate([-iw2 / 2, t + ih2])
                square([iw2, eps]);

        }
        translate([-iw2 / 2, t])
            square([iw2, ih2]);
    }

    if(cutout)
        rotate([90, 0, 90])
            linear_extrude(100)
                offset(2 * panel_clearance)
                    D();
    else
        color("silver") rotate([90, 0, 90]) {
            linear_extrude(l, center = true)
                difference() {
                    offset(t)
                        D();

                    D();
                }

            translate_z(-l / 2)
                linear_extrude(1)
                    offset(t)
                        D();
        }
}

function grey(n) = [0.01, 0.01, 0.01] * n;                                  //! Generate a shade of grey to pass to color().

module uSD(size, cutout = false) { //! Draw uSD socket
    min_w = 12;
    w = size.x - min_w;
    t = 0.15;

    if(cutout)
        ;    
    else 
        translate_z(size.z / 2) { 
            color("silver")
                rotate([90, 0, 90]) {
                    linear_extrude(size.y, center = true)
                        difference() {
                            square([size.x, size.z], center = true);
                            square([size.x - 2 * t, size.z - 2 * t], center = true);
                        }    

                    translate_z(-size.y / 2 + t / 2) 
                        cube([size.x, size.z, t], center = true);
                }    
            if(w > 0) 
                color(grey(20))
                    rotate([90, 0, 90]) 
                        translate_z(t)
                            linear_extrude(size.y - t, center = true)
                                difference() {
                                    square([size.x - 2 * t, size.z - 2 * t], center = true);

                                    translate([-size.x / 2 + min_w / 2 + 0.7, size.z / 2 - t])
                                        square([min_w, 2.2], center = true);
                                }    
        }    
}
