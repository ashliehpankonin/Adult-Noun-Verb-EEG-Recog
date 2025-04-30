% Written by Ashlie Pankonin May 2022
% Operates on individual subject data
% This script appends the individual subject averaged ERP waveforms of the
% 31 and 32 trigger code and acronym combinations into a single ERP sets. 

% Trigger code and acronym combinations:
% 31: INMA, CNMA, IMA, CMA
% 32: INMA, CNMA, IMA, CMA
% 51: IN, CN

close all; clearvars;

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb'}; 

% Full set of subjects:
% Verb subjects:
%'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb',
%'110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb',
%'030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb',
%'100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb',
%'030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',
%'110719_1f_verb'(for 110719_1f_verb, only 31_INMA, 31_CNMA, 32_CNMA, and
%51_CN though because other combos only had one epoch and can't convert
%those into ERPs :c)
%subject_list = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb','111919_1f_verb'}; 

% Noun subjects:
% '041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA',
% '042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA',
% '092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA',
% '100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA',
% '102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA',
% '110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA',
% '100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA',
% '111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'
%subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};


% List all the trigger codes you wan to loop through (i.e., define your set of trigger codes)
% Triggercode info (full set of trigger codes): '31' = M+, '32' = M-, '51' = New
triggercode_list = {'31', '32'};
numtriggercodes = length(triggercode_list); %number of trigger codes in your set

% List all the acronyms you wan to loop through (i.e., define your set of acronyms)
% Full set of acronyms: 'INMA', 'CNMA', 'IMA', 'CMA', 'IN', 'CN'
acronym_list = {'INMA', 'CNMA', 'IMA', 'CMA'}; 

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};    
    
    % start EEGLAB
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
     eeglab('redraw');
     disp ('eeglab redrawn');

    % clear ERPlab variables
    ALLERP = [];
    ERP = []; 
    CURRENTERP = 0;

    for b=1 
        acronym = acronym_list{b};
        for a=1:2
            triggercode = triggercode_list{a};
                
            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
                
        end %end of looping through trigger codes
        ERP = pop_appenderp( ALLERP , 'Erpsets',  1:2 );
        ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new'], 'filename',[subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new.erp'], 'filepath', subjectfolder, 'Warning','off');
    end %end of looping through acronym INMA

    for b=2 
        acronym = acronym_list{b};
        for a=1:2
            triggercode = triggercode_list{a};

            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
                
        end %end of looping through trigger codes
        ERP = pop_appenderp( ALLERP , 'Erpsets',  3:4 );
        ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new'], 'filename',[subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new.erp'], 'filepath', subjectfolder, 'Warning','off');
    end %end of looping through acronym CNMA

    for b=3 
        acronym = acronym_list{b};
        for a=1:2
            triggercode = triggercode_list{a};

            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
                
        end %end of looping through trigger codes
        ERP = pop_appenderp( ALLERP , 'Erpsets',  5:6 );
        ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_31&32_' acronym '_ERPs_renamedbins_new_app'], 'filename',[subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new.erp'], 'filepath', subjectfolder, 'warning','off');
    end %end of looping through acronym IMA

    for b=4 
        acronym = acronym_list{b};
        for a=1:2
            triggercode = triggercode_list{a};

            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
                
        end %end of looping through trigger codes
        ERP = pop_appenderp( ALLERP , 'Erpsets',  7:8 );
        ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_31&32_' acronym '_ERPs_renamedbins_new_app'], 'filename',[subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new.erp'], 'filepath', subjectfolder, 'warning','off');    
    end %end of looping through acronym CMA

end %end of looping through all subjects