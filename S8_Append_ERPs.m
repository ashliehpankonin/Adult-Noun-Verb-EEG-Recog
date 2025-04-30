% Written by Ashlie Pankonin May 2022 
% Operates on individual subject data
% This script appends the specified individual subject averaged ERP
% waveforms into a single ERP set.

% Trigger code and acronym combinations:
% 31: INMA, CNMA 
% 32: INMA, CNMA 
% 51: IN, CN

close all; clearvars;

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

% Full set of verb subjects: 
%'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb',
%'110719_2f_verb','111419_1f_verb','111219_1f_verb','101519_1f_verb',
%'020320_1f_verb', '030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb',
%'100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb',
%'030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',
%'110719_1f_verb'
%subject_list = {'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Full set of noun subjects: 
%'120919_1f_verb','020320_1f_verb','111919_1f_verb','111519_1f_verb',
%'111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb',
%'101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb',
%'102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb',
%'102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb',
%'100519_1f_verb', '110419_1f_verb','030220_2f_verb','092619_1f_verb'
%subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};


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
    
    % start EEGLAB
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
     eeglab('redraw');
     disp ('eeglab redrawn');

    % clear ERPlab variables
    ALLERP = [];
    ERP = []; 
    CURRENTERP = 0;

    % Path to the folder containing the current subject's data
    subjectfolder  = [parentfolder '/' subject '/'];
    
     % Load ERP sets
    ERP = pop_loaderp ('filename', [subject '_recog_31&32_INMA&CNMA_ERPs_renamedbins_app_NMAbin.erp'], 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
    ERP = pop_loaderp ('filename', [subject '_recog_31&32_IMA&CMA_ERPs_renamedbins_app_MAbin.erp'], 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
    ERP = pop_loaderp ('filename', [subject '_recog_51_IN&CN_ERPs_renamedbins_app_Newbin.erp'], 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');

    ERP = pop_appenderp( ALLERP , 'Erpsets',  1:3 );
    ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_ERPs_app_NMA&MA&New'], 'filename',[subject '_recog_ERPs_app_NMA&MA&New.erp'], 'filepath', subjectfolder, 'Warning','off');


%     ERP = pop_loaderp ('filename', [subject '_recog_31&32_CNMA_ERPs_app_combobin_new.erp'], 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
%     ERP = pop_loaderp ('filename', [subject '_recog_31&32_INMA_ERPs_app_combobin_new.erp'], 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
%     ERP = pop_loaderp ('filename', [subject '_recog_51_CN_ERPs_app_renamedbin_new.erp'], 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
%     ERP = pop_loaderp ('filename', [subject '_recog_51_IN_ERPs_app_renamedbin_new.erp'], 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
% 
%     ERP = pop_appenderp( ALLERP , 'Erpsets',  1:4 );
%     ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_ERPs_app_new'], 'filename',[subject '_recog_ERPs_app_new.erp'], 'filepath', subjectfolder, 'Warning','off');
    
end %end of looping through all subjects
