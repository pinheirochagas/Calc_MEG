%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Workflow for SEMDIM experiment  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Import Data
* create symbolic link to empty room and experimental runs files (see symboliclinks.m)

%%%%%%%%%% General Brainstorm 
* Always open brainstorm in matlab from the brainstorm folder: 
    /neurospin/meg/meg_tmp/Semdim_Valentina_2014/scripts/brainstorm/brainstorm3
* To update, go to Help->Update Brainstorm : the last version is downloaded and replaces the previous version. 
  Matlab will be closed and you have to start it again for the new version to be effective.
  
/neurospin/meg/meg_tmp/Semdim_Valentina_2014/scripts/brainstorm/ contains all bst analysis and includes folders:
* brainstorm3: Contains all bst program files. NO user data here, you can delete it and replace it with a new version.
* brainstorm_db: Database folder containing all bst database files. Do not touch!
* bst_data: Contains all MEG and anatomical data.

%%%%%%%%%%%% Initialize protocol and subject(s)
* Open Semdist Protocol 
* Generate new subject 
* Set 'Yes, one channel file per subject (EEG)' (reason: sss files will be imported that have already been co-registered with MaxMove). 
* You will import here the data AFTER Maxfilter and Head Movement Correction, so you will have always the same head-channel transformation (simplifies things afterwards): 
  Use the same channel configuration for all runs: Right-click on subject node > Edit subject > Yes, use one channel file per subject.

%%%%%%%%%%%% MRI segmentation with Freesurfer
* See freesurfer_workflow.m

%%%%%%%%%%%% Import individual anatomy 
* Import FreeSurfer Folder:        http://neuroimage.usc.edu/brainstorm/Tutorials/LabelFreeSurfer
* Place fiducials:                 http://neuroimage.usc.edu/brainstorm/CoordinateSystems
* Check registration:              right-click on cortex_15002 > MRI registration > Check MRI/surface registration 

%%%%%%%% Review the raw signal + Maxfilter and Head Movement correction with Neuromag software
* Adapt the pipeline scripts to perform maxfilter and head movement correction steps.
* Explore raw data with BST to identify bad channels to input in Maxfilter: 
    * Go to the fake subject named ReviewRawData (standard anatomy and one channel file per run)
    * right-click on subject -> Review raw file. 
    * Automatically prompted to improve coregistration with additional digitized points. Irrelevant, coregistration is not performed here.
    * (deprecated) Graph: Remember that by default data are low-pass filtered to 40 Hz and DC corrected (I think on a window of 2048 points).
    * BST visualization: right-click on subject > Review Raw -> your raw dataset.     
    * Open MAG, GRAD, EOG, ECG time course, MAG, GRAD topography (No magnetic interpolation -> 2D sensor cap, norm grad for grad). 
      Use "review raw" figure setup. Scroll all time course with time window 10s for bad channel identification.
    * Further bad channel identification: Change time window to 2s, display MAG and GRAD time course on single channels (Maj J - Maj P) 
      on a few time points.
    * Check that events are correctly identified (should be 6 deviants per category per run + 232 hab).
* Once you loaded and explored all runs, you can check within BST difference between runs in MEG-MRI co-registration.
* Maxfilter (sss + head movement correction): insert bad channels in bn_par_basic and run bn_preproc_basic (in folder /bst_scripts/neuromag_preproc/). 
  Save head movement figure in /sss folder.
* Go to the subject folder, open the first sss file. When prompted to improve coregistration with additional digitized points, 
  press yes (only for this run, as the others have the very same channel file, so do not do it again).
* Check difference between raw and sss, in particular on artifacts marked by visual inspection. 
  (It might be that for some runs, the general amplitude increases due to MaxMove, but accurate observation (s10r1 vs s10r1_sss) makes me 
  pretty confident.). Remove links to raw files in BST.
* Bad segment identification: Open sss file, visualize as for raw file, and mark bad segments. Leave only stereotyped blink and cardiac artifacts. Save.
* Low-pass filter at 40 Hz: Select all sss files into Process1 window, run Pre-process -> Band-pass filter, mark 40 Hz in Upper cutoff frequency (no high-pass filter).
  To avoid border filtering artifacts, filtering is performed also on bad segments.

%% Removal of ECG/EOG artifacts %%
* Blink/ECG event identification: 
    * Open sss_bandpass files (review raw + topo), run SSP -> Detect eye blinks and SSP -> Detect heartbeats
    * Scroll through blink events to check whether identification is correct. 
      Remove blink events if blinks look dirty (not purely frontal activation) and/or if heartbeats are within 200 ms
    * Check if heartbeats are correctly identified in the ECG signal (they are too many to check ALL of them, but since they are so many, SSP should work better).
    * OLD PROCEDURE HAS A PROBLEM: Select all sss_bandpass files into Process1 window, run Artifacts -> Detect eye blinks. 2 problems:
    1) it is not possible to set a time interval that includes ALL runs (it's automatically set to the first run I think)
    2) it detects eye blinks also within the bad segments! The best is to do the following:
% * Check blink-related activity for optimal SSP parameters:
%     * Compute blink-related epochs: Select all sss_bandpass files into Process1 window, run Import recordings -> Import MEG/EEG: Events, 
%       Condition name: blink_epochs, Event names: blink, Time window: long enough to include blinks for all runs, epoch time: -1000 1000 ms.
%     * Convert epochs into EEGLAB dataset, compute tfa (/bst_scripts/tfa_blink), plot ersp, itc to check optimal frequency range 
%       of SSP computation (alpha interference).
* Compute blink SSP: 
    * Select the sss_bandpass files that contain nice blinks into Process2 window, Files A
    * Select ALL sss_bandpass files into Process2 window, Files B
    * run Artifacts -> Compute SSP: Eye blinks 
      (or Compute SSP: Generic when frequency range has to be modified), MEG MAG.
      SSP computed from Files A are applied on ALL files of the subject (even the ones not selected in Files B if co-registered).
    * Open data from one run (setup: blink MAG) to check SSP topography , and the effectiveness of the correction. 
      If the component is not automatically activated (<12 percent), you have to open ALL runs to activate it (and viceversa). 
    * You might also check it on the averaged blink-related fields, but be aware that SSP application depends on history.
* Same for GRAD.
* Clear and load data AGAIN (so that first SSP has been applied!)
* Compute ECG SSP: Same as above, replace blink by ECG. 
* Check SSP effect on averages time-locked to ECG/EOG triggers (also in source space!). Apply SSPs 
  (How are these taken into account in source reconstruction?).
  
* IMPORTANT NOTE about SSP projectors (from http://neuroimage.usc.edu/forums/showthread.php?1204-application-of-projectors):  
  If you calculate new projectors for a subject where you have raw + imported recordings, it would automatically apply the projector to all 
  the files (link + epochs).
  But if you check or uncheck the selected projectors while reviewing a continuous file, it has no effect on the epochs already imported.


%% Compute head model %%
* For MEG data only, use the Overlapping Spheres model.

%% Noise covariance matrix %%
* Load empty room recordings relative to the subject (see Scheda_soggetti.xlsx) in subject EmptyRoom. Analyse as raw data: 
* Identify bad channels in bn_par_er. It is desirable that bad channels include those identified in recorded data.
* Run Maxfilter (with no head transformation) with bn_preproc_er. 
* Open the sss file in subject EmptyRoom, mark bad segments, filter.
* Compute the covariance matrix for the whole ER time series. Check image.
* Copy it to the 'common file' folder of the subject.
* NOTE: do not use the "copy to other subjects" otpion because it copies it to ALL other subjects!.

%% Source estimation %%
* Use default wMNE.

%% Epoch and further cleaning %%
* Epoch on relevant events: deviants: [11:19],[21:29],[31:39],[41:49]; habituation:[1 2 3 4], apply SSP projectors (EOG ECG correction), epoch range [-150 850] ms.
* Add time offset: -50 ms (stimulus-trigger delay). Now the epoch range is [-200 800] ms.
* Remove baseline: [-200 0]. Would high-pass filtering be better?
* Concatenate these steps into one script: /bst_scripts/bst_epoch. INPUT NEEDED: you have to enter the subject name in the matlab file.
* Scroll between trials in each condition for further visual rejection of epochs containing residual artifacts. 
 (peak-to-peak threshold (e.g. grad: 3000, mag: 2000) is not reliable. Probability-based measures would be better)
 In practice: open butterfly, right-click and open topography, to scroll use F3 (among trials) and F2 (among conditions), Maj for going backward.
* Compute averages and put them in the @intra folder. Use /bst_scripts/bstcontrast to compute the regression on number deviants (function to optimize)

Now data are ready to be converted into FT for single subject stats!
