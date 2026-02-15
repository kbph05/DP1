# CSANfv.do
# Date: Feburary 14th, 2026
# Author: Kane Zhan
# Purpose: To allow for functional verification of the N-bit Conditional Sum Adder (CSAN) topology. 
# Goals:
# 1. Name a unique transcript file
# 2. Turn on/off re-direction to this transcript file when you wish to capture the output
# 3. Compile all relevant sourcecode
# 4. Start a simulation of the appropriate testbench
# 5. Setup an appropriate wave window
# 6. Run the simulation
# ...for some baffling reason the default modelsim behaviour is quiet meaning puts are suppressed. stupid.
# let's use echos then.
# echo "argv = <$argv>"
# huh, so apparently command line arguments dont work and argv isnt set when the command is executed. awesome.
# also every assignment prints to the console. why??? 

# make tcl shut up by putting "; list" after every assignment
# Imports
package require cmdline; list

# Constants / Flags
# default to capturing into transcript 
if {![info exists ::capture_set]} {
    set ::capture_set 1; list
}
# Version tag just for fun
set version 1.0.0; list

# This doesn't work right now
# set options {
#     {c              "Enable transcript capture"}
#     {capture        "Enable transcript capture"}
# }

# set usage "Version: v$version \n\n\n Usage: do CSANfv.do \[options]" 

# 1. Name a unique transcript file
# ../Documentation/OutputFiles/CSAN_Testing_Transcript_{yyyy-mm-dd-hh-mm-ss}
# Time 
set systemTime [clock seconds]; list
set timestamp [clock format $systemTime -format "%Y-%m-%d_%H-%M-%S"]; list

set transcript_file "../Documentation/OutputFiles/CSAN_Testing_Transcript_$timestamp.txt"; list
# 2. Turn on/off re-direction to this transcript file when you wish to capture the output
# (This doesnt work right now) Check for flag '-c / -capture', if flag true then direct all console output to this transcript file
# try {
#     array set params [::cmdline::getoptions argv $options $usage]
# } trap {CMDLINE USAGE} {msg o} {
#     puts $msg
#     exit 1
# }
# set capture_set [expr {$params(c) || $params(capture)}]

# echo "\ncapture set: $capture_set\n"
if {$capture_set == 1} {
    echo "\nCapturing output into transcript file: $transcript_file\n"
} else {
    echo "\n Not capturing output into transcript file\n"
}


if {$capture_set == 1} {
    # 3. Compile all relevant sourcecode    
    vcom -2008 -logfile $transcript_file ../SourceCode/*.vhd ./*.vhd
    # 4. Start a simulation of the appropriate testbench
    # -c: console mode: runs vsim without gui
    # -l: specifies log file for the output
    # 5. Setup an appropriate wave window
    # 6. Run the simulation
    vsim -c TBCSAN -l $transcript_file -do {
    do waveCSAN.do  
    run -all      
    }
} else {
    # 3. Compile all relevant sourcecode    
    vcom -2008 ../SourceCode/*.vhd  
    vcom -2008 ./*.vhd
    # 4. Start a simulation of the appropriate testbench
    vsim TBCSAN.vhd
    # 5. Setup an appropriate wave window
    do waveCSAN.do    
    # 6. Run the simulation
    run -all    
}





