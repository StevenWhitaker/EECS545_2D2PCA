% train2DPCA
% 
% Use training images to calculate the projection axes for 2DPCA. See the paper
% "(2D)2PCA: Two-directional two-dimensional PCA for efficient face
% representation and recognition" by Zhang and Zhou.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-12-11
% 
% 
% function [X] = train2DPCA(train, p)
% 
% Input | Description
% ------------------------------------------------------------------------------
% train | Training images; should be array of size [M,nx,ny]
% p     | Percent variation to explain in row space
% 
% Output | Description
% ------------------------------------------------------------------------------
% X      | Row projection axes; matrix of size [ny,d] (d is reduced dim)

function [X] = train2DPCA(train, p)
  
  [M, ~, ny] = size(train);
  
  % Calculate G
  Abar = squeeze(mean(train, 1)); % Average training image
  G = zeros(ny,ny); % Initialize G
  for m = 1:M
    Am = squeeze(train(m,:,:));
    tmp = Am - Abar;
    G = G + tmp.' * tmp;
  end
  G = G / M;
  
  % Calculate the eigenvectors of G
  [V, E] = eig(G, 'vector');
  % Make sure the eigenvectors are sorted properly
  [E, idx] = sort(E, 'descend');
  V = V(:,idx);
  
  % Grab the principal eigenvectors of G
  X = V(:,1:dimred(E, p));
  
end
