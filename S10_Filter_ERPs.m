% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin September 2022 
% Operates on individual subject data
% This script loads the averaged ERP waveform and creates low-pass filtered
% versions of the ERP waveforms.

close all; clearvars;

%Location of the main study directory, based on where this script is saved
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

%Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script; for running individual lines of code, replace the current file path with the path on your computer, e.g.: 
%Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing
%Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

%List of subjects to process, based on the name of the folder that contains that subject's data
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
%'120919_1f_verb','020320_1f_verb','111919_1f_verb','111519_1f_verb',
%'111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb',
%'101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb',
%'102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb',
%'100519_1f_verb', '110419_1f_verb','030220_2f_verb','092619_1f_verb'
%SUB = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};


%**********************************************************************************************************************************************************************

% Create averaged ERP waveforms

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Loop through each subject listed in SUB
for i = 1:length(SUB)
  
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the ERP waveforms in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs.erp'], 'filepath', Subject_Path);
    
    % Apply a low-pass filter (non-causal Butterworth impulse response function, 12 Hz half-amplitude cut-off, 40 dB/oct roll-off) to the ERP waveforms
    ERP = pop_filterp( ERP,  1:68 , 'Cutoff',  12, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
    ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs_12Hzlpfilt'], 'filename', [Subject_Path SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs_12Hzlpfilt.erp']);

%End subject loop
end 

%*************************************************************************************************************************************