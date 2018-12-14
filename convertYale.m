% convertYale
% 
% Read in the PGM files of the Yale database and save as a .mat file to be used
% later.
% 
% The Yale database was downloaded on 2018-11-28 from 
% http://vismod.media.mit.edu/vismod/classes/mas622-00/datasets/
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-28
% 
% 
% function convertYale(datadir)
% 
% Input   | Description
% ------------------------------------------------------------------------------
% datadir | Location of Yale database

function convertYale(datadir)
  
  % Specify constants for the Yale database
  K  = 15;  % Number of subjects (classes)
  N  = 11;  % Number of images per subject
  nx = 116; % Number of pixels in x direction
  ny = 98;  % Number of pixels in y direction
  
  % Names of facial expressions
  expr = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', ...
    'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink'};
  
  % Create the data structure to hold the data
  data = zeros(K, N, nx, ny);
  
  % Read all the images
  for k = 1:K
    dirtmp = sprintf('%s/subject%02d', datadir, k);
    for n = 1:N
      data(k,n,:,:) = imread(sprintf('%s.%s.pgm', dirtmp, expr{n}));
    end
  end
  
  % Save
  save('yale.mat', 'data', '-v7.3');
  
end
