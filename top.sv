`include "uvm_macros.svh"
import uvm_pkg::*;
import tx_pkg::*;
module apb_top(); 
    
    apb_if vif();
    AMBA_APB dut(.PCLK(vif.PCLK),
                .PRESET(vif.PRESET), .PADDR(vif.PADDR), .PWRITE(vif.PWRITE), .PSEL(vif.PSEL), .PENABLE(vif.PENABLE), .PWDATA(vif.PWDATA), .PRDATA(vif.PRDATA), .PREADY(vif.PREADY)); 
        initial begin
            vif.PCLK = 1'b0; 
            forever 
                #5 vif.PCLK = ~vif.PCLK;
        end
        initial begin
            vif.PRESET = 1'b1;
            `uvm_info("APB TOP", $sformatf("RESET is applied"), UVM_LOW);
            #15;
            vif.PRESET = 1'b0;
            `uvm_info("APB TOP", $sformatf("RESET is released"), UVM_LOW);
        end


    initial begin  
        uvm_config_db#(virtual apb_if) :: set(null,"*","vif",vif);
        run_test("apb_base_test");
    end


endmodule