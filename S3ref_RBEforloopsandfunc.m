% Written by Ashlie Pankonin March 2021 with help from Jacob Momsen 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script will rereference, baseline, and epoch files 

%   NOTES:

% 	1) This script should be located in a directory that is included in 
%   Matlab's search path.

% 	2) The script for the RerefBaselineandEpoch.m function should be
% 	also be stored in the same location/directory as this script.
	
% 	3) All of the _manrej.xlsx files should also be stored in the same 
%   location as the datasets (i.e., in their respective subject folders).

% This is just a cleaner version of RerefBaselineandEpochScriptwforloops.m
% that calls the RerefBaselineandEpoch function instead of having it all
% written out. The only reason I'm not using this script is because the
% list of rejected epochs are not stored in masterrej when I call the
% RerefBaselineandEpoch function and I can't get my workaround of
% numel(masterrej...) to return the correct number of total epochs
% rejected, so I'm going with the messier script for now (Ashlie 3/18/21)

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/verb/WLA Adult/WLA Verb Adult Participants (EEG Data)';

% List all the subject folders you want to loop through
subject_list = {'102419_1f_verb'};
% Refer to EEG Data Tracking Google Spreadsheet to determine which
% participant needs what (i.e., rereferencing, baselining, and/or epoching)

% Set up triggercode info
%triggercode = '32'; % '31' = M+, '32' = M-, '51' = New
% List all the trigger codes you wan to loop through
triggercode_list = {'31', '32', '51'};

% Set up acronym info
%acronym = 'CNMA'; % 'INMA', 'CNMA', 'IN', 'CN', 'IMA', 'CMA'
% List all the acronyms you wan to loop through
acronym_list = {'INMA', 'CNMA', 'IN', 'CN'};

numsubjects = length(subject_list);
for s=1:numsubjects
    subject = subject_list{s};
    
    numtriggercodes = length(triggercode_list);
    for a=1:numtriggercodes
        triggercode = triggercode_list{a};
        if a == 1 || a == 2
        %numacronyms = length(acronym_list);
            for b=1:2
                acronym = acronym_list{b};
                RerefBaselineandEpoch(subject, triggercode, acronym)
            end

        elseif a == 3
        %numacronyms = length(acronym_list);
            for b=3:4
                acronym = acronym_list{b};
                RerefBaselineandEpoch(subject, triggercode, acronym)
                
            end
        end
    end
end

% Open text file and review contents
open '/Volumes/verb/WLA Adult/WLA Verb Adult Participants (EEG Data)/NumberofEpochsRemoved.txt'
