

#-----------------------------------------------------------------------
# Static Power Analysis
#-----------------------------------------------------------------------
set_power_analysis_mode \
    -reset

set_power_analysis_mode \
    -leakage_power_view 	AV_fast_mode_wc_rc125_setup \
    -dynamic_power_view        	AV_fast_mode_wc_rc125_setup \
    -write_static_currents      true \
    -binary_db_name             staticPower.db \
    -create_binary_db           true \
    -method                     static 

#-----------------------------------------------------------------------
# to define power for instances that are missing .lib
#-----------------------------------------------------------------------
set_power \
    -reset

#set_power \
#    -cell                       pll \
#    -pin                        VDD \
#                                0.5
set_power \
    -instance                   u0 \
    -pin                        VDD \
                                0.5
#-----------------------------------------------------------------------
# define switching activity for primary inputs/nets/clocks if they are not
# defined thru user attribute, TCF, VCD or clock constraints. Remember, Voltus
# will use the SDCs but that only controls clocks and registers. SDCs do not
# say how often clock gates toggle.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# set toggle rate on the rst pin and propagate activities:
#-----------------------------------------------------------------------
set_switching_activity \
    -reset

set_switching_activity \
    -input_port                 rst \
    -activity                   0.25 \
    -duty                       0.30

propagate_activity

#-----------------------------------------------------------------------
# validate the activity was properly applied
#-----------------------------------------------------------------------
get_activity \
    -port                       rst

set_switching_activity \
    -pin [ \
        get_pins -of_objects [ \
            get_cells RC_CGIC* -hierarchical \
        ] \
        -filter "@direction == out" \
    ] \
    -activity                   0.1

propagate_activity

#-----------------------------------------------------------------------
# validate the activities was properly applied
#-----------------------------------------------------------------------
get_activity \
    -pin [ \
        get_pins -of_objects [ \
            get_cells RC_CGIC* -hierarchical \
        ] \
        -filter "@direction == out" \
    ]

#-----------------------------------------------------------------------
# set default activities for all nets/pins/etc for unclocked nets
#-----------------------------------------------------------------------
set_default_switching_activity \
    -input_activity             0.3 \
    -period                     4.0 \
    -clock_gates_output_ratio   0.5

#-----------------------------------------------------------------------
# define output directory
#-----------------------------------------------------------------------
set_power_output_dir            $vars(dbs_dir)/staticPowerResults

#-----------------------------------------------------------------------
# run power analysis
#-----------------------------------------------------------------------
report_power \
    -outfile                    static.rpt

#-----------------------------------------------------------------------
# generate different report formats:
#-----------------------------------------------------------------------
report_power -instances {u0}    -outfile u0.rpt
report_power -instances {*}     -outfile all.rpt
report_power -instances {ring}  -outfile ring.rpt
