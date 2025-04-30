% Modified by Ashlie Pankonin April 2021 (not the first author/creator,
% unsure who wrote it originally)

% This script not only prepares EEG datasets for computing averaged ERPs
% via ERPLAB but also computes those averaged ERPs via ERPLAB.

% This script and the data files you want to check should be located in a 
% directory that is included in Matlab's search path.


% Clear memory and the command window
clear
clc
 
% Initialize the ALLERP structure and CURRENTERP
ALLERP = buildERPstruct([]);
CURRENTERP = 0;
 
% Set the save_everything variable to 1 to save all of the intermediate files to the hard drive
% Set to 0 to save only the initial and final dataset and ERPset for each subject
save_everything  = 1;
 
% Set the plot_PDFs variable to 1 to create PDF files with the waveforms
% for each subject (set to 0 if you don't want to create the PDF files).
plot_PDFs = 0;

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'111919_1f_verb'};

% Subjects to prep: all verb subjects prepped 5/12/21 and again 9/21/22
% (after more cleaning, changing refs); all noun subjects prepped on
% 5/30/22 and again 9/21/22 (after changing refs)

% Verb subjects that are all prepped:
%'120919_1f_verb','111519_1f_verb', '111819_1f_verb',
%'110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb',
%'030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb',
%'100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb',
%'030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',
%'110719_1f_verb'(for 110719_1f_verb, only 31_INMA, 31_CNMA, 32_CNMA, and
%51_CN though because other combos only had one epoch and can't convert
%those into ERPs :c),'111919_1f_verb'(didn't prep again on 9/21/22 b/c has
%hand bias in recog task so not included in analyses anyway)
% Full set of verb subjects: 
% subject_list = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Noun subjects that are all prepped:
% '041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA',
% '042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA',
% '092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA',
% '100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA',
% '102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA',
% '110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA',
% '100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA',
% '111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'
% Full set of noun subjects: 
% subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

numsubjects = length(subject_list); %number of subjects in your set

% List all the trigger codes you wan to loop through (i.e., define your set of trigger codes)
% Triggercode info (full set of trigger codes): '31' = M+, '32' = M-, '51' = New
triggercode_list = {'31', '32'};
numtriggercodes = length(triggercode_list); %number of trigger codes in your set

% List all the acronyms you wan to loop through (i.e., define your set of acronyms)
% Full set of acronyms: 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
acronym_list = {'IMA', 'CMA'};

 
% Loop through all subjects
for s=1:numsubjects
    subject = subject_list{s};
    numtriggercodes = length(triggercode_list);
    for a=1:numtriggercodes
        triggercode = triggercode_list{a};
        if a == 1 || a == 2
            for b=1:2
                acronym = acronym_list{b};
                fprintf('\n******\nProcessing subject %s\n******\n\n', subject);
                % Path to the folder containing the current subject's data
                subjectfolder  = [parentfolder '/' subject '/'];

                % Check to make sure the dataset file exists
                % spath = path + subject's initial filename + .set
                 spath = [subjectfolder subject '_recog_epoched_' triggercode '_' acronym '_new.set'];
                    if exist(spath, 'file')<=0
                        fprintf('\n *** WARNING: %s does not exist *** \n', spath);
                        fprintf('\n *** Skipping all processing for this subject *** \n\n');
                    
                    else
                        % Load original dataset
                        fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject);
                        subjectsetname = [subject '_recog_epoched_' triggercode '_' acronym '_new'];
                        EEG = pop_loadset('filename', [subjectsetname '.set'], 'filepath', subjectfolder);

                        % Convert epoched dataset into a continuous one
                        fprintf('\n\n\n**** %s: Converting epoched dataset into a continuous one ****\n\n\n', subject);
                        EEG = pop_epoch2continuous(EEG,'Warning','off');
                        EEG = eeg_checkset( EEG );
                        EEG.setname = [subjectsetname '_ep2con_new']; 
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end    

                        % Create EEG event list
                        fprintf('\n\n\n**** %s: Creating EEG event list ****\n\n\n', subject);
                        EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
                        EEG.setname = [EEG.setname '_elist_new']; % output file's new name
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end

                        % Assign bins via BINLISTER
                        fprintf('\n\n\n**** %s: Assigning bins via BINLISTER ****\n\n\n', subject);       
                        EEG = pop_binlister( EEG , 'BDF', [parentfolder '/WLA_binlist.txt'], 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
                        %EEG = pop_binlister( EEG , 'BDF', [parentfolder '/WLA_binlist.txt'], 'IndexEL',  1, 'SendEL2', 'EEG', 'Workspace&EEG', 'Voutput', 'EEG' );
                        EEG.setname = [EEG.setname '_bins']; % output file's new name
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end

                        % Extracts bin-based epochs (200ms pre-stim, 1000ms post-stim, baseline correction by pre-stim window)
                        fprintf('\n\n\n**** %s: Bin-based epoching ****\n\n\n', subject);
                        EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre');
                        EEG.setname = [EEG.setname '_be_new']; % output file's new name
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end
                        
                        % Compute averaged ERPs (all epochs, including those that contain
                        % either "boundary" or invalid events)
                        fprintf('\n\n\n**** %s: Averaging ERPs ****\n\n\n', subject);              
                        ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
                        ERP.erpname = [subject '_recog_' triggercode '_' acronym '_ERPs_new'];  % name for erpset 
                        pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', subjectfolder, 'warning', 'off');
                    end % end of the "if/else" statement that makes sure the file exists
            end %end of looping through acronyms INMA and CNMA
        elseif a == 3
            for b=3:4
                acronym = acronym_list{b};
                fprintf('\n******\nProcessing subject %s\n******\n\n', subject);
                % Path to the folder containing the current subject's data
                subjectfolder  = [parentfolder '/' subject '/'];

                % Check to make sure the dataset file exists
                % spath = path + subject's initial filename + .set
                 spath = [subjectfolder subject '_recog_epoched_' triggercode '_' acronym '_new.set'];
                    if exist(spath, 'file')<=0
                        fprintf('\n *** WARNING: %s does not exist *** \n', spath);
                        fprintf('\n *** Skipping all processing for this subject *** \n\n');
                    
                    else
                        % Load original dataset
                        fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject);
                        subjectsetname = [subject '_recog_epoched_' triggercode '_' acronym '_new'];                        
                        EEG = pop_loadset('filename', [subjectsetname '.set'], 'filepath', subjectfolder);

                        % Convert epoched dataset into a continuous one
                        fprintf('\n\n\n**** %s: Converting epoched dataset into a continuous one ****\n\n\n', subject);
                        EEG = pop_epoch2continuous(EEG,'Warning','off');
                        EEG = eeg_checkset( EEG );
                        EEG.setname = [subjectsetname '_ep2con_new']; 
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end    

                        % Create event list
                        fprintf('\n\n\n**** %s: Creating event list ****\n\n\n', subject);
                        EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
                        EEG.setname = [EEG.setname '_elist_new']; % output file's new name
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end

                        % Run BINLISTER
                        fprintf('\n\n\n**** %s: Running BINLISTER ****\n\n\n', subject);       
                        EEG = pop_binlister( EEG , 'BDF', [parentfolder '/WLA_binlist.txt'], 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
                        %EEG = pop_binlister( EEG , 'BDF', [parentfolder '/WLA_binlist.txt'], 'IndexEL',  1, 'SendEL2', 'EEG', 'Workspace&EEG', 'Voutput', 'EEG' );
                        EEG.setname = [EEG.setname '_bins_new']; % output file's new name
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end

                        % Extracts bin-based epochs (200ms pre-stim, 1000ms post-stim, baseline correction by pre-stim window)
                        fprintf('\n\n\n**** %s: Bin-based epoching ****\n\n\n', subject);
                        EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre');
                        EEG.setname = [EEG.setname '_be_new']; % output file's new name
                        if (save_everything)
                            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                        end
                        
                        % Compute averaged ERPs (all epochs, including those that contain
                        % either "boundary" or invalid events)
                        fprintf('\n\n\n**** %s: Averaging ERPs ****\n\n\n', subject);              
                        ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
                        ERP.erpname = [subject '_recog_' triggercode '_' acronym '_ERPs_new'];  % name for erpset 
                        pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', subjectfolder, 'warning', 'off');
                    end % end of the "if/else" statement that makes sure the file exists                
            end %end of looping through acronyms IN and CN
        end %end "if/else" statement for selecting trigger codes
    end %end of looping through trigger codes
end % end of looping through all subjects

fprintf('\n\n\n**** FINISHED with Data Processing ****\n\n\n');