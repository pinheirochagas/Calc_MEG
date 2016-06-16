import os
import subprocess
            
script_fs = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/free_surfer_segmentation/sw_scripts/ag150338.sh'
cmd = "source " + script_fs
subprocess.call(cmd, shell=True)