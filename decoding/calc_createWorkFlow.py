# Generate jobs.py files and creates a somaWF file to be imported in soma_gui and run 
# the computations in the NeuroSpin cluster
# Calc_MEG
# Pinheiro-Chagas - 2016
# Adapted from Darinka Treubutschek

# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
import os
from soma_workflow.client import Job, Workflow, Helper
from initDirs import dirs

def calc_createWorkFlow(conditions, subjects, baselinecorr, dec_method, dec_scorer, gatordiag):
    # Initialize job files and names
    initbody = 'import sys \n' + "sys.path.append(" + "'" + dirs['script'] + "')\n" + \
                'from initDirs import dirs\n' + \
               'from prepDataDecoding import prepDataDecoding\n' + \
               'from calcDecoding import calcDecoding\n'

    #Write actual job files
    ListJobName = []
    python_file, Listfile = [], []
    # python_file_reg, Listfile_reg = [], []

    for c, condcouple in enumerate(conditions):
        for s, subject in enumerate(subjects):
            body = initbody + "params = prepDataDecoding(dirs," + "'"+condcouple[0]+"'" + "," + "'"+condcouple[1]+"'" + "," + "'"+subject+"'" + "," + "'"+baselinecorr+"'" + ")\n"
            body_class = body + "calcDecoding(params," + "'"+dec_method+"'" "," + "'"+dec_scorer+"'" + "," + "'"+gatordiag+"'" + ")"

            # body_reg = initbody + "calc_dec_wTask_CR('" + wkdir + "'," + str(condcouple) + "," + "'" + subject + "'" "," "'reg'" + ")"

            # Use a transparent and complete job name referring to arguments of interests
            jobname = subject + '_' + condcouple[0] + '_' + condcouple[1] + '_' + dec_method
            ListJobName.append(jobname)

            # Write jobs in a dedicated folder
            name_file_class = os.path.join(dirs['root'], ('scripts/decoding/somaWF/jobs/jobs_' + jobname + '.py'))

            Listfile.append(name_file_class)
            with open(name_file_class, 'w') as python_file:
                python_file.write(body_class)

    # Create workflow
    jobs = []

    for i in range(len(Listfile)):
        JobVar = Job(command = ['python', Listfile[i]], name = ListJobName[i],
                     native_specification = '-l walltime=30:00:00, -l nodes=1:ppn=2')
                     #native_specification = '-l walltime=1:00:00, -l nodes=2:ppn=16,pmem=8gb,pvmem=9gb')
        jobs.append(JobVar)

    # Save the workflow variables
    WfVar = Workflow(jobs = jobs)
    # WfVar = Workflow(jobs = jobs, dependencies = dependencies)

    somaWF_name = dirs['script'] + 'somaWF/workflows/calc_WorkFlow_withinTask_class'
    Helper.serialize(somaWF_name, WfVar)