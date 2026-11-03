`include "dc_transaction.sv"
class dc_sequence extends uvm_sequence#(dc_transaction);
  `uvm_object_utils(dc_sequence)
  function new(string name="dc_sequence");
    super.new(name);
  endfunction
  
  dc_transaction tr;
  int unsigned fps=2;
  
  virtual task body();
    repeat(fps)begin
    tr=dc_transaction::type_id::create("tr");
    start_item(tr);
    tr.randomize();
    finish_item(tr);
      get_response(tr);
    end
  endtask
endclass
