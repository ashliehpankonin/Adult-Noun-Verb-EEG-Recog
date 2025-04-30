% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin May 2022
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms, measures
% the mean amplitude during the time window of the component, and saves a
% separate text file for each measurement in the ERP Measurements folder.
% Note that based on their respective susceptibility to high frequency
% noise, mean amplitude is calculated on the averaged ERP waveforms
% *without* a low-pass filter applied.

close all; clearvars;

% Location of the main study directory
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: 
% DIR = /Users/KappenmanLab/ERP_CORE/N400
% DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% Location of the folder that contains this script and any associated processing files
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: 
% Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing/Grand_Average_ERPs
% Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Full set of verb subjects: 
%'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb',
%'110719_2f_verb','111419_1f_verb','111219_1f_verb','101519_1f_verb',
%'020320_1f_verb', '030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb',
%'100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb',
%'030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',
%'110719_1f_verb'
%SUB = {'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Full set of noun subjects: 

%SUB = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

%*************************************************************************************************************************************

% Set measurement time window for measuring mean amplitude in milliseconds
% (e.g., 300 to 500 ms)
% N400 = 300 to 500 ms
timewindow = [300 500];

% Set EEG channel(s) to measure the components
% 61 = Average of Fz, Cz, Pz, F3, F4, P3, P4, C3, C4
% 62 = Average of AF3, AF4,Fz, Cz, Pz, F3, F4, P3, P4, C3, C4
% 63-68 = Average of 3 electrodes to create right, middle, left, frontal,
% central, parietal (see S9_Add_a_Chan.m)
chan = [61:68]; 
% Set wave bins for measurement
% N400 = [7 14 17 20] or [15 22], depending on ERP waveforms used
% bin7 = Old CNMA
% bin14 = Old INMA
% bin 15 = Old NMA
% bin17 = New CN
% bin20 = New IN
% bin22 = New
parentbins = [15 22];  

% Set baseline correction period for measurement
baselinecorr = [-100 0]; 

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%*************************************************************************************************************************************

% Waveform measurements on averaged ERP waveforms without a low-pass filter
% applied

% Create a text file containing a list of unfiltered ERPsets and their file
% locations to measure mean amplitude from
 ERPset_list = fullfile(Current_File_Path, 'Measurement_ERP_List_NMA&New.txt');
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs.erp'];
        fprintf(fid,'%s\n', erppath);
    end %End subjects loop
fclose(fid);

% Measure mean amplitude using the time window, channel(s), and bin(s)
% specified above
ALLERP = pop_geterpvalues( ERPset_list, timewindow, parentbins, chan, 'Baseline', baselinecorr, 'Measure', 'meanbl', 'Filename',... 
    [Current_File_Path filesep 'Mean_ERP_List_NMA&New_manyN400ROIs.txt'], 'Binlabel', 'on', 'FileFormat', 'wide', 'InterpFactor',  1,  'Resolution', 3);

%*************************************************************************************************************************************
