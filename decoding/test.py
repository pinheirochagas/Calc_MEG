import sys
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from scipy import stats

sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')



data_path = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/data/mat/'
result_path = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/data/decoding/'


epochs_times = np.load(result_path + 'epochs_times.npy')




scores_op1 = np.load(result_path + 'Classification_ 3_vs_4_vs_5_vs_6_Trainset_all_Testset_all.npy')
group_scores_op1 = np.mean(scores_op1, 0)
sem_group_scores_op1 = stats.sem(scores_op1, 0)
diag_op1 = group_scores_op1.diagonal()
diag_op1_sem = sem_group_scores_op1.diagonal()

scores_op2 = np.load(result_path + 'Classification_all 0_vs_1_vs_2_vs_3_Trainset_all_Testset_all.npy')
group_scores_op2 = np.mean(scores_op2, 0)
diag_op2 = group_scores_op2.diagonal()
sem_group_scores_op2 = stats.sem(scores_op2, 0)
diag_op2_sem = sem_group_scores_op2.diagonal()



fig1 = plt.figure()
ax1 = fig1.add_subplot(122)


scores_op1_crop = diag_op1[(epochs_times > -0.2) & (epochs_times < .8)]
scores_op2_crop = diag_op2[(epochs_times > 1.4) & (epochs_times < 2.4)]


scores_op2_crop-scores_op1_crop


ax1 = fig1.add_subplot(121)
plt.plot(epochs_times,diag_op1,epochs_times,diag_op2, linewidth=1.5)

ax1 = fig1.add_subplot(122)
plt.plot(epochs_times[(epochs_times > -0.2) & (epochs_times < .8)],scores_op2_crop-scores_op1_crop, linewidth=1.5)