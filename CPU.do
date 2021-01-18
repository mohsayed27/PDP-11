vsim work.CPU
add wave sim:/CPU/*
add wave -position insertpoint  \
sim:/CPU/l/clk \
sim:/CPU/l/rst \
sim:/CPU/l/rom_addr \
sim:/CPU/l/rom_data_out 

# reset all
force -freeze sim:/CPU/rst 0 0
force -freeze sim:/CPU/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/CPU/rom_addr 100 0
#force -freeze sim:/CPU/e_dest 0 0
# x\"AAAA\"
#force in3 8'd33
#force in2 8'b01110000
run