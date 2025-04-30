% Written by Ashlie Pankonin April 2021
% Operates on individual subject data
% This script appends all of the individual subject averaged ERP waveforms
% created for each trigger code and acronym combination into a single ERP
% set.

% Trigger code and acronym combinations:
% 31: INMA, CNMA, IMA, CMA
% 32: INMA, CNMA, IMA, CMA
% 51: IN, CN

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Full set of verb subjects: 
%'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb',
%'110719_2f_verb','111419_1f_verb','111219_1f_verb','101519_1f_verb',
%'020320_1f_verb', '030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb',
%'100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb',
%'030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',

%'110719_1f_verb'

% subject_list = {'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 


% Set of noun subjects: 
% '041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA',
% '042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA',
% '092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA',
% '100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA',
% '102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA',
% '110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA',
% '100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA',
% '111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'

% subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA', '100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA', '111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'}; 


% Verb subjects appended: all appended 5/31/21 and again 9/23/22
% (after more cleaning, changing refs)
%'120919_1f_verb','020320_1f_verb','111919_1f_verb','111519_1f_verb',
%'111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb',
%'101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb',
%'102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb',
%'100519_1f_verb', '110419_1f_verb','030220_2f_verb','092619_1f_verb'

% Noun subjects appended: all appended 2nd time on 9/23/22 (after changing
% refs)


% List all the trigger codes you wan to loop through (i.e., define your set of trigger codes)
% Triggercode info (full set of trigger codes): '31' = M+, '32' = M-, '51' = New
triggercode_list = {'31', '51'};
numtriggercodes = length(triggercode_list); %number of trigger codes in your set

% List all the acronyms you wan to loop through (i.e., define your set of acronyms)
% Full set of acronyms: 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
acronym_list = {'INMA', 'CNMA', 'IMA','IN'}; 
numacronyms = length(acronym_list); %number of acroynyms in your set

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};
    
    % start EEGLAB
    eeglab;
    
    numtriggercodes = length(triggercode_list);
    for a=1:numtriggercodes
        triggercode = triggercode_list{a};
        if a == 1 %|| a == 2
            for b=1:3
                acronym = acronym_list{b};
                
            %for b=1:numacronyms
            %acronym = acronym_list{b};
            
            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
            
            end %end of looping through acronyms INMA and CNMA
        elseif a == 2
            for b=4
                acronym = acronym_list{b};
                
                % Path to the folder containing the current subject's data
                subjectfolder  = [parentfolder '/' subject '/'];
            
                % Load ERP sets
                subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'];
                ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
            end %end of looping through acronyms IN and CN
        end %end "if/else" statement for selecting trigger codes
    end %end of looping through trigger codes
    ERP = pop_appenderp( ALLERP , 'Erpsets',  1:4 );
    ERP = pop_savemyerp(ERP, 'erpname', [subject '_reocog_ERPs_app_31INMA&31CNMA&31IMA&51IN'], 'filename',[subject '_recog_ERPs_app_31INMA&31CNMA&31IMA&51IN.erp'], 'filepath', subjectfolder, 'Warning','on');
    %ALLERP = pop_deleterpset( ALLERP , 'Erpsets',  7, 'Saveas', 'on' );
    
end %end of looping through all subjects
