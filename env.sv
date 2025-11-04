class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  agent agt;
  scoreboard     sb;
  // cov_colect cm;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = agent :: type_id :: create ("agent", this);
        sb = scoreboard:: type_id :: create("sb",this);
        // cm = cov_collect:: type_id :: create("cm",this);

    endfunction
  
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
    agt.mon.wap.connect(sb.sb_export_write);
    agt.mon.rap.connect(sb.sb_export_read);

    agt.drv.seq_item_port.connect(agt.sqr.seq_item_export);

   endfunction
endclass