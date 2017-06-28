# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from calc_createWorkFlow import calc_createWorkFlow

# Subjects
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

#subjects = ['s03']
conditions = [['resplock_absdeviant', 'resplock_absdeviant']]
baselinecorr = 'nobaseline'
dec_method = 'class'
dec_scorer = 'accuracy'
gatordiag = 'gat'
decimate = 2

calc_createWorkFlow(conditions, subjects, baselinecorr, dec_method, dec_scorer, gatordiag, decimate)


# 'resp_side'
# 'choice'
# 'correctness'
# 'resplock_cres'
# 'resplock_pres'
# 'resplock_op1'
# 'resplock_op2'
# 'resplock_operator'
# 'resultlock_cres'
# 'resultlock_pres'
# 'resultlock_op1'
# 'resultlock_op2'
# 'resultlock_operator'