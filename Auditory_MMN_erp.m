% Auditory_MMN_erp.m
% Written by Raphael Gastrock, Feb. 23, 2023
% script to calculate MMN

%% Extract epochs

%read in processed data then:

conditions = {
    'standard'
    'oddball'
    };
triggers = {'16140' '16141'};
for cond_idx = 1:length(conditions)
    data = pop_epoch(EEG, triggers(cond_idx), [-0.2 0.8]);
    data = pop_rmbase(data, [-200, 0]);
    
    %Save preprocessed
    fname = sprintf('1_%s.set', conditions{cond_idx});
    pop_saveset(data, fname, set_path);
    
end

%% Load and plot
cd(set_path)
close all
standard = pop_loadset('1_standard.set');
oddball = pop_loadset('1_oddball.set');

% Data format is channels x time points x trials
get_ERP = @(condition, channels) squeeze(mean(condition.data(channels, :, :), [1 3]));

% Uncomment the channels you want to plot
%chans = [3, 4, 11]; % Oz, O1, O2
chans = [2, 5, 8, 9, 10]; % C3, POz, Fz, Cz, C4

%% Plot
figure
dif_wav = get_ERP(oddball, chans) - get_ERP(standard, chans);

plot(oddball.times, get_ERP(standard, chans), 'b', 'LineWidth', 2)
hold on
plot(oddball.times, get_ERP(oddball, chans), 'r', 'LineWidth', 2)
hold on
plot(oddball.times, dif_wav, 'k', 'LineWidth', 2)

xline(0)
xline(300)
yline(0)

legend('Standard', 'Oddball', 'Difference')
legend('boxoff')
legend('Location', 'northwest')
set(gca,'FontSize', 13)
xlabel('Time(ms)')
ylabel('Mean Amplitude (μV)')