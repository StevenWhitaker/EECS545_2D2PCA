% run_classify2D2PCA
% 
% Call classify2D2PCA and calculate classification accuracy.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-14
% updated: 2018-11-28, Add yale.mat dataset
% updated: 2018-11-29, Specify percent variation to explain instead of reduced
%                      dimension
% updated: 2018-12-01, Return reduced dimension from the classification routine

clear; close all;
% load('orl.mat');
load('yale.mat');

[K, N, nx, ny] = size(data);

% Specify parameters used in 2D2PCA paper for ORL dataset
ntrain = floor(N / 2);
ntest = N - ntrain;
train = data(:,1:ntrain,:,:);
test = data(:,ntrain+1:end,:,:);
pr = 0.95; % Percent variation to explain in row space
pc = 0.95; % Percent variation to explain in column space
% pr = 10; % ORL
% pc = 11;
% pr = 5; % Yale
% pc = 8;

tic;
[labels, d, q] = classify2D2PCA(train, reshape(test, [], nx, ny), pr, pc);
t = toc;

correct = repmat((1:K).', 1, ntest);
correct = correct(:);
accuracy = sum(labels == correct) / (K * ntest);

percentred = 1 - (d * q) / (nx * ny);
