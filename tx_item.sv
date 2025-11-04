class tx_item extends uvm_sequence_item;
  
  `uvm_object_utils(tx_item)
  
  rand  bit [31:0] PADDR;
  rand  bit [31:0] PWDATA;
		bit PWRITE;
		bit PENABLE;
		bit PSEL;
		bit PRESET;
		bit [0:3] PSTRB;
		bit [31:0] PRDATA;
		bit PSLVERR;
		bit PREADY;
 
  constraint c1{soft PADDR[31:0]>=32'd0; PADDR[31:0] <32'd32;};
 
  //Constructor
  function new(string name = "tx_item");
    super.new(name);
  endfunction 
	virtual function void do_copy(uvm_object rhs);
		tx_item tx_rhs;

		if (!$cast(tx_rhs, rhs)) begin
			`uvm_fatal(get_type_name(), "ILLEGAL ARGUMENT");
		end

		super.do_copy(rhs);

		this.PADDR   = tx_rhs.PADDR;
		this.PWDATA  = tx_rhs.PWDATA;
		this.PWRITE  = tx_rhs.PWRITE;
		this.PENABLE = tx_rhs.PENABLE;
		this.PSEL    = tx_rhs.PSEL;
		this.PRESET  = tx_rhs.PRESET;
		this.PSTRB   = tx_rhs.PSTRB;
		this.PRDATA  = tx_rhs.PRDATA;
		this.PSLVERR = tx_rhs.PSLVERR;
		this.PREADY  = tx_rhs.PREADY;
	endfunction


	virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		tx_item tx_rhs;

		if (!$cast(tx_rhs, rhs)) begin
			`uvm_fatal(get_type_name(), "ILLEGAL ARGUMENT");
		end

		return super.do_compare(rhs, comparer) &&
			(this.PADDR   === tx_rhs.PADDR) &&
			(this.PWDATA  === tx_rhs.PWDATA) &&
			(this.PWRITE  === tx_rhs.PWRITE) &&
			(this.PENABLE === tx_rhs.PENABLE) &&
			(this.PSEL    === tx_rhs.PSEL) &&
			(this.PRESET  === tx_rhs.PRESET) &&
			(this.PSTRB   === tx_rhs.PSTRB) &&
			(this.PRDATA  === tx_rhs.PRDATA) &&
			(this.PSLVERR === tx_rhs.PSLVERR) &&
			(this.PREADY  === tx_rhs.PREADY);
	endfunction



	virtual function string convert2string();
		string s;

		s = super.convert2string();
		s = {s, "\n[tx_item values]\n"};
		s = {s, $sformatf("  PADDR   : 0x%0h\n", PADDR)};
		s = {s, $sformatf("  PWDATA  : 0x%0h\n", PWDATA)};
		s = {s, $sformatf("  PWRITE  : %0b\n",   PWRITE)};
		s = {s, $sformatf("  PENABLE : %0b\n",   PENABLE)};
		s = {s, $sformatf("  PSEL    : %0b\n",   PSEL)};
		s = {s, $sformatf("  PRESET  : %0b\n",   PRESET)};
		s = {s, $sformatf("  PSTRB   : 0x%0h\n", PSTRB)};
		s = {s, $sformatf("  PRDATA  : 0x%0h\n", PRDATA)};
		s = {s, $sformatf("  PSLVERR : %0b\n",   PSLVERR)};
		s = {s, $sformatf("  PREADY  : %0b\n",   PREADY)};

		return s;
	endfunction




	virtual function void do_print(uvm_printer printer); 
	printer.m_string = convert2string(); 
	endfunction

	virtual function void do_pack(uvm_packer packer); 
	// NOT IMPLEMENTED
	endfunction 

	virtual function void do_unpack(uvm_packer packer); 
	// NOT IMPLEMENTED
	endfunction 

	virtual function void do_record(uvm_recorder recorder); 
	// NOT IMPLEMENTED
	endfunction
 
endclass