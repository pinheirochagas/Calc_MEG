# Initialize dirs
# Calc_MEG
# Pinheiro-Chagas 2017

# Packages
from uuid import getnode

# Define dirs according to the computer
mac_address = getnode()

if mac_address == 119022279803690:
    # MAC with Lacie 4T
    root = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/'
else:
    # NeuroSpin workstation
    root = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/'

dirs = ({'root': root,
         'job': root + 'scripts/decoding/somaWF/jobs/',
         'data': root + 'data/mat/',
         'TFA_data': root + 'data/TFA/',
         'result': root + 'results/decoding/',
         'ind_result': root + 'results/decoding/individual_results/',
         'gp_result': root + 'results/decoding/group_results/',
         'script': root + 'scripts/decoding/'})


