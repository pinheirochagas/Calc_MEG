# Generate jobs.py files and creates a somaWF file to be imported in soma_gui and run 
# the computations in the NeuroSpin cluster
# Calc_MEG
# Pinheiro-Chagas - 2016
# Adapted from Darinka Treubutschek

##############################################################################################
#Import necessary libraries
import os
from soma_workflow.client import Job, Workflow, Helper
cwd = os.path.dirname(os.path.abspath(__file__)) #only if called from within script, else just give the actual path
#cwd = '/neurospin/meg/meg_tmp/WMP_Darinka_2015/Python'
os.chdir(cwd)
from calc_decoding_cfg import (wkdir)

##############################################################################################
#List of parameters to be parallelized
subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18','s19', 's21', 's22']

#conditions = [['op1', 'op1'], ['op2', 'op2'], ['pres', 'pres'],['cres', 'cres'],
#			  ['presc', 'presc'], ['presi', 'presi'], ['op1', 'pres'], ['op1', 'cres']]

#subjects = ['s19']

#conditions = [['op1', 'presTlock'], ['op1m', 'cresm'], ['op12', 'cres2'], ['op10', 'cres0'], ['op11', 'cres1']]
#conditions = [['opbigdec', 'opbigdec']]

conditions = [['op1', 'op1'], ['op2', 'op2'],['cres', 'cres'], ['addsub', 'addsub']]


##############################################################################################
#Initialize job files and names
List_python_files = []
initbody = 'import sys \n' + "sys.path.append(" + "'" + cwd + "')\n" + 'from calc_dec_wTask_CR import calc_dec_wTask_CR\n'


#Write actual job files
ListJobName = []
python_file, Listfile = [], []
# python_file_reg, Listfile_reg = [], []

for c, condcouple in enumerate(conditions):
	for s, subject in enumerate(subjects):
		
		body_class = initbody + "calc_dec_wTask_CR('" + wkdir + "'," + str(condcouple) + "," + "'" + subject + "'" "," "'class'" + ")"
		body_reg = initbody + "calc_dec_wTask_CR('" + wkdir + "'," + str(condcouple) + "," + "'" + subject + "'" "," "'reg'" + ")"

		#Use a transparent and complete job name referring to arguments of interests
		jobname = subject

		# for cond in condcouple:
		# 	jobname_class = jobname + '_' + cond + '_class'
		# 	jobname_reg = jobname + '_' + cond + '_reg'
		
		jobname_class = subject + '_' + condcouple[0] + '_' + condcouple[1] + '_class'
		jobname_reg = subject + '_' + condcouple[0] + '_' + condcouple[1] + '_reg'
		ListJobName.append(jobname_class)
		ListJobName.append(jobname_reg) # this is done twice because each subject gets two python files.

		#Write jobs in a dedicated folder
		name_file_class = os.path.join(wkdir, ('scripts/decoding/somaWF/jobs/jobs_' + jobname_class + '.py'))
		name_file_reg = os.path.join(wkdir, ('scripts/decoding/somaWF/jobs/jobs_' + jobname_reg + '.py'))

		Listfile.append(name_file_class)
		with open(name_file_class, 'w') as python_file:
			python_file.write(body_class)
		
		Listfile.append(name_file_reg)
		with open(name_file_reg, 'w') as python_file:
			python_file.write(body_reg)

##############################################################################################
#Create workflow	
jobs = []

for i in range(len(Listfile)):
	JobVar = Job(command = ['python', Listfile[i]], name = ListJobName[i],
                 native_specification = '-l walltime=30:00:00, -l nodes=1:ppn=8')
	jobs.append(JobVar)

#Save the workflow variables
WfVar = Workflow(jobs = jobs)
#WfVar = Workflow(jobs = jobs, dependencies = dependencies)
somaWF_name = wkdir + '/scripts/decoding/somaWF/workflows/calc_WorkFlow_withinTask_classEreg'
Helper.serialize(somaWF_name, WfVar)