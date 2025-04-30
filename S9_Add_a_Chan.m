% Written by Ashlie Pankonin May 2022
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms and adds a
% new channel to each file.
close all; clearvars;

%Location of the main study directory, based on where this script is saved
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

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

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG, EEG CURRENTSET ALLCOM] = eeglab;


% Loop through each subject listed in SUB
for i = 1:length(SUB)
   
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the averaged ERP waveforms outputted in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_recog_ERPs_app_NMA&New.erp'], 'filepath', Subject_Path);  

    % Add the channel 
    ERP = pop_erpchanoperator( ERP, { 'ch61 = (ch10+ch27+ch44+ch8+ch12+ch42+ch46+ch25+ch29)/9 label small N400 ROI'} ,...
            'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' );
   
    ERP = pop_erpchanoperator( ERP, { 'ch62 = (ch4+ch5+ch10+ch27+ch44+ch8+ch12+ch42+ch46+ch25+ch29)/11 label big N400 ROI'} ,...
            'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' );

    ERP = pop_erpchanoperator( ERP, {  'ch63 = (ch8+ch10+ch12)/3 label frontal'} ,...
        'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' ); %F3, Fz, F4
    
    ERP = pop_erpchanoperator( ERP, {  'ch64 = (ch25+ch27+ch29)/3 label central'} ,...
        'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' ); %C3, Cz, C4
   
    ERP = pop_erpchanoperator( ERP, {  'ch65 = (ch42+ch44+ch46)/3 label parietal'} ,...
        'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' ); %P3, Pz, P4      
  
    ERP = pop_erpchanoperator( ERP, {  'ch66 = (ch8+ch25+ch42)/3 label left'} ,...
        'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' ); %F3, C3, P3
    
    ERP = pop_erpchanoperator( ERP, {  'ch67 = (ch10+ch27+ch44)/3 label midline'} ,...
        'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' ); %Fz, Cz, Pz
    
    ERP = pop_erpchanoperator( ERP, {  'ch68 = (ch12+ch29+ch46)/3 label right'} ,...
            'ErrorMsg', 'popup', 'KeepLocations',  1, 'Warning', 'on' ); %F4, C4, P4
        

    % Save the file
    ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs'], 'filename', [Subject_Path SUB{i} '_recog_ERPs_app_NMA&New_manyN400ROIs.erp']);
    
end %End subject loop

%*************************************************************************************************************************************