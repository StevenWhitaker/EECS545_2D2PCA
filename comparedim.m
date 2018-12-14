% comparedim
% 
% Compare the classification accuracies of PCA and 2D2PCA as a function of
% reduced dimension.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-12-01

clear; close all;
load('orl.mat');
% load('yale.mat');

[K, N, nx, ny] = size(data);
ntrain = floor(N / 2);
ntest = N - ntrain;
train = data(:,1:ntrain,:,:);
test = data(:,ntrain+1:end,:,:);

dims = 1:100;
acc_pca = zeros(size(dims));
acc_2d2pca = zeros(size(dims));
for idx = 1:length(dims)
  dim = dims(idx);
  
  if dim == 1
    p = 0;
    pr = 0;
    pc = 0;
  else
    p = dim;
    k = 1:dim;
    div = k(rem(dim,k) == 0); % Find factors of dim
	% If there is an even number of factors, then the number is not a perfect
	% square, so pick the closest two factors (pr < pc)
    if rem(length(div),2) == 0
      pr = div(end/2);
      pc = div(end/2+1);
    else % dim is a perfect square, so pick the square root for both pr and pc
      pr = div(ceil(end/2));
      pc = pr;
    end
    if pr == 1
      pr = 0;
    end
    if pc == 1
      pc = 0;
    end
  end
  
  labels_pca = classifyPCA(train, reshape(test, [], nx, ny), p);
  labels_2d2pca = classify2D2PCA(train, reshape(test, [], nx, ny), pr, pc);
  
  correct = repmat((1:K).', 1, ntest);
  correct = correct(:);
  acc_pca(idx) = sum(labels_pca == correct) / (K * ntest);
  acc_2d2pca(idx) = sum(labels_2d2pca == correct) / (K * ntest);
  
end

fsize = 20; % Font size
plot(dims, acc_pca, 'b', dims, acc_2d2pca, 'r--', 'LineWidth', 2);
set(gca, 'FontSize', 14);
legend('PCA', '(2D)^2PCA', 'FontSize', fsize);
xlabel('Dimension', 'FontSize', fsize);
ylabel('Classification Accuracy', 'FontSize', fsize);
