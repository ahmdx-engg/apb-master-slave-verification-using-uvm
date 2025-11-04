class first_sequence extends uvm_sequence#(tx_item);
  `uvm_object_utils(first_sequence)
  
   int WRITE_BURST_LENGTH = 32;
   int READ_BURST_LENGTH = 32;
  //constructor
    function new(string name = "first_sequence");
        super.new(name);
    endfunction 
  
    virtual task body();
        tx_item write_trans;
        tx_item read_trans;   
        //generate the write transaction 
        write_trans = tx_item::type_id::create("write_trans");
        write_trans.PADDR = 0;

            
        for (int i=1; i<=WRITE_BURST_LENGTH; i++) begin
            write_trans.PSEL = 1;
            write_trans.PWRITE = 1;
            write_trans.PENABLE = 1;  
            write_trans.PWDATA = $urandom;
                
            start_item(write_trans);
                `uvm_info("WSEQUENCE", write_trans.convert2string(), UVM_DEBUG)
            finish_item(write_trans);

                
            write_trans.PADDR++; 
        end

        //generate read transaction 
        read_trans = tx_item::type_id::create("read_trans");
        read_trans.PADDR = 0;

        for(int i=1; i<=READ_BURST_LENGTH; i++) begin
            read_trans.PSEL = 1;
            read_trans.PWRITE = 0;
            read_trans.PENABLE = 1;
                
            start_item(read_trans);
                `uvm_info("RSEQUENCE", read_trans.convert2string(), UVM_DEBUG)
            finish_item(read_trans);
            read_trans.PADDR++;
        end
    endtask
endclass