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
os.chdir(cwd)
from initDirs import dirs
cwd = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding'

##############################################################################################
# List of parameters to be parallelized
subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 
           's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18','s19', 's21', 's22']

# conditions = [['op1', 'op1'], ['op2', 'op2'], ['pres', 'pres'],['cres', 'cres'],
#['presc', 'presc'], ['presi', 'presi'], ['op1', 'pres'], ['op1', 'cres']]

subjects = ['s03', 's13']

#conditions = [['op1', 'op1']]

#conditions = [['op2_01', 'op2_01'], ['op2_02', 'op2_02'], ['op2_03', 'op2_03'], 
#['op2_12', 'op2_12'],['op2_13', 'op2_13'], ['op2_23', 'op2_23'],
#['pres_34', 'pres_34'], ['pres_35', 'pres_35'], ['pres_36', 'pres_36'],
#['pres_45', 'pres_45'], ['pres_46', 'pres_46'], ['pres_56', 'pres_56'],
#['op1_34', 'op1_34'], ['op1_35', 'op1_35'], ['op1_36', 'op1_36'],
#['op1_45', 'op1_45'], ['op1_46', 'op1_46'], ['op1_56', 'op1_56']]

conditions = [['cres', 'cres']]


#conditions = [['pres_34', 'pres_34'], ['pres_35', 'pres_35'], ['pres_36', 'pres_36'], ['pres_45', 'pres_45'],
#['pres_46', 'pres_46'], ['pres_56', 'pres_56']]

#conditions = [['pres_34', 'pres_34']]

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
		# body_reg = initbody + "calc_dec_wTask_CR('" + wkdir + "'," + str(condcouple) + "," + "'" + subject + "'" "," "'reg'" + ")"

		#Use a transparent and complete job name referring to arguments of interests
		jobname = subject

		# for cond in condcouple:
		# 	jobname_class = jobname + '_' + cond + '_class'
		# 	jobname_reg = jobname + '_' + cond + '_reg'
		
		jobname_class = subject + '_' + condcouple[0] + '_' + condcouple[1] + '_class'
		# jobname_reg = subject + '_' + condcouple[0] + '_' + condcouple[1] + '_reg'
		ListJobName.append(jobname_class)
		# ListJobName.append(jobname_reg) # this is done twice because each subject gets two python files.

		#Write jobs in a dedicated folder
		name_file_class = os.path.join(wkdir, ('scripts/decoding/somaWF/jobs/jobs_' + jobname_class + '.py'))
		# name_file_reg = os.path.join(wkdir, ('scripts/decoding/somaWF/jobs/jobs_' + jobname_reg + '.py'))

		Listfile.append(name_file_class)
		with open(name_file_class, 'w') as python_file:
			python_file.write(body_class)
		
		# Listfile.append(name_file_reg)
		# with open(name_file_reg, 'w') as python_file:
		# 	python_file.write(body_reg)

##############################################################################################
#Create workflow	
jobs = []

for i in range(len(Listfile)):
	JobVar = Job(command = ['python', Listfile[i]], name = ListJobName[i],
                 #native_specification = '-l walltime=30:00:00, -l nodes=1:ppn=8')
                 native_specification = '-l walltime=30:00:00, -l nodes=2:ppn=16,pmem=8gb,pvmem=9gb')
	jobs.append(JobVar)

#Save the workflow variables
WfVar = Workflow(jobs = jobs)
#WfVar = Workflow(jobs = jobs, dependencies = dependencies)
somaWF_name = wkdir + '/scripts/decoding/somaWF/workflows/calc_WorkFlow_withinTask_class'
Helper.serialize(somaWF_name, WfVar)