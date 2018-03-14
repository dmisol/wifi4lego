# README #

## 3D-models ##

3d-models contains OpenSCAD files that survived after HDD crash:
* aaa-hor.scad is enclosure for PCB and 4 AAA recharcheable batteries
* m1.scad is an enclosure for 9g servo. 
Please note:
1. servo should be modified to enable 360 degree rotation
2. 3d printer should be paused before printing the roof, to embed servo itself

## remained software ##

Software structure is inherited from https://github.com/Spritetm, see https://github.com/dmisol/wifi4lego/wiki

ToDO: actual manual will be added

## Eagle ##

sch and pcb files were lost during HDD crash (with both home and git folders)

ESP-03 is connected as follows:
GND  -> GPIO15, GND
3.3V -> CH_PD, VCC
PWM0 -> GPIO12
PWM1 -> GPIO13
PWM2 -> GPIO14
RX,TX -> URXD,UTXD (for flashing)
FLASH -> GPIO0 (for flashing)

Will also try to fetch Gerber files from Seeed, if they are keeping archive of orders
