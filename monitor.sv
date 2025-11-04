class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
    virtual apb_if vif;
    uvm_analysis_port#(tx_item) wap;
    uvm_analysis_port #(tx_item) rap;
    //Constructor 
    function new(string name ="monitor", uvm_component parent = null);
        super.new(name, parent);
        wap = new("wap", this);
        rap = new("rap", this);
    endfunction
    
    //Build Phase 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
        `uvm_error("build_phase","driver virtual interface failed")
        end
        
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            writing_phase();
            reading_phase();
        join        
    endtask
  
  //Run Phase
    task writing_phase();
        //Creating new transaction object
        tx_item trans = tx_item::type_id::create("trans");
        int pr_addr = 0, pa_addr = 0;
        integer pr_data, pa_data;
        int write_count =0;
        forever begin
        //wait for rising edge of clock 
            @(posedge vif.PCLK) begin 
                while((!vif.PSEL && !vif.PENABLE) || !vif.PWRITE) begin // wait untill PSEL or PENABLE is not 1
                    @(posedge vif.PCLK)
                        `uvm_info("WMONITOR",$sformatf("Wating for write mode or PSEL or PENABLE is not high PSEL"),UVM_DEBUG) 
                end
                
                trans.PRESET = vif.PRESET;
                trans.PADDR = vif.PADDR;
                trans.PWDATA = vif.PWDATA;
                trans.PWRITE = vif.PWRITE;
                trans.PSEL = vif.PSEL;
                trans.PREADY = vif.PREADY;
                trans.PSLVERR = vif.PSLVERR;
                trans.PENABLE = vif.PENABLE;

                pr_data = trans.PWDATA;
                pr_addr = trans.PADDR;
                if((pr_addr != pa_addr) || pr_data !== pa_data) begin
                    //Pass the transaction to analysis port
                    // `uvm_info("WMONITOR",$sformatf("Sent Transaction to SB: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PWDATA =%0d, PREADY =%0d PSLERR = %0d", trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PWDATA,trans.PREADY,trans.PSLVERR),UVM_DEBUG)
                    wap.write(trans);
                    pa_addr = pr_addr;
                    pa_data = pr_data;
                end
                else
                    `uvm_info("WMONITOR",$sformatf("Writing same data on same address"),UVM_DEBUG)
                //wait for the write transaction to complete   
                while(!vif.PREADY && write_count<=10) begin
                    @(posedge vif.PCLK);
                        `uvm_info("WMONITOR",$sformatf("Ready signal is not high"),UVM_DEBUG)
                        write_count++;
                end

                if(write_count>10) begin
                    `uvm_error("WMONITOR", "Ready signal was not high since 10 clock cycle")
                    write_count =0;
                end 
            end
            #1;
        end
    endtask 
    task reading_phase();
      //Creating new transaction object
        tx_item trans = tx_item::type_id::create("trans");
        int pr_addr = 0, pa_addr = 0;
        integer pr_data, pa_data;
        int read_count =0;
   
        forever begin
            //wait for rising edge of clock 
            @(posedge vif.PCLK) begin 
            @(posedge vif.PCLK) begin 
                
                while((!vif.PSEL && !vif.PENABLE) || vif.PWRITE) begin// wait untill PSEL or PENABLE is not 1
                    @(posedge vif.PCLK)
                        `uvm_info("RMONITOR",$sformatf("Wating for read mode or PSEL or PENABLE is not high PSEL =%0d, PENABLE =%0d, PWRITE =%0d",vif.PSEL,vif.PENABLE,vif.PWRITE),UVM_DEBUG) end
                
                    trans.PRESET = vif.PRESET;
                    trans.PADDR = vif.PADDR; 
                    trans.PWRITE = vif.PWRITE;
                    trans.PSEL = vif.PSEL;
                    trans.PREADY = vif.PREADY;      
                    trans.PSLVERR = vif.PSLVERR;
                    trans.PENABLE = vif.PENABLE;

                    
                    //wait for the ready signal to assert
                    while(!vif.PREADY && read_count <=10) begin
                        @(posedge vif.PCLK)
                        `uvm_info("RMONITOR",$sformatf("Ready signal is not high"),UVM_DEBUG)
                        read_count++;
                    end

                if(read_count >10) begin
                    `uvm_error("RMONITOR",$sformatf("Ready signal was not high since 10 clock cycle"))
                    read_count =0;
                end

                trans.PRDATA = vif.PRDATA;
                
                pr_data = trans.PRDATA;  
                pr_addr = trans.PADDR;
                if((pr_addr != pa_addr) || pr_data !== pa_data)begin
                //Pass the transaction to analysis port
                    `uvm_info("RMONITOR",$sformatf("Sent Transaction to SB: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PRDATA =%0d ,PREADY =%0d PSLVERR =%0d", trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PRDATA,trans.PREADY,trans.PSLVERR),UVM_DEBUG)
                    rap.write(trans);
                    pa_addr = pr_addr;
                    pa_data = pr_data;
                end
                else
                    `uvm_info("RMONITOR",$sformatf("Reading same data from same addrs"),UVM_DEBUG)
            end
            #1;
        end
        end
   endtask  
endclass 