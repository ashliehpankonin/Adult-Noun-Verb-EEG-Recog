% Written by Ashlie Pankonin April 2021

% This script automates the "Convert an epoched dataset into a continuous
% one" option offered in EPRLAB so that you can eventually go on to compute
% averaged ERPs. It is essentially reverting EEG datasets that were
% (manually) epoched via EEGLAB back into continuous ones.

% This script and the data files you want to check should be located in a 
% directory that is included in Matlab's search path.

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/verb/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through
subject_list = {'020320_1f_verb'};
% Subjects to convert: 
%'120919_1f_verb','111919_1f_verb','111519_1f_verb',
%'111819_1f_verb', '110719_1f_verb','110719_2f_verb',
%'111419_1f_verb','111219_1f_verb','020320_1f_verb',
%'030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb',
%'022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb',
%'102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb',
%'030220_2f_verb','101519_1f_verb'

% Subjects that have been converted:

% Set up triggercode info
%triggercode = '32'; % '31' = M+, '32' = M-, '51' = New
% List all the trigger codes you wan to loop through
triggercode_list = {'31', '32', '51'};

% Set up acronym info
%acronym = 'CNMA'; % 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
% List all the acronyms you wan to loop through
acronym_list = {'INMA', 'CNMA', 'IN', 'CN'};

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};
    
    numtriggercodes = length(triggercode_list);
    for a=1:numtriggercodes
        triggercode = triggercode_list{a};
        if a == 1 || a == 2
            for b=1:2
                acronym = acronym_list{b};
                
                % Path to the folder containing the current subject's data
                subjectfolder = [parentfolder '/' subject '/'];
 
                subjectsetname = [subject '_recog_epoched_' triggercode '_' acronym];
                
                % Make output directories for each subject and condition         
                pathtran = [parentfolder filesep subject filesep];
                if ~exist(pathtran, 'dir')
                    mkdir(pathtran);
                end

                % Start EEGLAB
                eeglab;

                % Load dataset
                EEG = pop_loadset('filename',[subjectsetname '.set'],'filepath',subjectfolder);
                EEG = eeg_checkset( EEG );
                
                % Convert epoched dataset into a continuous one
                EEG = pop_epoch2continuous(EEG,'Warning','off');
                EEG = eeg_checkset( EEG );
                
                % Save dataset futher processing 
                newsetname = [subjectsetname '_ep2con.set']; % output file's new name
                EEG = pop_saveset( EEG, [subjectfolder newsetname]);
            end
        elseif a == 3
            for b=3:4
                acronym = acronym_list{b};
                
                % Get subject info (same name as subjects.m function)
                subjectfolder = [parentfolder '/' subject '/'];
                
                subjectsetname = [subject '_recog_epoched_' triggercode '_' acronym];
                
                % Make output directories for each subject and condition         
                pathtran = [parentfolder filesep subject filesep];
                if ~exist(pathtran, 'dir')
                    mkdir(pathtran);
                end

                % Start EEGLAB
                eeglab;

                % Load dataset
                EEG = pop_loadset('filename',[subjectsetname '.set'],'filepath',subjectfolder);
                EEG = eeg_checkset( EEG );
                
                % Convert epoched dataset into a continuous one
                EEG = pop_epoch2continuous(EEG,'Warning','off');
                EEG = eeg_checkset( EEG );
                
                % Save dataset futher processing 
                newsetname = [subjectsetname '_ep2con.set']; % output file's new name
                EEG = pop_saveset( EEG, [subjectfolder newsetname]);
            end
        end
    end
end