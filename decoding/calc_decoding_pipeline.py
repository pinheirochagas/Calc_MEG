# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np
from classifyGeneral import classifyGeneral
import pandas as pd
from prepDataDecTFA import prepDataDecTFA

# Subjects
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

# Basic parameters
conditions = [['resultlock_pres_i', 'resultlock_pres_i']]
baselinecorr = 'nobaseline'
dec_method = 'class' # class reg classGeneral
dec_scorer = 'accuracy' # accuracy or kendall_score
gatordiag = 'gat'
decimate = 2

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    calcDecoding(params, dec_method, dec_scorer, gatordiag)     # or calcDecoding(params, dec_method, dec_scorer, gatordiag)

conditions = [['resultlock_pres_c', 'resultlock_pres_c']]
for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    calcDecoding(params, dec_method, dec_scorer, gatordiag)     # or calcDecoding(params, dec_method, dec_scorer, gatordiag)


## Save trialinfo pres - isso é uma gambiarra. Tenho que achar a maneira correta de salvar trialinfo para cada sujeito e deixar no output do classifier.
for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    fname = dirs['result'] + '/group_results/' + conditions[0][0] + '_' + conditions[0][1] + '/' + subject + '_' + conditions[0][0] + '_' + conditions[0][1] + '_trialinfo.csv'
    X_train_info = params['X_train_info']
    X_train_info.to_csv(fname)

########## TIme frequency
results = pd.DataFrame(index=range(1, 1), columns={'Accuracy'})
conditions = [['op2_freq_riemann', 'op2_freq_riemann']]
for s, subject in enumerate(subjects):
    X, y, params = prepDataDecTFA(dirs, conditions[0][0], conditions[0][1], subject)
    result = classifyGeneral(X, y, params)
    results.loc[s] = result['Accuracy'][0]


prepDataDecTFA(train_set, test_set, subject):





# Combine subjects Riemann
results = np.zeros(len(subjects))
for s, subject in enumerate(subjects):
    fname = dirs['ind_result'] + conditions[0][0] + '_' + conditions[0][1] + '/' + subject + '_' + conditions[0][0] + '_' + conditions[0][1] \
            + '_results_classRiemann.csv'
    df = pd.read_csv(fname)
    results[s] = df['Accuracy'][0]

    np.mean(results)





########################################################################################################################
####  Combine results and plot
# Libraries
import matplotlib.pyplot as plt
import combineSubsDecoding
import plotDecodingExplore
reload(plotDecodingExplore)
from combineSubsDecoding import combineSubsDecoding
from plotDecodingExplore import plotDecodingExplore
from initDirs import dirs
import scipy.io

#List of parameters
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']
#subjects = ['s02', 's03']

baselinecorr = 'nobaseline'
dec_method = 'class'  # 'reg' or 'class'
dec_scorer = 'accuracy'  # or 'accuracy' kendall_score
gatordiag = 'gat'
sfreq = 125

conditions = [['resplock_deviant', 'resplock_deviant'], ['resplock_pres', 'resplock_pres'],
              ['resplock_op2', 'resplock_op2'], ['resplock_op1', 'resplock_op1']]

for i in range(len(conditions)):
    condition = conditions[i]
    res = combineSubsDecoding(subjects, baselinecorr, dec_method, dec_scorer, gatordiag, [condition], sfreq)
    plotDecodingExplore(res)
    # Prepare results
    fname = dirs['gp_result'] + [condition][0][0] + '_' + [condition][0][1] + '/' + [condition][0][0] + '_' + [condition][0][1] + '_' + dec_method + '_' + dec_scorer + '_' + 'results'
    np.save(fname, res)
    fname_mat = fname + '.mat'
    scipy.io.savemat(fname_mat, res)
    plt.close("all")



## Missing

# ['resultlock_addsub', 'resultlock_addsub']
# ['resplock_absdeviant', 'resplock_absdeviant']
# ['resplock_cres', 'resplock_cres']
# ['resplock_addsub', 'resplock_addsub']



## Done
# ['addsub', 'addsub']
conditions = [['resplock_respside', 'resplock_respside']]

## To complete
# addsub
# op2 reg




conditions = [['op2', 'op2'], ['cres', 'cres'], ['resultlock_op1', 'resultlock_op1'],
              ['resultlock_op2', 'resultlock_op2'], ['resultlock_cres', 'resultlock_cres'],
              ['resultlock_pres', 'resultlock_pres'], ['resultlock_absdeviant', 'resultlock_absdeviant'], ['resultlock_deviant', 'resultlock_deviant'],
              ['resplock_respside', 'resplock_respside'], ['resplock_choice', 'resplock_choice'],
              ['resplock_deviant', 'resplock_deviant'], ['resplock_pres', 'resplock_pres'],
              ['resplock_op2', 'resplock_op2'], ['resplock_op1', 'resplock_op1']]




#######################################################################################################################



# Load results
import sys
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from scipy import stats
from initDirs import dirs
from jr.plot import pretty_gat, pretty_decod
import mne
from mne.decoding import GeneralizationAcrossTime



subjects = ['s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's22']

#subjects = ['s02']

conditions = [['cres_group', 'cres_group']]

#Combine results from all conditions
all_scores = []
all_diagonals = []

for c, cond in enumerate(conditions):
    for s, subject in enumerate(subjects):
        print('loading subject ' + subject)
        fname = dirs['result'] + 'individual_results/' + subject + '_' + cond[0] + '_' + cond[1] + '_results_class_accuracy_diagonal_nobaseline_correct.npy'
        #fname = dirs['result'] + 'individual_results/' + subject + '_' + cond[0] + '_' + cond[1] + '_results_class_accuracy_diagonal_nobaseline_correct.npy'
        results = np.load(fname)
        # Convert to list
        results = results.tolist()
        all_scores.append(results['score'])
        all_diagonals.append(results['diagonal'])
score = results['score']
diagonal = results['diagonal']
#time_calc = results['params']['times_calc']
#params = results['params']
all_scores = np.array(all_scores) #shape: subjects*n_cond, training_times, testing_times
all_diagonals = np.array(all_diagonals)



#Average data
#Reshape
all_scores = np.reshape(all_scores, (len(conditions), len(subjects), score.shape[0], score.shape[1])) #n_cond, n_subj, training_times, testing_times
all_diagonals = np.reshape(all_diagonals, (len(conditions), len(subjects), diagonal.shape[0]))

group_scores = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
sem_group_scores = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
group_diagonal = np.zeros((len(conditions), all_diagonals.shape[2]))
sem_group_diagonal = np.zeros((len(conditions), all_diagonals.shape[2]))

for c, cond in enumerate(conditions):
    group_scores[c, :, :] = np.mean(all_scores[c, :, :, :], 0)
    sem_group_scores[c, :, :] = stats.sem(all_scores[c, :, :, :], 0)

    group_diagonal[c, :] = np.mean(all_diagonals[c, :, :], 0)
    sem_group_diagonal[c, :] = stats.sem(all_diagonals[c, :, :], 0)



pretty_gat(group_scores[0, :, :], chance=.25)
plt.savefig(dirs['result'] + 'individual_results/figures/' + 'presTlockCres_cres_gat.png')

# Plot
times = np.arange(-0.2, 4.0004, 0.004)
pretty_decod(all_scores[0,:,:,0], chance=.5, color=[0,0,1], times=times)
plt.axvline(.8, color='k')  # mark stimulus onset
plt.axvline(1.6, color='k')  # mark stimulus onset
plt.axvline(2.4, color='k')  # mark stimulus onset
plt.axvline(3.2, color='k')  # mark stimulus onset
plt.ylim(.09, .2)
plt.savefig(dirs['result'] + 'individual_results/figures/' + 'cres_group.png')




for c, cond in enumerate(conditions):
    group_scores[c, :, :] = np.mean(all_scores[c, :, :, :], 0)
    sem_group_scores[c, :, :] = stats.sem(all_scores[c, :, :, :], 0)

    group_diagonal[c, :] = np.mean(all_diagonals[c, :, :], 0)
    sem_group_diagonal[c, :] = stats.sem(all_diagonals[c, :, :], 0)


for s, subject in enumerate(subjects):
    plt.figure(figsize=(15, 5))
    pretty_decod(all_scores[0,s,:,0], chance=.25)
    plt.axvline(0, color = 'g') #mark stimulus onset
    plt.axvline(.8, color = 'g') #mark stimulus onset
    plt.axvline(1.6, color = 'g') #mark stimulus onset
    plt.axvline(2.4, color = 'g') #mark stimulus onset
    plt.axvline(3.2, color = 'g') #mark stimulus onset
    plt.ylim(.1,.50)
    plt.savefig(dirs['result'] + 'individual_results/' + subject + 'cres_group.png')

    plt.figure(figsize=(15, 5))


for s, subject in enumerate(subjects):
    plt.subplot(5, 4, s+1)
    pretty_decod(all_scores[0,s,:,0], chance=.25)
    #plt.savefig(dirs['result'] + 'individual_results/' + subject + 'cres_50ms.png')


plt.close('all')

times = np.arange(-0.2, 4.4004, 0.004)

s_good = np.array([1,2,4,5,6,7,9,10,13,14,16])-1

plt.subplot(2,2,1)
pretty_decod(all_scores[0,s_good,:,0], chance=.25, color=[1,0,0])
pretty_decod(all_scores[0,np.array([2,6,10,14])-1,:,0], chance=.25, color=[0,1,0])



plt.ylim(.22, .4)
plt.subplot(2,2,2)
pretty_decod(all_scores[0,:,:,0], chance=.25)
plt.ylim(.22, .4)
plt.subplot(2,2,3)
pretty_decod(all_scores[0,np.array([2,6,10,14])-1,:,0], chance=.25)
plt.ylim(.22, .4)

#params = prepDataDecoding(dirs, 'cres', 'cres', 's02', 'baseline_correct')



params = prepDataDecoding(dirs, 'cres', 'cres', 's08', 'baseline_correct')
calcDecoding(params, 'class', 'accuracy', 'diagonal')


pretty_decod(all_scores[0,:,:,0], chance=.25, color=[0,0,1], times=times)
plt.axvline(.8, color='g')  # mark stimulus onset
plt.axvline(1.6, color='g')  # mark stimulus onset
plt.axvline(2.4, color='g')  # mark stimulus onset
plt.axvline(3.2, color='g')  # mark stimulus onset
plt.ylim(.22, .3)



results = np.load('/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/decoding/individual_results/s08_cres_cres_results_class_accuracy.npy')
results = results.tolist()


from jr.plot import pretty_gat, pretty_decod
import matplotlib.pyplot as plt


scores = results['score']


plt.subplot(3, 1, 1)
pretty_decod(scores, chance=.25)
plt.subplot(3, 1, 2)
pretty_gat(scores, chance=.25)
plt.subplot(3, 1, 3)
plt.plot(diag)



# Define conditions
conds = ['addsub', 'addsub']

# Run classification
calc_dec_wTask_CR(root_dir,['addsub', 'addsub'],'s01','class')



##############################################################


cmap = plt.get_cmap('gist_rainbow')
analyses = []

for ii in range(100):
    color = np.array(cmap(float(ii) / 100))
    analyses[ii] = color
