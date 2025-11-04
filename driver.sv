class driver extends uvm_driver#(tx_item);
    `uvm_component_utils(driver)
    virtual apb_if vif; 
  
  //Constructor
    function new(string name ="driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction 
  
  //Build Phase 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
            `uvm_error("build_phase","driver virtual interface failed")
        end
    endfunction
  
  //Run Phase
    task run_phase(uvm_phase phase);
   
        tx_item trans;
        trans = tx_item::type_id::create("trans");
        
        forever begin
            wait(!vif.PRESET);
            @(posedge vif.PCLK) begin  
                seq_item_port.get_next_item(trans);
                if(trans.PWRITE) begin
                    `uvm_info("WDRIVER",trans.convert2string(),UVM_DEBUG)
                    vif.PWRITE = trans.PWRITE;
                    vif.PSEL = trans.PSEL;
                    vif.PADDR = trans.PADDR;
                    vif.PWDATA = trans.PWDATA;
                    vif.PSTRB  = trans.PSTRB;

                    @(posedge vif.PCLK)
                        vif.PENABLE = trans.PENABLE;
       
                    //wait for ready signal
                    while(!vif.PREADY) begin
                        @(posedge vif.PCLK);
                            `uvm_info("WDRIVER",$sformatf("Wating for ready signal"),UVM_DEBUG)
                    end    
                    if(vif.PSLVERR)
                        `uvm_info("WDRIVER",$sformatf("write operation UNSUCCESSFUL"),UVM_DEBUG)
                    else  
                        `uvm_info("WDRIVER",$sformatf("write operation SUCCESSFUL"),UVM_DEBUG)
         
                    @(posedge vif.PCLK);
                        vif.PENABLE = 0;
                        vif.PSEL = 0; 
                end  
         
                else begin
                    `uvm_info("WDRIVER",trans.convert2string(),UVM_DEBUG)
                    vif.PWRITE = trans.PWRITE;
                    vif.PSEL = trans.PSEL;
                    vif.PADDR = trans.PADDR;
                    @(posedge vif.PCLK)
                        vif.PENABLE = trans.PENABLE;
                    //wait for ready signal
                    while(!vif.PREADY) begin
                        @(posedge vif.PCLK); 
                            `uvm_info("WDRIVER",$sformatf("Ready signal is not high"),UVM_DEBUG)
                        end
                    
                    if(vif.PSLVERR)
                        `uvm_info("WDRIVER",$sformatf("read operation UNSUCCESSFUL"),UVM_DEBUG)
                    else
                        `uvm_info("WDRIVER",$sformatf("read operation SUCCESSFUL"),UVM_DEBUG)
                    
                    @(posedge vif.PCLK);
                        vif.PENABLE = 0;
                        vif.PSEL = 0;   
                end 
       
                seq_item_port.item_done();
                `uvm_info("WDRIVER",$sformatf("Transaction Done"),UVM_DEBUG)
            end
        end
    
      endtask
endclass  