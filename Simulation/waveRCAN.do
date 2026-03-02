onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 50 {RCAN Functional Verification Waveform}
add wave -noupdate -divider -height 50 Constants
add wave -noupdate -height 50 -label N /tbrcan/N
add wave -noupdate -divider -height 50 {DUT Inputs}
add wave -noupdate -height 50 -label X /tbrcan/main/TV.inX
add wave -noupdate -height 50 -label Y /tbrcan/main/TV.inY
add wave -noupdate -height 50 -label Cin /tbrcan/main/TV.inC
add wave -noupdate -divider -height 50 {DUT Outputs}
add wave -noupdate -height 50 -label S /tbrcan/DUT_S
add wave -noupdate -height 50 -label Cout /tbrcan/DUT_Cout
add wave -noupdate -height 50 -label Ovfl /tbrcan/DUT_Ovfl
add wave -noupdate -divider -height 50 {Expected DUT Outputs}
add wave -noupdate -height 50 -label S /tbrcan/main/TV.outS
add wave -noupdate -height 50 -label Cout /tbrcan/main/TV.outC
add wave -noupdate -height 50 -label Ovfl /tbrcan/main/TV.outOvfl
add wave -noupdate -divider -height 50 Miscellaneous
add wave -noupdate -height 50 -label MeasurementIndex /tbrcan/main/MeasurementIndex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {571494 ps} 0}
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
WaveRestoreZoom {0 ps} {150 ns}
