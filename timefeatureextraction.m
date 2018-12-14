% timefeatureextraction
% 
% Time how long feature extraction takes for PCA, 2DPCA, and 2D2PCA.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-12-11

close all; clear;
load('orl.mat');

[K, N, nx, ny] = size(data);

% Use the same percent variation for all methods. We had discussed using
% sqrt(p) for each dimension of 2D2PCA to make it more comparable to 2DPCA,
% but I don't think that comparison is valid, especially when considering how
% different PCA is from the other two methods.
p = 0.95; % Percent variation to explain

tpca = zeros(5,1);
t2dpca = zeros(5,1);
t2d2pca = zeros(5,1);

% Try different number of training samples
for ntrain = 1:5

  ntest = N - ntrain;
  train = data(:,1:ntrain,:,:);
  test = data(:,ntrain+1:end,:,:);
  
  % PCA
  tic;
  U = trainPCA(reshape(train, K*ntrain, nx, ny), p);
  thetatrain = U' * reshape(train, K*ntrain, nx*ny).';
  tpca(ntrain) = toc;
  
  % 2DPCA
  tic;
  X = train2DPCA(reshape(train, K*ntrain, nx, ny), p);
  Ctrain = zeros(K, ntrain, nx, size(X,2));
  for k = 1:K
    for n = 1:ntrain
      Ctrain(k,n,:,:) = squeeze(train(k,n,:,:)) * X;
    end
  end
  t2dpca(ntrain) = toc;
  
  % 2D2PCA
  tic;
  [X, Z] = train2D2PCA(reshape(train, K*ntrain, nx, ny), p, p);
  Ctrain = zeros(K, ntrain, size(Z,2), size(X,2));
  for k = 1:K
    for n = 1:ntrain
      Ctrain(k,n,:,:) = Z' * squeeze(train(k,n,:,:)) * X;
    end
  end
  t2d2pca(ntrain) = toc;
  
end
