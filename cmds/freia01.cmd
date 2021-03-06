# This the full setup for the Timing System with E3.
#

#require devlib2, 2.9.0
require mrfioc2, 2.2.0
require iocStats, 1856ef5
require autosave, 5.8.0


epicsEnvSet("ENGINEER","hanlee x3409")
epicsEnvSet("LOCATION","Rack 1 at ICS Tuna Lab")

epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES","10000000")

epicsEnvSet("IOC", "FREIA")
epicsEnvSet("DEV1", "EVG0")

epicsEnvSet("MainEvtCODE" "14")
epicsEnvSet("HeartBeatEvtCODE"   "122")
epicsEnvSet("ESSEvtClockRate"  "88.0525")

mrmEvgSetupPCI("$(DEV1)", "10:0e.0")

dbLoadRecords("cpci-evg230-ess.db",  "SYS=$(IOC), D=$(DEV1), EVG=$(DEV1), FEVT=$(ESSEvtClockRate), FRF=352.21, FDIV=4")

# needed with software timestamp source w/o RT thread scheduling
var evrMrmTimeNSOverflowThreshold 100000


# iocStats
dbLoadRecords("iocAdminSoft.db", "IOC=$(IOC)-IocStats")


# # Auto save/restore

# # Directory should be existent before IOC runing
# epicsEnvSet("AUTOSAVE", "/home/timinguser/autosave")

# var save_restoreDebug 1

# dbLoadRecords("save_restoreStatus.db", "P=$(IOC)-Autosave")
# save_restoreSet_status_prefix("$(IOC):Autosave")
# set_savefile_path("${AUTOSAVE}")
# set_requestfile_path("${AUTOSAVE}")
# set_pass0_restoreFile("mrf_settings.sav")
# set_pass0_restoreFile("mrf_values.sav")
# set_pass1_restoreFile("mrf_values.sav")
# set_pass1_restoreFile("mrf_waveforms.sav")


iocInit()


dbl > "${IOC}_PVs.list"


# makeAutosaveFileFromDbInfo("${AUTOSAVE}/mrf_settings.req",  "autosaveFields_pass0")
# makeAutosaveFileFromDbInfo("${AUTOSAVE}/mrf_values.req",    "autosaveFields")
# makeAutosaveFileFromDbInfo("${AUTOSAVE}/mrf_waveforms.req", "autosaveFields_pass1")

# create_monitor_set("mrf_settings.req",   5 , "")
# create_monitor_set("mrf_values.req",     5 , "")
# create_monitor_set("mrf_waveforms.req", 30 , "")



dbpf "$(IOC)-$(DEV1):1ppsInp-Sel" "Sys Clk"

# # Master Event Rate 14 Hz
dbpf $(IOC)-$(DEV1):Mxc0-Prescaler-SP 6289464
dbpf $(IOC)-$(DEV1):TrigEvt0-EvtCode-SP $(MainEvtCODE)
dbpf $(IOC)-$(DEV1):TrigEvt0-TrigSrc-Sel "Mxc0"

# # Heart Beat 1 Hz
dbpf $(IOC)-$(DEV1):Mxc7-Prescaler-SP 88052496
dbpf $(IOC)-$(DEV1):TrigEvt7-EvtCode-SP $(HeartBeatEvtCODE)
dbpf $(IOC)-$(DEV1):TrigEvt7-TrigSrc-Sel "Mxc7"

# # EVR configuration
# dbpf $(IOC)-$(DEV2):DlyGen0-Width-SP 10000
# dbpf $(IOC)-$(DEV2):DlyGen0-Evt-Trig0-SP $(MainEvtCODE)
# dbpf $(IOC)-$(DEV2):OutFPUV0-Src-Pulse-SP "Pulser 0"

# Is there something similar to sleep(5)????
dbpf $(IOC)-$(DEV1):SyncTimestamp-Cmd 1

