%% Run Data Processing without ICA on GPR Participants 
% Clear memory and the command window
clear
clc
 
% Initialize the ALLERP structure and CURRENTERP
ALLERP = buildERPstruct([]);
CURRENTERP = 0;
 
% This defines the set of subjects 
subject_list = {'070518_1f_10y_WLNSF'};% change subjects
nsubj = length(subject_list); % number of subjects
 
% Path to the parent folder, which contains the data folders for all subjects
home_path  = 'D:\CleaningEpoching\EEGfiles\Data\Bilingual Sentence Processing\Bilingual Project\';% change file path
 
% Set the save_everything variable to 1 to save all of the intermediate files to the hard drive
% Set to 0 to save only the initial and final dataset and ERPset for each subject
save_everything  = 1;
 
% Set the plot_PDFs variable to 1 to create PDF files with the waveforms
% for each subject (set to 0 if you don't want to create the PDF files).
plot_PDFs = 0;
 
% Loop through all subjects
for s=1:nsubj

 fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{s});
 % Path to the folder containing the current subject's data
 data_path  = [home_path subject_list{s} '\'];
 
 % Check to make sure the dataset file exists
 % Initial filename = path plus Subject# plus _EEG.set
  sname = [data_path subject_list{s} '_cont.set'];% this creates ERPs from the file with the name of the subject name and the extension in parentheses so change the extension to match what you want it use
    if exist(sname, 'file')<=0
        fprintf('\n *** WARNING: %s does not exist *** \n', sname);
            fprintf('\n *** Skip all processing for this subject *** \n\n');
    else
        %
        % Load original dataset
        %
        fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject_list{s});
        EEG = pop_loadset('filename', [subject_list{s} '_cont.set'], 'filepath', data_path); % change extension 
 
     % Add the channel locations
        %
%         fprintf('\n\n\n**** %s: Adding channel location info ****\n\n\n', subject_list{s});
%         EEG = pop_chanedit(EEG, 'load',{'/Applications/MATLAB/eeglab13_5_4b/GPA Study/Channel_locs_NCL_32.ced' 'filetype' 'autodetect'});
%         EEG.setname = [subject_list{s} '_Chan']; % name for the dataset menu
%         if (save_everything)
%             EEG = pop_saveset(EEG, 'filename', [EEG.setname '_chan.set'], 'filepath', data_path);
%         end
%         
     
     % Create Event List
      fprintf('\n\n\n**** %s: Creating eventlist ****\n\n\n', subject_list{s});
        EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
        EEG.setname = [EEG.setname '_elist']; % name for the dataset menu
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
     

        
     % Run Binlister GPR
      fprintf('\n\n\n**** %s: Running BinLister ****\n\n\n', subject_list{s});       
        EEG = pop_binlister( EEG , 'BDF', 'D:\CleaningEpoching\EEGfiles\Matlab Scripts\WLAchild_preprocessing\WLA_binlist1.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
        EEG.setname = [EEG.setname '_bins'];
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
     
     %
     % Extracts bin-based epochs (500 ms pre-stim, 1500 ms post-stim. Baseline correction by pre-stim window)
     % Then save with _be suffix
     %
        fprintf('\n\n\n**** %s: Bin-based epoching ****\n\n\n', subject_list{s});
        EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre');
        EEG.setname = [EEG.setname '_be'];
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
      
     % Averaging. Only good trials.  Include standard deviation.  Save to disk.
     %
        fprintf('\n\n\n**** %s: Averaging Good Trials****\n\n\n', subject_list{s});              
        ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
        ERP.erpname = [subject_list{s} '_ERPs'];  % name for erpset menu
        pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', data_path, 'warning', 'off');
    
  
    end % end of the "if/else" statement that makes sure the file exists
       
end % end of looping through all subjects


fprintf('\n\n\n**** FINISHED with Data Processing without ICA GPR ****\n\n\n');