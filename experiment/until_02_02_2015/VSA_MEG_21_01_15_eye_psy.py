#!/usr/bin/env python
# -*- coding: utf-8

#'''
#====================================================
#Visual Attention MEG experiment
#Pedro Pinheiro-Chagas
#12/2014
#====================================================
#'''


'''
====================================================
            Import needed tools
====================================================
'''

from __future__ import division                                           # so that 1/3=0.333 instead of 1/3=0
import os                                                                   # for file/folder operations
import numpy as np                                                           # numbers
import pandas as pd                                                            # data storage 
from numpy import genfromtxt 
from numpy.random import random, shuffle
import random 
# for random number generators, shuffling and importing csv
from psychopy import visual, core, data, event, logging, gui, parallel            # all needed modules from psychopy
from psychopy.constants import *                                                      # things like STARTED, FINISHED
import pylink

'''
====================================================
            What this script does
====================================================

Version of the task in which participants have only to detect the target and it's location
If the target appears on the left, press the left button. 

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
   trig_port = parallel.ParallelPort(address=0x0378)               # send triggers corresonding to your stimuli
   trig_port.setData(0)
   print('Reset trigger port\n')
except:
   print('Problem connecting to PC parallel port')
try:
   resp_port1 = parallel.ParallelPort(address=0x0379)              # get subject responses
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

def WaitPressKey_Space(win):                                        # to allow the pressing of spacebar [escape will close the experiment]
    event.clearEvents()
    while True:
        for keys in event.getKeys():
            if keys in ['space']:
                return None
            elif keys in ['escape']:
                win.close()
                core.quit()
                return None 

# def WaitPressKey_Button(win):                                        # to allow the pressing of spacebar [escape will close the experiment]
#     event.clearEvents()
    
#     while True:
#         for keys in event.getKeys():
#             if keys in ['space']:
#                 return None

# def WaitMRITTL(win):                                                    # to wait for fMRI TTL [or S key]
#     Message(win, "Waiting for scanner TTL")
#     event.clearEvents()
#     while True:
#         for keys in event.getKeys():
#             if keys in ['s']:
#                 return None
#     win.flip()

def WaitTyesnoAnswerCPU(win,resp_event,rt_event,onset_event,eventStim):         # to allow the pressing of L/R for yes/no answers
    listkeys = event.getKeys()
    if len(listkeys) >  0:                                            # check if any response has been given now
        if resp_event == 0:                                           # check if any response has been given before
            for keys in listkeys:
                if int(exp_info['answ'])==1:                              # [8 = port1 = right]
                    if keys in ['l']:
                        rt_event = ((core.getTime()) - onset_event)*1000
                        resp_event = 'L'
                        print rt_event
                        print eventStim
                        print resp_event
                        #return resp_event, rt_event
                    elif keys in ['t']:
                        rt_event = ((core.getTime()) - onset_event)*1000
                        resp_event = 'T'
                        print rt_event
                        print eventStim
                        print resp_event
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

def WaitTyesnoAnswer(win,resp_event,rt_event,onset_event,eventStim):
    resp1 = resp_port1.readData()
    resp2 = resp_port2.readData()
    if resp1 !=  0:                                                    # check if any response has been given now with 8
        if resp_event == 0:                                            # check if any response has been given before
            if int(exp_info['answ'])==1:                              # [8 = port1 = right]
                if resp1 in [8]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'T'
                    print(resp_event)
                    print(rt_event)
                    print(eventStim)
            else:                                                      # [8 = port1 = right]
                if resp1 in [8]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'L'
                    print(resp_event)
                    print(rt_event)
                    print(eventStim)
    elif resp2 !=  0:                                                  # check if any response has been given now with 16
        if resp_event == 0:                                            # check if any response has been given before
            if int(exp_info['answ'])==1:                               # [16 = port2 = left]
                if resp2 in [16]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'L'
                    print(resp_event)
                    print(rt_event)
                    print(eventStim)
            else:                                                      # [16 = port2 = left]
                if resp2 in [16]:
                    rt_event = ((core.getTime()) - onset_event)*1000
                    resp_event = 'T'
                    print(resp_event)
                    print(rt_event)
                    print(eventStim)

    else:                                                               # no answer has been given, put 0
        resp_event = 0
        rt_event = 0
    return resp_event, rt_event                                         # return response and RT

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

def PresentCue(eventStim,ISI,eventDelay):                                       # to present target stimuli 
#    stim_trial = stim[trial]
    resp_event = 99
    rt_event = 99
    if eventStim == -6:
        code_event = 1
    else:
        code_event = 2

    if eventStim == -6:
        arrow = visual.SimpleImageStim(win, image='left_arrow.png', 
                                    units='', 
                                    pos=(0.0, 0.0), 
                                    flipHoriz=False, 
                                    flipVert=False, 
                                    name=None, 
                                    autoLog=None)
    else:
        arrow = visual.SimpleImageStim(win, image='right_arrow.png', 
                                    units='', 
                                    pos=(0.0, 0.0), 
                                    flipHoriz=False, 
                                    flipVert=False, 
                                    name=None, 
                                    autoLog=None) 
    cueDur = 12 
    msg = "TRIAL %s" % str(code_event)
    onset_event = core.getTime()  
    tot_trial = cueDur+eventDelay
    for frameN in range(tot_trial):
        # stimuli are presented for a fixed number of frames (30)
        if 1 <= frameN < 5: # duration of the stimulus
            trig_port.setData(code_event)           # send to the parallel port the code for this stimulus
            pylink.getEYELINK().sendMessage(msg);
            arrow.draw()
            squareL.draw()
            squareR.draw()
            fixation.draw()
            win.flip()        
        if 5 <= frameN < cueDur: # duration of the stimulus
            squareL.draw()
            squareR.draw()
            fixation.draw()
            win.flip()
        # fixation intrastimuli randomized
        if cueDur <= frameN < tot_trial:
            trig_port.setData(0)                   # send to the parallel port 0 to reset 
            squareL.draw()
            squareR.draw()
            fixation.draw()

        # show
            win.flip() 
    return resp_event, rt_event, onset_event, code_event


def PresenttargetResp(eventStim,ISI, position):                                       # to present target stimuli 
    event.clearEvents()
    resp_event = 0
    rt_event = 0
    #event.clearEvents()

    if position == -6 and eventStim == 'T':
        code_event = 10
    elif position == 6 and eventStim == 'T':
        code_event = 11
    elif position == -6 and eventStim == 'L':
        code_event = 12        
    elif position == 6 and eventStim == 'L':
        code_event = 13
    
    rotation = random.choice([0,45,90,135,180])

    stim = visual.TextStim(win, text=eventStim,
                            height=0.8, 
                            ori=0,
                            pos=(position, 0),
                            font = textFont,
                            color = textColor,
                            units='deg')

    mask1 = visual.TextStim(win, text='M',
                            height=1, 
                            ori=0,
                            pos=(position+.8, 0),
                            font = textFont,
                            color = textColor,
                            units='deg')
    mask2 = visual.TextStim(win, text='M',
                            height=1, 
                            ori=0,
                            pos=(position-.8, 0),
                            font = textFont,
                            color = textColor,
                            units='deg')
    mask3 = visual.TextStim(win, text='E',
                            height=1, 
                            ori=0,
                            pos=(position, .8),
                            font = textFont,
                            color = textColor,
                            units='deg')
    mask4 = visual.TextStim(win, text='E',
                            height=1, 
                            ori=0,
                            pos=(position, -.8),
                            font = textFont,
                            color = textColor,
                            units='deg')
        
    

    msg = "EVENT %s" % str(code_event)
    onset_event = core.getTime()  
    isi_trial = ITI # the time after the response
    mask_dur = 10
    targetDur = 3
    interval_dur = targetDur+3
    tot_trial = isi_trial+targetDur
    for frameN in range(tot_trial):
        # stimuli are presented for a fixed number of frames (targetDur)
        if 1 <= frameN <= targetDur: # time for sending the triggers
            trig_port.setData(code_event)          # send to the parallel port the code for this stimulus
            pylink.getEYELINK().sendMessage(msg);
            stim.draw()
            squareL.draw()
            squareR.draw()
            fixation.draw()
            win.flip()
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win,resp_event,rt_event,onset_event,eventStim)
        if targetDur < frameN <= interval_dur: # duration of the stimulus 
            squareL.draw()
            squareR.draw()
            fixation.draw()
            win.flip()
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win,resp_event,rt_event,onset_event,eventStim)
        if interval_dur <= frameN < interval_dur+mask_dur: # duration of the stimulus 
            # stim.draw()
            mask1.draw()
            mask2.draw()
            mask3.draw()
            mask4.draw()
            squareL.draw()
            squareR.draw()
            fixation.draw()
            win.flip()
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win,resp_event,rt_event,onset_event,eventStim)
        if interval_dur+mask_dur <= frameN < tot_trial:
            if resp_event == 0:
                resp_event, rt_event = WaitTyesnoAnswerCPU(win,resp_event,rt_event,onset_event,eventStim)
            trig_port.setData(0)                   # send to the parallel port 0 to reset 
            fixation.draw()
            squareL.draw()
            squareR.draw()
            win.flip() 
            #resp_event, rt_event = WaitTyesnoAnswerCPU(win,resp_event,rt_event,onset_event)
    return resp_event, rt_event, onset_event, code_event
    

def PresentStimuli(runlist, ISI):
    count = 0
    # create dictionary for results
    results = {}
    #for i in range(0,15):            # right now we don't want to see ALL the stimuli, but just some
    # for i in range(0,len(runlist)):
    for i in range(0,ntrials):
        trial = runlist.iloc[i]
        position = trial[2]
        eventDelay = trial[3]
        for e in range(0, len(trial)-3): # take only the columns that present stimuli
            # myEvent = trial[e] 
            if e == 0: # Present Cue
                eventStim = trial[0]
                resp_event, rt_event, onset_event, code_event = PresentCue(eventStim,ISI,eventDelay)              
            elif e == 1:
                eventStim = trial[1]
                resp_event, rt_event, onset_event, code_event = PresenttargetResp(eventStim, ISI, position)
                # resp_event, rt_event, onset_event = Presenttarget(eventStim, ISI, count)   
        # fill in the dictionary with the results
            results.setdefault('myEvent', []).append(eventStim)
            results.setdefault('onsets', []).append(onset_event)
            results.setdefault('code_event', []).append(code_event)
            results.setdefault('rt', []).append(rt_event)
            results.setdefault('response', []).append(resp_event)
            # count = count + 1
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
            'answ':''}                     # answer mapping [1 = YES/x-left, NO/y-right] vs [2 = YES/y-right, NO/x-left]
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
resultpath = 'results/VSA/'+ exp_info['id']
if not os.path.isdir(resultpath):
    os.makedirs(resultpath)
    
# load stimuli list for this run
#runlist = genfromtxt('stimuli/' + exp_info['id'] + '/'+ 'run' + exp_info['run'] +  '.csv', delimiter=',').astype(np.int)
# runlist = genfromtxt('stimuli/VSArun1.csv', delimiter=';').astype(np.int)
#runlist = genfromtxt('stimuli/stim.csv', delimiter=';').astype(np.int)
runlist = pd.read_csv('stimuli/VSA/' + exp_info['id'] + '/'+ 'run' + exp_info['run'] +  '.csv', header = 0, sep=',', encoding = 'latin-1') 


# Clock
clock = core.Clock()

# Set properties of the window    [1024 x 778 MEG screen]
#winColor = [0,0,0]
winColor = 'Black'
monitorSize = (1024, 768) # MEG ROOM
#monitorSize = (1024/2, 768/2)


win = visual.Window(size=monitorSize,
                    fullscr=False, 
                    monitor="testMonitor", 
                    units="pix", 
                    color=winColor)

myMouse = event.Mouse(win=win)
myMouse.setVisible(0)                                                                       # Mouse not visible

# Other objects to be presented
textColor = 'White'
textFont = 'Verdana'

fixation = visual.Circle(win, radius=0.1, 
                        edges=32, 
                        fillColor='White',
                        lineColor='White',
                        units='deg')

fixationColor = 'Gray'
# fixationThick=0.01
fixationThick=0.8

line1 = visual.Line(win, start=(-512, -389), 
                        end=(512, 389),
                        lineColor = fixationColor,
                        lineWidth=fixationThick,
                        units='deg')
line2 = visual.Line(win, start=(-512, 389), 
                        end=(512, -389),
                        lineColor = fixationColor,
                        lineWidth=fixationThick,
                        units='deg')

squareL = visual.Rect(win, width=3,
                         height=3,
                         pos=(-6, 0),
                         units='deg',
                         lineColor = 'White')

squareR = visual.Rect(win, width=3,
                         height=3,
                         pos=(6, 0),
                         units='deg',
                         lineColor = 'White')

# Create a line object

# List of ISI
# ISImin = 130.00
# ISImax = 200.00
# ISI = np.arange(ISImin, ISImax, (ISImax-ISImin)/160)
ISI = 24        # 400ms
ITI = 120       # 2000ms
INI = 60       # 2000ms
# cueDur = 9     # 100ms
# targetDur = 2  # 33ms
# shuffle(ISI)


'''
====================================================
       Set up the eye tracker
====================================================

'''

Get the eyelink information
eyelinktracker = pylink.EyeLink()

# Initiates the eyelink graphics
pylink.openGraphics()

# Name the EDF file
# edfFileName = "TEST.EDF" 
edfFileName = exp_info['id'] + exp_info['run'] + '.EDF'

# Opens the EDF file.
pylink.getEYELINK().openDataFile(edfFileName)

pylink.flushGetkeyQueue()
pylink.getEYELINK().setOfflineMode()

# Gets the display surface and sends a mesage to EDF file;
size = tuple(win.size)
pylink.getEYELINK().sendCommand("screen_pixel_coords =  0 0 %d %d" % size)
pylink.getEYELINK().sendMessage("DISPLAY_COORDS  0 0 %d %d" % size)


tracker_software_ver = 0
eyelink_ver = pylink.getEYELINK().getTrackerVersion()
if eyelink_ver == 3:
   tvstr = pylink.getEYELINK().getTrackerVersionString()
   vindex = tvstr.find("EYELINK CL")
   tracker_software_ver = int(float(tvstr[(vindex + len("EYELINK CL")):].strip()))
  

if eyelink_ver>=2:
   pylink.getEYELINK().sendCommand("select_parser_configuration 0")
   if eyelink_ver == 2: #turn off scenelink camera stuff
       pylink.getEYELINK().sendCommand("scene_camera_gazemap = NO")
else:
   pylink.getEYELINK().sendCommand("saccade_velocity_threshold = 35")
   pylink.getEYELINK().sendCommand("saccade_acceleration_threshold = 9500")
  
# set EDF file contents 
pylink.getEYELINK().sendCommand("file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON")
if tracker_software_ver>=4:
   pylink.getEYELINK().sendCommand("file_sample_data  = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET")
else:
   pylink.getEYELINK().sendCommand("file_sample_data  = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS")

# set link data (used for gaze cursor) 
pylink.getEYELINK().sendCommand("link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON")
if tracker_software_ver>=4:
   pylink.getEYELINK().sendCommand("link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,HTARGET")
else:
   pylink.getEYELINK().sendCommand("link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS")


pylink.setCalibrationColors( (0, 0, 0),(255, 255, 255));    #Sets the calibration target and background color
pylink.setTargetSize(int(size[0] / 70), int(size[0] / 300));    #select best size for calibration target
pylink.setCalibrationSounds("", "", "");
pylink.setDriftCorrectSounds("", "off", "off");


if(pylink.getEYELINK().isConnected() and not pylink.getEYELINK().breakPressed()):
   pylink.getEYELINK().doTrackerSetup()
else:
   raise Exception

# Status message on eye track screen
message ="record_status_message 'Trial %s'" % exp_info['run']
pylink.getEYELINK().sendCommand(message)

# Important, identifier for run id in EDF file
# msg = "TRIALID %s_%s" % (exp_info['id'], exp_info['run'])
# pylink.getEYELINK().sendMessage(msg);

error = pylink.getEYELINK().startRecording(1,1,1,1)

# Close the eyelink graphics
pylink.closeGraphics()

'''
====================================================
        Run the experiment
====================================================
'''
# print("#" * 20 + "     C'est parti!    " + "#" * 20)
print("#" * 20 + "    C'est parti le bloc %s!   " % exp_info['run'] + "#" * 20)


# INTRO
Message(win, u"Gardez les yeux fixes sur le centre de l'ecran")
WaitPressKey_Space(win)
Message(win, u'Preparez vous!')
WaitPressKey_Space(win)

# Wait a bit (literally) 30*16.7ms with std refresh rate of 60Hz
for frameN in range(INI):
    fixation.draw()
    squareL.draw()
    squareR.draw()
    win.flip()

for frameN in range(ITI):
    fixation.draw()
    squareL.draw()
    squareR.draw()
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
MessageEnd(win, u'Merci! Ce bloc est terminée.')
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
pylink.closeGraphics()

# Quit the experiment
core.quit()  