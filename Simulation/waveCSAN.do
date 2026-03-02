onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 50 {CSAN Functional Verification Waveform}
add wave -noupdate -divider -height 50 Constants
add wave -noupdate -height 50 -label N /tbcsan/N
add wave -noupdate -divider -height 50 {DUT Inputs}
add wave -noupdate -height 50 -label X -radix hexadecimal /tbcsan/main/TV.inX
add wave -noupdate -height 50 -label Y -radix hexadecimal /tbcsan/main/TV.inY
add wave -noupdate -height 50 -label Cin /tbcsan/main/TV.inC
add wave -noupdate -divider -height 50 {DUT Outputs}
add wave -noupdate -height 50 -label S -radix hexadecimal /tbcsan/DUT_S
add wave -noupdate -height 50 -label Ovfl /tbcsan/DUT_Ovfl
add wave -noupdate -height 50 -label Cout /tbcsan/DUT_Cout
add wave -noupdate -divider -height 50 {Expected Outputs}
add wave -noupdate -height 50 -label S -radix hexadecimal /tbcsan/main/TV.outS
add wave -noupdate -height 50 -label Cout /tbcsan/main/TV.outC
add wave -noupdate -height 50 -label Ovfl /tbcsan/main/TV.outOvfl
add wave -noupdate -divider -height 50 Miscellaneous
add wave -noupdate -height 50 -label MeasurementIndex /tbcsan/main/MeasurementIndex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55737 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
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
WaveRestoreZoom {0 ps} {150 ns}
