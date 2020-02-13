#'''
#====================================================
#Calculation MEG experiment
#Pedro Pinheiro-Chagas
#12/2014
#====================================================
#'''

from __future__ import division # so that 1/3=0.333 instead of 1/3=0
import os # for file/folder operations
import numpy as np # numbers
import pandas as pd  # data storage 
from numpy import genfromtxt # import csv to a numpy array
from numpy.random import random, shuffle # for random number generators and shuffling 
from psychopy import visual, core, data, event, logging, gui, parallel # all needed modules from psychopy
from psychopy.constants import *   


runlist = pd.read_csv('stimuli/Calc/' + 'ainaf' + '/'+ 'run' + '1' +  '.csv', header = 0, sep=',', encoding = 'latin-1') 

print runlist
