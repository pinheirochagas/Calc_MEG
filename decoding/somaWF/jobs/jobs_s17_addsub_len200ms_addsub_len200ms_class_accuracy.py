import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
params = prepDataDecoding(dirs,'addsub_len200ms','addsub_len200ms','s17','nobaseline',2)
calcDecoding(params,'class','accuracy','gat')