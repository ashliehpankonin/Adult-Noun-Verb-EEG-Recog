%% Run Data Processing without ICA on GPR Participants 
% Clear memory and the command window
clear
clc
 
% Initialize the ALLERP structure and CURRENTERP
ALLERP = buildERPstruct([]);
CURRENTERP = 0;
 
% This defines the set of subjects 

subject_list = {'070916_1f_9y_WLArecog'};
%{'071615_2m_11y_WLA', '071216_1f_12y_WLA', '072816_1f_8y_WLA'};
%{'062716_2f_10y_WLA', '062716_1m_8y_WLA', '111315_2m_11y_WLA', '110415_1m_9y_WLA', '110615_1m_13y_WLA', '071216_2M_11y_WLA', '063015_1m_8y_WLA', '070115_1m_9y_WLA', '070715_2m_11y_WLA'};
%{'070115_1m_9y_WLA'}; '060418_1f_8y_WLA''062315_3m_10y_WLA' , '062315_4f_9y_WLA', '071615_2m_11y_WLA', '020316_1m_8y_WLA', '070916_2m_13y_WLA', '072216_1m_13y_WLA', '072816_1f_8y_WLA', '072816_2m_11y_WLA', '100416_1f_9y_WLA', '082217_1f_13y_WLA', '082217_2m_9y_WLA'};
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
  sname = [data_path subject_list{s} '_tref.set'];  
    if exist(sname, 'file')<=0
        fprintf('\n *** WARNING: %s does not exist *** \n', sname);
            fprintf('\n *** Skip all processing for this subject *** \n\n');
    else
        %
        % Load original dataset
        %
        fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject_list{s});
        EEG = pop_loadset('filename', [subject_list{s} '_tref.set'], 'filepath', data_path); 
 
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
        EEG.setname = [EEG.setname '_all_elist']; % name for the dataset menu
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
         EEG  = pop_basicfilter( EEG,  1:32 , 'Cutoff',  0.1, 'Design', 'butter', 'Filter', 'highpass', 'Order',  2, 'RemoveDC', 'on');
         EEG.setname = [EEG.setname '_hpfilt'];
         if (save_everything)
             EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);              
         end
        
     % Run Binlister GPR
      fprintf('\n\n\n**** %s: Running BinLister ****\n\n\n', subject_list{s});       
        EEG = pop_binlister( EEG , 'BDF', 'L:\EEGfiles\Data\Matlab Scripts\WLArecog_child\Binlister.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
        EEG.setname = [EEG.setname 'all_bins'];
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
     
     %
     % Extracts bin-based epochs (500 ms pre-stim, 1500 ms post-stim. Baseline correction by pre-stim window)
     % Then save with _be suffix
     %
        fprintf('\n\n\n**** %s: Bin-based epoching ****\n\n\n', subject_list{s});
        EEG = pop_epochbin( EEG , [-200.0  1000.0],  'pre');
        EEG.setname = [EEG.setname '_all_be'];
        if (save_everything)
            EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
        end
     
     % Two rounds of artifact detection, then export eventlist just for fun
     % Save the processed EEG to disk because the next step will be averaging

     
     
        fprintf('\n\n\n**** %s: Artifact detection (extreme voltage) ****\n\n\n', subject_list{s});              

       % Two rounds of artifact detection, then export eventlist just for fun

        % Save the processed EEG to disk because the next step will be averaging

        fprintf('\n\n\n**** %s: Artifact detection (moving window peak-to-peak and step function) ****\n\n\n', subject_list{s});              
 
    
       EEG  = pop_artextval( EEG , 'Channel',  1:60, 'Flag',  1, 'Threshold', [ -75 75], 'Twindow', [ -200 1000] );       
     % Artifact detection. Moving window. Test window = [-100 1398];
      %Threshold = 100 uV; Window width = 200 ms;
      %Window step = 50 ms; Channels = 1 to 32; Flags to be activated = 1 & 4
     

        EEG = pop_artmwppth( EEG , 'Channel',  1:60, 'Flag', [ 1 4], 'Threshold',  100, 'Twindow', [ -200 1000], 'Windowsize',  200, 'Windowstep',  50 );   
        
     
   %   Artifact detection. Step-like artifacts in the bipolar
    %  HE channel (channel 2, created earlier with Channel Operations)
     % Threshold = 20 uV; Window width = 400 ms;
      % Window step = 10 ms; Flags to be activated = 1 & 3
        
        EEG  = pop_artstep( EEG , 'Channel',  2, 'Flag',  [1 3], 'Threshold',  20, 'Twindow', [ -200 1000], 'Windowsize',  400, 'Windowstep',  10 );
         EEG.setname = [EEG.setname '_ar'];
         EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', data_path);
         EEG = pop_exporteegeventlist(EEG, [data_path subject_list{s} '_eventlist_ar.txt']); 
        
     % Report percentage of rejected trials (collapsed across all bins)
        
         artifact_proportion = getardetection(EEG);
         fprintf('%s: Percentage of rejected trials was %1.2f\n', subject_list{s}, artifact_proportion);

     %
     % Averaging. Only good trials.  Include standard deviation.  Save to disk.
     %
        fprintf('\n\n\n**** %s: Averaging Good Trials****\n\n\n', subject_list{s});              
        ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
        ERP.erpname = [subject_list{s} '_all_ERPs'];  % name for erpset menu
        pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', data_path, 'warning', 'off');
    
     % Now make the difference waves and naming file _newb, directly specifying the
     % equation that modifies the existing ERPset
%         fprintf('\n\n\n**** %s: Adding new bins ****\n\n\n', subject_list{s}); 
%         ERP = pop_binoperator( ERP, {'b81 = b5-b11 label Diff Offset AmbNP T5-T3','b82 = b6-b12 label Diff Offset AmbNP T6-T4','b83 = b29-b27 label Diff V2 T5-T3','b84 = b30-b28 label Diff V2 T6-T4','b85 = b17-b15 label Onset AmbNP T5-T3','b86 = b18-b16 label Onset AmbNP T6-T4','b87 = b55-b53 label Diff 1 word post V2 T5-T3','b88 = b56-b54 label Diff 1 word post V2 T6-T4','b89 = b73-b71 label Diff Lastword T5-T3','b90 = b74-b72 label Diff Lastword T6-T4'});
%         ERP.erpname = [ERP.erpname '_newb'];  % name for erpset menu
%         if (save_everything)
%             pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', data_path, 'warning', 'off');
%         end
        
     %
     % Filtering ERP. Channels = 1 to 32; No high-pass;
     % Lowpass cutoff at 30 Hz; Order of the filter = 2.
     % Type of filter = "Butterworth"; Do not remove DC offset
     %
%         fprintf('\n\n\n**** %s: Low-pass filtering ERP at 30 Hz ****\n\n\n', subject_list{s});             
%         ERP = pop_filterp( ERP,1:32 , 'Cutoff',30, 'Design', 'butter', 'Filter', 'lowpass', 'Order',2 );
%         ERP.erpname = [ERP.erpname '_lp30Hz'];  % name for erpset menu
%         if (save_everything)
%             pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', data_path, 'warning', 'off');
%         end
     
     %
     % Rebaseline -50 to 50ms
     %
%         fprintf('\n\n\n**** %s: Adding -50 to 50 Baseline ****\n\n\n', subject_list{s});             
%         
%         ERP = pop_blcerp( ERP , 'Baseline', [ -50 50], 'Saveas', 'off' );
%         ERP.erpname = [ERP.erpname '_50b'];  % name for erpset menu
%         if (save_everything)
%             pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', data_path, 'warning', 'off');
%         end
        
        
     %
     % Low Pass 5Hz filter from unfiltered data
     % Do this on the unfiltered data, so first reload unfiltered file
     % Then do a second round of bin operations and save with _plus suffix
     %
%         fprintf('\n\n\n**** %s: Filtering 5 Hz ****\n\n\n', subject_list{s});              
%         fname = [subject_list{s} '_ERPs_newb.erp'];  % Re-create filename for unfiltered ERP
%         ERP = pop_loaderp( 'filename', fname, 'filepath', data_path );   % Load the file  
%      % Now low pass filtering at 5 Hz
%      % equation that modifies the existing ERPset
%         ERP = pop_filterp( ERP,1:32 , 'Cutoff',5, 'Design', 'butter', 'Filter', 'lowpass', 'Order',2 );
%         ERP.erpname = [ERP.erpname '_lp5Hz'];  % name for erpset menu
%         pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', data_path, 'warning', 'off');
 
    end % end of the "if/else" statement that makes sure the file exists
       
end % end of looping through all subjects


fprintf('\n\n\n**** FINISHED with Data Processing without ICA GPR ****\n\n\n');