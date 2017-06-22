import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
params = prepDataDecoding(dirs,'cres_group','cres_group','s18','nobaseline_correct')
calcDecoding(params,'class','accuracy','diagonal')