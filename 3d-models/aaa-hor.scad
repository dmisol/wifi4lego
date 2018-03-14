include <pcb.scad>
// todo - hole for a switch
// cut batt's bottom at front

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

DIV = 12;

L0 = BOTT + wall;
L1 = BOTT+R+wall;
L2 = 16.7;
/*
L0 = BOTT;
L1 = BOTT+R;
L2 = 16.7-wall;
*/
L3 = 27.2;

Ltop = 28.5;

deltax = 4;      // mounting holes
deltay = 0.3;

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

module pins(x,y){
    rad = vert_pin/2;
    color("green")
    for(i=[-x/2:x/2-1]) for(j=[0:y-1]) translate([step*(i+0.5), (step)*(j+0.5),0]) cylinder(r=rad, h=pinhigth);
}

module cutfront(){
    translate([2*step-gap-wall-(3*step-internal/2-wall-gap),gap+wall,BOTT])
    rotate(90,[0,1,0]) 
    linear_extrude(height=(3*step-internal/2-wall-gap)){
        polygon(points=[[0,0],[0,R],[-R,R]]);
    }
}
module battBody(front = (gap+wall+wire/2+Hp) ){
    H=(6*step-2*gap);
    difference(){
        union(){
            difference(){
                union(){
                    translate([2*step-gap-wall-R,gap,L1]) rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
                    translate([2*step-gap-wall-R-DIV,gap,L1])rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
                    translate([(2*step-gap-wall-R)-3*DIV/2,gap,L2])rotate(-90,[1,0,0]) cylinder(r=R+wall,h=H);
                    translate([2*step-gap-wall-R-DIV -5,gap,L1]) cube([(wall+R+DIV +5),H,Ltop-L1]);
                    translate([(2*step-gap-wall-R)-3*DIV/2 -R -wall,gap,L2]) cube([10,H,Ltop-L2]);
                    translate([2*step-gap-wall-R-DIV,gap,L1]) rotate(-35,[0,1,0]) translate([-R-wall,0,0]) cube([2*(R+wall),H,2*R]);
                    

                    for(i=[1:5]) translate([-step,i*step,BOTT]) cylinder(r=6.45/2,h=L2-BOTT);
                    translate([-step-internal/2,step-internal/2,BOTT]) cube([internal,4*step+internal,L2-BOTT]);

                    color("green") translate([2*step-gap-wall-R-DIV-1.3,3*step,L1-R+3]) rotate(-35,[0,1,0]) translate([-R-wall,0,0]) cube([2*R,3*step-gap,2*R-3]);
                    
                    for(i=[0:2]) translate([-2*step+gap,step-internal/2 +2*i*step, BOTT]) cube([step, internal, Ltop-BOTT]);
                        
                    //walls at the bottom of the lower batteries
                    color("blue") translate([2*step-gap-wall, step/2,BOTT]) cube([wall,5.5*step+internal/2,2*R]);
                    //front
                    color("blue") translate([-step-internal/2, gap,BOTT]) cube([3*R,wall,2*R]);
                    color("blue") translate([-step-internal/2, gap,BOTT]) cube([internal,step/2+1,R]);                   
                }
                translate([2*step-gap-wall-R, front, L1]) rotate(-90,[1,0,0]) cylinder(r=R,h=H+2*gap);
                translate([2*step-gap-wall-R-DIV, front, L1])rotate(-90,[1,0,0]) cylinder(r=R,h=H+2*gap);
                translate([2*step-gap-wall-R-DIV, front, L1-R]) cube([2*R,H+2*gap,2*R]);
                translate([(2*step-gap-wall-R)-3*DIV/2, front, L2])rotate(-90,[1,0,0]) cylinder(r=R,h=H+2*gap);
                translate([(2*step-gap-wall-R)-DIV/2, front, L2])rotate(-90,[1,0,0]) cylinder(r=R,h=H+2*gap);
                translate([2*step-gap-R-DIV, front, L1]) rotate(-35,[0,1,0]) translate([-R-wall,0,0]) cube([2*(R),H+2*gap,2*R]);
                translate([2*step-gap-R, front, L1]) rotate(-35,[0,1,0]) translate([-R-wall,0,0]) cube([2*(R),H+2*gap,2*R]);
                
                color("magenta") translate([-step+internal/2,front,BOTT]) cube([3*step - internal/2 - gap - wall, 6*step-internal, R]);

                //cover above the upper batteries
                translate([(2*step-gap-wall)-3*DIV/2, front, L2+R-7.5]) rotate(-90,[1,0,0]) cylinder(r=9,h=H+2*gap);
                
                for(i=[1:5]) for(j=[-1:1]) translate([j*step,i*step,BOTT]) cylinder(r=vert_pin_hole/2,h=L2-4);
                
                cutfront();
                
                // hack - remove stuff below pcb
                translate([-7,3.5,BOTT+2*R]) cube([17,36,50]);
                translate([-7,3.5,BOTT+2*R]) cube([10,38.5,50]);
                }
            
            // mounting for screws    
            color("green") translate([2*step-gap-wall-2*R-DIV - deltax, 4.5*step, L1+deltay]) rotate(90,[1,0,0]) cylinder(r=3,h=3*step-2*gap,center=true);
            color("green")  translate([(2*step-gap-wall-R)-DIV/2 +R + deltax , 4.5*step, L2-deltay]) rotate(90,[1,0,0]) cylinder(r=3,h=3*step-2*gap,center=true);                
            }
        color("red") translate([2*step-gap-wall-2*R-DIV - deltax, 5*step, L1+deltay]) rotate(90,[1,0,0]) cylinder(r=1.5,h=30,center=true);
        color("red")  translate([(2*step-gap-wall-R)-DIV/2 +R + deltax , 5*step, L2-deltay]) rotate(90,[1,0,0]) cylinder(r=1.5,h=30,center=true);
        }
}

module bottom(){
    difference(){
        union(){
            translate([-1.5*step,gap,0]) cube([3*step,6*step-2*gap,L0]);
            translate([-2*step+gap,step/2,0]) cube([4*step-2*gap,5*step,L0]);
            translate([-1.5*step,0.5*step,0]) cylinder(r=step/2-gap,h=L0);
            translate([ 1.5*step,0.5*step,0]) cylinder(r=step/2-gap,h=L0);
            translate([-1.5*step,5.5*step,0]) cylinder(r=step/2-gap,h=L0);
            translate([ 1.5*step,5.5*step,0]) cylinder(r=step/2-gap,h=L0);            
        }
        difference(){
            union(){
                translate([-1.5*step,gap+external,-gap/2]) cube([3*step,6*step-2*gap-2*external,L0 + gap]);
                translate([-2*step+gap+external,step/2,-gap/2]) cube([4*step-2*gap-2*external,5*step,L0 + gap]);
                translate([-1.5*step,0.5*step,-gap/2]) cylinder(r=step/2-external-gap,h=L0 + gap);
                translate([ 1.5*step,0.5*step,-gap/2]) cylinder(r=step/2-external-gap,h=L0 + gap);
                translate([-1.5*step,5.5*step,-gap/2]) cylinder(r=step/2-external-gap,h=L0 + gap);
                translate([ 1.5*step,5.5*step,-gap/2]) cylinder(r=step/2-external-gap,h=L0 + gap);  
            }
            //translate([-2*step+gap+external,gap+external,-gap/2]) cube([4*step-2*gap-2*external,6*step-2*gap-2*external,L0 + gap]);
                
            inner(4,6,L0);
        }
    }
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
    
    translate([-wire,gap+wall+wire/2+H+Hp,L1-2]) rotate(-35,[0,1,0]) cube([wire,wire,15]);
    translate([-wire+DIV,gap+wall+wire/2+H+Hp,L1-2]) rotate(-35,[0,1,0]) cube([wire,wire,15]);
}

module coverShape(offs=43, H0=BOTT, H1=17){
    R=7;
    color("lightblue"){
        
    translate([-2*step, offs, H0]) cube([4*step,10, H1-H0]);
//    translate([-2*step, offs, H1]) rotate(-35.5,[1,0,0]) cube([4*step,10, 20]);
    translate([0, offs+R, H1]) rotate(90,[0,1,0]) cylinder(r=R,h=40,center=true);
}}



difference(){
    union(){
        bottom();
        battBody();
        color("green") translate([0,0,Ltop]) pins(4,6);
        }
    
    battAndWires();

    translate([1,gap+wall+wire,L3]) rotate(180,[0,1,0]) { pcb();  pcbOutside(); }
        
    coverShape();
    
    translate([-2*step+BOTT+wall,gap+wall,L3-1.31]) cube([4*step-2*gap-BOTT-2*wall, pcbLength,50]);
}
//translate([1,gap+wall+wire,L3]) rotate(180,[0,1,0]) { pcb();  pcbOutside(); }
//battAndWires();
//coverShape();
//front();
