% Auditory_MMN_prepro.m
% Written by Raphael Gastrock, Feb. 23, 2023
% script to preprocess data across participants


%% set up path
eeglab_path = 'F:\Documents\eeglab_current\eeglab2021.1';  % change to where your eeglabfolder is
erplab_path = 'F:\Documents\eeglab_current';  % change to where your erplabfolder is
set_path = 'F:\Documents\Science\AuditoryMMN\data\ana_1'; % where you want data files to be saved
data_path = 'F:\Documents\Science\AuditoryMMN\data'; % where you want to read data from

% % addpath to eeglab
addpath(eeglab_path);
addpath(erplab_path);
eeglab;
close all

cd(data_path);
filenames = dir('*.set'); %looks for all .set files. Will work if you only have 1 .set file for each participant
participants = 1; %change to 1:x where x is the total number of participants

for pp = 1:length(participants)
    
    % Import data (change filenames idx to change file)
    EEG = pop_loadset(sprintf('erp_%d.set', pp)); 
    % need to change the parameters for each function, depending on your
    % needs
    [EEG, eventnums] = pop_importevent(EEG, 'append','no','event','eventsfeb21.txt','fields',{'number','type','latency','duration'},'skipline',1,'timeunit',0.0039062,'align',0);
    % car seems to be an erplab extension
    %EEG = pop_continuousartdet(EEG , 'ampth',  500, 'chanArray',  1:64, 'colorseg', [ 1 0.9765 0.5294], 'forder',  100, 'numChanThreshold',  1, 'stepms',  50, 'threshType', 'peak-to-peak', 'winms',  2000 );
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
    EEG = pop_iclabel(EEG, 'default');
    EEG = pop_icflag(EEG, [0 0;0.9 1;0.9 1;0.9 1;0.9 1;0.9 1;0 0]);
    EEG = pop_subcomp( EEG, [], 0);
    %end would be to save a .set file that the other script will use to
    %calculate erps
    fname = sprintf('erp_%d_prepro.set', pp);
    pop_saveset(EEG, fname, set_path);

end

