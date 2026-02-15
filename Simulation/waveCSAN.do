onerror {resume}
add wave -noupdate -divider Constants
add wave -noupdate /tbcsan/N
add wave -noupdate -divider {DUT Inputs}
add wave -noupdate /tbcsan/main/TV.inX
add wave -noupdate /tbcsan/main/TV.inY
add wave -noupdate /tbcsan/main/TV.inC
add wave -noupdate /tbcsan/TBX
add wave -noupdate /tbcsan/TBY
add wave -noupdate /tbcsan/TBC
add wave -noupdate -divider {DUT Outputs}
add wave -noupdate /tbcsan/DUT_S
add wave -noupdate /tbcsan/DUT_Ovfl
add wave -noupdate /tbcsan/DUT_Cout
add wave -noupdate -divider {Expected Outputs}
add wave -noupdate /tbcsan/main/TV.outS
add wave -noupdate /tbcsan/main/TV.outC
add wave -noupdate /tbcsan/main/TV.outOvfl
add wave -noupdate -divider {Test Vectors}
add wave -noupdate /tbcsan/main/TV
add wave -noupdate -divider Miscellaneous
add wave -noupdate /tbcsan/main/MeasurementIndex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12 ps} 0}
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
