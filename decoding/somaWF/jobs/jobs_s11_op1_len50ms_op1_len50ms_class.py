import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
params = prepDataDecoding(dirs,'op1_len50ms','op1_len50ms','s11','nobaseline_correct')
calcDecoding(params,'class','accuracy','diagonal')