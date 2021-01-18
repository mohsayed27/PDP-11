vsim -gui work.pla_all
add wave -position insertpoint sim:/pla_all/*

#NO OP
#NO OP
#NO OP
#377 (HLT)
force -freeze sim:/pla_all/IR 16'b1111000000000000 0
#314 (NOP)
force -freeze sim:/pla_all/IR 16'b1111100000000000 100 

#1 OP (BR)
#1 OP (BR)
#1 OP (BR)
#240
force -freeze sim:/pla_all/IR 16'b1110000000000000 200 
#240
force -freeze sim:/pla_all/IR 16'b1110110001000100 300 

#1 OP
#1 OP
#1 OP
#100 (Reg direct)
force -freeze sim:/pla_all/IR 16'b1100100000000000 400 
#140 (Reg indirect)
force -freeze sim:/pla_all/IR 16'b1100001000000001 500 
force -freeze sim:/pla_all/IR 16'b1100001000000010 600 #110 (Auto inc)
force -freeze sim:/pla_all/IR 16'b1100001000000100 700 #120 (Auto dec)
force -freeze sim:/pla_all/IR 16'b1100001000000111 800 -cancel 899 #130 (Indexed)

run -all