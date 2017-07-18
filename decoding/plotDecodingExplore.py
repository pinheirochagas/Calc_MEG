# Libraries
from __future__ import division
import matplotlib.pyplot as plt
from jr.plot import base, gat_plot, pretty_gat, pretty_decod, pretty_slices
from initDirs import dirs
import numpy as np
import os

def plotDecodingExplore(res, p_val_th=0.05, smoothWindow=5):

    # Define basic parameters
    dpi = 100
    facecolor = 'w'
    edgecolor = 'k'
    color = [0, 0, 1]

    # Define conditions and subjects
    conditions = res['conditions']
    subjects = res['subjects']
    chance = res['chance']
    sfreq = res['sfreq']
    dec_method = res['dec_method']
    dec_scorer = res['dec_scorer']

    # Define general filename
    #Times
    times = np.arange(res['train_times']['start'],res['train_times']['stop']+1/sfreq,1/sfreq)
    if times.shape[0] > res['all_diagonals'].shape[2]:
        times = np.arange(res['train_times']['start'],res['train_times']['stop'],1/sfreq)
    times = None

    # Crete dir if it doesn't exist
    save_dir = dirs['gp_result'] + conditions[0][0] + '_' + conditions[0][1]
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)

    # GAT individual subjects
    plt.figure(num=None, figsize=(15,12), dpi=dpi, facecolor=facecolor, edgecolor=edgecolor)
    for c, cond in enumerate(conditions):
        for s, sub in enumerate(subjects):
            plt.subplot(4,5,s+1)
            plot = pretty_gat(res['all_scores'][c, s, :, :], times=times, chance=chance, cmap='RdBu_r', colorbar=True, sfreq=sfreq)
            addLines(plot, conditions, 'gat')
            plt.title(cond[0] + '_'+ cond[1] + ' ' + sub)
    fname = dirs['gp_result'] + cond[0] + '_' + cond[1] + '/' + cond[0] + '_' + cond[1] + '_' + dec_method + '_' + dec_scorer + '_' + 'diagonal_individual.png'
    plt.savefig(fname, dpi=600)

    # Diagonal individual subjects
    plt.figure(num=None, figsize=(20,12), dpi=dpi, facecolor=facecolor, edgecolor=edgecolor)
    for c, cond in enumerate(conditions):
        for s, sub in enumerate(subjects):
            plt.subplot(4,5,s+1)
            plot = pretty_decod(res['all_diagonals'][c, s, :], times=times, chance=chance, xlabel='Times (s)')
            addLines(plot, conditions, 'diag')
            plt.title(cond[0] + '_' + cond[1] + ' ' + sub)
    fname = dirs['gp_result'] + cond[0] + '_' + cond[1] + '/' + cond[0] + '_' + cond[1] + '_' + dec_method + '_' + dec_scorer + '_' + 'gat_individual.png'
    plt.savefig(fname, dpi=600)

    #GAT group with uncorrected p values
    plt.figure(num=None, figsize=(10,10), dpi=dpi, facecolor=facecolor, edgecolor=edgecolor)
    for c, cond in enumerate(conditions):
        classLines = [None, None, None, None]
        print(cond)
        plot = pretty_gat(res['group_scores'][c, :, :], times=times, chance=chance, sig=res['p_values_gat'][c,:] < p_val_th, cmap='RdBu_r',
                   colorbar=True, xlabel='Testing Time (s)', ylabel='Training Time (s)', smoothWindow=smoothWindow)
        addLines(plot, conditions, 'gat')
        fname = dirs['gp_result'] + cond[0] + '_' + cond[1] + '/' + cond[0] + '_' + cond[1] + '_' + dec_method + '_' + dec_scorer + '_' + 'group_gat_uncorrected.png'
    plt.savefig(fname, dpi=600)

    #GAT group with corrected p values
    plt.figure(num=None, figsize=(10,10), dpi=dpi, facecolor=facecolor, edgecolor=edgecolor)
    for c, cond in enumerate(conditions):
        print(cond)
        plot = pretty_gat(res['group_scores'][c, :, :], times=times, chance=chance, sig=res['p_values_gat_fdr'][c,:] < p_val_th, cmap='RdBu_r',
                   colorbar=True, xlabel='Testing Time (s)', ylabel='Training Time (s)', smoothWindow=smoothWindow)
        addLines(plot, conditions, 'gat')
        fname = dirs['gp_result'] + cond[0] + '_' + cond[1] + '/' + cond[0] + '_' + cond[1] + '_' + dec_method + '_' + dec_scorer + '_' + 'group_gat_corrected.png'
    plt.savefig(fname, dpi=600)

    #Diagonal group with uncorrected p values
    plt.figure(num=None, figsize=getfigsize(conditions), dpi=dpi, facecolor=facecolor, edgecolor=edgecolor)
    for c, cond in enumerate(conditions):
            print (cond)
            #print(times[np.where(p_values_diagonal[c, :] < .05)])
            plot = pretty_decod(res['all_diagonals'][c, :, :], times=times, chance=chance, sig=res['p_values_diagonal'][c, :] < p_val_th,
                     color=color, fill=True, xlabel='Times (s)', sfreq=sfreq, smoothWindow=smoothWindow)
            addLines(plot,conditions, 'diag')
            fname = dirs['gp_result'] + cond[0] + '_' + cond[1] + '/' + cond[0] + '_' + cond[1] + '_' + dec_method + '_' + dec_scorer + '_' + 'group_diagonal_uncorrected.png'
    plt.savefig(fname, dpi = 600)

    #Diagonal group with corrected p values
    plt.figure(num=None, figsize=getfigsize(conditions), dpi=dpi, facecolor=facecolor, edgecolor=edgecolor)
    for c, cond in enumerate(conditions):
            print (cond)
            #print(times[np.where(p_values_diagonal[c, :] < .05)])
            plot = pretty_decod(res['all_diagonals'][c, :, :], times=times, chance=chance, sig=res['p_values_diagonal_fdr'][c, :] < p_val_th,
                     color=color, fill=True, xlabel='Times (s)', sfreq=sfreq, smoothWindow=smoothWindow)
            addLines(plot,conditions, 'diag')
            fname = dirs['gp_result'] + cond[0] + '_' + cond[1] + '/' + cond[0] + '_' + cond[1] + '_' + dec_method + '_' + dec_scorer + '_' + 'group_diagonal_corrected.png'
    plt.savefig(fname, dpi = 600)


def addLines(plot, conditions, gatordiag):

    color_line = '0.5'

    if gatordiag == 'diag':
        if conditions[0][0] == conditions[0][1]:
            if conditions[0][0] == 'op1' or conditions[0][0] == 'op2' or conditions[0][0] == 'cres' or conditions[0][0] == 'addsub':
                plot.axvline(.8, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axvline(1.6, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axvline(2.4, color=color_line, linestyle='-')  # mark stimulus onset
            elif conditions[0][0] == 'resultlock_op1' or conditions[0][0] == 'resultlock_addsub' or conditions[0][0] == 'resultlock_op2' or conditions[0][0] == 'resultlock_cres' or conditions[0][0] == 'resultlock_pres'\
                    or conditions[0][0] == 'resultlock_absdeviant' or conditions[0][0] == 'resultlock_deviant':
                plot.axvline(.4, color=color_line, linestyle='-')  # mark stimulus onset

    else:
        if conditions[0][0] == conditions[0][1]:
            if conditions[0][0] == 'op1' or conditions[0][0] == 'op2' or conditions[0][0] == 'cres' or conditions[0][0] == 'addsub':
                plot.axvline(.8, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axvline(1.6, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axvline(2.4, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axhline(.8, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axhline(1.6, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axhline(2.4, color=color_line, linestyle='-')  # mark stimulus onset
            elif conditions[0][0] == 'resultlock_op1' or conditions[0][0] == 'resultlock_addsub' or conditions[0][0] == 'resultlock_op2' or conditions[0][0] == 'resultlock_cres' or conditions[0][0] == 'resultlock_pres'\
                    or conditions[0][0] == 'resultlock_absdeviant' or conditions[0][0] == 'resultlock_deviant':
                plot.axvline(.4, color=color_line, linestyle='-')  # mark stimulus onset
                plot.axhline(.4, color=color_line, linestyle='-')  # mark stimulus onset

def getfigsize(conditions):
    if conditions[0][0] == conditions[0][1]:
        if conditions[0][0] == 'op1' or conditions[0][0] == 'op2' or conditions[0][0] == 'cres' or conditions[0][0] == 'addsub':
            figsize =(16,4)
        else:
            figsize =(5,4)

    return figsize
