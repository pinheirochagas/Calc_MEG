#!/usr/bin/env python
# -*- coding: utf-8

#'''
#====================================================
#Calculation MEG experiment
#Pedro Pinheiro-Chagas
#12/2014
#====================================================
#'''

'''
====================================================
            Import needed tools
====================================================
'''

from __future__ import division # so that 1/3=0.333 instead of 1/3=0
import os # for file/folder operations
import numpy as np # numbers
import pandas as pd  # data storage 
from numpy import genfromtxt # import csv to a numpy array
from numpy.random import random, shuffle # for random number generators and shuffling 
from psychopy import visual, core, data, event, logging, gui, parallel # all needed modules from psychopy
from psychopy.constants import *   
import pylink


'''
====================================================
            What this script does
====================================================

- store info about the subj (name, age, run)
- present calculations 
- collect answers and RT for the calculation verification task
====================================================
'''

# Define the number of trials
ntrials = 20


'''
====================================================
        MEG parallel port for input/output
====================================================
'''
# you need parallel port in order to:
try:
   trig_port = parallel.ParallelPort(address=0x0378)	# send triggers corresonding to your stimuli
   trig_port.setData(0)
   print('Reset trigger port\n')
except:
   print('Problem connecting to PC parallel port')
try:
   resp_port1 = parallel.ParallelPort(address=0x0379)	# get subject responses
   resp_port2 = parallel.ParallelPort(address=0x0BCE1)
except:
   print('Problem connecting to e-prime parallel port')
   class MockPort(object):
      def __init__(self):
          pass

      def readData(self):
         return 0

   resp_port = MockPort()


'''
====================================================
        Define needed functions
====================================================
'''

def WaitPressKey_Space(win):
# to allow the pressing of spacebar [escape will close the experiment]
    event.clearEvents()
    while True:
        for keys in event.getKeys():
            if keys in ['space']:
                return None
            elif keys in ['escape']:
                win.close()
                core.quit()
                return None 

def Message(win, string):                                              # to present a message
    message = visual.TextStim(win,  text=string,
                                    height=0.6,    
                                    ori=0,
                                    pos=(0, 0),
                                    font=textFont,
                                    color=textColor,
                                    units='deg')
    line1.draw()
    line2.draw()
    message.draw()
    win.flip()
    return message

def MessageEnd(win, string):                                              # to present a message
    message = visual.TextStim(win,  text=string,
                                    height=0.6,    
                                    ori=0,
                                    pos=(0, 0),
                                    font=textFont,
                                    color=textColor,
                                    units='deg')
    message.draw()
    win.flip()
    return message

def WaitTyesnoAnswerCPU(win,resp_event,rt_event,onset_event):         # to allow the pressing of L/R for yes/no answers
    listkeys = event.getKeys()
    if len(listkeys) >  0:                                            # check if any response has been given now
        if resp_event == 0:                                           # check if any response has been given before
            for keys in listkeys:
                if int(exp_info['answ'])==1:                              # [8 = port1 = right]
                    if keys in ['l']:
                        rt_event = ((core.getTime()) - onset_event)*1000
                        resp_event = 'C'
                        print rt_event
                        #return resp_event, rt_event
                    elif keys in ['t']:
                        rt_event = ((core.getTime()) - onset_event)*1000
                        resp_event = 'I'
                        print rt_event
                        #return resp_event, rt_event
                    elif keys in ['escape']:
                        win.close()
                        core.quit()
                        return None
                else:                                                   # run with YES = 4 on RIGHT and NO = 3 on LEFT
                    if keys in ['s']:
                        rt_event = (core.getTime()) - onset_event
                        resp_event = 4
                        print rt_event
                        #return resp_event, rt_event
                    elif keys in ['l']:
                        rt_event = (core.getTime()) - onset_event
                        resp_event = 3
                        print rt_event
                        #return resp_event, rt_event
                    elif keys in ['escape']:
                        win.close()
                        core.quit()
                        return None
    else:                                                               # no answer has been given, put 0
        resp_event = 0
        rt_event = 0
    return resp_event, rt_event

def WaitTyesnoAnswer(win,resp_event,rt_event,onset_event):
    resp1 = resp_port1.readData()
    resp2 = resp_port2.readData()
    if resp1 !=  0:                                                    # check if any response has been given now with 8
        if resp_event == 0:                                            # check if any response has been given before
            if int(exp_info['answ'])==1:                              # [8 = port1 = right]
                if resp1 in [8]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'L'
                    print(resp_event)
            else:                                                      # [8 = port1 = right]
                if resp1 in [8]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'T'
                    print(resp_event)
    elif resp2 !=  0:                                                  # check if any response has been given now with 16
        if resp_event == 0:                                            # check if any response has been given before
            if int(exp_info['answ'])==1:                               # [16 = port2 = left]
                if resp2 in [16]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'L'
                    print(resp_event)
            else:                                                      # [16 = port2 = left]
                if resp2 in [16]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'T'
                    print(resp_event)
    else:                                                               # no answer has been given, put 0
        resp_event = 99
        rt_event = 99
    return resp_event, rt_event     

def Presenttarget1(eventStim,ISI):
# to present 1th stimuli e.g. '4' + 3 = 7
    resp_event = 99
    rt_event = 99

    code_event = eventStim+1

    stim = visual.TextStim(win, text=eventStim,
                                height=2, 
                                ori=0,
                                pos=(0, 0.25),
                                font = textFont,
                                color = textColor,
                                units='deg')
    onset_event = core.getTime()  
    tot_trial = StimDur+ISI
    for frameN in range(tot_trial):
        # stimuli are presented for a fixed number of frames (30)
        if 1 <= frameN < 5: # duration of the stimulus
            #trig_port.setData(code_event)           # send to the parallel port the code for this stimulus
            # pylink.getEYELINK().sendMessage(msg);
            fixation.draw()
            stim.draw()
            win.flip()
        if 5 <= frameN < StimDur: # duration of the stimulus
            fixation.draw()
            stim.draw()
            win.flip()
        # fixation intrastimuli randomized
        if ISI <= frameN < tot_trial:
            #trig_port.setData(0)                   # send to the parallel port 0 to reset 
        # show
            fixation.draw()
            win.flip() 
    return resp_event, rt_event, onset_event, code_event

def Presenttarget23(eventStim,ISI):
# to present 2nd and 3rd stimuli e.g. 4 '+ 3' = 7 or 4 '= =' = 7
    resp_event = 99
    rt_event = 99

    if eventStim == -10:
        eventStim = '-'
        code_event = 91
    elif eventStim == 10:
        eventStim = '+'
        code_event = 93
    elif eventStim == 99:
        eventStim = '='
        code_event = 94       
    else:
        code_event = eventStim+21      

    stim = visual.TextStim(win, text=eventStim,
                                height=2, 
                                ori=0,
                                pos=(0, 0.25),
                                font = textFont,
                                color = textColor,
                                units='deg')
    onset_event = core.getTime()  
    tot_trial = StimDur+ISI
    for frameN in range(tot_trial):
        if 1 <= frameN < 5: # duration of the stimulus
            #trig_port.setData(code_event)           # send to the parallel port the code for this stimulus
            # pylink.getEYELINK().sendMessage(msg);
            fixation.draw()
            stim.draw()
            win.flip()
        if 5 <= frameN < StimDur: # duration of the stimulus
            fixation.draw()
            stim.draw()
            win.flip()
        # fixation intrastimuli randomized
        if ISI <= frameN < tot_trial:
            #trig_port.setData(0)                   # send to the parallel port 0 to reset 
        # show
            fixation.draw()
            win.flip() 
    return resp_event, rt_event, onset_event, code_event

def PresenttargetEqual(eventStim,ISI, eventDelay):
# to present the last equal sign stimuli e.g. 4 + 3 '=' 7 or 4 = = '=' 7
    resp_event = 99
    rt_event = 99

    eventStim = '='
    code_event = 95

    stim = visual.TextStim(win, text=eventStim,
                                height=2, 
                                ori=0,
                                pos=(0, 0.25),
                                font = textFont,
                                color = textColor,
                                units='deg')
    onset_event = core.getTime()  
    # isi_trial = ISI
    if eventDelay == 0:
    	tot_trial = StimDur+ISI+delay0
    else:
    	tot_trial = StimDur+ISI+delay400
    for frameN in range(tot_trial):
        # stimuli are presented for a fixed number of frames (30)
        if 1 <= frameN < 5: # duration of the stimulus
            #trig_port.setData(code_event)           # send to the parallel port the code for this stimulus
            # pylink.getEYELINK().sendMessage(msg);
            fixation.draw()
            stim.draw()
            win.flip()
        if 5 <= frameN < StimDur: # duration of the stimulus
            fixation.draw()
            stim.draw()
            win.flip()
        # fixation intrastimuli randomized
        if ISI <= frameN < tot_trial:
            #trig_port.setData(0)                   # send to the parallel port 0 to reset 
        # show
            fixation.draw()
            win.flip() 
    return resp_event, rt_event, onset_event, code_event

def PresenttargetResp(eventStim,ISI):  
    event.clearEvents()
    resp_event = 0
    rt_event = 0
    
    code_event = eventStim+41  

    stim = visual.TextStim(win, text=eventStim,
                                height=2, 
                                ori=0,
                                pos=(0, 0.25),
                                font = textFont,
                                color = textColor,
                                units='deg')  
    # isi_trial = ITI # the time after the response
    msg = "TRIAL %s" % str(code_event)
    onset_event = core.getTime()
    tot_trial = StimDur+ITI
    event.clearEvents()
    interval_dur = 10
    for frameN in range(tot_trial):
        # stimuli are presented for a fixed number of frames (30)
        if 1 <= frameN < 5: # duration of the stimulus
            #trig_port.setData(code_event)           # send to the parallel port the code for this stimulus
            # pylink.getEYELINK().sendMessage(msg);
            fixation.draw()
            stim.draw()
            win.flip()
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win, resp_event,rt_event,onset_event)
        if 5 <= frameN < StimDur: # duration of the stimulus
            fixation.draw()
            stim.draw()
            win.flip()
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win, resp_event,rt_event,onset_event)
        # fixation intertrial 
        if StimDur <= frameN < StimDur+interval_dur:
            #trig_port.setData(0)                   # send to the parallel port 0 to reset
            fixation.draw()
            win.flip()
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win, resp_event,rt_event,onset_event)
        if StimDur+interval_dur <= frameN < tot_trial:
            #trig_port.setData(0)                   # send to the parallel port 0 to reset 
            fixation.draw()
            win.flip()
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win, resp_event,rt_event,onset_event)
    return resp_event, rt_event, onset_event, code_event

def PresentStimuli(runlist, ISI):
    # create dictionary for results
    results = {}
    #for i in range(0,15):            # right now we don't want to see ALL the stimuli, but just some
    # for i in range(0,len(runlist)):
    for i in range(0,ntrials):
        trial = runlist[i,:]
        eventDelay = trial[5]                     
        for e in range(0, len(trial)-1): # exclude the last column which is the info of the delay
            myEvent = trial[e]
            if e == 0:
                eventStim = trial[0]
                resp_event, rt_event, onset_event, code_event = Presenttarget1(eventStim, ISI)
            elif e == 1:
                eventStim = trial[1]
                resp_event, rt_event, onset_event, code_event = Presenttarget23(eventStim, ISI)
            elif e == 2:
                eventStim = trial[2]
                resp_event, rt_event, onset_event, code_event = Presenttarget23(eventStim, ISI)
            elif e == 3:
                eventStim = trial[3]
                resp_event, rt_event, onset_event, code_event = PresenttargetEqual(eventStim, ISI, eventDelay)
            elif e == 4:
                eventStim = trial[4]
                resp_event, rt_event, onset_event, code_event = PresenttargetResp(eventStim, ISI)
            # fill in the dictionary with the results
            results.setdefault('myEvent', []).append(eventStim)
            results.setdefault('onsets', []).append(onset_event)
            results.setdefault('code_event', []).append(code_event)
            results.setdefault('rt', []).append(rt_event)
            results.setdefault('response', []).append(resp_event)
            # except:
            #     print('Problem here %s %s' %(i,e))
            #     break
    return results


'''
====================================================
    Store info about the experiment session
====================================================
'''
# Show a dialog box to enter session information
exp_name = 'Calc_MEG'
exp_info = {
            'id': '',                      # ID of the sub
            'run': '',                     # run (to know which runlist has to be loaded)
            'answ':'',}                    
# answer mapping [1 = YES/x-left, NO/y-right] vs [2 = YES/y-right, NO/x-left]
dlg = gui.DlgFromDict(dictionary=exp_info, title=exp_name)

# If 'Cancel' is pressed, quit
if dlg.OK == False:
    core.quit()

# Add the date and the experiment name
#exp_info['date'] = data.getDateStr()
#exp_info['exp_name'] = exp_name


'''
====================================================
            Set main variables
====================================================
'''

# I/O directories and names 
resultpath = 'results/Calc/'+ exp_info['id']
if not os.path.isdir(resultpath):
    os.makedirs(resultpath)
    
# load stimuli list for this run
runlist = genfromtxt('stimuli/Calc/' + exp_info['id'] + '/'+ 'run' + exp_info['run'] +  '.csv', delimiter=',').astype(np.int)
#runlist = genfromtxt('stimuli/stim.csv', delimiter=';').astype(np.int)

# runlist = genfromtxt('stimuli/Calc/' + 'pedro' + '/'+ 'run' + '1' +  '.csv', delimiter=',').astype(np.int)



# Clock
clock = core.Clock()

# Window  [1024 x 778 MEG screen]
#winColor = [0,0,0]
winColor = 'Black'

monitorSize = (1024, 778)
#monitorSize = (1680, 1050)
win = visual.Window(size=monitorSize,
                    fullscr=False, 
                    monitor="testMonitor", 
                    units="pix", 
                    color=winColor)

# Mouse not visible
myMouse = event.Mouse(win=win)
myMouse.setVisible(0)                                                                       

# Stimuli 
textColor = 'White'
textFont = 'Verdana'

# Fixations 
# This is to call attention of participants that the trial is begining 
fixation = visual.Circle(win, radius=0.05, 
                        edges=32, 
                        fillColor='Gray',
                        lineColor='Gray',
                        units='deg')
# Big lines fixation
lineFixationColor = 'Gray'
# lineFixationThick=0.01
lineFixationThick=0.8
line1 = visual.Line(win, start=(-512, -389), 
                        end=(512, 389),
                        lineColor = lineFixationColor,
                        lineWidth=lineFixationThick,
                        units='deg')
line2 = visual.Line(win, start=(-512, 389), 
                        end=(512, -389),
                        lineColor = lineFixationColor,
                        lineWidth=lineFixationThick,
                        units='deg')

# ISI, ITI and delay
ISI = 24
StimDur = 24
Initiate = 48
ITI = 120
delay0 = 0
delay400 = 24


'''
====================================================
       Set up the eye tracker
====================================================

'''

# # Get the eyelink information
# eyelinktracker = pylink.EyeLink()

# # Initiates the eyelink graphics
# pylink.openGraphics()

# # Name the EDF file
# # edfFileName = "TEST.EDF" 
# edfFileName = exp_info['id'] 

# #Opens the EDF file.
# pylink.getEYELINK().openDataFile(edfFileName)

# pylink.flushGetkeyQueue()
# pylink.getEYELINK().setOfflineMode()

# #Gets the display surface and sends a mesage to EDF file;
# size = tuple(win.size)
# pylink.getEYELINK().sendCommand("screen_pixel_coords =  0 0 %d %d" % size)
# pylink.getEYELINK().sendMessage("DISPLAY_COORDS  0 0 %d %d" % size)


# tracker_software_ver = 0
# eyelink_ver = pylink.getEYELINK().getTrackerVersion()
# if eyelink_ver == 3:
#     tvstr = pylink.getEYELINK().getTrackerVersionString()
#     vindex = tvstr.find("EYELINK CL")
#     tracker_software_ver = int(float(tvstr[(vindex + len("EYELINK CL")):].strip()))
    

# if eyelink_ver>=2:
#     pylink.getEYELINK().sendCommand("select_parser_configuration 0")
#     if eyelink_ver == 2: #turn off scenelink camera stuff
#         pylink.getEYELINK().sendCommand("scene_camera_gazemap = NO")
# else:
#     pylink.getEYELINK().sendCommand("saccade_velocity_threshold = 35")
#     pylink.getEYELINK().sendCommand("saccade_acceleration_threshold = 9500")
    
# # set EDF file contents 
# pylink.getEYELINK().sendCommand("file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON")
# if tracker_software_ver>=4:
#     pylink.getEYELINK().sendCommand("file_sample_data  = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET")
# else:
#     pylink.getEYELINK().sendCommand("file_sample_data  = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS")

# # set link data (used for gaze cursor) 
# pylink.getEYELINK().sendCommand("link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON")
# if tracker_software_ver>=4:
#     pylink.getEYELINK().sendCommand("link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,HTARGET")
# else:
#     pylink.getEYELINK().sendCommand("link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS")


# pylink.setCalibrationColors( (0, 0, 0),(255, 255, 255));    #Sets the calibration target and background color
# pylink.setTargetSize(int(size[0] / 70), int(size[0] / 300));    #select best size for calibration target
# pylink.setCalibrationSounds("", "", "");
# pylink.setDriftCorrectSounds("", "off", "off");


# if(pylink.getEYELINK().isConnected() and not pylink.getEYELINK().breakPressed()):
#     pylink.getEYELINK().doTrackerSetup()
# else:
#     raise Exception

# # Status message on eye track screen
# message ="record_status_message 'Trial %s'" % exp_info['run']
# pylink.getEYELINK().sendCommand(message)

# # Important, identifier for run id in EDF file
# msg = "TRIALID %s_%s" % (exp_info['id'], exp_info['run'])
# pylink.getEYELINK().sendMessage(msg);

# error = pylink.getEYELINK().startRecording(1,1,1,1)

# # Close the eyelink graphics
# pylink.closeGraphics()

'''
====================================================
        Run the experiment
====================================================
'''
print("#" * 20 + "    C'est parti le bloc %s!   " % exp_info['run'] + "#" * 20)

# INTRO
Message(win, u"Gardez les yeux fixes sur le centre de l'ecran")
WaitPressKey_Space(win)
Message(win, u'Preparez vous!')
WaitPressKey_Space(win)
# Add participants keys! 

# Wait a bit (literally) 30*16.7ms with std refresh rate of 60Hz
for frameN in range(ITI):
    fixation.draw()
    win.flip()

Start_onset = core.getTime()
print(Start_onset)

# Present all stimuli of this run and get results
# results =  PresentStimuli(stim, odd1, odd2, runlist,ISI)
results =  PresentStimuli(runlist,ISI)

'''
====================================================
                End the experiment
====================================================
'''
MessageEnd(win, u'MERCI! Ce bloc est terminée.')
WaitPressKey_Space(win)

# Save all data to a file
results_fname = exp_info['run'] + '_' + 'results.csv'
results_fname = os.path.join(resultpath, results_fname)
results = pd.DataFrame(results)

# Subtract TTL from all onsets
results['onsets'] = results['onsets']-Start_onset

taskone = results.copy() # Making a copying and saving
taskone.to_csv(results_fname, index=False, encoding = 'latin-1') 

print("#" * 20 + "    Le bloc %s est FINI!   " % exp_info['run'] + "#" * 20)

# Close eye tracking enviroment and write edfFile
pylink.getEYELINK().closeDataFile()
pylink.getEYELINK().receiveDataFile(edfFileName, edfFileName)
pylink.getEYELINK().close()
#pylink.closeGraphics()

# Quit the experiment
core.quit()  