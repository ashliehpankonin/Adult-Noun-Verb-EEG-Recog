% Written by Ashlie Pankonin April 2021

% This script is simply the "for" loop set-up necessary for obtaining the
% following combinations of trigger codes and acronyms with the adult word
% recognition (see "Epoching Guide (Verbs & Nouns)" spreadsheet for more 
% information about the meaning of these trigger codes and acronyms):
% 31: INMA, CNMA, IMA, CMA 
% 32: INMA, CNMA, IMA, CMA 
% 51: IN, CN

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/verb/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'120919_1f_verb'};%,'020320_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb','101519_1f_verb','020320_1f_verb', '030920_1f_verb','102419_1f_verb','021720_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb'}; 
% Full set of subjects: 
%'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb',
%'110719_2f_verb','111419_1f_verb','111219_1f_verb','101519_1f_verb',
%'020320_1f_verb', '030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb',
%'100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb',
%'030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',

%'110719_1f_verb'

% List all the trigger codes you wan to loop through (i.e., define your set of trigger codes)
% Triggercode info (full set of trigger codes): '31' = M+, '32' = M-, '51' = New
triggercode_list = {'31', '32', '51'};
numtriggercodes = length(triggercode_list); %number of trigger codes in your set

% List all the acronyms you wan to loop through (i.e., define your set of acronyms)
% Full set of acronyms: 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
acronym_list = {'INMA', 'CNMA', 'IN', 'CN'}; 
numacronyms = length(acronym_list); %number of acroynyms in your set

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};
    
    numtriggercodes = length(triggercode_list);
    for a=1:numtriggercodes
        triggercode = triggercode_list{a};
        if a == 1 || a == 2
            for b=1:2
                acronym = acronym_list{b};
                
            %for b=1:numacronyms
            %acronym = acronym_list{b};
            
            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
            
            end %end of looping through acronyms INMA and CNMA
        elseif a == 3
            for b=3:4
                acronym = acronym_list{b};
                
                % Path to the folder containing the current subject's data
                subjectfolder  = [parentfolder '/' subject '/'];
            
                % Load ERP sets
                subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs.erp'];
                ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
            end %end of looping through acronyms IN and CN
        end %end "if/else" statement for selecting trigger codes
    end %end of looping through trigger codes
end %end of looping through all subjects
