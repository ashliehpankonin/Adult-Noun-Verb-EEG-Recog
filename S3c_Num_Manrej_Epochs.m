% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

% Verb subjects that are all prepped:
%'120919_1f_verb','111519_1f_verb', '111819_1f_verb',
%'110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb',
%'030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb',
%'092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb',
%'100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb',
%'030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',
%'110719_1f_verb'(for 110719_1f_verb, only 31_INMA, 31_CNMA, 32_CNMA, and
%51_CN though because other combos only had one epoch and can't convert
%those into ERPs :c),'111919_1f_verb'(didn't prep again on 9/21/22 b/c has
%hand bias in recog task so not included in analyses anyway)
% Full set of verb subjects: 
% subject_list = {'120919_1f_verb','111519_1f_verb', '111819_1f_verb','110719_2f_verb','111419_1f_verb','111219_1f_verb', '101519_1f_verb','030920_1f_verb','102419_1f_verb','021720_1f_verb','020320_1f_verb','092619_1f_verb', '102519_1f_verb','110819_1f_verb','022120_1f_verb','100319_1f_verb', '102819_1f_verb', '022820_1f_verb','102919_1f_verb','030220_1f_verb', '100519_1f_verb', '110419_1f_verb','030220_2f_verb',}; 

% Noun subjects that are all prepped:
% '041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA',
% '042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA',
% '092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA',
% '100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA',
% '102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA',
% '110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA',
% '100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA',
% '111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'
% Full set of noun subjects: 
% subject_list = {'041015_1f_WLA','041315_1f_WLA','041715_1f_WLA','042015_1f_WLA','042015_2f_WLA','042715_1f_WLA','050115_1f_WLA','091715_1f_WLA','092415_1f_WLA','092415_2f_WLA','092515_1f_WLA','093015_1f_WLA','100115_2f_WLA','100215_1f_WLA','100915_2f_WLA','102315_2f_WLA','102915_2m_WLA','110415_1f_WLA','110515_1f_WLA','110915_1F_WLA','110915_2f_WLA','112015_1f_WLA','112015_2f_WLA','092515_2f_WLA','100915_1f_WLA','101415_1f_WLA','103015_2f_WLA','110615_1f_WLA','111215_1f_WLA','111915_1m_WLA','120415_1f_WLA'};

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};
    
    % Specify the directory containing Excel files
    directory = ['/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG Data)/' subject '/']; % Update with your directory path
    
    % Get a list of all Excel files in the directory
    file_list = dir(fullfile(directory, '*.xlsx'));
    
    % Check if file_list is empty
    if isempty(file_list)
        disp('No Excel files found in the specified directory.');
        return;
    end
    
    % Initialize vectors to store file names and corresponding numbers of cells with values
    file_names = strings(1, numel(file_list));
    num_cells_with_values = zeros(1, numel(file_list));
    
    % Loop through each Excel file
    for i = 1:numel(file_list)
        % Construct the full file path
        fullfile_path = fullfile(directory, file_list(i).name);
    
        % Read the Excel file
        [~, ~, raw] = xlsread(fullfile_path);
    
        % Calculate the number of cells with values
        num_cells_with_values(i) = sum(~cellfun(@isempty, raw(:)));
    
        % Store the file name
        file_names(i) = file_list(i).name;
    end
    
    % Display the file names and corresponding numbers of cells with values
    for i = 1:numel(file_list)
        fprintf('File name: %s, Number of cells with values: %d\n', file_names(i), num_cells_with_values(i));
    end
end
