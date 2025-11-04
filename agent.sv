class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  sequencer sqr;
  driver   drv;
  monitor  mon;
  //constructor
  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
    uvm_analysis_port #(tx_item) dut_in_tx_port;
    uvm_analysis_port #(tx_item) dut_out_tx_port;

  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = sequencer::type_id::create("sqr",this);
    drv = driver::type_id::create("drv",this);
    mon = monitor::type_id::create("mon",this);
    dut_in_tx_port=new("dut_in_tx_port",this);
    dut_out_tx_port=new("dut_out_tx_port",this);
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon.wap.connect(dut_in_tx_port);
    mon.rap.connect(dut_out_tx_port);
    drv.seq_item_port.connect(sqr.seq_item_export);
    `uvm_info("WAGENT",$sformatf("Connected Sequencer to Driver"),UVM_LOW)
  endfunction
endclass

    