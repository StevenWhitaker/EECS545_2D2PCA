% run_classifyPCA
% 
% Call classifyPCA and calculate classification accuracy.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-29
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
p = 0.95; % Percent variation to explain
% p = 702; % ORL
% p = 504; % Yale

tic;
[labels, d] = classifyPCA(train, reshape(test, [], nx, ny), p);
t = toc;

correct = repmat((1:K).', 1, ntest);
correct = correct(:);
accuracy = sum(labels == correct) / (K * ntest);

percentred = 1 - d / (nx * ny);
