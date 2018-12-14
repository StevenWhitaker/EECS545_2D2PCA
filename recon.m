% recon
% 
% Compare quality of reconstructed images using PCA, 2DPCA, and 2D2PCA with
% similar compression ratios.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-12-11

close all; clear;
load('orl.mat');

[K, N, nx, ny] = size(data);

ntrain = 5;
ntest = N - ntrain;
train = data(:,1:ntrain,:,:);
test = data(:,ntrain+1:end,:,:);
p = 2; % Reduced dimension for PCA
d = round((ntrain * p + nx * ny * p) / (ntrain * nx + ny)); % Reduced row dimension for 2DPCA and 2D2PCA
q = round((ntrain * p + nx * ny * p - ny * d) / (ntrain * d + nx)); % Reduced column dimension for 2D2PCA

% Calculate the compression ratios for each algorithm
tmp = ntrain * nx * ny;
compPCA = tmp / (ntrain * p + nx * ny * p);
comp2DPCA = tmp / (ntrain * nx * d + ny * d);
comp2D2PCA = tmp / (ntrain * d * q + ny * d + nx * q);

% PCA
U = trainPCA(reshape(train, K*ntrain, nx, ny), p); % [nx*ny,d]
thetatrain = U' * reshape(train, K*ntrain, nx*ny).'; % [d,K*ntrain]
reconPCA = U * thetatrain; % [nx*ny,K*ntrain]
reconPCA = reshape(reconPCA.', K, ntrain, nx, ny);

% 2DPCA
X = train2DPCA(reshape(train, K*ntrain, nx, ny), d);
recon2DPCA = zeros(K, ntrain, nx, ny);
for k = 1:K
  for n = 1:ntrain
    Ctrain = squeeze(train(k,n,:,:)) * X;
    recon2DPCA(k,n,:,:) = Ctrain * X';
  end
end

% 2D2PCA
[X, Z] = train2D2PCA(reshape(train, K*ntrain, nx, ny), d, q);
recon2D2PCA = zeros(K, ntrain, nx, ny);
for k = 1:K
  for n = 1:ntrain
    Ctrain = Z' * squeeze(train(k,n,:,:)) * X;
    recon2D2PCA(k,n,:,:) = Z * Ctrain * X';
  end
end

figure(); colormap(gray(256));
nsub = 6;
fsize = 16;
for i = 1:nsub
  subplot(4,nsub,i);
  imagesc(squeeze(train(i,1,:,:)));
  set(gca, 'xticklabel', []); set(gca, 'yticklabel', []);
  if i == 1
    ylabel('Original', 'FontSize', fsize);
  end
  subplot(4,nsub,i+nsub);
  imagesc(squeeze(reconPCA(i,1,:,:)));
  set(gca, 'xticklabel', []); set(gca, 'yticklabel', []);
  if i == 1
    ylabel('PCA', 'FontSize', fsize);
  end
  subplot(4,nsub,i+2*nsub);
  imagesc(squeeze(recon2DPCA(i,1,:,:)));
  set(gca, 'xticklabel', []); set(gca, 'yticklabel', []);
  if i == 1
    ylabel('2DPCA', 'FontSize', fsize);
  end
  subplot(4,nsub,i+3*nsub);
  imagesc(squeeze(recon2D2PCA(i,1,:,:)));
  set(gca, 'xticklabel', []); set(gca, 'yticklabel', []);
  if i == 1
    ylabel('(2D)^2PCA', 'FontSize', fsize);
  end
end
