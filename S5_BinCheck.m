% Written by Ashlie Pankonin April 2023
% Operates on individual subject data
% This script checks the numbers of bins in each ERP file.

% This script and the data files you want to check should be located in a 
% directory that is included in Matlab's search path.

% Create a text file to collect output in
fileID = fopen('/Volumes/Life Support/WLA Adult/BinCheck.txt','w');
fprintf(fileID, 'Bin Check\n\n');

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/Life Support/WLA Adult/WLA Noun Adult Participants (EEG data)';

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
%'110719_1f_verb'
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
acronym_list = {'INMA', 'CNMA', 'IMA', 'CMA'}; 
numacronyms = length(acronym_list); %number of acroynyms in your set


% Loop through all subjects
numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};

    
    for b=1:numacronyms
        acronym = acronym_list{b};

        
    
        % Path to the folder containing the current subject's data
        subjectfolder  = [parentfolder '/' subject '/'];
    
        % Load ERP sets
        subjectsetname = [subject '_recog_31&32_' acronym '_ERPs_renamedbins_app_new.erp'];
        ERP = pop_loaderp ('filename', subjectsetname, 'filepath', subjectfolder,'overwrite','off','Warning','off','UpdateMainGui','on');

        % Create list of bin amounts
        tBins=[ERP.nbin]';


        % Record the bin amounts and provide status report
        fileID = fopen('/Volumes/Life Support/WLA Adult/BinCheck.txt','a');
   
        if tBins ~= 6
            fprintf(fileID,[ subject '_' acronym ' has ' mat2str(tBins) ' bins. This is not the right amount of bins!\n'] );
        else
        fprintf(fileID, [ subject '_' acronym ' has ' mat2str(tBins) ' bins. All good.\n' ] );
        fclose(fileID);
        end
    end
end

% Open text file and review contents
open '/Volumes/Life Support/WLA Adult/BinCheck.txt'