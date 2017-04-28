# Import functions
import sys
sys.path.append('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/decoding/')
from calc_dec_wTask_CR import calc_dec_wTask_CR

# Define dirs
root_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/'

# Subjects
subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

# Define conditions
conds = ['addsub', 'addsub']

# Run classification
calc_dec_wTask_CR(root_dir,['addsub', 'addsub'],'s01','class')




