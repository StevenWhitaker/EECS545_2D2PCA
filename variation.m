% variation
% 
% See how well PCA and 2D2PCA can capture variations in the subject.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-12-11

close all; clear;
load('yale.mat');

[K, N, nx, ny] = size(data);

% Facial variation
% ntrain = [3, 8]; % happy and sad faces for training
% ntest = [6, 9, 10, 11]; % normal, sleepy, surprised, and wink for testing
% Lighting variation
% ntrain = [1]; % center light for training
% ntest = [4, 6, 7]; % left, normal, and right lighting for testing
% Glasses vs no glasses
ntrain = [5]; % no glasses for training
ntest = [2]; % glasses for testing
train = data(:,ntrain,:,:);
test = data(:,ntest,:,:);
p = 0.95; % Percent variation to explain

% PCA
tic;
labels = classifyPCA(train, reshape(test, [], nx, ny), p);
tpca = toc;

correct = repmat((1:K).', 1, length(ntest));
correct = correct(:);
accpca = sum(labels == correct) / (K * length(ntest));

% % 2D2PCA
% tic;
% labels = classify2DPCA(train, reshape(test, [], nx, ny), p);
% t2dpca = toc;
% 
% acc2dpca = sum(labels == correct) / (K * length(ntest));

% 2D2PCA
tic;
labels = classify2D2PCA(train, reshape(test, [], nx, ny), p, p);
t2d2pca = toc;

acc2d2pca = sum(labels == correct) / (K * length(ntest));
