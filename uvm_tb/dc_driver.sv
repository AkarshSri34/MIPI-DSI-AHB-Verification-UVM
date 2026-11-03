class dc_driver extends uvm_driver#(dc_transaction);
  `uvm_component_utils(dc_driver)
  function new(string name="dc_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  // Virtual Interface + Transaction Handle
  virtual dc_intf vif;
  dc_transaction tr;
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dc_intf)::get(this, "*", "intf", vif))
      `uvm_fatal("NO_VIF", "Unable to access virtual interface")
  endfunction

  //------------------------------------------
  // Drive Hsync Across Frame 
  //------------------------------------------
  virtual task drive_1_hsync();
    repeat (tr.vbe+1) @(posedge vif.clk);
    for (int i = 0; i < tr.height; i++) begin
             vif.hsync <= 1;
          repeat (tr.HPW) @(posedge vif.clk);
             vif.hsync <= 0;
          repeat (tr.htotal - tr.HPW) @(posedge vif.clk);
      end
  endtask

  //------------------------------------------
  // Vsync Drive (full frame cycle)
  //------------------------------------------
  virtual task drive_2_vsync();
    @(posedge vif.clk);
    vif.vsync <= 1;
    repeat (tr.VPW) @(posedge vif.clk);
    vif.vsync <= 0;
  endtask
    

  //------------------------------------------------
  // Drive Pixel Data Across Frame (only data path)
  //------------------------------------------------
  virtual task drive_3_data();
    vif.data_valid <= 0;
    vif.pixel_data<=0;
    repeat (tr.vbe+1) @(posedge vif.clk);
    for (int i = 0; i < tr.height; i++) 
      begin
       repeat(tr.hbe) @(posedge vif.clk);
        for (int j = 0; j < tr.width; j++) 
        begin
             vif.pixel_data <= $urandom_range(0,24'hFFFFFF);
             vif.data_valid <= 1;
             @(posedge vif.clk);
         end
             vif.data_valid <= 0;
             vif.pixel_data <= 0;
             repeat(tr.HFP)@(posedge vif.clk);
    end
    repeat(tr.VFP-1)@(posedge vif.clk);
  endtask
  //------------------------------------------
  // Run Phase (Main Driver Logic)
  //------------------------------------------
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tr);
     `uvm_info(get_type_name(),$sformatf("HPW=%0d HBP=%0d HFP=%0d",tr.HPW, tr.HBP, tr.HFP),UVM_LOW)
     `uvm_info(get_type_name(),$sformatf("VPW=%0d VBP=%0d VFP=%0d",tr.VPW, tr.VBP, tr.VFP),UVM_LOW)
      fork
        drive_1_hsync();      // All Hsync operations
        drive_2_vsync();  // Vsync pulse + frame timing
        drive_3_data();      // All pixel data driving
      join
      seq_item_port.item_done(tr);
    end
  endtask
endclass

