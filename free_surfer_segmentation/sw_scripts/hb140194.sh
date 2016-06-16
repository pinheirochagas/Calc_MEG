#!/bin/sh
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

export SUBJECTS_DIR=/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat
recon-all -autorecon-all -subjid hb140194