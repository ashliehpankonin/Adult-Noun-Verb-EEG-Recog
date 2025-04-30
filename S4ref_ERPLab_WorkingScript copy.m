%% Run Data Processing without ICA on GPR Participants 
% Clear memory and the command window
clear
clc
 
% Initialize the ALLERP structure and CURRENTERP
ALLERP = buildERPstruct([]);
CURRENTERP = 0;
 
% This defines the set of subjects 
%'063015_1m_8y_WLArecog', '070916_1f_9y_WLArecog', '071216_2M_11y_WLArecog', '071615_2m_11y_WLArecog'
subject_list = {'070916_1f_9y_WLArecog'}; %'063015_1m_8y_WLArecog', '070115_1m_9y_WLArecog', '070715_2m_11y_WLArecog', '062716_2f_10y_WLArecog', '060418_1f_8y_WLArecog', '062716_1m_8y_WLArecog', '111315_2m_11y_WLArecog', '110415_1m_9y_WLArecog', '110615_1m_13y_WLArecog', '071216_2M_11y_WLArecog'};
    
%'062315_4f_9y_WLArecog', '071615_2m_11y_WLArecog', '020316_1m_8y_WLArecog','070916_2m_13y_WLArecog','071216_1f_12y_WLArecog', '072216_1m_13y_WLArecog', '072816_1f_8y_WLArecog', '072816_2m_11y_WLArecog', '100416_1f_9y_WLArecog', '082217_2m_9y_WLArecog'};
nsubj = length(subject_list); % number of subjects
 
% Path to the parent folder, which contains the data folders for all subjects
home_path  = '/Users/ashleygoussak/Desktop/DLDrecog Data/';
 
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
 data_path  = [home_path subject_list{s} '/'];
 
 % Check to make sure the dataset file exists
 % Initial filename = path plus Subject# plus _EEG.set
  sname = [data_path subject_list{s} '_WLA_tref.set'];  
    if exist(sname, 'file')<=0
        fprintf('\n *** WARNING: %s does not exist *** \n', sname);
            fprintf('\n *** Skip all processing for this subject *** \n\n');
    else
        %
        % Load original dataset
        %
        fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject_list{s});
        EEG = pop_loadset('filename', [subject_list{s} '_WLA_tref.set'], 'filepath', data_path); 
 
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
        EEG.setname = [EEG.setname '_WLAallnew_elist']; % name for the dataset menu
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
     
     %
     % High-pass filter the EEG
     % Channels = 1 to 32; High-pass cutoff at 0.1 Hz;
     % No lowpass filter; Order of the filter = 2.
     % Type of filter = "Butterworth"; Remove DC offset; Filter
     % "between" boundary events
     %
       fprintf('\n\n\n**** %s: High-pass filtering EEG at 0.1 Hz ****\n\n\n', subject_list{s});              
         EEG  = pop_basicfilter( EEG,  1:60 , 'Cutoff',  0.1, 'Design', 'butter', 'Filter', 'highpass', 'Order', 2, 'RemoveDC',  'on');
        %   
         EEG.setname = [EEG.setname '_hpfilt'];
         if (save_everything)
             EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);              
         end
        
     % Run Binlister GPR
      fprintf('\n\n\n**** %s: Running BinLister ****\n\n\n', subject_list{s});       
        EEG = pop_binlister( EEG , 'BDF', '/Users/ashleygoussak/Desktop/DLDrecog Data/Scripts (1)/Binlister.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
        EEG.setname = [EEG.setname 'WLAallnew_bins'];
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
     
     %
     % Extracts bin-based epochs (500 ms pre-stim, 1500 ms post-stim. Baseline correction by pre-stim window)
     % Then save with _be suffix
     %
        fprintf('\n\n\n**** %s: Bin-based epoching ****\n\n\n', subject_list{s});
        EEG = pop_epochbin( EEG , [-500.0  1000.0],  'pre');
        EEG.setname = [EEG.setname 'WLAallnew_be'];
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
     
     % Two rounds of artifact detection, then export eventlist just for fun
     % Save the processed EEG to disk because the next step will be averaging

     
      fprintf('\n\n\n**** %s: Averaging Good Trials****\n\n\n', subject_list{s});              
        ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
        ERP.erpname = [subject_list{s} '_WLAallnew_ERPs'];  % name for erpset menu
        pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', data_path, 'warning', 'off');
 
    end % end of the "if/else" statement that makes sure the file exists
       
end % end of looping through all subjects


fprintf('\n\n\n**** FINISHED with Data Processing without ICA GPR ****\n\n\n');