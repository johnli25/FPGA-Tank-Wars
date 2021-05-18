transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {385_lab6.svo}

vlog -sv -work work +incdir+C:/Users/warri/Desktop/ece_385/lab6/output_files {C:/Users/warri/Desktop/ece_385/lab6/output_files/testbench2.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  testbench2

add wave *
view structure
view signals
run 10000 ns
