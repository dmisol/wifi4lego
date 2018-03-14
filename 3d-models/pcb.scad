wire = 1.25;
pcbThickness = 1.2;
pcbWidth = 28.3;
pcbLength = 42.5;
module powerSw(){
    R = 3;
    H=4;
    $fn=32;
    rotate(90,[1,0,0]) cylinder(r=R,h=H,center=true);
    translate([0,H/2,0]) sphere(r=R);
    translate([0,-H/2,0]) sphere(r=R);
    
    translate([-R,-H/2-1.5,-10]) cube([2*R-1,H+3,10]);
    translate([-R,-H/2-1.5,-2]) cube([2*R,H+3,4]);
}
module pcbServo(x){
    $fn=32;
/*
    R = 3.5/2;
    
    translate([-20,-2.54,pcbThickness]) cube([20,2.54*2,2*R]);
    translate([-20,-2.54,pcbThickness+R]) rotate(90,[0,1,0])cylinder(r=R,h=20);
    translate([-20,2.54,pcbThickness+R]) rotate(90,[0,1,0])cylinder(r=R,h=20);

    
    translate([-20,-2.54-R,-10]) cube([20-x/2,2*(2.54+R),10+3]);
*/
    translate([-20,-2.54*1.5,pcbThickness]) cube([20,3*(2.54),2.7]);
    
    translate([-20,-2.54*1.5,-10]) cube([20-x/2,3*(2.54),10+2.8]);
    

    translate([-2.5,0,0]) sphere(r=1.5);
    translate([-2.5,-2.54,0]) sphere(r=1.5);
    translate([-2.5,2.54,0]) sphere(r=1.5);
    
}
module pcbOutside(x=pcbWidth){
    color("magenta") {
        translate([-x/2-2,5,1.2+2]) powerSw(x);
        
        translate([0,15.25,0]) pcbServo(x);
        translate([0,26.67,0]) pcbServo(x);
        translate([0,38.1,0]) pcbServo(x);
    }
}


module pcb(){
    x=pcbWidth;
    y=pcbLength;
    th = pcbThickness+0.1;
    
    wpos=21;
    wneg =14;
    
    difference(){
        color("silver"){
            translate([-x/2,0,0]) cube([x,y,th]);
            difference(){
                translate([-x/2+1,0,th]) cube([x-2,y,4]);
                translate([6,22,th]) cube([30,1,30]);
            }
        }
        translate([-x/2,0,0]) rotate(45,[0,0,1]) cube([2,2,15],center=true);
        translate([0,0,1.2+4]) rotate(45,[1,0,0]) cube([30,4,4],center=true);
        translate([0,y,1.2+5]) rotate(45,[1,0,0]) cube([30,7,7],center=true);
        
        translate([0,y-12,th+2.5]) cube([20,20,20]);
        
//        translate([-20,y-31,th]) cube([13,50,20]);        
        translate([-20,y-32,th]) cube([13,50,20]);        
    }
    color("red") translate([-x/2+3.8,-wire/2,0]) cube([wire,wire,wpos]);
    color("blue") translate([x/2-3.8-wire,-wire/2,0]) cube([wire,wire,wneg]);
    
   
}

//pcb();  pcbOutside();
