class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
   
    `uvm_analysis_imp_decl(_W)
    `uvm_analysis_imp_decl(_R)

    virtual apb_if vif;
  
    tx_item trans_write;
    tx_item trans_read;
    
    uvm_analysis_imp_W #(tx_item, scoreboard) sb_export_write;
    uvm_analysis_imp_R #(tx_item, scoreboard) sb_export_read;
    
    bit   WPSLVERR, RPSLVERR;
    bit [31:0]    read_q[$];
    bit [31:0]    write_q[$];
    bit [31:0]   write,read;
    int compare_pass =0, compare_fail =0;
        
    function new (string name ="scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export_write = new("sb_export_write", this);
        sb_export_read = new("sb_export_read", this);
        if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
            `uvm_error("build_phase","driver virtual interface failed")
        end
    endfunction
        
    virtual function void write_W (input tx_item trans);
        write_q.push_back(trans.PWDATA);
        WPSLVERR = trans.PSLVERR;
        `uvm_info("SB",$sformatf("Got Write Transaction: write queue size =%0d PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PWDATA =%0d PSLVERR = %0d", write_q.size(),trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PWDATA,trans.PSLVERR),UVM_DEBUG)
    endfunction
 
    virtual function void write_R (input tx_item trans);
        read_q.push_back(trans.PRDATA);
        RPSLVERR = trans.PSLVERR;
        `uvm_info("SB",$sformatf("Got Read Transaction: read q size =%0d PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PRDATA =%0d PSLVERR = %0d",read_q.size(), trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PRDATA,trans.PSLVERR),UVM_DEBUG)
    endfunction
  
    task run_phase(uvm_phase phase);

        forever begin
            @(posedge vif.PCLK) begin 
                if(WPSLVERR || RPSLVERR) begin
                    if(WPSLVERR) write_q.pop_front();
                    if(RPSLVERR) read_q.pop_front();
                end
                else begin
                    if(write_q.size() >0 && read_q.size() >0) begin 
                        read  = read_q.pop_front();
                      if(read) 
                        write = write_q.pop_front();
                       compare();
                    end
                end

            end
        end
    endtask
  
   
    virtual function void compare();
        if(write == read) begin
            `uvm_info("compare", $sformatf("Test: OK! Write Data = %0d Read Data = %0d",write,read), UVM_LOW);
            compare_pass++;
        end
        else begin
            `uvm_info("compare", $sformatf("Test: Fail! Write Data = %0d Read Data = %0d",write,read), UVM_LOW);
            compare_fail++;
        end
    endfunction: compare 
    
     //Report Phase 
  	function void report_phase(uvm_phase phase);
   		super.report_phase(phase);
 
        if(compare_fail>0) begin
                    `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
            `uvm_info(get_type_name(), $sformatf("----       TEST FAIL COUNTS  %0d     ----",compare_fail), UVM_NONE)
                    `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        end
        if(compare_pass>0)begin
                    `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
            `uvm_info(get_type_name(), $sformatf("----       TEST PASS COUNTS  %0d     ----",compare_pass), UVM_NONE)
                    `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        end
  	endfunction : report_phase  
endclass