%%% FREESURFER - MRI SEGMENTATION %%%
This step consists in segmenting each individual???s brain. 
Tip: you can write a shell script to perform all these steps at once. See here: https://github.com/mne-tools/mne-scripts/tree/master/sample-data

%% 1. MRI data import with BRAINVISA %%
- Create a temporary folder: 
/neurospin/meg/meg_tmp/mystudy/mri/NIP_tmp
where you will import your MRI data with Brainvisa (DICOM format). NIP is the anonymous name associated with the subject, typical format: ab010234

- Open a terminal window, type in 
brainvisa 
A gui interface opens up: 
1. Click on ???Data Management??? located in the left panel. 
2. Double-click on ???Data Storage Client??? located in the middle panel. 
A new window opens up (called ???data storage client???) 
In the middle panel, select the directory in which you want the MRI to be transferred to: 
/neurospin/meg/meg_tmp/mystudy/mri/NIP_tmp
3. On the left panel, click on the ???+??? to open up the system folder from which the MRI of your 
subject was acquired (in most cases, it will be ???Siemens Tim Trio 3.0T (NeuroSpin) 
A list of folders appear classified by dates ???yyyymmdd??? 
 Select the date corresponding to the date your subject underwent MRI. 
 You should see listed the NIP of your subject in that folder. 
 Select the series you need to import. 
Tip: In general, the structural anatomy file is marked as 'MPRAGE' (but the name is sometimes 
missing) and its size is between 30 and 35 Mb. 
4. Click on ???Add>>??? in the middle panel. 
You can repeat this as many times as MRI series you need to import (insuring you select the 
proper folder each time!). Once your selection is finished, click on ???Run??? in the middle panel. The 
MRI series will be exported. You???re done with that step. 

%% 2. MRI segmentation with FREESURFER %%
1. Open a terminal window and indicate the path (without supplementary spaces) to the freesurfer_segmentation folder (you should NOT create it before, it is generated automatically): 
export SUBJECTS_DIR=/neurospin/meg/meg_tmp/mystudy/mri/
export SUBJECT=NIP
!! before each segmentation, otherwise you get a bug with function nu_correctsource $FREESURFER_HOME/SetUpFreeSurfer.sh (or SetUpFreeSurfer.csh depending on shell type)
and specify the source:
source $FREESURFER_HOME/SetUpFreeSurfer.sh

2. Indicate the path to the first MRI slice of your subject:

For MRI acquired a long time ago: 
export PTK=/neurospin/meg/meg_tmp/mystudy/mri/NIP_tmp/ptk_server_task_0/*/*000001.mrdc 

For MRI acquired more recently:
You need to manually check out the name of the first slice of the series.  
cd /neurospin/meg/meg_tmp/mystudy/mri/NIP_tmp/ptk_server_task_0/
to see the ordered list of files: 
ls -l 
export PTK=/neurospin/meg/meg_tmp/mystudy/mri/NIP_tmp/ptk_server_task_0/firstslice.dcm

3. Do freesurfer segmentation!
freesurfer 
recon-all -s $SUBJECT -i $PTK -all 
** The processing takes 7 to 12h. ** 
The resulting segmentation will automatically be saved into the folder you specified: 
$SUBJECTS_DIR/$SUBJECT
!! The folder ???/neurospin/meg/meg_tmp/mystudy/mri/NIP_tmp/??? in which you exported the original MRI slices with Brainvisa is no longer needed. DELETE it once finished with segmentation.

% Example for my data:
1. Create a temporary folder: 
/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/anat/am090241_tmp/
where to import BRAINVISA MRI (correspondence between subjects and NIPs in Scheda_soggetti.xlsx)

2. Freesurfer segmentation commands:
- DO NOT create another folder!
export SUBJECTS_DIR=/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/anat/
export SUBJECT=am090241
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export PTK=/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/anat/am090241_tmp/ptk_server_task_0/PatientID-am090241-3286_StudyID-001_SeriesNumber-000002_000001.dcm
freesurfer
recon-all -s $SUBJECT -i $PTK -all

Segmentation has been saved in the new folder:
/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/anat/am090241/


