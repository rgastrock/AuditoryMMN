% Auditory_MMN_erp.m
% Written by Raphael Gastrock, Feb. 23, 2023
% script to calculate MMN

%% Extract epochs
eeglab_path = 'F:\Documents\eeglab_current\eeglab2021.1';  % change to where your eeglabfolder is
erplab_path = 'F:\Documents\eeglab_current';  % change to where your erplabfolder is
set_path = 'F:\Documents\Science\AuditoryMMN\data\ana_1'; % where you want data files to be saved
data_path = 'F:\Documents\Science\AuditoryMMN\data'; % where you want to read data from

% % addpath to eeglab
addpath(eeglab_path);
addpath(erplab_path);
eeglab;
close all

cd(set_path);
filenames = dir('*.set'); %looks for all .set files. Will work if you only have 1 .set file for each participant
participants = 1; %change to 1:x where x is the total number of participants

for pp = 1:length(participants)
    %read in processed data then:
    EEG = pop_loadset(sprintf('erp_%d_prepro.set', pp)); 
    %then you have the regular and deviant conditions (consider 2 for now)
    conditions = {
        'deviant_high'
        'deviant_low'
        };
    %pick out events/triggers that match specific conditions
    %start with Inv1, dev, high, attended (1111)
    %and with Inv1, reg, high, attended (1211)
    triggers = {'1111' '1121'};
    for cond_idx = 1:length(conditions)
        data = pop_epoch(EEG, triggers(cond_idx), [-0.8 0.8]);
        data = pop_rmbase(data, [-200, 0]);
    
        %Save preprocessed
        fname = sprintf('erp_%d_%s.set', pp, conditions{cond_idx});
        pop_saveset(data, fname, set_path);
    
    end
end

%% Load and plot
%currently can only do it for 1 participant. But you'd want a grand average
%across participants once you have more, and that is what you'll plot
%below, according to conditions
cd(set_path)
close all
devh = pop_loadset('erp_1_deviant_high.set');
devl = pop_loadset('erp_1_deviant_low.set');

% Data format is channels x time points x trials
get_ERP = @(condition, channels) squeeze(mean(condition.data(channels, :, :), [1 3]));

% channels you want to plot - currently guessed electrode locations
chans = [1,4,5,6,9,11,13, 34, 39, 40, 41, 44, 46, 50]; % Fp1, F1, F3, F5, FC1, FC5, C3; Fp2, F2, F4, F6, FC2, FC6, C4

%% Plot
figure
dif_wav = get_ERP(devh, chans) - get_ERP(devl, chans);

plot(devh.times, get_ERP(devh, chans), 'b', 'LineWidth', 2)
hold on
plot(devh.times, get_ERP(devl, chans), 'r', 'LineWidth', 2)
hold on
plot(devh.times, dif_wav, 'k', 'LineWidth', 2)

xline(0)
xline(300)
yline(0)

legend('deviant_high', 'deviant_low', 'Difference')
legend('boxoff')
legend('Location', 'northwest')
set(gca,'FontSize', 13)
xlabel('Time(ms)')
ylabel('Mean Amplitude (μV)')