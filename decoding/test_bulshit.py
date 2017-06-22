# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np

subject = 's03'
params = prepDataDecoding(dirs, 'presTlockCres', 'cres', subject, 'baseline_nocorrect')
calcDecoding(params, 'class', 'accuracy', 'gat')
