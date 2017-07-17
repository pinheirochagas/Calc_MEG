import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
params = prepDataDecoding(dirs,'resultlock_pres_len200ms','resultlock_pres_len200ms','s08','nobaseline',2)
calcDecoding(params,'class','accuracy','gat')