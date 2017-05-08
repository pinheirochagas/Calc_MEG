# Initialize dirs
# Calc_MEG
# Pinheiro-Chagas 2017

# Packages
import socket

# Define dirs according to the computer
if socket.gethostname() == 'pc76.home':
    # MAC with Lacie 4T
    root = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/'
else:
    # NeuroSpin workstation
    root = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/'

dirs = ({'root': root,
         'job': root + 'scripts/decoding/somaWF/jobs/',
         'data': root + 'data/mat/',
         'result': root + 'results/decoding/',
         'script': root + 'scripts/decoding/'})
