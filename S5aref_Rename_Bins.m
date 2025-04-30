% Written by Ashlie Pankonin May 2022
% Operates on individual subject data
% This script renames the bins in the 51 individual subject averaged ERP
% waveforms so that it's possible to differentiate between the waveforms
% that come from 51 IN and 51 CN.

close all; clearvars;

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'022120_1f_verb'};

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
%subject_list = {'120919_1f_verb','111919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

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


% List all the acronyms you wan to loop through (i.e., define your set of acronyms)
% Full set of acronyms: 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
acronym_list = {'IN', 'CN'}; 


numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};    
    % start EEGLAB
    eeglab;

    for b=1 
        acronym = acronym_list{b};
        % Path to the folder containing the current subject's data
        subjectfolder  = [parentfolder '/' subject '/'];
            
        % Load ERP sets
        subjectsetname = [subject '_recog_51_' acronym '_ERPs_new.erp'];
        ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
        ERP = pop_binoperator( ERP, {  'nbin1 = b1 label Mp',  'nbin2 = b2 label Mm',  'nbin3 = b3 label New IN'});
        ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_51_' acronym '_ERPs_app_renamedbin_new'], 'filename',[subject '_recog_51_' acronym '_ERPs_app_renamedbin_new.erp'], 'filepath', subjectfolder, 'warning','off');
    end

    for b=2 
        acronym = acronym_list{b};
        % Path to the folder containing the current subject's data
        subjectfolder  = [parentfolder '/' subject '/'];
            
        % Load ERP sets
        subjectsetname = [subject '_recog_51_' acronym '_ERPs_new.erp'];
        ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');
        ERP = pop_binoperator( ERP, {  'nbin1 = b1 label Mp',  'nbin2 = b2 label Mm',  'nbin3 = b3 label New CN'});
        ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_51_' acronym '_ERPs_app_renamedbin_new'], 'filename',[subject '_recog_51_' acronym '_ERPs_app_renamedbin_new.erp'], 'filepath', subjectfolder, 'warning','off');
    end

end
