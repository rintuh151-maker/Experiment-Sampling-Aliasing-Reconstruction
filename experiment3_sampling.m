clc;
clear;
close all;

%% Experiment 3: Sampling, Aliasing and Reconstruction

% Signal frequencies
f1 = 40;              % First frequency in Hz
f2 = 90;              % Second frequency in Hz
fmax = max(f1,f2);    % Maximum frequency

% Nyquist rate
nyquist_rate = 2*fmax;

fprintf('Maximum frequency = %.2f Hz\n', fmax);
fprintf('Nyquist rate = %.2f Hz\n\n', nyquist_rate);

%% High-resolution reference signal
Fplot = 10000;        % Plotting resolution
T = 1;              % Signal duration

t = 0:1/Fplot:T;

x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);

%% Sampling frequencies
fs_values = [270 180 140];

for k = 1:length(fs_values)

    fs = fs_values(k);

    % Sampling
    ts = 0:1/fs:T;
    xs = sin(2*pi*f1*ts) + 0.5*sin(2*pi*f2*ts);

    %% Sinc reconstruction
    xrec = zeros(size(t));

    for n = 1:length(ts)
        xrec = xrec + xs(n)*sinc(fs*(t-ts(n)));
    end

    %% Reconstruction error
    error_signal = x - xrec;

    RMSE = sqrt(mean(error_signal.^2));

    %% Aliased frequencies
    f_alias1 = abs(f1 - round(f1/fs)*fs);
    f_alias2 = abs(f2 - round(f2/fs)*fs);

    fprintf('Sampling frequency = %d Hz\n',fs);
    fprintf('RMSE = %.6f\n',RMSE);
    fprintf('Aliased f1 = %.2f Hz\n',f_alias1);
    fprintf('Aliased f2 = %.2f Hz\n\n',f_alias2);

    %% Figure 1: Reference and sampled signal
    figure;

    plot(t,x,'LineWidth',1.5);
    hold on;

    stem(ts,xs,'filled');

    xlabel('Time (s)');
    ylabel('Amplitude');

    title(['Reference and Sampled Signal, f_s = ',num2str(fs),' Hz']);

    legend('Reference signal','Samples');

    grid on;

    %% Figure 2: Reconstructed waveform
    figure;

    plot(t,x,'LineWidth',1.5);
    hold on;

    plot(t,xrec,'--','LineWidth',1.5);

    xlabel('Time (s)');
    ylabel('Amplitude');

    title(['Sinc Reconstruction, f_s = ',num2str(fs),' Hz']);

    legend('Original signal','Reconstructed signal');

    grid on;

 %% Figure 3: Magnitude spectrum of sampled signal

Nsample = length(xs);

% Zero padding for better frequency-domain visualization
Nfft = 4096;

Xsample = abs(fft(xs,Nfft))/Nsample;

f_axis = (0:Nfft-1)*(fs/Nfft);

% Keep only positive frequencies
half = 1:floor(Nfft/2);

figure;

plot(f_axis(half),Xsample(half),'LineWidth',1.5);

xlim([0 fs/2]);

xlabel('Frequency (Hz)');
ylabel('Magnitude');

title(['Magnitude Spectrum of Sampled Signal, f_s = ',num2str(fs),' Hz']);

grid on;
    %% Figure 4: Reconstruction error
    figure;

    plot(t,error_signal,'LineWidth',1.5);

    xlabel('Time (s)');
    ylabel('Error');

    title(['Reconstruction Error, f_s = ',num2str(fs),' Hz']);

    grid on;

end