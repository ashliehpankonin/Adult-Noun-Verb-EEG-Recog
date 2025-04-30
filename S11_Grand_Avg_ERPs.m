% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin May 2022
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms to create
% grand average ERP waveforms across participants both with and without a
% low-pass filter applied.

close all; clearvars;

% Location of the main study directory
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: 
% DIR = /Users/KappenmanLab/ERP_CORE/N400
% DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

% Location of the folder that contains this script and any associated processing files
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: 
% Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing/Grand_Average_ERPs
% Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
SUB = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

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

% Create grand average ERP waveforms from individual subject ERPs *WITHOUT* low-pass filter applied 

% % Open EEGLAB and ERPLAB Toolboxes  
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% 
% % Create a text file containing a list of ERPsets and their file locations to include in the grand average ERP waveforms
% ERPset_list = fullfile(Current_File_Path, 'GA_ERPs_Verb_NMA&New.txt');
% fid = fopen(ERPset_list, 'w');
%     for i = 1:length(SUB)
%         Subject_Path = [DIR filesep SUB{i} filesep];
%         erppath = [Subject_Path SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs.erp'];
%         fprintf(fid,'%s\n', erppath);
%     end
% fclose(fid);
% 
% % Create a grand average ERP waveform
% ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
% ERP = pop_savemyerp(ERP, 'erpname', 'GA_ERPs_Verb_NMA&New', 'filename', 'GA_ERPs_Verb_NMA&New.erp', 'filepath', Current_File_Path, 'Warning', 'off');

%*************************************************************************************************************************************

% Create grand average ERP waveforms from individual subject ERPs *WITH* a low-pass filter applied

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Create a text file containing a list of low-pass filtered ERPsets and
% their file locations to include in the grand average ERP waveforms
ERPset_list = fullfile(Current_File_Path, 'GA_ERPs_lpfilt_Verb_NMA&New.txt');
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs_12Hzlpfilt.erp'];
        fprintf(fid,'%s\n', erppath);
    end
fclose(fid);

% Create a grand average ERP waveform
ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname', 'GA_ERPs_lpfilt_Verb_NMA&New', 'filename', 'GA_ERPs_lpfilt_Verb_NMA&New.erp', 'filepath', Current_File_Path, 'Warning', 'off');

%*************************************************************************************************************************************
