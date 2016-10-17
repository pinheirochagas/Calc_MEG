# Run classification and regression for conditions within the same task (calc)
# Calc_MEG
# Pinheiro-Chagas - 2016

##############################################################################################

def calc_dec_wTask_CR(wkdir, Condition, Subject, Type): # Type is class or ger
	
	##########################################################################################
	#Test input
	#wkdir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/'
	#Condition = ['op1', 'op1']
	#Subject = 's01'
	
	####################################################################
	#Load necessary libraries
	import mne
	import os
	import sys 
	import os.path as op
	import numpy as np
	import pandas as pd
	import scipy.io as sio
	from scipy import stats
	from fldtrp2mne_calc import fldtrp2mne_calc
	from calc_classification import calc_classification
	from calc_regression import calc_regression
	from calc_decoding_cfg import (result_path)
	
	cwd = os.path.dirname(os.path.abspath(__file__))
	os.chdir(cwd)

	##########################################################################################
	#Subfunction

	def calc_prepDec_wTask_CR(wkdir, Condition, Subject, Type):

		######################################################################################
		#Basic config

		from calc_decoding_cfg import (data_path, baseline, downsampling, trainTimes, testTimes)
		#Decoding
		trainset = Condition[0] # and then this will be already known when calling the function
		testset = Condition[1]

		params = {'baseline': baseline, 'downsampling': downsampling,
		'classification': Condition, 'trainset': trainset, 
		'testset': testset, 'trainTimes': trainTimes, 'testTimes': testTimes}

		fname_calc = data_path + '/' + Subject + '_calc.mat' # add smoothed once corrected
		fname_vsa = data_path + '/' + Subject + '_vsa.mat'
		epoch_calc,info_calc = fldtrp2mne_calc(fname_calc, 'data', 'calc')
		#epoch_vsa,info_vsa = fldtrp2mne_calc(fname_vsa, 'data', 'vsa')

		##Select data to use.
		## Time lock to the presentation of the result
		## This code sniped should be modularized and flexibilized
		idx_delay = info_calc['delay'] == 1
		idx_nodelay = info_calc['delay'] == 0

		time_calc_crop = np.arange(-0.1,0.8004,0.004) 

		epoch_calc_delay = epoch_calc[idx_delay]
		epoch_calc_delay.crop(3.5,4.4)
		epoch_calc_delay.times = time_calc_crop

		epoch_calc_nodelay = epoch_calc[idx_nodelay]
		epoch_calc_nodelay.crop(3.1,4)
		epoch_calc_nodelay.times = time_calc_crop

		info_calc_delay = info_calc[info_calc['delay'] == 1]
		info_calc_nodelay = info_calc[info_calc['delay'] == 0]
		info_calc_delay['operand'] = info_calc_delay['preResult'] # add another column 'operand' for the big decoder
		info_calc_nodelay['operand'] = info_calc_nodelay['preResult'] # add another column 'operand' for the big decoder

		epoch_calc_resplock = mne.epochs.concatenate_epochs([epoch_calc_delay,epoch_calc_nodelay])
		info_calc_resplock = pd.concat([info_calc_delay, info_calc_nodelay])
		print 'concat well'
          
           #########################################################################	
           ## Create the big decoder with operand1, operand2 and presented result ##
           ######################################################################### 	
          
		## Epochs will have 900 ms, -100 to 800. 
		## Epochs Operand1
		epoch_calc_Op1 = epoch_calc[info_calc['operand1'] < 100] # have to add that otherwise it rewrites info_calc!-why?
		epoch_calc_Op1.crop(-0.1,0.8)
		epoch_calc_Op1.times = time_calc_crop
		info_calc_Op1 = info_calc[info_calc['operand1'] < 100]
		info_calc_Op1['operand'] = info_calc_Op1['operand1'] # add another column 'operand' for the big decoder
		print epoch_calc
		print info_calc
		## Epochs Operand2
		epoch_calc_Op2 = epoch_calc[info_calc['operand1'] < 100] 
		epoch_calc_Op2.crop(0.7, 1.6)
		epoch_calc_Op2.times = time_calc_crop
		info_calc_Op2 = info_calc[info_calc['operand1'] < 100]
		info_calc_Op2['operand'] = info_calc_Op2['operand2'] # add another column 'operand' for the big decoder
		
		## Baseline correct
		#epoch_calc_Op1.apply_baseline(baseline)
		#epoch_calc_Op2.apply_baseline(baseline)
		#epoch_calc_delay.apply_baseline(baseline)
		#epoch_calc_nodelay.apply_baseline(baseline)
		## Concatenate
		#epoch_calc_bigdec = mne.epochs.concatenate_epochs([epoch_calc_Op1,epoch_calc_Op2,epoch_calc_delay,epoch_calc_nodelay])	
		#info_calc_bigdec = pd.concat([info_calc_Op1,info_calc_Op2,info_calc_delay, info_calc_nodelay])

		#Baseline correction
		#epoch_calc.apply_baseline(baseline)


		#Downsample data if needed
		if downsampling > 0:
			epoch_calc.decimate(downsampling)
			#epoch_vsa.decimate(downsampling)

		if trainset[-1] == testset[-1]: #Check whether we are training and testing on the same data
			mode = 'cross-validation'
			if trainset == 'op1':
				X_train = epoch_calc
				y_train = np.array(info_calc['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.2, 'stop': 4.5}
				testTimes = {'start': -0.2, 'stop': 4.5}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op2':
				train_index = info_calc['operator'] != 0
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand2'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.2, 'stop': 4.5}
				testTimes = {'start': -0.2, 'stop': 4.5}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'pres':
				train_index = (info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': 3.1, 'stop': 4.5}
				testTimes = {'start': 3.1, 'stop': 4.5}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'cres':
				#train_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6)
				train_index = info_calc['operator'] != 0
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['corrResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.2, 'stop': 4.5}
				testTimes = {'start': -0.2, 'stop': 4.5}
				trainTimes = {'start': -0.2, 'stop': 2}
				testTimes = {'start': -0.2, 'stop': 2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'addsub':
				train_index = info_calc['operator'] != 0
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operator'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.2, 'stop': 4.5}
				testTimes = {'start': -0.2, 'stop': 4.5}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'presTlock':
				train_index = (info_calc_resplock['preResult'] >= 3) & (info_calc_resplock['preResult'] <= 6)
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc_resplock[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'corrIncorrResTlock': # correct of incorrect results
				info_calc_resplock[info_calc_resplock['absdeviant'] != 0] = 1
				X_train = epoch_calc_resplock
				y_train = np.array(info_calc_resplock['absdeviant'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'deviantResTlock': # deviants 1:4
				train_index = info_calc_resplock['absdeviant'] > 0
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc_resplock[train_index]['absdeviant'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'pres_34':
				train_index = (info_calc_resplock['preResult'] == 3) | (info_calc_resplock['preResult'] == 4)
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'pres_35':
				train_index = (info_calc_resplock['preResult'] == 3) | (info_calc_resplock['preResult'] == 5)
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'pres_36':
				train_index = (info_calc_resplock['preResult'] == 3) | (info_calc_resplock['preResult'] == 6)
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'pres_45':
				train_index = (info_calc_resplock['preResult'] == 4) | (info_calc_resplock['preResult'] == 5)
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'pres_46':
				train_index = (info_calc_resplock['preResult'] == 4) | (info_calc_resplock['preResult'] == 6)
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'pres_56':
				train_index = (info_calc_resplock['preResult'] == 5) | (info_calc_resplock['preResult'] == 6)
				X_train = epoch_calc_resplock[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'presi':
				train_index = (info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6) & (info_calc['absdeviant'] > 0)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
			elif trainset == 'presc':
				train_index = (info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6) & (info_calc['absdeviant'] == 0)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['preResult'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
			elif trainset == 'op1comp':
				train_index = info_calc['operand2'] == 33 # only comparison trials
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
			elif trainset == 'delay_nodelay':
				X_train = epoch_calc
				y_train = np.array(info_calc['delay'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
			elif trainset == 'op1_34':
				train_index = (info_calc['operand1'] == 3) | (info_calc['operand1'] == 4)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 1.6}
				testTimes = {'start': -0.1, 'stop': 1.6}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op1_35':
				train_index = (info_calc['operand1'] == 3) | (info_calc['operand1'] == 5)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 1.6}
				testTimes = {'start': -0.1, 'stop': 1.6}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op1_36':
				train_index = (info_calc['operand1'] == 3) | (info_calc['operand1'] == 6)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 1.6}
				testTimes = {'start': -0.1, 'stop': 1.6}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op1_45':
				train_index = (info_calc['operand1'] == 4) | (info_calc['operand1'] == 5)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 1.6}
				testTimes = {'start': -0.1, 'stop': 1.6}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op1_46':
				train_index = (info_calc['operand1'] == 4) | (info_calc['operand1'] == 6)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 1.6}
				testTimes = {'start': -0.1, 'stop': 1.6}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op1_56':
				train_index = (info_calc['operand1'] == 5) | (info_calc['operand1'] == 6)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 1.6}
				testTimes = {'start': -0.1, 'stop': 1.6}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op2_01':
				train_index = (info_calc['operand2'] == 0) | (info_calc['operand2'] == 1)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand2'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': 1.5, 'stop': 3.2}
				testTimes = {'start': 1.5, 'stop': 3.2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op2_02':
				train_index = (info_calc['operand2'] == 0) | (info_calc['operand2'] == 2)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand2'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': 1.5, 'stop': 3.2}
				testTimes = {'start': 1.5, 'stop': 3.2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op2_03':
				train_index = (info_calc['operand2'] == 0) | (info_calc['operand2'] == 3)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand2'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': 1.5, 'stop': 3.2}
				testTimes = {'start': 1.5, 'stop': 3.2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op2_12':
				train_index = (info_calc['operand2'] == 1) | (info_calc['operand2'] == 2)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand2'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': 1.5, 'stop': 3.2}
				testTimes = {'start': 1.5, 'stop': 3.2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op2_13':
				train_index = (info_calc['operand2'] == 1) | (info_calc['operand2'] == 3)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand2'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': 1.5, 'stop': 3.2}
				testTimes = {'start': 1.5, 'stop': 3.2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'op2_23':
				train_index = (info_calc['operand2'] == 2) | (info_calc['operand2'] == 3)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand2'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': 1.5, 'stop': 3.2}
				testTimes = {'start': 1.5, 'stop': 3.2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'vsa':
				epoch_vsa,info_vsa = fldtrp2mne_calc(fname_vsa, 'data', 'vsa')
				epoch_vsa.apply_baseline(baseline)			
				train_index = info_vsa['congruency'] == 1
				X_train = epoch_vsa[train_index]
				y_train = np.array(info_vsa[train_index]['cue'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 1.5}
				testTimes = {'start': -0.1, 'stop': 1.5}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif trainset == 'opbigdec':
				train_index = info_calc_bigdec['operator'] != 0
				X_train = epoch_calc_bigdec[train_index]
				y_train = np.array(info_calc_bigdec[train_index]['operand'])
				y_train = y_train.astype(np.float64)
				X_test = X_train
				y_test = y_train
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})				
		else:
			mode = 'mean-prediction'
			if (trainset == 'op1') & (testset == 'prescdelay'):
				train_index = info_calc['operand1'] != info_calc['preResult']
				test_index = (info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6) & (info_calc['absdeviant'] == 0) & (info_calc['delay'] == 1)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['preResult'])
				y_test = y_test.astype(np.float64)
			elif (trainset == 'op1') & (testset == 'prescnodelay'):
				train_index = info_calc['operand1'] != info_calc['preResult']
				test_index = (info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6) & (info_calc['absdeviant'] == 0) & (info_calc['delay'] == 0)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['preResult'])
				y_test = y_test.astype(np.float64)
			elif (trainset == 'op1') & (testset == 'presinodelay'):
				train_index = info_calc['operand2'] > 0
				test_index = (info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6) & (info_calc['absdeviant'] > 1) & (info_calc['delay'] == 0)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['preResult'])
				y_test = y_test.astype(np.float64)
			elif (trainset == 'op1') & (testset == 'presidelay'):
				train_index = info_calc['operand2'] > 0
				test_index = (info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6) & (info_calc['absdeviant'] > 1) & (info_calc['delay'] == 1)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['preResult'])
				y_test = y_test.astype(np.float64)
			elif (trainset == 'op1') & (testset == 'pres'):
				train_index = info_calc['operand1'] != info_calc['preResult']
				test_index = info_calc['operand1'] == info_calc['preResult']
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['preResult'])
				y_test = y_test.astype(np.float64)
			elif (trainset == 'op1') & (testset == 'presTlock'):
				train_index = info_calc['operand1'] != info_calc['preResult']
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				test_index = (info_calc_resplock['preResult'] >= 3) & (info_calc_resplock['preResult'] <= 6)
				X_test = epoch_calc_resplock[test_index]
				y_test = np.array(info_calc_resplock[test_index]['preResult'])
				y_test = y_test.astype(np.float64)
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif (trainset == 'op1m') & (testset == 'cresm'):
				#train_index = info_calc['operand1'] != info_calc['preResult']
				test_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
				X_train = epoch_calc
				y_train = np.array(info_calc['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['corrResult'])
				y_test = y_test.astype(np.float64)
				# Update params
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': 1.5, 'stop': 2.4}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif (trainset == 'op10') & (testset == 'cres0'):
				#train_index = info_calc['operand1'] != info_calc['preResult']
				test_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
				X_train = epoch_calc
				y_train = np.array(info_calc['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['corrResult'])
				y_test = y_test.astype(np.float64)
				# Update params
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': -0.1, 'stop': 0.8}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif (trainset == 'op11') & (testset == 'cres1'):
				#train_index = info_calc['operand1'] != info_calc['preResult']
				test_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
				X_train = epoch_calc
				y_train = np.array(info_calc['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['corrResult'])
				y_test = y_test.astype(np.float64)
				# Update params
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': 0.7, 'stop': 1.6}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif (trainset == 'op12') & (testset == 'cres2'):
				#train_index = info_calc['operand1'] != info_calc['preResult']
				test_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operand1'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['corrResult'])
				y_test = y_test.astype(np.float64)
				# Update params
				trainTimes = {'start': -0.1, 'stop': 0.8}
				testTimes = {'start': 2.5, 'stop': 3.4}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif (trainset == 'vsa') & (testset == 'addsub'):
				# Load attention data
				epoch_vsa,info_vsa = fldtrp2mne_calc(fname_vsa, 'data', 'vsa')
				epoch_vsa.apply_baseline(baseline)
				train_index = info_vsa['congruency'] == 1
				test_index = info_calc['operator'] != 0
				# Correct labels for the cue to match add and sub
				info_vsa[info_vsa['cue'] == 1] = -1
				info_vsa[info_vsa['cue'] == 2] = 1
				X_train = epoch_vsa[train_index]
				y_train = np.array(info_vsa[train_index]['cue'])
				y_train = y_train.astype(np.float64)
				X_test = epoch_calc[test_index]
				y_test = np.array(info_calc[test_index]['operator'])
				y_test = y_test.astype(np.float64)
				# Update params
				trainTimes = {'start': -0.1, 'stop': 1.5}
				testTimes = {'start': 0.7, 'stop': 3.2}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})
			elif (trainset == 'addsub') & (testset == 'vsa'):
				# Load attention data
				epoch_vsa,info_vsa = fldtrp2mne_calc(fname_vsa, 'data', 'vsa')
				epoch_vsa.apply_baseline(baseline)

				train_index = info_calc['operator'] != 0
				test_index = info_vsa['congruency'] == 1
				# Correct labels for the cue to match add and sub
				info_vsa[info_vsa['cue'] == 1] = -1
				info_vsa[info_vsa['cue'] == 2] = 1
				
				X_train = epoch_calc[train_index]
				y_train = np.array(info_calc[train_index]['operator'])
				y_train = y_train.astype(np.float64)

				X_test = epoch_vsa[test_index]
				y_test = np.array(info_vsa[test_index]['cue'])
				y_test = y_test.astype(np.float64)

				# Update params
				trainTimes = {'start': 0.7, 'stop': 3.2}
				testTimes = {'start': -0.1, 'stop': 1.5}
				params.update({'trainTimes': trainTimes})
				params.update({'testTimes': testTimes})


				#################### THINK ABOUT IT!!! ########################
		#import ipdb; ipdb.set_trace() # to debug... 	
		# Update params with mode
		params.update({'mode': mode})	
		print('preparing to decode')
		######################################################################################
		#Decode
 
              
		if Type == 'class':
			print('Decoding subject classification')
			gat, score, diagonal = calc_classification(X_train, y_train, X_test, y_test, params)
			scoreR = 'auc'
		elif Type == 'reg':
			print('Decoding subject regression')
			gat, score, diagonal = calc_regression(X_train, y_train, X_test, y_test, params)
			scoreR = 'r2'
      
		return params, epoch_calc.times, gat, score, diagonal, y_train, y_test, scoreR
  
      ### DELETE OBJECTS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	scoreR, params, times_calc, gat, score, diagonal, y_train, y_test = calc_prepDec_wTask_CR(wkdir, Condition, Subject, Type)

	results = {'params': params, 'times_calc': times_calc, 'score': score, 'diagonal': diagonal, 'y_train': y_train, 'y_test': y_test}
	#results = {'params': params, 'times_calc': times_calc, 'gat': gat, 'score': score, 'diagonal': diagonal}
	# do I need to save the gat? 
	sys.getsizeof(results)
	#Save data
	#fname = result_path + '/individual_results/' + Subject + '_' + Condition[0] + '_' + Condition[1] + '_results_' + Type + '_' + scoreR
	fname = result_path + '/individual_results/' + Subject + '_' + Condition[0] + '_' + Condition[1] + '_results_' + Type
	np.save(fname, results)