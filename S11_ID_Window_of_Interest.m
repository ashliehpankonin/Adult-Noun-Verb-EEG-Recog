% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin Sep 2022
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms, measures
% the average negative peak latency during the specified time window,
% and saves a separate text file for each measurement in the ERP Measurements 
% folder. These measures are calculated on the averaged ERP waveforms
% *without* a low-pass filter applied.

close all; clearvars;

% Location of the main study directory
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: 
% DIR = /Users/KappenmanLab/ERP_CORE/N400
% DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/WLA Noun Child/WLA Noun Child Participants (EEG Data)';

% Location of the folder that contains this script and any associated processing files
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: 
% Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing/Grand_Average_ERPs
% Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/Life Support/WLA Noun Child/WLA Noun Child Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
SUB = {'010616_1m_8y_WLA','010616_2m_12y_WLA','020316_1m_8y_WLA','020816_1f_8y_WLA','021716_1f_9y_WLA','022716_1f_12y_WLA','022716_2f_13y_WLA','031116_1m_8y_WLA','031317_1f_8y_WLA','031317_2m_10y_WLA','031516_1m_13y_WLA','032316_1m_14y_WLA','032717_1f_10y_WLA','032816_1f_15y_WLA','033016_1f_10y_WLA','040116_1m_11y_WLA','040216_1m_15y_WLA','040216_2m_15y_WLA','040516_1f_10y_WLA','040516_2f_13y_WLA','040816_1f_15y_WLA','060616_1f_16y_WLA','060916_1m_9y_WLA','061416_1f_14y_WLA','061815_1f_15y_WLA','061815_2m_12y_WLA','061816_1m_16y_WLA','062116_1f_10y_WLA','062315_1f_10y_WLA','062315_2m_8y_WLA','062315_3m_10y_WLA','062315_4f_9y_WLA','062316_1f_8y_WLA','062516_1f_8y_WLA','062516_2m_10y_WLA','062715_1f_12y_WLA','070116_1f_14y_WLA','070116_2m_16y_WLA','070215_1m_12y_WLA','070317_1m_14y_WLA','070516_1f_14y_WLA','070516_2f_8y_WLA','070616_2f_14y_WLA','070715_1m_13y_WLA','070916_2m_13y_WLA','071216_1f_12y_WLA','071415_1f_8y_WLA','071615_1m_12y_WLA','071615_2m_11y_WLA','072315_1m_10y_WLA','072315_2f_14y_WLA','072816_1f_8y_WLA','072816_2m_11y_WLA','080515_1f_13y_WLA','081115_1f_8y_WLA','090215_1f_10y_WLA','090817_1f_9y_WLA','090817_2f_11y_WLA','100416_1f_9y_WLA','101217_1m_9y_WLA','101217_2f_11y_WLA','101516_1f_10y_WLA','101516_2f_12y_WLA','110515_1m_11y_WLA','110715_1m_8y_WLA','111817_1f_12y_WLA','112315_2f_10y_WLA','112415_1f_14y_WLA','112415_2m_13y_WLA'};

% Full list of participants:
%'010616_1m_8y_WLA','010616_2m_12y_WLA','020316_1m_8y_WLA','020816_1f_8y_WLA','021716_1f_9y_WLA','022716_1f_12y_WLA','022716_2f_13y_WLA','031116_1m_8y_WLA','031317_1f_8y_WLA','031317_2m_10y_WLA','031516_1m_13y_WLA','032316_1m_14y_WLA','032717_1f_10y_WLA','032816_1f_15y_WLA','033016_1f_10y_WLA','040116_1m_11y_WLA','040216_1m_15y_WLA','040216_2m_15y_WLA','040516_1f_10y_WLA','040516_2f_13y_WLA','040816_1f_15y_WLA','060616_1f_16y_WLA','060916_1m_9y_WLA','061416_1f_14y_WLA','061815_1f_15y_WLA','061815_2m_12y_WLA','061816_1m_16y_WLA','062116_1f_10y_WLA','062315_1f_10y_WLA','062315_2m_8y_WLA','062315_3m_10y_WLA','062315_4f_9y_WLA','062316_1f_8y_WLA','062515_1m_15y_WLA','062516_1f_8y_WLA','062516_2m_10y_WLA','062715_1f_12y_WLA','070116_1f_14y_WLA','070116_2m_16y_WLA','070215_1m_12y_WLA','070317_1m_14y_WLA','070516_1f_14y_WLA','070516_2f_8y_WLA','070616_2f_14y_WLA','070715_1m_13y_WLA','070916_2m_13y_WLA','071216_1f_12y_WLA','071415_1f_8y_WLA','071615_1m_12y_WLA','071615_2m_11y_WLA','072315_1m_10y_WLA','072315_2f_14y_WLA','072816_1f_8y_WLA','072816_2m_11y_WLA','080515_1f_13y_WLA','081115_1f_8y_WLA','090215_1f_10y_WLA','090817_1f_9y_WLA','090817_2f_11y_WLA','100416_1f_9y_WLA','101217_1m_9y_WLA','101217_2f_11y_WLA','101516_1f_10y_WLA','101516_2f_12y_WLA','110515_1m_11y_WLA','110715_1m_8y_WLA','111817_1f_12y_WLA','112315_2f_10y_WLA','112415_1f_14y_WLA','112415_2m_13y_WLA'

% List of participants with TM, WC, and OC ERP files:
% '020316_1m_8y_WLA','020816_1f_8y_WLA','021716_1f_9y_WLA','031116_1m_8y_WLA','032316_1m_14y_WLA','040116_1m_11y_WLA','040516_1f_10y_WLA','062516_1f_8y_WLA','070516_1f_14y_WLA','070616_2f_14y_WLA','072816_1f_8y_WLA','081115_1f_8y_WLA','090817_1f_9y_WLA'

% List of participants with TM and WC ERP files (no OC; 49-50 out of 50 epochs removed):
% '010616_1m_8y_WLA','010616_2m_12y_WLA','022716_1f_12y_WLA','022716_2f_13y_WLA','031317_1f_8y_WLA','031317_2m_10y_WLA','031516_1m_13y_WLA','040816_1f_15y_WLA','060616_1f_16y_WLA','060916_1m_9y_WLA','061416_1f_14y_WLA','061815_1f_15y_WLA','061816_1m_16y_WLA','062116_1f_10y_WLA','062315_1f_10y_WLA','062315_2m_8y_WLA','062316_1f_8y_WLA','070116_1f_14y_WLA','070116_2m_16y_WLA','070317_1m_14y_WLA','070516_2f_8y_WLA','070916_2m_13y_WLA','071615_1m_12y_WLA','072315_1m_10y_WLA','072315_2f_14y_WLA','072816_2m_11y_WLA','080515_1f_13y_WLA','090215_1f_10y_WLA','090817_2f_11y_WLA','100416_1f_9y_WLA','101217_1m_9y_WLA','101217_2f_11y_WLA','101516_1f_10y_WLA','101516_2f_12y_WLA','110515_1m_11y_WLA','110715_1m_8y_WLA','111817_1f_12y_WLA','112315_2f_10y_WLA','112415_1f_14y_WLA','112415_2m_13y_WLA'
% '032717_1f_10y_WL'A,'033016_1f_10y_WLA','040516_2f_13y_WLA','061815_2m_12y_WLA','062315_3m_10y_WLA','062315_4f_9y_WLA','062516_2m_10y_WLA','062715_1f_12y_WLA','070215_1m_12y_WLA','071216_1f_12y_WLA','071415_1f_8y_WLA'

% List of participants with TM and OC ERP files (no WC; 49-50 out of 50 epochs removed):
% '071615_2m_11y_WLA'

% List of participants with only TM ERP files (no WC or OC; 49-50 out of 50 epochs removed):
% 040216_1m_15y_WLA, 040216_2m_15y_WLA, 070715_1m_13y_WLA, 032816_1f_15y_WLA

% '062515_1m_15y_WLA' has not been processed past ICAR right now due to it only having 58 not 60 channels

% Set up acronym info
acronym = 'WC'; %Full acronym list: 'TM', 'OC', 'WC'
%*************************************************************************************************************************************

% Set measurement time window for measuring the peak latecy in milliseconds
% (e.g., 300 to 500 ms)
% N400 = 300 to 500 ms
timewindow = [200 600];

% Set EEG channel(s) to measure the components
chan = [8:2:12 26:2:30 42:2:46]; % F3, Fz, F4, C3, Cz, C4, P3, Pz, P4 
% Set wave bins for measurement
parentbins = [1];  

% Set baseline correction period for measurement
baselinecorr = [-100 0]; 

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%*************************************************************************************************************************************

% Waveform measurements on averaged ERP waveforms without a low-pass filter
% applied

% Create a text file containing a list of unfiltered ERPsets and their file
% locations to measure the negative peak latency from
ERPset_list = fullfile(Current_File_Path, ['Measurement_' acronym '_ERP_List.txt']);
fid = fopen(ERPset_list, 'w');

numsubjects = length(SUB);
for i = 1:length(SUB)

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Check whether the data set exists
    if exist([Subject_Path SUB{i} '_' acronym '_ERPs.erp'],'file')<=0
       fprintf(['\n *** ' SUB{i} '_' acronym '_ERPs.erp does not exist. Cannot process file. *** \n'], Subject_Path);
    else
       erppath = [Subject_Path SUB{i} '_' acronym '_ERPs.erp'];
       fprintf(fid,'%s\n', erppath);
       % Load the ERP waveforms in .erp ERPLAB file format
    end
end
fclose(fid);

% Measure the negative peak latency using the time window, channel(s), and bin(s)
% specified above
ALLERP = pop_geterpvalues( ERPset_list, timewindow,  parentbins, chan , 'Baseline', baselinecorr, 'Binlabel', 'on', 'FileFormat', 'wide',...
 'Filename', [Current_File_Path filesep 'Negative_Peak_Latency_ERP_' acronym '_List.txt'], 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'peaklatbl', 'Neighborhood',  3, 'PeakOnset',  1, 'Peakpolarity',...
 'negative', 'Peakreplace', 'absolute', 'Resolution',  3 );

%*************************************************************************************************************************************
