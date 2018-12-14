% classify2D2PCA
% 
% Classify test images using the 2D2PCA algorithm, as described in the paper
% "(2D)2PCA: Two-directional two-dimensional PCA for efficient face
% representation and recognition" by Zhang and Zhou.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-14
% updated: 2018-11-29, Specify percent variation to explain instead of reduced
%                      dimension
% updated: 2018-12-01, Return reduced dimension from the classification routine
% 
% 
% function [labels, d, q] = classify2D2PCA(train, test, pr, pc)
% 
% Input | Description
% ------------------------------------------------------------------------------
% train | Training images; should be array of size [K,ntrain,nx,ny]
% test  | Test images; should be array of size [ntest,nx,ny]
% pr    | Percent variation to explain in row space (or pr == d if pr > 1)
% pc    | Percent variation to explain in column space (or pc == q if pc > 1)
% 
% Output | Description
% ------------------------------------------------------------------------------
% labels | Labels assigned to each of the test images; vector of length ntest
% d      | Reduced dimension of the row space
% q      | Reduced dimension of the column space
% 
% Comments:
% K is the number of classes.
% ntrain is number of training images per class.
% ntest is total number of test images.
% Each image is of size [nx,ny].

function [labels, d, q] = classify2D2PCA(train, test, pr, pc)
  
  [K, ntrain, nx, ny] = size(train);
  ntest = size(test, 1);
  
  % Train
  [X, Z] = train2D2PCA(reshape(train, K*ntrain, nx, ny), pr, pc);
  
  % Grab reduced dimensions
  d = size(X,2);
  q = size(Z,2);
  
  % Create training feature matrices
  Ctrain = zeros(K, ntrain, q, d);
  for k = 1:K
    for n = 1:ntrain
      Ctrain(k,n,:,:) = Z' * squeeze(train(k,n,:,:)) * X;
    end
  end
  
  % Initialize labels
  labels = -ones(ntest, 1);
  
  % Compare each test feature matrix to each training feature matrix
  for t = 1:ntest
    C = Z' * squeeze(test(t,:,:)) * X; % Test feature matrix
    dmin = Inf; % Keep track of minimum distance
    for k = 1:K
      for n = 1:ntrain
        dst = dist(C, reshape(Ctrain(k,n,:,:), q, d)); % Calculate distance
        if dst < dmin
          dmin = dst;
          labels(t) = k; % Assign label of closest class
        end
      end
    end
  end
  
end


% dist
% 
% Calculate the distance between two matrices by taking the root-sum-of-squares
% of the elements of the matrix formed by the difference of the two input
% matrices (i.e., the Frobenius norm of the difference).
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-14
% 
% 
% function [d] = dist(A, B)
% 
% Input | Description
% ------------------------------------------------------------------------------
% A     | First matrix input; must be same size as B
% B     | Second matrix input; must be same size as A
% 
% Output | Description
% ------------------------------------------------------------------------------
% d      | Distance between A and B, given by the Frobenius norm of A - B
function [d] = dist(A, B)
  
  diffmat = A - B;
  d = norm(diffmat(:));
  
end
