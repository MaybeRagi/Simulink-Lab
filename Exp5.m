% Initialization
clc;
clear;
close all;

% ==========================================
% 1. Define Signals
% ==========================================
u1 = 1:8;                 % Input signal
h = [0.4, 1, 0.4];        % Channel impulse response
N = length(u1);           % Length of input signal
L = length(h);            % Length of channel

% Plot input signal and channel impulse response
figure('Name', 'Input and Channel');
subplot(2, 1, 1);
stem(u1, 'filled');
axis([0, 10, 0, 10]);
title('Input Signal');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2, 1, 2);
stem(h, '^', 'filled');
axis([0, 10, 0, 2]);
title('Channel Impulse Response');
xlabel('Sample Index');
ylabel('Amplitude');

% ==========================================
% 2. Linear vs Circular Convolution
% ==========================================
yl1 = conv(u1, h);        % Linear convolution
yc1 = cconv(u1, h, N);    % N-point Circular convolution

% Plot Convolution Results
figure('Name', 'Linear vs Circular Convolution');
stem(yl1, 'x', 'LineWidth', 1.5);
hold on;
stem(yc1, 'o', 'LineWidth', 1.5);
hold off;
title(sprintf('Convolution Results, N = %d', N));
xlabel('Sample Index');
ylabel('Amplitude');
legend('Linear', 'Circular', 'Location', 'northwest');

% ==========================================
% 3. Cyclic Prefix (CP) Addition
% ==========================================
% Extract the last L samples of the input signal to form the CP
ucp = u1(N - L + 1 : N); 

% Prepend the CP to the input signal
u2 = [ucp, u1]; 

% Pass the signal with CP through the channel (Linear Convolution)
yl2 = conv(u2, h); 

% Remove the CP from the received signal to extract the useful data
yl2_no_cp = yl2(L + 1 : end); 

% Plot results with Cyclic Prefix
figure('Name', 'Convolution with Cyclic Prefix');
stem(yl2_no_cp(1:N), 'x', 'LineWidth', 1.5); % Plot only the N valid data symbols
hold on;
stem(yc1, 'o', 'LineWidth', 1.5);
hold off;
title('Convolution Results with Cyclic Prefix');
xlabel('Sample Index');
ylabel('Amplitude');
legend('Linear (CP Removed)', 'Circular', 'Location', 'northwest');

% ==========================================
% 4. Verification
% ==========================================
% Check if the N valid samples match the circular convolution
% Note: Added abs() to ensure negative differences don't falsely pass
if max(abs(yc1 - yl2_no_cp(1:N))) < 1e-8
    disp('Success: Linear and circular convolution sequences match.');
else
    disp('Error: Received symbols do not match transmitted symbols.');
end