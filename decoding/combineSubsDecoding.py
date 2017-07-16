#Libraries
from __future__ import division
import numpy as np
from scipy import stats
from scipy.stats import wilcoxon
from scipy.stats import mannwhitneyu
#Personal functions
from stats import _my_wilcoxon
from initDirs import dirs
from jr.stats import parallel_stats



def combineSubsDecoding(subjects, baselinecorr, dec_method, dec_scorer, gatordiag, conditions, sfreq, complete='no'):

    #Load data
    # Initialize results
    all_scores = []
    all_diagonals = []
    all_ypred = []
    all_ytrue = []

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
            #all_ypred.append(results['y_pred'])
            #all_ytrue.append(results['y_true'])
            # times = results['times_calc']
    score = results['score']
    diagonal = results['diagonal']
    #ypred = results['y_pred']
    all_scores = np.array(all_scores)  # shape: subjects*n_cond, training_times, testing_times
    all_diagonals = np.array(all_diagonals)
    # all_ypred = np.array(all_ypred)

    # chance = 0.5

    # Define chance
    if dec_scorer == 'kendall_score':
        chance = 0  # chance-level
    else:
        chance = 1 / len(np.unique(results['y_true']))


    # Reshape and average data
    all_scores = np.reshape(all_scores, (len(conditions), len(subjects), score.shape[0], score.shape[1]))  # n_cond, n_subj, training_times, testing_times
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

    # Define times
    times = np.arange(results['train_times']['start'], results['train_times']['stop'] + 0.008, 0.008)
    # times = np.arange(-0.55,results['train_times']['stop'] + 0.05 + 0.008,0.008)

    # Compute stats for each condition separately
    p_values_gat = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
    p_values_gat_fdr = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
    p_values_diagonal = np.zeros((len(conditions), all_diagonals.shape[2]))
    p_values_diagonal_fdr = np.zeros((len(conditions), all_diagonals.shape[2]))

    for c, cond in enumerate(conditions):
        print('calculating stats for condition' + '_' + cond[0] + '_' + cond[1])
        p_values_gat[c, :, :] = parallel_stats(all_scores[c, :, :, :] - chance, function=_my_wilcoxon, correction=False, n_jobs=-1)
        p_values_gat_fdr[c, :, :] = parallel_stats(all_scores[c, :, :, :] - chance, function=_my_wilcoxon, correction='FDR', n_jobs=-1)
        p_values_diagonal[c, :] = parallel_stats(all_diagonals[c, :, :] - chance, function=_my_wilcoxon, correction=False, n_jobs=-1)
        p_values_diagonal_fdr[c, :] = parallel_stats(all_diagonals[c, :, :] - chance, function=_my_wilcoxon, correction='FDR', n_jobs=-1)

        # Get one-sided p-value
        p_values_diagonal[c, :] = p_values_diagonal[c, :] / 2.
        p_values_diagonal_fdr[c, :] = p_values_diagonal_fdr[c, :] / 2.


    if complete == 'no':
        results = (
        {'chance': chance,'dec_method': dec_method, 'dec_scorer': dec_scorer, 'conditions': conditions, 'subjects': subjects, 'all_scores': all_scores, 'all_diagonals': all_diagonals, 'group_scores': group_scores,
         'sem_group_scores': sem_group_scores, 'group_diagonal': group_diagonal,
         'sem_group_diagonal': sem_group_diagonal, 'times': times, 'p_values_gat': p_values_gat,
         'p_values_gat_fdr': p_values_gat_fdr, 'p_values_diagonal': p_values_diagonal,
         'p_values_diagonal_fdr': p_values_diagonal_fdr,
         'sem_group_diagonal': sem_group_diagonal, 'times': times, 'p_values_gat': p_values_gat,
         'p_values_gat_fdr': p_values_gat_fdr, 'p_values_diagonal': p_values_diagonal,
         'p_values_diagonal_fdr': p_values_diagonal_fdr,
         'sfreq': sfreq, 'train_times': results['train_times'], 'test_times': results['test_times']})
    elif complete == 'yes':
        results = (
        {'chance': chance, 'dec_method': dec_method, 'dec_scorer': dec_scorer, 'conditions': conditions, 'subjects': subjects, 'all_scores': all_scores, 'all_diagonals': all_diagonals, 'group_scores': group_scores,
         'sem_group_scores': sem_group_scores, 'group_diagonal': group_diagonal,
         'sem_group_diagonal': sem_group_diagonal, 'times': times, 'p_values_gat': p_values_gat,
         'p_values_gat_fdr': p_values_gat_fdr, 'p_values_diagonal': p_values_diagonal,
         'p_values_diagonal_fdr': p_values_diagonal_fdr,
         'sem_group_diagonal': sem_group_diagonal, 'times': times, 'p_values_gat': p_values_gat,
         'p_values_gat_fdr': p_values_gat_fdr, 'p_values_diagonal': p_values_diagonal,
         'p_values_diagonal_fdr': p_values_diagonal_fdr,
         'sfreq': sfreq, 'train_times': results['train_times'], 'test_times': results['test_times'], 'all_ypred': all_ypred,
         'all_ytrue': all_ytrue})
    else:
        error('you can only specify yes or no fr complete')


    return results



def error(message):
    import sys
    sys.stderr.write("error: %s\n" % message)
    sys.exit(1)



