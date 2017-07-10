import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from classifyRiemann import classifyRiemann
params = prepDataDecoding(dirs,'op1_riemann','op1_riemann','s17','nobaseline',2)
classifyRiemann(params['X_train'], params['y_train'], params)