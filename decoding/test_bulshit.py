# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np

# Subjects
#subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
  #          's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

subjects = ['s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's22']

subject = 's04'

##
conditions = [['addsub', 'vsa']]
baselinecorr = 'nobaseline'
dec_method = 'class'
dec_scorer = 'accuracy'
gatordiag = 'gat'
decimate = 2

params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)