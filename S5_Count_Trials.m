% Written by ChatGPT and Ashlie Pankonin Jan 2025
% Operates on individual subject data
% This script counts the number of trials in each bin in each ERP file.

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Full set of verb subjects: 
% subject_list = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Full set of noun subjects: 
% subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

% List all the trigger codes you wan to loop through (i.e., define your set of trigger codes)
% Triggercode info (full set of trigger codes): '31' = M+, '32' = M-, '51' = New
triggercode_list = {'51'};
numtriggercodes = length(triggercode_list); %number of trigger codes in your set

% List all the acronyms you wan to loop through (i.e., define your set of acronyms)
% Full set of acronyms: 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
acronym_list = {'CN'}; 
numacronyms = length(acronym_list); %number of acroynyms in your set

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Initialize storage for results
data = {};
data{1,1} = 'Participant';
data{1,2} = 'Filename';
bin_labels = {}; % To store bin names dynamically

% Start processing each subject
row_idx = 2; % Row index for data storage
for s = 1:length(subject_list)
    participant_id = subject_list{s}; % Get current subject ID
    participant_path = fullfile(parentfolder, participant_id); % Construct full path to participant folder

      % Loop through each trigger code and acronym
    for t = 1:numtriggercodes
        triggercode = triggercode_list{t}; % Current trigger code
        for a = 1:numacronyms
            acronym = acronym_list{a}; % Current acronym

            % Construct filename pattern based on the naming convention
            filename_pattern = sprintf('%s_recog_%s_%s_ERPs_renamedbins_new.erp', participant_id, triggercode, acronym);

            % Get the ERP file matching the pattern
            erp_files = dir(fullfile(participant_path, filename_pattern));

            % If ERP file exists, load and process
            if ~isempty(erp_files)
                erpfile = fullfile(participant_path, erp_files.name);
                ERP = pop_loaderp('filename', erp_files.name, 'filepath', participant_path);

                % Extract trial counts per bin
                bin_counts = [ERP.ntrials.accepted]; % Number of accepted trials per bin

                % Store bin labels (only on first encounter)
                if isempty(bin_labels)
                    for j = 1:length(bin_counts)
                        bin_labels{1, j} = sprintf('Bin %d', j);
                    end
                    data(1, 3:(length(bin_labels)+2)) = bin_labels; % Set column headers
                end

                % Store subject data
                data{row_idx, 1} = participant_id; % Subject ID
                data{row_idx, 2} = erp_files.name; % ERP file name
                data(row_idx, 3:(length(bin_counts)+2)) = num2cell(bin_counts); % Bin counts

                row_idx = row_idx + 1; % Move to next row
            end
        end
    end
end

% Convert to table and write to CSV
output_file = fullfile(parentfolder, 'ERP_BinCounts.csv');
T = cell2table(data(2:end, :), 'VariableNames', data(1, :));
writetable(T, output_file);

fprintf('Spreadsheet saved as: %s\n', output_file);