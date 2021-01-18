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

#110 (Auto inc) 
force -freeze sim:/pla_all/IR 16'b1100001000000010 600

#120 (Auto dec)
force -freeze sim:/pla_all/IR 16'b1100001000000100 700 

#130 (Indexed)
force -freeze sim:/pla_all/IR 16'b1100001000000111 800




#2 OP
#2 OP
#2 OP

#010 (Reg direct)
force -freeze sim:/pla_all/IR 16'b0001100000000000 900 

#020 (Reg indirect)
force -freeze sim:/pla_all/IR 16'b0100100001000000 1000 

#030 (Auto inc)
force -freeze sim:/pla_all/IR 16'b0100100010000000 1100 

#040 (Auto dec)
force -freeze sim:/pla_all/IR 16'b0100100100000000 1200 

#050 (Indexed)
force -freeze sim:/pla_all/IR 16'b0100100110000000 1300 -cancel 1399

run -all