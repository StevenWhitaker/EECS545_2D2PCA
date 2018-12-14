% trainPCA
% 
% Use training images to calculate the projection axes for PCA. See HW 5 problem
% 2.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-29
% 
% 
% function [U] = trainPCA(train, p)
% 
% Input | Description
% ------------------------------------------------------------------------------
% train | Training images; should be array of size [M,nx,ny]
% p     | Percent variation to explain (determines how many eigenfaces to keep)
% 
% Output | Description
% ------------------------------------------------------------------------------
% U      | Principal eigenfaces; matrix of size [nx*ny,d], where d is reduced
%        | dimension

function [U] = trainPCA(train, p)
  
  [M, nx, ny] = size(train);
  
  % Vectorize each image
  X = reshape(train, M, nx * ny).'; % [nx*ny,M]
  
  % Calculate the eigenvectors and eigenvalues of the sample covariance matrix
  [V, S, ~] = svd(X - mean(X, 2));
  lambda = diag(S).^2 / M;
  
  % Grab the principal eigenvectors of S
  U = V(:,1:dimred(lambda, p));
  
end
