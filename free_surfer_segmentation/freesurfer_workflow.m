%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  FREESURFER - MRI SEGMENTATION  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 1. MRI data import with BRAINVISA %%

- Create a temporary folder: 
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ml090321_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/rm080030_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cs150099_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100109_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/dp150209_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mm150194_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100042_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl140280_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ts150275_tmp

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/bc150339_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mk150295_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jf140150_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/hb140194_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cd130323_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ag150338_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/db150361_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ej130467_tmp

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mp150285_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl130503_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/tc120199_tmp
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ps150333_tmp

- Open a terminal window, type in brainvisa 
1. Click on Data Management located in the left panel. 
2. Double-click on Data Storage Client located in the middle panel. 
3. A new window opens up, in the middle panel, select the directory in which you want the MRI to be transferred to:  /neurospin/meg/meg_tmp/mystudy/mri/NIP_tmp
4. On the left panel, click on thesystem folder from which the MRI of your  subject was acquired (in most cases, it will be Siemens Tim Trio 3.0T (NeuroSpin) 
5. Select the date corresponding to the date your subject underwent MRI. 
6. Select the series you need to import. Tip: In general, the structural anatomy file is marked as 'MPRAGE' (but the name is sometimes  missing) and its size is between 30 and 35 Mb. 
7. Click on Add>> in the middle panel. 

You can repeat this as many times as MRI series you need to import (insuring you select the proper folder each time!). 
Once your selection is finished, click on Run in the middle panel. 
The MRI series will be exported. 


%% 2. MRI convert to .mgz with FREESURFER %%

- Create the needed folders (mri/orig and mri/transforms): 
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ml090321/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ml090321/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/rm080030/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/rm080030/mri/orig



mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cs150099/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cs150099/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100109/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100109/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/dp150209/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/dp150209/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mn150194/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mn150194/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100042/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100042/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl140280/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl140280/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ts150275/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ts150275/mri/orig


mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/bc150339/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/bc150339/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mk150295/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mk150295/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jf140150/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jf140150/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/hb140194/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/hb140194/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cd130323/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cd130323/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ag150338/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ag150338/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/db150361/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/db150361/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ej130467/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ej130467/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mp150285/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mp150285/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl130503/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl130503/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/tc120199/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/tc120199/mri/orig

mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ps150333/mri/transforms
mkdir /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ps150333/mri/orig


source $FREESURFER_HOME/SetUpFreeSurfer.sh

- Select the first dicom file, by listing with ls -l
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/raw_data/anat/ml090321_tmp/ptk_server_task_0/ml090321-4429_001_000002_1.3.12.2.1107.5.2.32.35185.2014062416082195399172532.dcm  /neurospin/meg/meg_tmp/Calculation_Pedro_2014/raw_data/anat/ml090321/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/raw_data/anat/rm080030_tmp/ptk_server_task_0/rm080030-4339_001_000002_1.3.12.2.1107.5.2.32.35185.2014041509222829376684600.dcm  /neurospin/meg/meg_tmp/Calculation_Pedro_2014/raw_data/anat/rm080030/mri/orig/001.mgz

mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cs150099_tmp/ptk_server_task_0/cs150099-4827_001_000002_1.3.12.2.1107.5.2.32.35185.2015062217580393797517358.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cs150099/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100109_tmp/ptk_server_task_0/jm100109-4806_001_000002_1.3.12.2.1107.5.2.32.35185.2015060214010017060401430.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100109/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/dp150209_tmp/ptk_server_task_0/dp150209-4854_001_000002_1.3.12.2.1107.5.2.32.35185.30000015072112442439000000004.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/dp150209/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mn150194_tmp/ptk_server_task_0/mn150194-4870_001_000002_1.3.12.2.1107.5.2.32.35185.2015072914250241422717979.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mn150194/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100042_tmp/ptk_server_task_0/jm100042-4880_001_000003_1.3.12.2.1107.5.2.32.35185.2015082410171642347200904.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jm100042/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl140280_tmp/ptk_server_task_0/sl140280-4760_001_000002_1.3.12.2.1107.5.2.32.35185.2015042715094144937712698.dcm  /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl140280/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ts150275_tmp/ptk_server_task_0/ts150275-4874_001_000002_1.3.12.2.1107.5.2.32.35185.2015073018110122973400937.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ts150275/mri/orig/001.mgz


mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/bc150339_tmp/ptk_server_task_0/bc150339-4909_001_000002_1.3.12.2.1107.5.2.32.35185.201510071632401171862824.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/bc150339/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mk150295_tmp/ptk_server_task_0/mk150295-4908_001_000002_1.3.12.2.1107.5.2.32.35185.2015100711590451053955430.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mk150295/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jf140150_tmp/ptk_server_task_0/jf140150-4717_001_000002_1.3.12.2.1107.5.2.32.35185.2015032412493889849512730.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/jf140150/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/hb140194_tmp/ptk_server_task_0/hb140194-4749_001_000002_1.3.12.2.1107.5.2.32.35185.2015042213340117759135462.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/hb140194/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cd130323_tmp/ptk_server_task_0/cd130323-4684_001_000002_1.3.12.2.1107.5.2.32.35185.2015030517272318102306481.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/cd130323/mri/orig/001.mgz

mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ag150338_tmp/ptk_server_task_0/ag150338-4915_001_000013_1.3.12.2.1107.5.2.43.67069.2015110411145120044404855.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ag150338/mri/orig/001.mgz                                                                                                        
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/db150361_tmp/ptk_server_task_0/db150361-5087_001_000002_1.3.12.2.1107.5.2.43.67069.2016041409282382136202956.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/db150361/mri/orig/001.mgz 
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ej130467_tmp/ptk_server_task_0/ej130467-4920_001_000002_1.3.12.2.1107.5.2.43.67069.2015111910570651727806381.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ej130467/mri/orig/001.mgz

mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mp150285_tmp/ptk_server_task_0/mp150285-5149_001_000002_1.3.12.2.1107.5.2.43.67069.2016052511244439068840363.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/mp150285/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl130503_tmp/ptk_server_task_0/sl130503-4780_001_000002_1.3.12.2.1107.5.2.32.35185.2015050512451985844317570.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/sl130503/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/tc120199_tmp/ptk_server_task_0/tc120199-3555_001_000002_1.3.12.2.1107.5.2.32.35185.2013020709524210347029532.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/tc120199/mri/orig/001.mgz
mri_convert /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ps150333_tmp/ptk_server_task_0/ps15033-4919_001_000002_1.3.12.2.1107.5.2.43.67069.2015110914550881736230787.dcm /neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/anat/ps150333/mri/orig/001.mgz






%% 3. MRI segmentation with FREESURFER %%


- Update the script for the cluster
- do the recon-all segmentation
