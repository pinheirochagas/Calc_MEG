# Generate jobs.py files and creates a somaWF file to be imported in soma_gui and run 
# the computations in the NeuroSpin cluster
# Calc_MEG
# Pinheiro-Chagas - 2016

##############################################################################################
#Import necessary libraries
import os
from soma_workflow.client import Job, Workflow, Helper
cwd = os.path.dirname(os.path.abspath(__file__)) #only if called from within script, else just give the actual path
#cwd = '/neurospin/meg/meg_tmp/WMP_Darinka_2015/Python'
os.chdir(cwd)
from wmp_cfg_loc import (wkdir)
##############################################################################################
#List of parameters to be parallelized

subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18','s19', 's21', 's22']

conditions = [['cres', 'cres']]

##############################################################################################
#Initialize job files and names
List_python_files = []
initbody = 'import sys \n'
initbody = initbody + "sys.path.append(" + "'" + cwd + "')\n"
initbody = initbody + 'import calc_decoding\n'

#Write actual job files
python_file, Listfile, ListJobName = [], [], []

for c, condcouple in enumerate(conditions):
	for s, subject in enumerate(subjects):
		
		body = initbody + "calc_decoding('" + wkdir + "',"
		body = body + str(condcouple) + ","
		body = body + "'" + subject + "')"
		
		#Use a transparent and complete job name referring to arguments of interests
		jobname = subject
		
		for cond in condcouple:
			jobname = jobname + '_' + cond
		ListJobName.append(jobname)
		
		#Write jobs in a dedicated folder
		name_file = []
		name_file = os.path.join(wkdir, ('scripts/decoding/somaWF/jobs/jobs_' + jobname + '.py'))
		Listfile.append(name_file)
		
		with open(name_file, 'w') as python_file:
			python_file.write(body)

##############################################################################################
#Create workflow	
jobs = []

for i in range(len(Listfile)):
	JobVar = Job(command = ['python', Listfile[i]], name = ListJobName[i],
                 native_specification = '-l walltime=4:00:00, -l nodes=1:ppn=8')
	jobs.append(JobVar)

#Save the workflow variables
WfVar = Workflow(jobs = jobs)
#WfVar = Workflow(jobs = jobs, dependencies = dependencies)
somaWF_name = os.path.join(wkdir, 'somaWF/workflows/calc_decoding_workflow')
Helper.serialize(somaWF_name, WfVar)
