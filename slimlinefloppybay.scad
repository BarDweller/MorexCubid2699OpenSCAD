width=96;                 //width for bay
height=14;                //height for bay
depth=4;                  //depth (height as printed) for rim wall

wallthick=1;              //thickness for all walls

wflange=1;                //flange extra width on sides
flangeoffset=0.5;         //offset from front plate
flangethickness=0.5;      //thickness for flange

//clip dimensions
clipwidth=5;
clipthick=wallthick;       //total width for upright
clipheight=7;              //total height
retainerthick=wallthick*2; //total width for overhang
retainerheightinclip=2.5;  //total height for slope part.

module originalrim(){
  difference(){
    cube( [height,width,depth], center=true );
    cube( [height-(wallthick*2),width-(wallthick*2),depth+2], center=true );
  }
}

module baseplate(){
  translate([0,0,-depth/2+wallthick])
    cube( [height,width,wallthick], center=true );
}

module flanges(){
  translate( [0,width/2,-(depth/2)+flangeoffset] )
    cube( [height,wflange,flangethickness], center=true );
  translate( [0,-width/2,-(depth/2)+flangeoffset] )
    cube( [height,wflange,flangethickness], center=true );   
}

module prism(l, w, h){
  //centered.
  translate([-l/2,-w/2,-h/2])
     polyhedron(
             points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
             faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
             );
}

//a single retention clip
module clip(){
  translate([0,0,-retainerheightinclip/2 ]){
    cube( [clipwidth,clipthick,clipheight-retainerheightinclip], center=true );
    translate( [0,-retainerthick/2+clipthick/2,(clipheight-retainerheightinclip)/2 + (retainerheightinclip/2)] )
      prism(clipwidth,retainerthick,retainerheightinclip);
  }
}

module leftclip(){
  clip();
}
module rightclip(){
  rotate([0,0,180])
    clip();
}

module clips(){
  translate([0,-width/2 + retainerthick/2 - clipthick/2 , clipheight/2 - depth/2 + wallthick]) color("red") leftclip();
  translate([0,width/2 - retainerthick/2 + clipthick/2 , clipheight/2 - depth/2 + wallthick]) color("red") rightclip();
}


//mounting for a barreljack.. 
screwmountdistance = 18; //separation for screw holes
screwmountradius=1/2;    //radius for screw holes
barrelradius = 7/2;      //radius for barreljack (centered between screwholes)
module powersocketstamp(){
  translate([0,-screwmountdistance/2,-wallthick/2]){
    translate([0,0,0])
      cylinder(r=screwmountradius,h=wallthick*3,center=true);
    translate([0,screwmountdistance/2,0])
      cylinder(r=barrelradius,h=wallthick*3,center=true);
    translate([0,screwmountdistance,0])
      cylinder(r=screwmountradius,h=wallthick*3,center=true);  
  }
}

//edge wall
originalrim();
//pointless original detail
flanges();
//retentionclips
clips();
//baseplate, punched out for barreljack. (just use baseplate(); if you dont want barreljack)
difference(){
  baseplate();
  //move the barrel jack over to one edge (remove translate to leave centered)
  translate([0,(width-(wallthick*10))/screwmountdistance * (screwmountdistance/2) - (screwmountdistance/2),0])
    powersocketstamp();
}




