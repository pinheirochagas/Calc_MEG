# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from calc_createWorkFlow import calc_createWorkFlow

# Subjects
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

# Subjects
#subjects = ['s03']

#subjects = ['s03']
conditions = [['op1','op1'], ['addsub', 'addsub'], ['op2', 'op2'], ['cres', 'cres'], ['resultlock_op1', 'resultlock_op1'],
              ['resultlock_addsub', 'resultlock_addsub'], ['resultlock_op2', 'resultlock_op2'], ['resultlock_cres', 'resultlock_cres'],
              ['resultlock_pres', 'resultlock_pres'], ['resultlock_absdeviant', 'resultlock_absdeviant'], ['resultlock_deviant', 'resultlock_deviant'],
              ['resplock_respside', 'resplock_respside'], ['resplock_choice', 'resplock_choice'], ['resplock_absdeviant', 'resplock_absdeviant'],
              ['resplock_deviant', 'resplock_deviant'], ['resplock_pres', 'resplock_pres'], ['resplock_cres', 'resplock_cres'],
              ['resplock_op2', 'resplock_op2'], ['resplock_addsub', 'resplock_addsub'], ['resplock_op1', 'resplock_op1'], ['vsa', 'vsa'],
              ['vsa', 'addsub'], ['addsub', 'vsa'], ['resultlock_cres', 'cres'], ['op1', 'cres'], ['op1', 'resultlock_pres']]

conditions = [['op1','op1'], ['op2', 'op2'], ['cres', 'cres'], ['resultlock_op1', 'resultlock_op1'],
              ['resultlock_op2', 'resultlock_op2'], ['resultlock_cres', 'resultlock_cres'],
              ['resultlock_pres', 'resultlock_pres'], ['resultlock_absdeviant', 'resultlock_absdeviant'], ['resultlock_deviant', 'resultlock_deviant'],
              ['resplock_absdeviant', 'resplock_absdeviant'], ['resplock_deviant', 'resplock_deviant'], ['resplock_pres', 'resplock_pres'], ['resplock_cres', 'resplock_cres'],
              ['resplock_op2', 'resplock_op2'], ['resplock_op1', 'resplock_op1'],
              ['resultlock_cres', 'cres'], ['op1', 'cres'], ['op1', 'resultlock_pres']]

baselinecorr = 'nobaseline'
#dec_method = 'class'
#dec_scorer = 'accuracy'
dec_method = 'reg'
dec_scorer = 'kendall_score'
gatordiag = 'gat'
decimate = 2

for i in range(0,len(conditions)):
    calc_createWorkFlow(conditions[i], subjects, baselinecorr, dec_method, dec_scorer, gatordiag, decimate)


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

