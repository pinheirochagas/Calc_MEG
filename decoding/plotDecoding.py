#Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
#sys.path.append('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/decoding/')
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from scipy import stats
from scipy.stats import wilcoxon
from scipy.stats import mannwhitneyu

#Personal functions
from initDirs import dirs
from jr.plot import base, gat_plot, pretty_gat, pretty_decod, pretty_slices
from jr.stats import gat_stats, parallel_stats

def plotDecoding(subjects, baselinecorr, dec_method, dec_scorer, gatordiag, conditions, sfreq, chance):


    #Define custom wilcoxon
    def _my_wilcoxon(X):
        out = wilcoxon(X)
        return out[1]


    #Basics
    #Paths

    #List of parameters
    subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
                's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

    #subjects = ['s03']
    #s02_op1_op1_results_class_accuracy_diagonal_nobaseline_correct.npy

    baselinecorr = 'nobaseline'
    #dec_method = 'reg'
    #dec_scorer = 'kendall_score'
    dec_method = 'class'
    dec_scorer = 'accuracy'
    gatordiag = 'gat'

    conditions = [['resultlock_pres', 'resultlock_pres']]

    sfreq = 150
    chance = .25 #chance-level

    ttp = [-0.2] #starting time point
    toi = [[0.3, 0.6], [0.8, 2.532]] #training time points over which to average


    # Initialize results
    all_scores = []
    all_diagonals = []
    all_ypred = []

    ####################Load data####################
    for c, cond in enumerate(conditions):
        for s, subject in enumerate(subjects):
            print('loading subject ' + subject)
            fname = dirs['ind_result'] + cond[0] + '_' + cond[1] + '/' + subject + '_' + cond[0] + '_' + cond[
                1] + '_' + 'results' + '_' + dec_method + '_' + dec_scorer + '_' + gatordiag + '_' + baselinecorr + '.npy'
            # fname = dirs['ind_result'] + cond[0] + '_' + cond[1] + '/' + subject + '_' + cond[0] + '_' + cond[1] + '_' + 'results' + '_' + dec_method + '_' + dec_scorer + '_' + gatordiag + '.npy'
            results = np.load(fname)
            results = results.tolist()
            all_scores.append(results['score'])
            all_diagonals.append(results['diagonal'])
            all_ypred.append(results['y_pred'])
            # times = results['times_calc']
    score = results['score']
    diagonal = results['diagonal']
    ypred = results['y_pred']
    all_scores = np.array(all_scores)  # shape: subjects*n_cond, training_times, testing_times
    all_diagonals = np.array(all_diagonals)
    # all_ypred = np.array(all_ypred)

    # Reshape and average data
    all_scores = np.reshape(all_scores, (
    len(conditions), len(subjects), score.shape[0], score.shape[1]))  # n_cond, n_subj, training_times, testing_times
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

    times = np.arange(results['train_times']['start'], results['train_times']['stop'] + 0.008, 0.008)

    # Compute stats for each condition separately
    p_values_gat = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
    p_values_gat_fdr = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
    p_values_diagonal = np.zeros((len(conditions), all_diagonals.shape[2]))
    p_values_diagonal_fdr = np.zeros((len(conditions), all_diagonals.shape[2]))

    for c, cond in enumerate(conditions):
        print('calculating stats for condition' + '_' + cond[0] + '_' + cond[1])
        p_values_gat[c, :, :] = parallel_stats(all_scores[c, :, :, :] - chance, function=_my_wilcoxon, correction=False,
                                               n_jobs=-1)
        p_values_gat_fdr[c, :, :] = parallel_stats(all_scores[c, :, :, :] - chance, function=_my_wilcoxon,
                                                   correction='FDR', n_jobs=-1)
        p_values_diagonal[c, :] = parallel_stats(all_diagonals[c, :, :] - chance, function=_my_wilcoxon,
                                                 correction=False, n_jobs=-1)
        p_values_diagonal_fdr[c, :] = parallel_stats(all_diagonals[c, :, :] - chance, function=_my_wilcoxon,
                                                     correction='FDR', n_jobs=-1)

        # Get one-sided p-value
        p_values_diagonal[c, :] = p_values_diagonal[c, :] / 2.
        p_values_diagonal_fdr[c, :] = p_values_diagonal_fdr[c, :] / 2.

        save_dir = dirs['result'] + 'individual_results/' + params['train_set'] + '_' + params['test_set'] + '/'
        if not os.path.exists(save_dir):
            os.makedirs(save_dir)

