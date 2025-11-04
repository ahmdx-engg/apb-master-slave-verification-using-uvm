class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  
  apb_env env;
  first_sequence wrs;

    function new(string name ="apb_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
  
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = apb_env::type_id::create("env",this);
	    wrs = first_sequence::type_id::create("wrs");
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology;
        `uvm_info(get_full_name,$sformatf("In end of elaboration  phase"),UVM_HIGH)
    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection (this);
        $display("%t Starting sequence fifo_seq run_phase",$time);
        wrs.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass