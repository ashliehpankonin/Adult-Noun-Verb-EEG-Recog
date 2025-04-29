%Written by Cristy Sotomayor June 2020
%edited by Ashlie Pankonin August 2020
%run ica and save

 datafolder = '/Volumes/verb/WLA Verb Adult Participants (EEG data)/';% change file path
    captype = 1;
    capchan = 64;
%[list all the subject folders you want to loop through] 

subject_list = {'';}% change subjects
%completed subjects (WLfC & Recog):'020320_1f_verb', '021720_1f_verb', '022120_1f_verb', '022820_1f_verb'
%'030220_1f_verb','030220_2f_verb','030920_1f_verb','092619_1f_verb,','100319_1f_verb' 
%'100419_1f_verb','100519_1f_verb','101519_1f_verb','102419_1f_verb','102519_1f_verb'
%'102819_1f_verb','102919_1f_verb','110419_1f_verb','110719_1f_verb','110719_2f_verb'
%'110819_1f_verb','111219_1f_verb','111419_1f_verb','111519_1f_verb','111819_1f_verb',
%'111919_1f_verb','120919_1f_verb'
numsubjects = length(subject_list);

for s=1:numsubjects

    subject = subject_list{s};

    subjectfolder = [datafolder subject filesep subject '_recog_cleaned.set']; % this creates ICA file from the file with the name of the subject name and the extension in parentheses so change the extension to match what you want it use
    % get subject info, same name as subjects.m (function)
  %  [datafolder subject captype capchan capfile badcell] = WLAchild_subjects3;
   % subject
      dataset = [subject '_recog_cleaned.set']% this creates ICA file from the file with the name of the subject name and the extension in parentheses so change the extension to match what you want it use
    
    
% get subject info, same name as subjects.m (function)
%[datafolder subject captype capchan capfile badcell] = WLAchild_subjects(s);
%subject

%load current dataset
EEG=pop_loadset('filename', dataset, 'filepath', [datafolder subject filesep]);

% make output directories for each subject and condition         
pathtran = [datafolder filesep subject filesep];
   if ~exist(pathtran, 'dir')
         mkdir(pathtran);
   end
       newsetname= [subject '_recog_ICA.set']; %output file new name

        
EEG= pop_runica(EEG,'extended',1,'interupt', 'on');
[ALLEEG EEG] = eeg_store(ALLEEG,EEG,CURRENTSET)
eeglab redraw

%load channel information
EEG= pop_chanedit(EEG, 'lookup', '/Volumes/verb/Adult Word Learning Study Scripts/SynAmps2 Quik-Cap64.DAT'); %edit based on location of chanlocs file
[ALLEEG EEG] = eeg_store(ALLEEG,EEG,CURRENTSET)
eeglab redraw

EEG = pop_saveset( EEG, [pathtran newsetname]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

end

