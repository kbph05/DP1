onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Constants
add wave -noupdate /tbrcan/N
add wave -noupdate -divider {DUT Inputs}
add wave -noupdate /tbrcan/main/TV.inX
add wave -noupdate /tbrcan/main/TV.inY
add wave -noupdate /tbrcan/main/TV.inC
add wave -noupdate /tbrcan/TBX
add wave -noupdate /tbrcan/TBY
add wave -noupdate /tbrcan/TBC
add wave -noupdate -divider {DUT Outputs}
add wave -noupdate /tbrcan/DUT_S
add wave -noupdate /tbrcan/DUT_Cout
add wave -noupdate /tbrcan/DUT_Ovfl
add wave -noupdate -divider {Expected Outputs}
add wave -noupdate /tbrcan/main/TV.outS
add wave -noupdate /tbrcan/main/TV.outC
add wave -noupdate /tbrcan/main/TV.outOvfl
add wave -noupdate -divider {Test Vectors}
add wave -noupdate /tbrcan/main/TV
add wave -noupdate -divider Miscellaneous
add wave -noupdate /tbrcan/main/MeasurementIndex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {819 ps}
