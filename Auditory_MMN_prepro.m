% Auditory_MMN_prepro.m
% Written by Raphael Gastrock, Feb. 23, 2023
% script to preprocess data across participants


%% set up path
eeglab_path = 'F:\Documents\eeglab_current\eeglab2021.1';  % change to where your eeglabfolder is
set_path = 'F:\Documents\Science\AuditoryMMN\data\ana_1'; % where you want data files to be saved
data_path = 'F:\Documents\Science\AuditoryMMN\data'; % where you want to read data from

% % addpath to eeglab
addpath(eeglab_path);
eeglab;
close all

cd(data_path);
filenames = dir('*.set'); %looks for all .set files. Will work if you only have 1 .set file for each participant
participants = 1:5; %change to 1:x where x is the total number of participants

for pp = 1:length(participants)
    
    % Import data (change filenames idx to change file)
    EEG = pop_loadset(sprintf('erp_%d.set', pp)); 
    % run functions in your history file here, line by line
    %hard for me to know the parameters you want for every function
    [EEG, eventnumbers] = pop_importevent(EEG);
    %pop_continuousartdet
    %save as new set
    %pop_runica
    %etc

    %end would be to save a .set file that the other script will use to
    %calculate erps

end

