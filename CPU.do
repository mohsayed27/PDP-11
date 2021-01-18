vsim -gui work.CPU
#add wave -position insertpoint sim:/CPU/*
#sim:/CPU/clk \
#sim:/CPU/rst \
#sim:/CPU/memory_read_signal \
#sim:/CPU/memory_write_signal \
#sim:/CPU/MDR_en_in \
#sim:/CPU/MDR_en_out \
#sim:/CPU/MAR_en_in \
#sim:/CPU/data_bus \
#sim:/CPU/ram_data_out \
#sim:/CPU/MDR_out \ 
#sim:/CPU/MAR_out 
add wave -position insertpoint  \
sim:/cpu/data_bus
add wave -position insertpoint  \
sim:/cpu/clk
add wave -position insertpoint  \
sim:/cpu/MDR_en_in
add wave -position insertpoint  \
sim:/cpu/MAR_en_in
add wave -position insertpoint  \
sim:/cpu/MDR_en_out
add wave -position insertpoint  \
sim:/cpu/memory_read_signal
add wave -position insertpoint  \
sim:/cpu/ram_data_out
add wave -position insertpoint  \
sim:/cpu/MDR_out
add wave -position insertpoint  \
sim:/cpu/MAR_out
add wave -position insertpoint  \
sim:/cpu/R0_out
add wave -position insertpoint  \
sim:/cpu/R0_en_in
add wave -position insertpoint  \
sim:/cpu/R0_en_out

# reset all
#noforce  sim:/CPU/data_bus 
force -freeze sim:/CPU/rst 0 0
force -freeze sim:/CPU/Clk 0 0, 1 {50 ps} -r 100

force -freeze sim:/CPU/data_bus 10'd5 0
#force -freeze sim:/CPU/R0_en_in 1 0
#force -freeze sim:/CPU/MAR_en_in 1 0
#force -freeze sim:/CPU/memory_read_signal 1 0
force -freeze sim:/CPU/R0_en_in 1 0
run

noforce  sim:/CPU/data_bus 
force -freeze sim:/CPU/memory_read_signal 0 0
force -freeze sim:/CPU/MAR_en_in 0 0
#force -freeze sim:/CPU/MDR_en_out 1 0
force -freeze sim:/CPU/R0_en_in 0 0

run
force -freeze sim:/CPU/R0_en_out 1 0
#force -freeze sim:/CPU/MDR_en_out 0 0
#force -freeze sim:/CPU/R0_en_in 0 0
#force -freeze sim:/CPU/data_bus 10'd0 0
run 
#noforce  sim:/CPU/data_bus 
#force -freeze sim:/CPU/R0_en_out 1 0
#run



#force -freeze sim:/CPU/e_dest 0 0
# x\"AAAA\"
#force in3 8'd33
#force in2 8'b01110000
#run