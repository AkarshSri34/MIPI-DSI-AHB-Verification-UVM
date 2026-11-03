class dc_monitor extends uvm_monitor;
  `uvm_component_utils(dc_monitor)
  function new(string name="dc_monitor", uvm_component parent);
    super.new(name,parent);
  endfunction

  uvm_analysis_port#(dc_transaction) dc_send_data;
  dc_transaction tr;
  virtual dc_intf vif;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dc_intf)::get(this,"*","intf",vif))
      `uvm_fatal("NO_VIF","Interface Unable to access")
    dc_send_data=new("dc_send_data",this);
  endfunction
  

  bit [23:0]pixel_queue[$];
  
  virtual task capture_pixel_data();
    @(posedge vif.clk);
    if(vif.data_valid)
      pixel_queue.push_back(vif.pixel_data);
  endtask
   
  virtual task load_in_pixel_mem();
    tr=dc_transaction::type_id::create("tr");
    tr.pixel_data=new[pixel_queue.size()];
    foreach(tr.pixel_data[i])
      tr.pixel_data[i]=pixel_queue.pop_front();
    dc_send_data.write(tr);
  endtask
  
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      fork
        capture_pixel_data();
      join
        load_in_pixel_mem ();
    end
  endtask
  
endclass
