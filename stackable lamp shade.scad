$fa = 1;
$fs = 0.4;


/* [Basic Constants] */
layerWidth = 0.8;
layerHeight = 0.2;

/* [Main Structure] */
size = 180;
    move = size * 0.7;
height = 20;
wallThickness = 0.8;

/* [Cross Supports] */
supportHeight = 1;
supportWidth = 10;

/* [Central Supports] */
centralSupportRadius = 6;
centralSupportSupportRadius = 1;
centralHoleRadius = 3;

/* [Slots] */
slotDepth = 2;
slotThickness = 1;

/* [Dovetail Meshing] */
dovetailThickness = 2;
dovetailScale = 0.85; // [0:0.01:1]
dovetailSquish = 0.6; // [0:0.01:1]




maxRadius = size + move;
// minRadius = 
echo();
echo("Max radius is ", maxRadius, "mm");
// echo("Min radius is ", minRadius);
echo();
    

// Define Module to make main shape
module MakeShape (radius) {
    for(i = [ [ move,  0,  0],
              [0, move, 0],
              [-move, 0, 0],
              [0, -move, 0], ])
    {
       translate(i)
       translate([0,0,height/2])
       cylinder(h=height, r=radius, center = true);
    }
}

module MakeShell(shellSize) {
    difference () {  // Create Shell
            scale([1,1,1]) MakeShape(size);
            scale([1,1,2]) translate([0,0,-1]) MakeShape(size - shellSize);
            };
};

module Dovetail8() {
    for(i = [0 : 1 : 7]) {
        rotate([90,90,(i * 45)]) 
        scale([dovetailSquish,1,1]) cylinder(h = dovetailThickness, r = centralSupportRadius, center = true);
        
        i = i + 1;
    };
};

module CentralSupport() {
    cylinder(h=(height-(slotDepth)), r=centralSupportRadius);
    translate([0,0,(height - slotDepth)]) scale(dovetailScale) Dovetail8();

    // make square supports
    difference() {
        
        //make uncut sqare supports
        union() {
            rotate(45) 
            translate([0,0,supportHeight/2]) 
            cube([supportWidth,(maxRadius*2),supportHeight],center=true);
            
            rotate(135) 
            translate([0,0,supportHeight/2]) 
            cube([supportWidth,(maxRadius*2),supportHeight],center=true);
        };
            
        // make inverse shape
        difference() {
            translate([0,0,-0.001]) scale([2,2,2]) MakeShape(size);
            translate([0,0,-0.001]) scale([1,1,1]) MakeShape(size);
        };
    };
};

module FirstLayerSupport() {
    difference() {
        MakeShell(layerWidth * 2);
        translate([0,0,maxRadius + layerHeight]) cube(size = maxRadius * 2, center = true);
    }
}

module main() {
    // Create Shell with slots
    difference() {
        MakeShell(wallThickness);
            
        color("red")  difference () {
            scale([1.0001,1.0001,1.0001]) translate([0,0,-0.001]) 
            intersection() { 
                MakeShell(slotThickness + 0.001); rotate([0,0,45]) 
                MakeShell(slotThickness + 0.001); 
            };
            
            translate([0,0, height/2])
                cube([maxRadius * 3, maxRadius * 3, height - slotDepth], center = true);
        };
    };
    
    difference() {  // create central support
        CentralSupport();
        
        translate([0,0,-height]) cylinder(h=height*3, r=centralHoleRadius);
        scale(dovetailScale) Dovetail8();
        };
        
    translate([0,0,(supportHeight/2)]) cylinder(h = supportHeight, r = (centralSupportRadius + centralSupportSupportRadius), center = true);

    // Make first layer support
    FirstLayerSupport();
};

main();

// FirstLayerSupport();

// rotate(45) translate([0,0,height-slotDepth]) main();

// Dovetail8();


