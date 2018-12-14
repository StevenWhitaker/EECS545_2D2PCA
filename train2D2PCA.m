% train2D2PCA
% 
% Use training images to calculate the projection axes for 2D2PCA. See the paper
% "(2D)2PCA: Two-directional two-dimensional PCA for efficient face
% representation and recognition" by Zhang and Zhou.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-14
% updated: 2018-11-29, Specify percent variation to explain instead of reduced
%                      dimension
% 
% 
% function [X, Z] = train2D2PCA(train, pr, pc)
% 
% Input | Description
% ------------------------------------------------------------------------------
% train | Training images; should be array of size [M,nx,ny]
% pr    | Percent variation to explain in row space (or pr == d if pr > 1)
% pc    | Percent variation to explain in column space (or pc == q if pc > 1)
% 
% Output | Description
% ------------------------------------------------------------------------------
% X      | Row projection axes; matrix of size [ny,d] (d is reduced dim)
% Z      | Column projection axes; matrix of size [nx,q] (q is reduced dim)

function [X, Z] = train2D2PCA(train, pr, pc)
  
  [M, nx, ny] = size(train);
  
  % Calculate Gr and Gc
  Abar = squeeze(mean(train, 1)); % Average training image
  Gr = zeros(ny,ny); % Initialize Gr
  Gc = zeros(nx,nx); % Initialize Gc
  for m = 1:M
    Am = squeeze(train(m,:,:));
    tmp = Am - Abar;
    Gr = Gr + tmp.' * tmp;
    Gc = Gc + tmp * tmp.';
  end
  Gr = Gr / M;
  Gc = Gc / M;
  
  % Calculate the eigenvectors of Gr and Gc
  [Vr, Er] = eig(Gr, 'vector');
  [Vc, Ec] = eig(Gc, 'vector');
  % Make sure the eigenvectors are sorted properly
  [Er, idx] = sort(Er, 'descend');
  Vr = Vr(:,idx);
  [Ec, idx] = sort(Ec, 'descend');
  Vc = Vc(:,idx);
  
  % Grab the principal eigenvectors of Gr and Gc
  X = Vr(:,1:dimred(Er, pr));
  Z = Vc(:,1:dimred(Ec, pc));
  
end
