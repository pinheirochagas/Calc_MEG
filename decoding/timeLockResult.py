
import mne
import pandas as pd
import numpy as np


def prepDataDecoding(info_calc, epoch_calc):

    # Time lock to the presentation of the result
    print ('timelock result and concate')
    idx_delay = info_calc['delay'] == 1
    idx_nodelay = info_calc['delay'] == 0

    time_calc_crop = np.arange(-0.2, 0.8004, 0.004) # Sensitive line, depends on frquency sample

    epoch_calc_delay = epoch_calc[idx_delay]
    epoch_calc_delay.crop(3.4, 4.4)
    epoch_calc_delay.times = time_calc_crop

    epoch_calc_nodelay = epoch_calc[idx_nodelay]
    epoch_calc_nodelay.crop(3.0, 4)
    epoch_calc_nodelay.times = time_calc_crop

    info_calc_delay = info_calc[info_calc['delay'] == 1]
    info_calc_nodelay = info_calc[info_calc['delay'] == 0]
    #info_calc_delay['operand'] = info_calc_delay['presResult']  # add another column 'operand' for the big decoder
    #info_calc_nodelay['operand'] = info_calc_nodelay['presResult']  # add another column 'operand' for the big decoder

    epoch_calc_reslock = mne.epochs.concatenate_epochs([epoch_calc_delay, epoch_calc_nodelay])
    info_calc_reslock = pd.concat([info_calc_delay, info_calc_nodelay])

    return epoch_calc_reslock, info_calc_reslock