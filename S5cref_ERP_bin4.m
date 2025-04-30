%Written my Julie Schneider & Bambi DeLaRosa May 2016
%ERP make bin #4
WLArecog_paths;

%'062315_3m_10y_WLArecog' , '062315_4f_9y_WLArecog', '071615_2m_11y_WLArecog', '020316_1m_8y_WLArecog', '070916_2m_13y_WLArecog', '071216_1f_12y_WLArecog', '072216_1m_13y_WLArecog', '072816_1f_8y_WLArecog', '072816_2m_11y_WLArecog', '100416_1f_9y_WLArecog','070916_1f_9y_WLArecog' '063015_1m_8y_WLArecog' '070115_1m_9y_WLArecog', '070715_2m_11y_WLArecog', '062716_2f_10y_WLArecog', '062716_1m_8y_WLArecog', '111315_2m_11y_WLArecog', '110415_1m_9y_WLArecog', '110615_1m_13y_WLArecog', '071216_2M_11y_WLArecog' '070715_2m_11y_WLArecog','110415_1m_9y_WLArecog',
%'110615_1m_13y_WLArecog', '070916_2m_13y_WLArecog', '071216_1f_12y_WLArecog' THIS ONE '060418_1f_8y_WLArecog', 
%'082217_2m_9y_WLArecog'
subject_list = { '060418_1f_8y_WLArecog'}; 
numsubjects = length(subject_list);

%2:9 10:28 30:39 SSs for reepoching 5 18 51 58 63 26 2 8 11 15 36 40 86
for s=1:numsubjects %CHANGE TO SUBJECT(S) OF INTEREST
    
     subject = subject_list{s};
% get subject info, same name as subjects.m (function)
    original_dataset= [subject 'WLAall_ERPs.erp']
%[datafolder subject captype capchan capfile badcell] = WLArecog_subjects(s);

 % start EEGLAB
        eeglab; 
        
%load current dataset
ERP = pop_loaderp('filename', original_dataset, 'filepath', [pathdata 'WLArecog_child' filesep subject filesep]);

% make output directories for each subject and condition         
pathtran = [pathdata 'WLArecog_child' filesep subject filesep];
   if ~exist(pathtran, 'dir')
         mkdir(pathtran);
   end
       newsetname= [subject 'WLAall_ERPsBin4.erp']; %output file new name
     
       
        
ERP = pop_binoperator( ERP, {  'BIN4 = BIN1 + BIN2'});
[ALLEEG EEG] = eeg_store(ALLEEG,EEG,CURRENTSET)
eeglab redraw


%load channel information
% EEG= pop_chanedit(EEG, 'lookup', 'L:\CleaningEpoching\EEGfiles\Data\Neuroscan Caps\Synamps2 Quik-Cap64.dat'); %edit based on location of chanlocs file
% [ALLEEG EEG] = eeg_store(ALLEEG,EEG,CURRENTSET)
% eeglab redraw

ERP = pop_savemyerp(ERP, [pathtran newsetname]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

end

