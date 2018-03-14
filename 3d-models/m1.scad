step=8;
inner = 1.7;
gap = 0.1;
vert_pin = 4.85;
vert_pin_hole = 5.1;   // was 5.05
pinhigth = 2.0;

servod = 11.7;
servow = 12.3;
servoh = 22.2;
 
thin = (2*step)/5;
 
$fn=32;

external = 1.55;
internal = 1.6;

Htotal = 16-gap;
Hhat = 8 - servow/2-gap;


EARS = 1;
RIGHT = 1;
function tr(x,y,z) = [step*x,step*y,step*z];

module holey(x,y,z){
     color("red") translate([(x)*step,(y)*step,(z)*step]) rotate(90,[1,0,0]){
        cylinder(h=step, r=5/2, center=true);
        translate([0,0,step/2]) cylinder(h=1.7,r=6.3/2, center=true);
        translate([0,0,-step/2]) cylinder(h=1.7,r=6.3/2, center=true);
     }
}
module innery(x,y,z){
     color("red") translate([(x)*step,(y)*step,(z)*step]) rotate(90,[1,0,0]){
        cylinder(h=step, r=6.3/2, center=true);
     }
}

module servo3(){
translate([0, servoh - 2.5*step + 0.4, 0])
    {
    wire = 2.2;
    
    translate([-servow/2 - 0.1, -servoh-10, -servow/2]) cube([22.7 + 0.2, servoh+10, servow + 0.1]);
    rotate(270,[1,0,0]) cylinder(h=4.5, r=servow/2);
//    translate([-4.8-servow/2 -0.2, -2.8 -4.2 - 0.05, -servow/2]) cube([32.2+ 0.8, 2.8 + 0.1, servow + 0.1]);
    translate([-4.8-servow/2 -0.2, -2.8 -4.2, -servow/2]) cube([32.2+ 0.8, 2.8 - 0.1, servow + 0.1]);

    rotate(270,[1,0,0]) cylinder(r=9.5/2, h=16.5);
      
    color("blue") translate([-servow/2,-0,-servow/2]) cube([15, servoh, servow + 0.1]);
    
    color("blue") {
        translate([-servow/2, -4.2,0]) rotate(45,[0,0,1]) cube([3, 3, servow + 0.2], center=true);
        translate([-servow/2 + 22.7, -4.2,0]) rotate(45,[0,0,1]) cube([3, 3, servow + 0.2], center=true);
    }
  }
}

module corner(c=0){
        translate([0,0,- (Htotal + gap)/2])
        difference(){
            cylinder(r=step/2-gap, h=Htotal);
            difference(){
                translate([0,0,-gap]) cylinder(r=step/2-external-gap, h=(Htotal-Hhat)+gap);
                if((c==1)&&EARS) translate([step/2,0,(Htotal + gap)/2]) rotate(-90,[1,0,0])cylinder(r=step/2-gap, h=2*step, center=true);
                if((c==2)&&EARS) translate([0,step/2,(Htotal + gap)/2]) rotate(-90,[0,1,0])cylinder(r=step/2-gap, h=2*step, center=true);
            }

            translate([-step,-step/2,-gap]) cube([step,step,Htotal + 2*gap]);
            translate([-step/2,-step,-gap]) cube([step,step,Htotal + 2*gap]);
        }
}

module pins(){
    h= (Htotal + gap)/2 - gap;
    rad = vert_pin/2;
    color("green")
    for(i=[-2:0]) for(j=[-1:3]) if((i!=-2)||(j!=-1)) translate([step*(j-0.5), (step)*(i),h]) cylinder(r=rad, h=pinhigth);
}

module corners(){
    translate(tr(2.5, 0, 0)) corner(1);
    translate(tr(2.5, -2, 0)) rotate(-90,[0,0,1]) corner(2);
    translate(tr(-0.5, -2, 0)) rotate(180,[0,0,1]) corner();
    translate(tr(-1.5, -1, 0)) rotate(180,[0,0,1]) corner(1);
    translate(tr(-1.5, 0, 0)) rotate(90,[0,0,1]) corner(2);
}

module body(){
    union(){
        difference(){
            union(){
                translate([-2*step + gap, -1*step, -(Htotal + gap)/2]) cube([5*step - 2*gap, 1*step, Htotal]);
                translate([-1*step + gap, -2*step, -(Htotal + gap)/2]) cube([4*step - 2*gap, 1*step, Htotal]);
                
                translate([-1.5*step, -1.5*step + gap, -(Htotal + gap)/2]) cube([4*step, 2*step - 2*gap, Htotal]);
                translate([-0.5*step, -2.5*step + gap, -(Htotal + gap)/2]) cube([3*step, 3*step - 2*gap, Htotal]);                
            }
            
            difference(){
                union(){
                    translate([-2*step+gap+external,-1.5*step+gap+external,-(Htotal + gap)/2 - gap]) cube([4*step-2*gap-2*external,2*step-2*gap-2*external,(Htotal - Hhat) + gap]);
                    translate([-1*step+gap+external,-2.5*step+gap+external,-(Htotal + gap)/2 - gap]) cube([4*step-2*gap-2*external,3*step-2*gap-2*external,(Htotal - Hhat) + gap]);
                    
                    //translate([-step - vert_pin_hole/2, -1.5*step - vert_pin_hole/2, -servow/2]) cube([vert_pin_hole,vert_pin_hole,servow]);
                }
                inner();
            }
        translate([-2*step,-2.5*step+4.3, - servow/2 + 3.5]) cube([2*step,2.0,servow-3.5]);  // wires            
            
        }    
        corners();    
        pins();
    }
}

module inner(){
    translate([0,0,-(Htotal + gap)/2])
    difference(){
        union(){
            translate([-step-internal/2,-1.5*step,0]) cube([internal,2*step,(Htotal-Hhat)]);
            for(i=[0:2]) {
                translate([step*(i)-internal/2,-2.5*step,0]) cube([internal,3*step,(Htotal-Hhat)]);
            }
            
            translate([-1*step,step*(-1.5)-internal/2,0]) cube([4*step,internal,(Htotal-Hhat)]);
            translate([-2*step,step*(-0.5)-internal/2,0]) cube([5*step,internal,(Htotal-Hhat)]);
            
            for(i=[-2:-1]) for(j=[-1:2])
               if((i!=-2)||(j!=-1))translate([step*(j), (step)*(i+0.5),0]) cylinder(r=6.45/2, h=(Htotal-Hhat));              
        }
        for(i=[-2:-1]) for(j=[-1:2]){
                if((i!=-2)||(j!=-1)) translate([step*(j), (step)*(i+0.5),-gap]) cylinder(r=vert_pin_hole/2, h=Htotal);

            }

        

    }

    if(EARS) {   
        translate([-2*step,-1.5*step+gap,0]) rotate(-90,[1,0,0])cylinder(r=step/2-gap, h=2*step - 2*gap);
        translate([ 3*step,-2.5*step+gap,0]) rotate(-90,[1,0,0])cylinder(r=step/2-gap, h=3*step - 2*gap);
    }
}

module eless(){
    difference(){
        body();
        servo3();
        translate([-servow/2,servoh - 2.5*step + 0.2,0]) cube([15, servoh, servow+10]);
    }
}

module full(){
    difference(){
        union(){
            eless();
            translate([-2*step,-1*step+gap,0]) rotate(-90,[1,0,0])cylinder(r=step/2-gap, h=1*step - 2*gap);
            translate([ 3*step,-1*step+gap,0]) rotate(-90,[1,0,0])cylinder(r=step/2-gap, h=1*step - 2*gap);
        }
        holey( 3,0,0);  holey(3,-1,0); innery(3,-2,0); 
        holey(-2,-1,0);  holey(-2,0,0);
    }
}

module  final(){
    if(EARS) full();  
    else eless();
}

if(RIGHT) mirror([1,0,0])  final();
else final();
    
//corners();
//servo3();
//inner();