import uvm_pkg::*;
`include "uvm_macros.svh"
class dc_transaction extends uvm_sequence_item;
  //`uvm_object_utils(dc_transaction)

  function new(string name = "dc_transaction");
    super.new(name);
  endfunction
typedef enum {QQVGA,QVGA, CIF, CIF_PLUS,VGA, HD, FULL_HD} resolution_e;
  // --------------------------------------------------------
  // Resolution selection
  // --------------------------------------------------------
  rand resolution_e res_type;
  
    // Constraint ? resolution must be inside enum range
  constraint c_resolution {res_type inside {[0:6]};}



  bit [23:0] pixel_data[];
  
  `uvm_object_utils_begin(dc_transaction)
`uvm_field_array_int(pixel_data, UVM_ALL_ON | UVM_DEC)     
  `uvm_object_utils_end
  // --------------------------------------------------------
  // DSI Timing parameters
  // --------------------------------------------------------
  randc int unsigned HPW;   // HSYNC pulse width
  randc int unsigned HBP;   // HSYNC back porch
  randc int unsigned HFP;   // HSYNC front porch
  
  randc int unsigned VPW;   // VSYNC pulse width
  randc int unsigned VBP;   // VSYNC back porch
  randc int unsigned VFP;   // VSYNC front porch
  
  constraint HPW_c1{HPW inside {[5:10]};}
  constraint HBP_c2{HBP inside {[2:5]};}
  constraint HFP_c3{HFP inside {[2:5]};}
  constraint VPW_c4{VPW inside {[5:10]};}
  constraint VBP_c5{VBP inside {[2:5]};}
  constraint VFP_c6{VFP inside {[2:5]};}


  int unsigned htotal;// HTOTAL ? Total Horizontal Pixels (active + blanking)
  int unsigned vtotal;// VTOTAL ? Total Vertical Lines (active + blanking)
  
  int unsigned hbe; // HBE ? Horizontal Begin of active video  
  int unsigned hbs; // HBS ? Horizontal Begin of Sync  
  int unsigned vbe; // VBE ? Vertical Begin of active video
  int unsigned vbs; // VBS ? Vertical Begin of Sync 
  
  

  int unsigned width;
  int unsigned height;
  // --------------------------------------------------------
  // Post-randomize: 
  // --------------------------------------------------------
   function void post_randomize();
    // Resolution lookup
    case (res_type)
      QQVGA:    begin width = 16;  height = 12;  end //160x120
      QVGA:     begin width = 32;  height = 24;  end //320x240
      CIF:      begin width = 35;  height = 28;  end //352x288
      CIF_PLUS: begin width = 10;  height = 10;  end //704x576
      VGA:      begin width = 64;  height = 48;  end //640x480
      HD:       begin width = 12; height = 7;  end //1280x720
      FULL_HD:  begin width = 19; height = 10; end //1920x1080
    endcase

    `uvm_info(get_type_name(),$sformatf("Selected Resolution = %s(%0dx%0d)",res_type, width, height),UVM_LOW)
    // Horizontal timing calculations
    htotal = HPW + HBP + width + HFP;
    hbe    = HPW + HBP;
    hbs    = HPW + HBP + width;
    // Vertical timing calculations
     vtotal =VPW+VBP+(htotal*height)+VFP;
     vbe    = VPW + VBP;
     vbs    = VPW + VBP + (htotal*height);
    `uvm_info(get_type_name(),$sformatf("HTotal=%0d, VTotal=%0d", htotal, vtotal),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("hbe=%0d, hbs=%0d", hbe, hbs),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("vbe=%0d, vbs=%0d", vbe, vbs),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("hbe=%0d, hbs=%0d", hbe, hbs),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("vbe=%0d, vbs=%0d", vbe, vbs),UVM_LOW)
  endfunction

endclass

