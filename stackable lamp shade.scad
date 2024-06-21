$fa = 1;
$fs = 0.4;

// Define Constants
size = 20;
    move = size*0.7;
height = 20;
wallThickness = 0.8;

slotDepth = 2;
slotThickness = 1;

centralSupportRadius = 6;
supportHeight = 1;
supportWidth = 10;



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
            scale([1,1,2]) translate([0,0,-1]) MakeShape(shellSize - wallThickness);
            };
};

module main() {
    // Create Shell with slots
    difference() {
        MakeShell(size);
            
        color("red")  difference () {
            scale([1.0001,1.0001,1.0001]) translate([0,0,-0.001]) 
            intersection() { 
                MakeShell(size-slotThickness); rotate([0,0,45]) 
                MakeShell(size-slotThickness); 
            };
            
            translate([0,0, height/2])
                cube([maxRadius * 3, maxRadius * 3, height - slotDepth], center = true);
            };
    };

    // Create support structure (shorten to allow for slots
    cylinder(h=(height-(slotDepth)), r=centralSupportRadius);

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

main();

// rotate(45) translate([0,0,height-slotDepth]) main();


