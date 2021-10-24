#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLK_MAIN} -period 41.667 -waveform { 0.000 20.833 } [get_ports {CLK_MAIN}]
derive_clock_uncertainty

#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {CLK_MAIN}] -rise_to [get_clocks {CLK_MAIN}]  0.070  
set_clock_uncertainty -rise_from [get_clocks {CLK_MAIN}] -fall_to [get_clocks {CLK_MAIN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {CLK_MAIN}] -rise_to [get_clocks {CLK_MAIN}]  0.070  
set_clock_uncertainty -fall_from [get_clocks {CLK_MAIN}] -fall_to [get_clocks {CLK_MAIN}]  0.070  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************
