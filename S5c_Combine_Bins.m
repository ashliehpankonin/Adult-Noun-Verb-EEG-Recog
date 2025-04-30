% Written by Ashlie Pankonin May 2022 and revised May 2023
% Operates on individual subject data
% This script creates a new bin of the non-flatlined ERP waveforms to
% account for combining the 31 and 32 individual subject averaged ERP
% waveforms into a single ERP set.

close all; clearvars;

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Noun  Adult Participants (EEG data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

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
acronym_list = {'INMA', 'CNMA','IMA', 'CMA'}; 

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};    
    % start EEGLAB
    eeglab;

    for b=1:size(acronym_list, 2) 
        acronym = acronym_list{b};
        % Path to the folder containing the current subject's data
        subjectfolder  = [parentfolder '/' subject '/'];
            
        % Load ERP sets
        subjectsetname = [subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new.erp'];
        ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder);

        % Check which bins are not flatlined and should be combined
        non_flatlined_bins = [];

        % Extract the digits from the warning message using regular expressions
        warning_regex = '\d+';
        flatlined_bins = regexp(extractAfter(evalc('ERP = pop_loaderp (''filename'', subjectsetname, ''filepath'', subjectfolder);'), 'WARNING'), warning_regex, 'match');
          
        % Ensure the digits are numbers, not strings
        flatlined_bins = cellfun(@(x) str2double(x), flatlined_bins);
         display(flatlined_bins)

        % Find and save the non-flatlined bins in an array
        for bin = 1:size(ERP.bindescr, 2)
            if ~ismember(bin, flatlined_bins) 
            non_flatlined_bins = [non_flatlined_bins bin];
            end
        end %end of looping through bins

        % Convert non-flatlined bins array into comma-separated string
        non_flatlined_bins = strjoin(cellstr(num2str(non_flatlined_bins')),',');
        display(non_flatlined_bins)
        
        % Create a new weighted average bin from the non-flatlined bins using pop_binoperator()
        ERP = pop_binoperator( ERP, {['b7 = wavgbin(' non_flatlined_bins ') label Old ' acronym]});
       
        % Save the ERP with the new weighted average bin from the non-flatlined bins
        ERP = pop_savemyerp(ERP, 'erpname', [subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_combobin_new'], 'filename',[subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_combobin_new.erp'], 'filepath', subjectfolder, 'warning','off');
    
    end %end of looping through acronyms
end %end of looping through subjects