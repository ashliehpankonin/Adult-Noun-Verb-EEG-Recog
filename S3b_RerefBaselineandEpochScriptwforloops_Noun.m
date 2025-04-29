% Written by Ashlie Pankonin March 2021 with help from Jacob Momsen
% Revised by Ashlie Pankonin 4/27/22

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script will rereference, baseline, and epoch files 

%   NOTES:

% 	1) This script should be located in a directory that is included in 
%   Matlab's search path.
	
% 	2) All of the _manrej.xlsx files should also be stored in the same 
%   location as the datasets (i.e., in their respective subject folders).

%   3) To obtain the total number of epochs rejected for each dataset, open
%   the masterrej variable after running this script and the second number
%   in the array size will be the number you want (e.g., in an array size
%   of 1x10, 10 is the total number of epochs rejected)


% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

% List all the subject folders you want to loop through
subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

% Refer to EEG Data Tracking Google Spreadsheet to determine which
% participant needs what (i.e., rereferencing, baselining, and/or epoching)

% Full list of participants to process:
% '041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA',
% '042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA',
% '092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA',
% '102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA',
% '110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA',
% '101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA',
% '120415_1f_WLA'
% subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

% Processed participants:
% '041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA',
% '042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA',
% '092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','102315_2f_WLA','102915_2m_WLA',
% '110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA',
% '112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA',
% '110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA','100215_1f_WLA'

% Set up triggercode info
%triggercode = '32'; % '31' = M+, '32' = M-, '51' = New
% List all the trigger codes you wan to loop through
triggercode_list = {'31', '32', '51'};

% Set up acronym info
%acronym = 'CNMA'; % 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
% List all the acronyms you wan to loop through
acronym_list = {'IMA', 'CMA'};

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};
    
    numtriggercodes = length(triggercode_list);
    for a=1:numtriggercodes
        triggercode = triggercode_list{a};
        if a == 1 || a == 2
        %numacronyms = length(acronym_list);
            for b=1:2
                acronym = acronym_list{b};
                % Parentfolder should be the main file path that leads you to your data. 
                % The last file should be the one that houses your subject folders.
                parentfolder = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

                % Get subject info (same name as subjects.m function)
                subjectfolder = [parentfolder '/' subject '/'];

                % Make output directories for each subject and condition         
                pathtran = [parentfolder filesep subject filesep];
                if ~exist(pathtran, 'dir')
                    mkdir(pathtran);
                end

                % If the dataset has not been rereferenced yet, rereference it
                if ~exist([pathtran subject '_recog_reref_new.set'], 'file')

                    newsetname = [subject '_recog_reref_new.set']; % output file's new name

                    clear EEG ALLEEG

                    % Start EEGLAB
                    eeglab;

                    % Load dataset
                    EEG = pop_loadset('filename',[subject 'recog_ICAR.set'],'filepath',subjectfolder);
                    EEG = eeg_checkset( EEG );
                    eeglab redraw

                    % Rereference dataset
                    EEG = pop_reref( EEG, [33 41] );%should be 33 (TP7) and 41 (TP8), originally 27 (T7) and 32 (T8)
                    EEG = eeg_checkset( EEG );

                    % Save dataset futher processing  
                    EEG = pop_saveset( EEG, [subjectfolder newsetname]);

                % If the dataset has been rereferenced but not baselined yet, baseline it    
                elseif ~exist([pathtran subject '_recog_epoch_' triggercode '_bl_new.set'], 'file')

                    newsetname = [subject '_recog_epoch_' triggercode '_bl_new.set']; % output file's new name

                    clear EEG ALLEEG

                    % Start EEGLAB
                    eeglab;

                    % Load rereferenced dataset
                    EEG = pop_loadset('filename',[subject '_recog_reref_new.set'],'filepath',subjectfolder);
                    EEG = eeg_checkset( EEG );

                    % Baseline dataset
                    EEG = pop_epoch( EEG, {triggercode}, [-0.5 1], 'newname', [subject '_recog_epoch_' triggercode '_bl_new'], 'epochinfo', 'yes');
                    EEG = eeg_checkset( EEG );
                    EEG = pop_rmbase( EEG, [-200 0]);
                    EEG = eeg_checkset( EEG );

                    % Save dataset futher processing  
                    EEG = pop_saveset( EEG, [subjectfolder newsetname]);

                % If the data set has been rereferenced and baselined but not epoched yet, epoch it    
                elseif ~exist([pathtran subject '_recog_epoched_' triggercode '_' acronym '_new.set'], 'file')
                %elseif ~exist([pathtran subject '_recog_epoched_' triggercode '_' acronym '_SR.set'], 'file') % SR = script reject

                    newsetname = [subject '_recog_epoched_' triggercode '_' acronym '_new.set']; % output file's new name
                    %newsetname = [subject '_recog_tobeepoched_' triggercode '_' acronym '.set']; % output file's new name

                    clear EEG ALLEEG

                    % Start EEGLAB
                    eeglab;

                    % Load baselined dataset
                    EEG = pop_loadset('filename',[subject '_recog_epoch_' triggercode '_bl_new.set'],'filepath',subjectfolder);
                    EEG = eeg_checkset( EEG );

                    % Epoch dataset

                    % First, select epochs to reject based on:
                    EEG = pop_eegthresh(EEG,1,[1:60] ,-75,75,-0.5,0.998,2,0); % abnormal/extreme/outlier values
                    EEG = eeg_checkset( EEG );
                    EEG = pop_rejtrend(EEG,1,[1:60] ,750,50,0.3,2,0); % abnormal linear trends/varianc
                    EEG = eeg_checkset( EEG );
                    EEG = pop_jointprob(EEG,1,[1:60] ,5,5,0,0,0,[],0); % improbable data
                    EEG = pop_rejkurt(EEG,1,[1:60] ,5,5,0,0,0,[],0); % abnormal/kurtotic distributions
                    EEG = eeg_checkset( EEG );
               %% Jacob's mods 3/17/21
                    % Create a vector that stores all the epochs marked for rejection 
                    % based on the statistical artifact rejection methods above

                    % ARvector (= Artifact Rejection vector) contains a "1" for each 
                    % epoch that was flagged by each of the rejection algorithms used 
                    % in the previous lines
                    ARflagpull(1,:)=EEG.reject.rejjp(1,:);
                    ARflagpull(2,:)=EEG.reject.rejkurt(1,:);
                    ARflagpull(3,:)=EEG.reject.rejthresh(1,:);
                    ARflagpull(4,:)=EEG.reject.rejconst(1,:);
                    ARflags=sum(ARflagpull,1);
                        Flaggedtrials =[]; % just the number of the flagged epochs
                        ARvector=zeros(1,length(ARflags));
                        for T=1:length(ARflags)
                            if ARflags(1,T)>0
                                ARvector(1,T)=1;
                                Flaggedtrials(end+1)=T;
                            end
                        end
                        clearvars ARflagpull ARflags

                     % Then, select epochs to reject based on a file that lists 
                     % additional epochs to mark as "bad" and reject all the selected 
                     % epochs
                     ARfolder = ['/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)/' subject '/'];
                     ARname = [ARfolder subject '_recog_' triggercode '_' acronym '_manrej.xlsx'];

                        [manrej]=xlsread([ARname],1);
                        masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym '_new'])=unique(cat(2,manrej,Flaggedtrials));
                        clearvars manrej Flaggedtrials %clears the variables for the next subject

                       % [masterrej] is now the thing you'd put in the second 
                       % location of the pop_rejepoch command. This will also hold all
                       % the rejected trials for each subject, which will be helpful for
                       % calculating # trials rejected for your study etc

                        EEG = pop_rejepoch( EEG,[ masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym '_new'])] ,0);
                        EEG = eeg_checkset( EEG );

                        % Save dataset futher processing 
                        %newsetname = [subject '_recog_epoched_' triggercode '_' acronym '_SR2.set']; % output file's new name, SR = script reject
                        EEG = pop_saveset( EEG, [subjectfolder newsetname]);

                        % Record the number of epochs in the pre-created
                        % text file - I can't get the numel(...) command to
                        % return the correct number of total epochs
                        % rejected, so abandoning this whole text file
                        % thing for now
                        %fileID = fopen('/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)/NumberofEpochsRemoved.txt','a');
                        %fprintf(fileID, [subject '_recog_epoched_' triggercode '_' acronym ': ' numel(masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym])) '\n' ] );
                        %fclose(fileID);
                end     
            end

%         elseif a == 3
%         %numacronyms = length(acronym_list);
%             for b=3:4
%                 acronym = acronym_list{b};
%                 % Parentfolder should be the main file path that leads you to your data. 
%                 % The last file should be the one that houses your subject folders.
%                 parentfolder = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';%change this
% 
%                 % Get subject info (same name as subjects.m function)
%                 subjectfolder = [parentfolder '/' subject '/'];
% 
%                 % Make output directories for each subject and condition         
%                 pathtran = [parentfolder filesep subject filesep];
%                 if ~exist(pathtran, 'dir')
%                     mkdir(pathtran);
%                 end
% 
%                 % If the dataset has not been rereferenced yet, rereference it
%                 if ~exist([pathtran subject '_recog_reref_new.set'], 'file')
% 
%                     newsetname = [subject '_recog_reref_new.set']; % output file's new name
% 
%                     clear EEG ALLEEG
% 
%                     % Start EEGLAB
%                     eeglab;
% 
%                     % Load dataset
%                     EEG = pop_loadset('filename',[subject 'recog_ICAR.set'],'filepath',subjectfolder);
%                     EEG = eeg_checkset( EEG );
%                     eeglab redraw
% 
%                     % Rereference dataset
%                     EEG = pop_reref( EEG, [33 41] );%should be 33 (TP7) and 41 (TP8), originally 27 (T7) and 32 (T8)
%                     EEG = eeg_checkset( EEG );
% 
%                     % Save dataset futher processing  
%                     EEG = pop_saveset( EEG, [subjectfolder newsetname]);
% 
%                 % If the dataset has been rereferenced but not baselined yet, baseline it    
%                 elseif ~exist([pathtran subject '_recog_epoch_' triggercode '_bl_new.set'], 'file')
% 
%                     newsetname = [subject '_recog_epoch_' triggercode '_bl_new.set']; % output file's new name
% 
%                     clear EEG ALLEEG
% 
%                     % Start EEGLAB
%                     eeglab;
% 
%                     % Load rereferenced dataset
%                     EEG = pop_loadset('filename',[subject '_recog_reref_new.set'],'filepath',subjectfolder);
%                     EEG = eeg_checkset( EEG );
% 
%                     % Baseline dataset
%                     EEG = pop_epoch( EEG, {triggercode}, [-0.5 1], 'newname', [subject '_recog_epoch_' triggercode '_bl_new'], 'epochinfo', 'yes');
%                     EEG = eeg_checkset( EEG );
%                     EEG = pop_rmbase( EEG, [-200 0]);
%                     EEG = eeg_checkset( EEG );
% 
%                     % Save dataset futher processing  
%                     EEG = pop_saveset( EEG, [subjectfolder newsetname]);
% 
%                 % If the data set has been rereferenced and baselined but not epoched yet, epoch it    
%                 elseif ~exist([pathtran subject '_recog_epoched_' triggercode '_' acronym '_new.set'], 'file')
%                 %elseif ~exist([pathtran subject '_recog_epoched_' triggercode '_' acronym '_SR.set'], 'file') % SR = script reject
% 
%                     newsetname = [subject '_recog_epoched_' triggercode '_' acronym '_new.set']; % output file's new name
%                     %newsetname = [subject '_recog_tobeepoched_' triggercode '_' acronym '.set']; % output file's new name
% 
%                     clear EEG ALLEEG
% 
%                     % Start EEGLAB
%                     eeglab;
% 
%                     % Load baselined dataset
%                     EEG = pop_loadset('filename',[subject '_recog_epoch_' triggercode '_bl_new.set'],'filepath',subjectfolder);
%                     EEG = eeg_checkset( EEG );
% 
%                     % Epoch dataset
% 
%                     % First, select epochs to reject based on:
%                     EEG = pop_eegthresh(EEG,1,[1:60] ,-75,75,-0.5,0.998,2,0); % abnormal/extreme/outlier values
%                     EEG = eeg_checkset( EEG );
%                     EEG = pop_rejtrend(EEG,1,[1:60] ,750,50,0.3,2,0); % abnormal linear trends/varianc
%                     EEG = eeg_checkset( EEG );
%                     EEG = pop_jointprob(EEG,1,[1:60] ,5,5,0,0,0,[],0); % improbable data
%                     EEG = pop_rejkurt(EEG,1,[1:60] ,5,5,0,0,0,[],0); % abnormal/kurtotic distributions
%                     EEG = eeg_checkset( EEG );
%                %% Jacob's mods 3/17/21
%                     % Create a vector that stores all the epochs marked for rejection 
%                     % based on the statistical artifact rejection methods above
% 
%                     % ARvector (= Artifact Rejection vector) contains a "1" for each 
%                     % epoch that was flagged by each of the rejection algorithms used 
%                     % in the previous lines
%                     ARflagpull(1,:)=EEG.reject.rejjp(1,:);
%                     ARflagpull(2,:)=EEG.reject.rejkurt(1,:);
%                     ARflagpull(3,:)=EEG.reject.rejthresh(1,:);
%                     ARflagpull(4,:)=EEG.reject.rejconst(1,:);
%                     ARflags=sum(ARflagpull,1);
%                         Flaggedtrials =[]; % just the number of the flagged epochs
%                         ARvector=zeros(1,length(ARflags));
%                         for T=1:length(ARflags)
%                             if ARflags(1,T)>0
%                                 ARvector(1,T)=1;
%                                 Flaggedtrials(end+1)=T;
%                             end
%                         end
%                         clearvars ARflagpull ARflags
% 
%                      % Then, select epochs to reject based on a file that lists 
%                      % additional epochs to mark as "bad" and reject all the selected 
%                      % epochs
%                      ARfolder = ['/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)/' subject '/'];
%                      ARname = [ARfolder subject '_recog_' triggercode '_' acronym '.xlsx'];
% 
%                         [manrej]=xlsread([ARname],1);
%                         masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym '_new'])=unique(cat(2,manrej,Flaggedtrials));
%                         clearvars manrej Flaggedtrials %clears the variables for the next subject
% 
%                        % [masterrej] is now the thing you'd put in the second 
%                        % location of the pop_rejepoch command. This will also hold all
%                        % the rejected trials for each subject, which will be helpful for
%                        % calculating # trials rejected for your study etc
% 
%                         EEG = pop_rejepoch( EEG,[ masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym '_new'])] ,0);
%                         EEG = eeg_checkset( EEG );
% 
%                         % Save dataset futher processing 
%                         %newsetname = [subject '_recog_epoched_' triggercode '_' acronym '_SR2.set']; % output file's new name, SR = script reject
%                         EEG = pop_saveset( EEG, [subjectfolder newsetname]);
% 
%                         % Record the number of epochs in the pre-created
%                         % text file - I can't get the numel(...) command to
%                         % return the correct number of total epochs
%                         % rejected, so abandoning this whole text file
%                         % thing for now
%                         %fileID = fopen('/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)/NumberofEpochsRemoved.txt','a');
%                         %fprintf(fileID, [subject '_recog_epoched_' triggercode '_' acronym ': ' numel(masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym])) '\n' ] );
%                         %fclose(fileID);
%                 end
%        
%             end
        end
    end
end

% Open text file and review contents
%open '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)/NumberofEpochsRemoved.txt'
