% classifyPCA
% 
% Classify test images using PCA.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-29
% updated: 2018-12-01, Return reduced dimension from the classification routine
% 
% 
% function [labels, d] = classifyPCA(train, test, p)
% 
% Input | Description
% ------------------------------------------------------------------------------
% train | Training images; should be array of size [K,ntrain,nx,ny]
% test  | Test images; should be array of size [ntest,nx,ny]
% p     | Percent variation to explain
% 
% Output | Description
% ------------------------------------------------------------------------------
% labels | Labels assigned to each of the test images; vector of length ntest
% d      | Reduced dimension
% 
% Comments:
% K is the number of classes.
% ntrain is number of training images per class.
% ntest is total number of test images.
% Each image is of size [nx,ny].

function [labels, d] = classifyPCA(train, test, p)
  
  [K, ntrain, nx, ny] = size(train);
  ntest = size(test, 1);
  
  % Train
  [U] = trainPCA(reshape(train, K*ntrain, nx, ny), p);
  
  % Grab reduced dimension
  d = size(U,2);
  
  % Create training features
  thetatrain = U' * reshape(train, K*ntrain, nx*ny).'; % [d,K*ntrain]
  thetatrain = reshape(thetatrain.', K, ntrain, d); % [K,ntrain,d]
  
  % Initialize labels
  labels = -ones(ntest, 1);
  
  % Compare each test feature to each training feature
  theta = U' * reshape(test, ntest, nx*ny).'; % [d,ntest]
  for t = 1:ntest
    dmin = Inf; % Keep track of minimum distance
    for k = 1:K
      for n = 1:ntrain
        dst = norm(theta(:,t) - squeeze(thetatrain(k,n,:))); % Calculate distance
        if dst < dmin
          dmin = dst;
          labels(t) = k; % Assign label of closest class
        end
      end
    end
  end
  
end
