import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
params = prepDataDecoding(dirs,'op1_len200ms','op1_len200ms','s02','nobaseline',2)
calcDecoding(params,'class','accuracy','gat')