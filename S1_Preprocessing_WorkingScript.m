%Written by Julie Schneider & Bambi DeLaRosa May 2016
%Revised by Ashlie Pankonin June 2020
% set up paths; put parent folder here too; define subject list

resample= 500; %set resample rate
lowcut=0.1; %set high pass filter
highcut=50; %set low pass filter

    captype = 1;
    capchan = 64;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% loop over subjects 
% [Parentfolder should be the main filepath to lead you to your data. the last file should be the one that houses your subject folders)]

parentfolder = '/Volumes/verb/WLA Verb Adult Participants (EEG data)/';% change file path (may need to change whole thing)

%[list all the subject folders you want to loop through] 
%subjects that have been preprocessed (WLfC & Recog):
%'120919_1f_verb','111919_1f_verb','111519_1f_verb',
%'111819_1f_verb', '110719_1f_verb','110719_2f_verb',
%'111419_1f_verb','111219_1f_verb','020320_1f_verb',
%'030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb',
%'022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb',
%'102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb',
%'030220_2f_verb','101519_1f_verb','100419_1f_verb'
subject_list = {''};% change subjects
numsubjects = length(subject_list);

for s=1:numsubjects

    subject = subject_list{s};

    subjectfolder = [parentfolder subject '/'];
    % get subject info, same name as subjects.m (function)
  %  [datafolder subject captype capchan capfile badcell] = WLAchild_subjects3;
   % subject
    
        % make output directories for each subject and condition         
        pathtran = [parentfolder filesep subject filesep];
        if ~exist(pathtran, 'dir')
            mkdir(pathtran);
        end
        newsetname= [subject '_preproc.set']; %output file new name

        clear EEG ALLEEG
        % start EEGLAB
        eeglab;

        % initialize badcell empty
badcell = {};

        % load cnt eeg file
        EEG = pop_loadcnt([subjectfolder subject '.cnt'], 'dataformat', 'auto', 'keystoke', 'on');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', [subject '_prepoc'], 'gui', 'off');
  
        %making set name to subject
        EEG=pop_editset(EEG, 'subject', subject);
        eeglab redraw
        
        
        % unused 'drop' electrodes in standard 128-channel cap
if captype == 1 && capchan == 128
    dropelectrodes = {'10', '11', '84', '85', '110', '111'};
    badcell = [badcell, dropelectrodes];
end

% non-EEG electrodes for all caps combined
noneeg = {'VEO', 'HEO', 'VEOG', 'HEOG', 'EKG', 'EMG', 'M1', 'M2', 'PulseOx'};
badcell = [badcell, noneeg];

% default electrode files
if capchan == 64
    capfile = 'SynAmps2 Quik-Cap64.dat';
elseif capchan == 128
    capfile = 'SynAmps2 Quik-Cap128.dat';
end

        
        %remove unused channels
        EEG=pop_select(EEG, 'nochannel', {'VEO' 'VEOG' 'HEO' 'HEOG' 'M1' 'M2' 'EKG' 'EMG'});
        [ALLEEG EEG CURRENTSET]= pop_newset(ALLEEG, EEG, 1, 'overwrite', 'on', 'gui', 'off');
        [ALLEEG EEG]= eeg_store(ALLEEG, EEG, CURRENTSET);
        
        %resample at new rate 
        EEG=pop_resample(EEG,resample);
        [ALLEEG EEG CURRENTSET]=pop_newset(ALLEEG, EEG,1, 'overwrite', 'on', 'gui', 'off');
        [ALLEEG EEG]= eeg_store(ALLEEG, EEG, CURRENTSET);
        
        %high pass filter
        EEG = pop_eegfilt( EEG, lowcut, 0, [], [0], 0, 0, 'fir1', 0);
        [ALLEEG EEG CURRENTSET]=pop_newset(ALLEEG, EEG,1, 'overwrite', 'on', 'gui', 'off');
        [ALLEEG EEG]= eeg_store(ALLEEG, EEG, CURRENTSET);        

        %low pass filter
        EEG = pop_eegfilt( EEG, 0, highcut, [], [0], 0, 0, 'fir1', 0);
        [ALLEEG EEG CURRENTSET]=pop_newset(ALLEEG, EEG,1, 'overwrite', 'on', 'gui', 'off');
        [ALLEEG EEG]= eeg_store(ALLEEG, EEG, CURRENTSET); 
        
        %clean raw EEG data
        %EEG = clean_rawdata(EEG, CURRENTSET, [0.25 0.75], 0.8, 4, 5, 'off');
        %EEG = eeg_checkset( EEG );
        %pop_eegplot( EEG, 1, 1, 1);
        %EEG = eeg_checkset( EEG );
        
        %saving output file
         EEG = eeg_checkset( EEG ); 
         EEG = pop_saveset( EEG, [subjectfolder newsetname]);
         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);%end
end