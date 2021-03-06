// HEX CELL CAPS
// This script generates a model of end caps for building 
// battery packs using cylindrical cells. 
// Original concept by ES user "SpinningMagnets"
// More info can be found here:
// https://endless-sphere.com/forums/viewtopic.php?f=3&t=90058
//
// This file was created by Addy and is released as public domain
// 11/29/2017 V1.3




// CONFIGURATION

opening_dia = 12;   // Circular opening to expose cell 
cell_dia = 18.2;    // Cell diameter (18.2 for 18650)
wall = 0.8;           // Wall thickness around a single cell. Spacing between cells is twice this amount.
holder_height = 10;  // Total height of cell holder
separation = 1;   // Separation between cell top and tab slots
slot_height = 2;    // Height of all slots
col_slot_width = 4; // Width of slots between rows
row_slot_width = 8; // Width of slots along rows

rect_style = 1;     // 1 for rectangular shape pack, 0 for rhombus
part = "both";       // "normal","mirrored", or "both"  You'll want a mirrored piece if the tops and bottom are different

num_rows = 2;       
num_cols = 8;

$fn = 90;       // Number of facets for circular parts.  
extra = 0.1;    // enlarge hexes by this to make them overlap
spacing = 4;    // Spacing between top and bottom pieces when printing both pieces
// END OF CONFIGURATION



hex_w = cell_dia + 2*wall;
hex_pt = (hex_w/2 + extra) / cos(30);


if (part == "mirrored")
    mirror_pack();
else if(part == "both")
{
    regular_pack();
    if(num_rows % 2 == 1)   // If odd pack
    {
       translate([hex_w/2, 1.5*(hex_pt-extra)*num_rows + spacing,0])
       mirror_pack();
    }
    else
    {
        translate([0,1.5*(hex_pt-extra)*num_rows + spacing,0])
        mirror_pack();
    }
}
else
    regular_pack();



echo(total_height=1.5*(hex_pt-extra)*(num_rows-1)+hex_pt*2);

if (rect_style)
    echo(total_width=hex_w*(num_cols+0.5));
else
    echo(total_width=hex_w*(num_cols+0.5*(num_rows-1)));

  

module regular_pack()
{
    union()
    {
        for(row = [0:num_rows-1])
        {
            
            if (rect_style)
            {
                if ((row % 2) == 0)
                {            
                    translate([0,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            single_hex();
                    }                
                }
                else
                {
                    translate([0.5 * hex_w,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            single_hex();
                    }
                }
            }
            else if (rect_style == 0)
            {
                translate([row*(0.5 * hex_w),1.5*(hex_pt-extra)*row,0])
                for(col = [0:num_cols-1])
                {
                    translate([hex_w*col,0,0])
                        single_hex();
                }

            }
        }
    }      
}

module mirror_pack()
{
    union()
    {
        for(row = [0:num_rows-1])
        {
            
            if (rect_style)
            {
                if ((row % 2) == 0)
                {            
                    translate([0,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            single_hex();
                    }                
                }
                else
                {
                    translate([-0.5 * hex_w,1.5*(hex_pt-extra)*row,0])
                    for(col = [0:num_cols-1])
                    {
                        translate([hex_w*col,0,0])
                            single_hex();
                    }
                }
            }
            else if (rect_style == 0)
            {
                translate([-row*(0.5 * hex_w),1.5*(hex_pt-extra)*row,0])
                for(col = [0:num_cols-1])
                {
                    translate([hex_w*col,0,0])
                        single_hex();
                }

            }
        }
    }      
}


module single_hex()
{
    difference()
    {
        // Hex block
        linear_extrude(height=holder_height, center=false, convexity=10)
            polygon([ for (a=[0:5])[hex_pt*sin(a*60),hex_pt*cos(a*60)]]); 
                
        // Top opening    
        translate([0,0,-1])
            cylinder(h=holder_height+2,d=opening_dia);
          
        // Cell space    
        //#translate([0,0,-holder_height])
            //cylinder(h=2*(holder_height-slot_height),d=cell_dia);
            cylinder(h=2 *(holder_height-slot_height-separation) ,d=cell_dia, center=true);
        
        // 1st column slot
        rotate([0,0,60])
            translate([0,0,holder_height])    
                cube([hex_w+1,col_slot_width,2*slot_height], center=true);    
            
        // 2nd column slot    
        rotate([0,0,-60])
            translate([0,0,holder_height])    
                cube([hex_w+1,col_slot_width,2*slot_height], center=true);
       
        // Row slot 
        translate([0,0,holder_height]) 
            cube([hex_w+1,row_slot_width,2*slot_height], center=true);   
    }   
}

