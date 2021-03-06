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

def calc_createWorkFlow(conditions, subjects, baselinecorr, dec_method, dec_scorer, gatordiag, decimate):
    # Initialize job files and names
    initbody = 'import sys \n' + "sys.path.append(" + "'" + dirs['script'] + "')\n" + \
                'from initDirs import dirs\n' + \
               'from prepDataDecoding import prepDataDecoding\n' + \
               'from calcDecoding import calcDecoding\n'

    #Write actual job files
    ListJobName = []
    python_file, Listfile = [], []
    # python_file_reg, Listfile_reg = [], []

    #for c, condcouple in enumerate(conditions):
    for s, subject in enumerate(subjects):
        body = initbody + "params = prepDataDecoding(dirs," + "'"+conditions[0]+"'" + "," + "'"+conditions[1]+"'" + "," + "'"+subject+"'" + "," + "'"+baselinecorr+"'" + "," + str(decimate) + ")\n"
        body_class = body + "calcDecoding(params," + "'"+dec_method+"'" "," + "'"+dec_scorer+"'" + "," + "'"+gatordiag+"'" + ")"

        # body_reg = initbody + "calc_dec_wTask_CR('" + wkdir + "'," + str(condcouple) + "," + "'" + subject + "'" "," "'reg'" + ")"

        # Use a transparent and complete job name referring to arguments of interests
        jobname = subject + '_' + conditions[0] + '_' + conditions[1] + '_' + dec_method + '_' + dec_scorer
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

    somaWF_name = dirs['script'] + 'somaWF/workflows/' + conditions[0] + '_' + conditions[1] + '_' + dec_method + '_' + dec_scorer
    Helper.serialize(somaWF_name, WfVar)


def calc_createWorkFlowRiemann(conditions, subjects, baselinecorr, dec_method, dec_scorer, decimate):
    # Initialize job files and names
    initbody = 'import sys \n' + "sys.path.append(" + "'" + dirs['script'] + "')\n" + \
                'from initDirs import dirs\n' + \
               'from prepDataDecoding import prepDataDecoding\n' + \
               'from classifyRiemann import classifyRiemann\n'

    #Write actual job files
    ListJobName = []
    python_file, Listfile = [], []
    # python_file_reg, Listfile_reg = [], []

    #for c, condcouple in enumerate(conditions):
    for s, subject in enumerate(subjects):
        body = initbody + "params = prepDataDecoding(dirs," + "'"+conditions[0]+"'" + "," + "'"+conditions[1]+"'" + "," + "'"+subject+"'" + "," + "'"+baselinecorr+"'" + "," + str(decimate) + ")\n"
        body_class = body + "classifyRiemann(params['X_train'], params['y_train'], params)"

        # body_reg = initbody + "calc_dec_wTask_CR('" + wkdir + "'," + str(condcouple) + "," + "'" + subject + "'" "," "'reg'" + ")"

        # Use a transparent and complete job name referring to arguments of interests
        jobname = subject + '_' + conditions[0] + '_' + conditions[1] + '_riemann'
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
                     native_specification = '-l walltime=60:00:00, -l nodes=1:ppn=2')
                     #native_specification = '-l walltime=1:00:00, -l nodes=2:ppn=16,pmem=8gb,pvmem=9gb')
        jobs.append(JobVar)

    # Save the workflow variables
    WfVar = Workflow(jobs = jobs)
    # WfVar = Workflow(jobs = jobs, dependencies = dependencies)

    somaWF_name = dirs['script'] + 'somaWF/workflows/' + conditions[0] + '_' + conditions[1] + '_riemann'
    Helper.serialize(somaWF_name, WfVar)