import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
params = prepDataDecoding(dirs,'resplock_deviant_len200ms','resplock_deviant_len200ms','s18','nobaseline',2)
calcDecoding(params,'reg','kendall_score','gat')