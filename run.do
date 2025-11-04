vlib work
vlog apb_if.sv design.sv pkg.sv top.sv
vsim work.apb_top +define+UVM_REPORT_DISABLE_FILE_LINE 
add wave -position insertpoint  \
sim:/apb_top/vif/PADDR \
sim:/apb_top/vif/PCLK \
sim:/apb_top/vif/PENABLE \
sim:/apb_top/vif/PRDATA \
sim:/apb_top/vif/PREADY \
sim:/apb_top/vif/PRESET \
sim:/apb_top/vif/PSEL \
sim:/apb_top/vif/PSLVERR \
sim:/apb_top/vif/PSTRB \
sim:/apb_top/vif/PWDATA \
sim:/apb_top/vif/PWRITE
run -all