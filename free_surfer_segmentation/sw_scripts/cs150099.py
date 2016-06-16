import os
import subprocess
            
script_fs = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/sw_scripts/cs150099.sh'
cmd = "source " + script_fs
subprocess.call(cmd, shell=True)