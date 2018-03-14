include <pcb.scad>

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

R = 10.7/2;
H = 42.5;
Rp = 5/2;
Hp = 1.5;
wall = 0.75;

BOTT=2;

L0 = BOTT + wall;

L1 = BOTT+R+wall;
DIV = 12;
L2 = 16.7;

L3 = 27.2;



module AAA(rot=true){
    rotate(-90,[1,0,0]) 
    if(rot){
        color("blue") cylinder(r=R, h=H);
        color("red") translate([0,0,H]) cylinder(r=Rp, h=Hp);
    }   else {
        color("red") cylinder(r=Rp, h=Hp);
        color("blue") translate([0,0,Hp]) cylinder(r=R, h=H);
    }
} 

function tr(x,y,z) = [step*x,step*y,step*z];

module holex(x,y,z){
     color("red") translate([(x+0.5)*step,(y)*step,5.75+(z-1)*step]) rotate(90,[0,1,0]){
        cylinder(h=step, r=5/2, center=true);
        translate([0,0,step/2]) cylinder(h=1.7,r=6.3/2, center=true);
        translate([0,0,-step/2]) cylinder(h=1.7,r=6.3/2, center=true);
     }
}

module corner(H=BOTT){
        difference(){
            cylinder(r=step/2-gap, h=H);
            difference(){
                translate([0,0,-gap]) cylinder(r=step/2-external-gap, h=H+gap);
            }
            translate([-step,-step/2,-gap]) cube([step,step,H + 2*gap]);
            translate([-step/2,-step,-gap]) cube([step,step,H + 2*gap]);
        }
}
module corners(){
    translate(tr(1.5, 5.5, 0)) corner(L0);
    translate(tr(1.5, 0.5, 0)) rotate(-90,[0,0,1]) corner(L0);
    translate(tr(-1.5, 0.5, 0)) rotate(180,[0,0,1]) corner(L0);
    translate(tr(-1.5, 5.5, 0)) rotate(90,[0,0,1]) corner(L0);
}

module bulkhead(H,prot=false){
    translate([-2*step+gap,-internal/2,0]) cube([step-vert_pin_hole/2-gap,internal,H]);
    if(prot) translate([-2*step+gap+ BOTT,-internal/2,L2]) cube([wall+R,internal,H-L2]);    
    translate([step+vert_pin_hole/2,-internal/2,0]) cube([step-vert_pin_hole/2-gap,internal,H]);
}

module pins(x,y){
    rad = vert_pin/2;
    color("green")
    for(i=[-x/2:x/2-1]) for(j=[0:y-1]) translate([step*(i+0.5), (step)*(j+0.5),0]) cylinder(r=rad, h=pinhigth);
}



module bottom(offs=100){
    x=4;
    y=6;
    difference(){
        union(){
            
            difference(){
                union(){
                    translate([-x*step/2+0.5*step+gap,gap,0]) cube([(x-1)*step-2*gap,y*step-2*gap,L0]);
                    translate([-x*step/2+gap,0.5*step+gap,0]) cube([x*step-2*gap,(y-1)*step-2*gap,L0]);
                }
                difference(){
                    translate([-x*step/2+gap+external,gap+external,-gap/2]) cube([x*step-2*gap-2*external,y*step-2*gap-2*external,L0 + gap]);
                
                    inner(x,y,L0);
                }
            }
            
            corners();
        }
    translate([-step*x/2,offs,BOTT]) cube([step*x,100,100]);
    }
}
    
module body(){
    translate([0,1*step,BOTT]) bulkhead(28.5-BOTT);
    translate([0,3*step,BOTT]) bulkhead(28.5-BOTT,true);
    translate([0,5*step,BOTT]) bulkhead(28.5-BOTT,true);
}

module inner(x,y,H){

    difference(){
        union(){
            for(i=[-x/2-1:x/2-1]) 
                translate([step*(i)-internal/2,0,0]) cube([internal,y*step,H]);
            
            for(i=[1:y-1])
                translate([-x*step/2,step*(i)-internal/2,0]) cube([x*step,internal,H]);
            
            for(i=[-x/2+1:x/2-1]) for(j=[1:y-1])
               translate([step*(i), (step)*(j),0]) cylinder(r=6.45/2, h=H);              
        }
        for(i=[-x/2+1:x/2-1]) for(j=[1:y-1])
            translate([step*(i), (step)*(j),-gap/2]) cylinder(r=vert_pin_hole/2, H+gap);
    }
}

module battAndWires(){
    translate([2*step-gap-wall-R,gap+(wall+wire/2),L1])AAA(false);
    translate([2*step-gap-wall-R-DIV,gap+(wall+wire/2),L1])AAA(false);
    translate([(2*step-gap-wall-R)-DIV/2,gap+(wall+wire/2),L2])AAA();
    translate([(2*step-gap-wall-R)-3*DIV/2,gap+(wall+wire/2),L2])AAA();
    translate([-wire,gap+wall+wire/2,L1-2]) cube([wire,wire,L3-L1+2]);
}
module front(){
    H=(step+internal/2-gap);
    color("orange")difference(){
        union(){
            translate([2*step-gap-wall-R,gap,L1]) rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
            translate([2*step-gap-wall-R-DIV,gap,L1])rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
            translate([(2*step-gap-wall-R)-3*DIV/2,gap,L2])rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
            
            //translate([-2*step+gap+BOTT,gap,L2]) cube([2*R,H,28.5-L2]);
            translate([((2*step-gap-wall-R)-3*DIV/2)-R-wall,gap,L2]) cube([2*R,H,28.5-L2]);
            translate([-step,gap,L1]) cube([3*step-gap,H,28.5-L1]);
            
            translate([2*step-gap-wall-R-DIV,gap,L1]) rotate(-35,[0,1,0]) translate([-R-wall,0,0]) cube([2*(R+wall),H,2*R]);

            //translate([-step,step,BOTT])cylinder(r=vert_pin_hole/2,h=L1);
        }
      translate([-2*step,0,28.5]) cube([4*step,1*step,100]);
      translate([2*step-gap-wall-2*R-DIV,gap+wall+wire/2+Hp,L1+1]) cube([2*R+DIV-1,step,L3-3-L1-1]);
      translate([(2*step-gap-wall-R)-3*DIV/2-R+1,gap+wall+wire/2+Hp,L2]) cube([R+1,step,R+3]);
      for(i=[-1:1]) translate([i*step,step,0])cylinder(r=6.45/2,h=L1);
    }
}

module leftSide(){
    difference(){
        union(){
            difference(){
                union(){
                    for(i=[1:5]) translate([-step,i*step,BOTT]) cylinder(r=6.45/2,h=L2-BOTT);
                    translate([-step-internal/2,step-internal/2,BOTT]) cube([internal,4*step+internal,L2-BOTT]);
                }
                ;
            }
            translate([(2*step-gap-wall-R)-3*DIV/2,step-internal/2,L2])rotate(-90,[1,0,0]) cylinder(r=R+wall,h=4*step+internal);            
        }
        for(i=[1:5]) translate([-step,i*step,BOTT-gap]) cylinder(r=vert_pin_hole/2,h=L2);
        translate([-step+internal/2,0,0]) cube([50,6*step,50]);
        //translate([-2*step,5*step+internal/2,0]) cube([4*step,6*step,50]);
        //translate([-2*step,0,0]) cube([4*step,step-internal/2,50]);        
    }
}

module cover(offs=5*step+internal/2){
    color("lightblue"){
        
    H=(step-gap-internal/2);
        
    translate([2*step-gap-wall-R,offs,L1]) rotate(-90,[1,0,0]) cylinder(r=R,h=H);
    translate([2*step-gap-wall-2*R,offs,L1]) cube([2*R,H,28.5-L1]);
        
    translate([2*step-gap-wall-R-DIV,offs,L1])rotate(-90,[1,0,0]) cylinder(r=R,h=H);
    translate([2*step-gap-wall-2*R-DIV,offs,L1]) cube([2*R,H,28.5-L1]);
    
    translate([2*step-gap-wall-R-DIV,offs,L1+1]) cube([2*R,H,28.5-L1-1]);        
        
    translate([2*step-gap-wall-R-DIV,offs,L1]) rotate(-35,[0,1,0]) translate([-R,0,0]) cube([2*R,H,2*R]);
        
    translate([2*step-gap-wall-R-3*DIV/2,offs,L2])rotate(-90,[1,0,0]) cylinder(r=R,h=H);
    translate([2*step-gap-wall-2*R-3*DIV/2,offs,L2]) cube([2*R,H,28.5-L2]);        
}}
module back(){
    H=(step-gap-internal/2);
    difference(){
        union(){
            translate([2*step-gap-wall-R,5*step+internal/2,L1]) rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
            translate([2*step-gap-wall-R-DIV,5*step+internal/2,L1])rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
            translate([(2*step-gap-wall-R)-3*DIV/2,5*step+internal/2,L2])rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
            translate([2*step-gap-wall-R-DIV -5,5*step+internal/2,L1]) cube([(wall+R+DIV +5),H,28.5-L1]);
            translate([(2*step-gap-wall-R)-3*DIV/2 -R -wall,5*step+internal/2,L2]) cube([10,H,28.5-L2]);

            translate([2*step-gap-wall-R-DIV,5*step+internal/2,L1]) rotate(-35,[0,1,0]) translate([-R-wall,0,0]) cube([2*(R+wall),H,2*R]);
        }
        
        }
}
difference(){
    union(){
        bottom();
        color("green") body();
        color("green") translate([0,0,28.5]) pins(2,5);
        color("green") translate([-2*step+gap+BOTT,step/2,L3]) cube([4*step-2*gap-BOTT,5*step,(28.5-L3)]);
        
        front();
        back();
        cover();
        diff = (28.5-L3);
        echo("hat is ",diff);
        
        color("grey"){
            // 
            translate([-2*step+gap+BOTT,step,L2]) cube([wall,4*step,L3-L2]);
            leftSide();
        }
        color("lightgrey") translate([2*step-gap-wall,step,L0]) cube([wall,4*step,L3-(L0)]);
        //color("grey") translate([-2*step+gap+BOTT,step,L0]) cube([wall,4*step,L3-(L0)]);
    }
    
    battAndWires();

    translate([1,gap+wall+wire,L3]) rotate(180,[0,1,0]) { pcb();  pcbOutside(); }
        
    cover();
    //translate([-2*step,0,0]) cube([4*step, 5*step,50]);
}

//holex(-2,2,1);
//holex(-2,4,1);


//battAndWires();
//front();
/*
color("green"){
    body();
    //translate([-2*step+gap,0,0]) cube([2+wall,50,50]);
    //translate([2*step-gap-wall,0,0]) cube([wall,50,50]);
}
*/

/*
translate([1,wall+wire,L3]) rotate(180,[0,1,0]) {
    pcb();
    pcbOutside();
}
*/
//corners();
//servo3();
//inner();