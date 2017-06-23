# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from calc_createWorkFlow import calc_createWorkFlow

# Subjects
#subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
#            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']



subjects = ['s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's22']
conditions = [['vsa', 'addsub']]
baselinecorr = 'no'
dec_method = 'class'
dec_scorer = 'accuracy'
gatordiag = 'gat'

calc_createWorkFlow(conditions, subjects, baselinecorr, dec_method, dec_scorer, gatordiag)