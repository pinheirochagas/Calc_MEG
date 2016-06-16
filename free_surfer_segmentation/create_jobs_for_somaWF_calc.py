# -*- coding: utf-8 -*-
"""
Created on Fri Apr 25 11:37:04 2014
@author: id983365

Modified on Mo, Feb. 9th, 2015
@author: dt237143

Modified on Mo, March 02th, 2015
@author: vb

script to generate :
    - .sh to launch one freesurfer command
    - .py which creates the somaWF
"""

from soma_workflow.client import Job, Workflow, Helper
import os.path

#parameters to change
#############################################################################
#subjects = ['ml090321','rm080030']
#subjects = ['cs150099','jm100109','dp150209','mn150194','jm100042','sl140280','ts150275']
#subjects = ['bc150339','mk150295','jf140150','hb140194','cd130323']
subjects = ['ag150338','db150361','ej130467','mp150285','ps150333', 'tc120199', 'sl130503']

subjects_dir = "/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat"
path_script = "/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/free_surfer_segmentation/sw_scripts"

#create_shell_file(id_subject)
############################################################################
shell_file = ".sh"
python_file = ".py"

def create_shell_file(id_subject):
    cmd_freesurfer = "recon-all -autorecon-all -subjid {id_subject}".format(
                    id_subject=id_subject)

    body = """#!/bin/sh
# FreeSurfer home directory
[ -z "$FREESURFER_HOME" ] && FREESURFER_HOME=/i2bm/local/freesurfer
 export FREESURFER_HOME
# Configure FreeSurfer
. ${FREESURFER_HOME}/FreeSurferEnv.sh

# FreeSurfer 5.1.0 or less require "en" locale
LANG='en_US.UTF-8'

# Set a variable to mark the FreeSurfer shells
I2BM_FREESURFER=$FREESURFER_HOME
export I2BM_FREESURFER
"""
    body = body + "\nexport SUBJECTS_DIR=" + subjects_dir
    body = body + "\n" + cmd_freesurfer

    name_file = os.path.join(path_script, (id_subject + '.sh'))
    shell_file = open(name_file, "w")
    shell_file.write(body)
    shell_file.close
    return name_file


def create_python_file(id_subject, shell_file):
    body = """import os\nimport subprocess
            """
    body = body + "\nscript_fs = '" + shell_file + "'"
    body = body + "\ncmd = \"source \" + script_fs"
    body = body + "\nsubprocess.call(cmd, shell=True)"

    name_file = os.path.join(path_script, (id_subject + '.py'))
    python_file = open(name_file, "w")
    python_file.write(body)
    python_file.close
    return name_file

# create the workflow:
def create_somaWF(liste_python_files):
    jobs = []
    for file_python in liste_python_files:
        file_name = os.path.basename(file_python)
        job_1 = Job(command=["python", file_python], name=file_name)
        jobs.append(job_1)

    #jobs = [job_1]
    dependencies = []
    workflow = Workflow(jobs=jobs, dependencies=dependencies)

    # save the workflow into a file
    somaWF_name = os.path.join(path_script, "soma_WF_JOBS_segment_4")
    Helper.serialize(somaWF_name, workflow)

if __name__ == "__main__":
    liste_shell_files = []
    liste_python_files = []
    for s in subjects:
        name_shell_file = create_shell_file(s)
        name_python_file = create_python_file(s, name_shell_file)
        #liste_shell_files.append(name_shell_file)
        liste_python_files.append(name_python_file)

create_somaWF(liste_python_files)
