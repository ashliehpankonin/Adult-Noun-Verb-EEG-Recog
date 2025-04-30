function RerefBaselineandEpoch(subject, triggercode, acronym)

% Written by Ashlie Pankonin March 2021 with help from Jacob Momsen 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is a function that will rereference, baseline, and epoch files 

% For this function to work properly, you will need to do the following
% before calling it:
%   * Set up a list of all the subject folders you want to loop through, 
%   for example:
%       subject_list = {'100319_1f_verb'};
%       numsubjects = length(subject_list);
%       for s=1:numsubjects
%           subject = subject_list{s};   
%   * Specify the triggercode(s) you want to process, for example:
%       triggercode = '32'; % '31' = M+, '32' = M-, '51' = New, or:
%       triggercode_list = {'31', '32', '51'};
%       numtriggercodes = length(triggercode_list);
%       for a=1:numtriggercodes
%           triggercode = triggercode_list{a};
%   * Specify the acronym(s) you want to process, for example:
%       acronym = 'INMA'; % 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
%       acronym_list = {'INMA', 'CNMA', 'IN', 'CN'};
%       numacronyms = length(acronym_list);
%           for b=1:numacronyms
%           acronym = acronym_list{b};
%  (See RBEforloopsandfunc.m to see how those loops should be structured 
%  in relation to one another)

    % Parentfolder should be the main file path that leads you to your data. 
    % The last file should be the one that houses your subject folders.
    parentfolder = '/Volumes/verb/WLA Adult/WLA Verb Adult Participants (EEG Data)';
    
    % Get subject info (same name as subjects.m function)
    subjectfolder = [parentfolder '/' subject '/'];

    % Make output directories for each subject and condition         
    pathtran = [parentfolder filesep subject filesep];
    if ~exist(pathtran, 'dir')
        mkdir(pathtran);
    end

    % If the dataset has not been rereferenced yet, rereference it
    if ~exist([pathtran subject '_recog_reref.set'], 'file')

        newsetname = [subject '_recog_reref.set']; % output file's new name

        clear EEG ALLEEG

        % Start EEGLAB
        eeglab;

        % Load dataset
        EEG = pop_loadset('filename',[subject '_recog_ICAR.set'],'filepath',subjectfolder);
        EEG = eeg_checkset( EEG );
        eeglab redraw

        % Rereference dataset
        EEG = pop_reref( EEG, [24 32] );
        EEG = eeg_checkset( EEG );

        % Save dataset futher processing  
        EEG = pop_saveset( EEG, [subjectfolder newsetname]);

    % If the dataset has been rereferenced but not baselined yet, baseline it    
    elseif ~exist([pathtran subject '_recog_epoch_' triggercode '_bc.set'], 'file')

        newsetname = [subject '_recog_epoch_' triggercode '_bc.set']; % output file's new name

        clear EEG ALLEEG

        % Start EEGLAB
        eeglab;

        % Load rereferenced dataset
        EEG = pop_loadset('filename',[subject '_recog_reref.set'],'filepath',subjectfolder);
        EEG = eeg_checkset( EEG );

        % Baseline dataset
        EEG = pop_epoch( EEG, {  triggercode  }, [-0.5           1], 'newname', [subject '_recog_epoch_' triggercode '_bc'], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-200    0]);
        EEG = eeg_checkset( EEG );

        % Save dataset futher processing  
        EEG = pop_saveset( EEG, [subjectfolder newsetname]);

    % If the data set has been rereferenced and baselined but not epoched yet, epoch it    
    elseif ~exist([pathtran subject '_recog_epoched_' triggercode '_' acronym '.set'], 'file')
    %elseif ~exist([pathtran subject '_recog_epoched_' triggercode '_' acronym '_SR.set'], 'file') % SR = script reject

        newsetname = [subject '_recog_epoched_' triggercode '_' acronym '.set']; % output file's new name
        %newsetname = [subject '_recog_tobeepoched_' triggercode '_' acronym '.set']; % output file's new name

        clear EEG ALLEEG

        % Start EEGLAB
        eeglab;

        % Load baselined dataset
        EEG = pop_loadset('filename',[subject '_recog_epoch_' triggercode '_bc.set'],'filepath',subjectfolder);
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
         ARfolder = ['/Volumes/verb/WLA Adult/WLA Verb Adult Participants (EEG Data)/' subject '/'];
         ARname = [ARfolder subject '_recog_' triggercode '_' acronym '_manrej.xlsx'];

            [manrej]=xlsread([ARname],1);
            masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym])=unique(cat(2,manrej,Flaggedtrials));
            clearvars manrej Flaggedtrials %clears the variables for the next subject

           % [masterrej] is now the thing you'd put in the second 
           % location of the pop_rejepoch command. This will also hold all
           % the rejected trials for each subject, which will be helpful for
           % calculating # trials rejected for your study etc

            EEG = pop_rejepoch( EEG,[ masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym])] ,0);
            EEG = eeg_checkset( EEG );

            % Save dataset futher processing 
            %newsetname = [subject '_recog_epoched_' triggercode '_' acronym '_SR2.set']; % output file's new name, SR = script reject
            EEG = pop_saveset( EEG, [subjectfolder newsetname]);
            
            % Record the number of epochs in the pre-created text file - I
            % can't get the numel(...) command to return the correct number
            % of total epochs rejected, so abandoning this whole function
            % for now
            fileID = fopen('/Volumes/verb/WLA Adult/WLA Verb Adult Participants (EEG Data)/NumberofEpochsRemoved.txt','a');
            fprintf(fileID, [subject '_recog_epoched_' triggercode '_' acronym ': ' masterrej.(['sub_' subject '_recog_epoched_' triggercode '_' acronym]) '\n' ] );
            fclose(fileID);
    end
end
