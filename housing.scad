
length=24.6;
side=7.9;
inside=5.1;
round_to_tip=9.9;
round_radius=1.3;
pair_length=41.2;
tip_wall=1; // FIXME measure

groove_small = 3.1;
groove_large = 3.5;
groove_depth = 0.6;
groove_length = 11.0;

overlap=2*length - pair_length;
wall = (side-inside)/2;
tip_side = side - 2*tip_wall;
tip_depth = round_to_tip - round_radius;

module groove(){
	linear_extrude(groove_length)
	polygon([
		[0,-groove_small/2],
		[0,groove_small/2],
		[-groove_depth, groove_large/2],
		[-groove_depth,-groove_large/2],
	]);
}

difference(){
	cube([side,side,length]);
	// wire port
	translate([wall,wall,round_to_tip+round_radius]) cube([inside,inside,length]);
	// side holes
	for(i=[0,side]) // fixme
		translate([i, 0, round_to_tip]) rotate([-90,0,0]) cylinder(side,round_radius,$fn=36);
	// cutout for opposite shell
	difference(){
		cube([side, side/2, overlap]);
		// tongue
		translate([tip_wall,0,0]) cube([tip_side, tip_side/2+tip_wall/2, tip_depth]);
	};
	// cutout for opposite tongue
	translate([tip_wall,side/2,0]) cube([tip_side, tip_side/2, overlap]);
	// tongue hole through to back
	translate([tip_wall*2,tip_wall,tip_wall]) cube([tip_side-2*tip_wall,tip_side/2-tip_wall/2,round_to_tip+round_radius]);
	// grooves
	translate([side, side/2, length-groove_length]) groove();
	translate([side/2, 0, length-groove_length]) rotate([0,0,-90]) groove();
}
translate([0, side/2, length-groove_length]) groove();
translate([side/2, side, length-groove_length]) rotate([0,0,-90]) groove();
