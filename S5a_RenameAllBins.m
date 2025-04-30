% Written by Ashlie Pankonin April 2023
% Operates on individual subject data
% This script renames the bins in the individual subject averaged ERP
% waveforms so that it's possible to differentiate between the waveforms
% that come from each trigger code and acronym combination.

close all; clearvars;

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'111919_1f_verb'};

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
triggercode_list = {'31', '32', '51'};
numtriggercodes = length(triggercode_list); %number of trigger codes in your set

% List all the acronyms you wan to loop through (i.e., define your set of acronyms)
% Full set of acronyms: 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
acronym_list = {'INMA', 'CNMA','IMA', 'CMA','IN', 'CN'}; 

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};    
    % start EEGLAB
    eeglab;
    
    for b=1:4
        acronym = acronym_list{b};
        for a=1:2
            triggercode = triggercode_list{a};
                
            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_new.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder, 'overwrite','off','Warning','off','UpdateMainGui','on');

            
            ERP = pop_binoperator( ERP, {['nbin1 = b1 label Mp - ' triggercode ' ' acronym],  ['nbin2 = b2 label Mm - ' triggercode ' ' acronym],  ['nbin3 = b3 label N - ' triggercode ' ' acronym]});
            ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new'], 'filename',[subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'], 'filepath', subjectfolder, 'warning','off');
        end
    end

    for b=5:6
        acronym = acronym_list{b};
        for a=3
            triggercode = triggercode_list{a};
                
            % Path to the folder containing the current subject's data
            subjectfolder  = [parentfolder '/' subject '/'];
            
            % Load ERP sets
            subjectsetname = [subject '_recog_' triggercode '_' acronym '_ERPs_new.erp'];
            ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder, 'overwrite','off','Warning','off','UpdateMainGui','on');

            
            ERP = pop_binoperator( ERP, {['nbin1 = b1 label Mp - ' triggercode ' ' acronym],  ['nbin2 = b2 label Mm - ' triggercode ' ' acronym],  ['nbin3 = b3 label N - ' triggercode ' ' acronym]});
            ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new'], 'filename',[subject '_recog_' triggercode '_' acronym '_ERPs_renamedbins_new.erp'], 'filepath', subjectfolder, 'warning','off');            
        end
    end

end
