% convertORL
% 
% Read in the PGM files of the ORL database and save as a .mat file to be used
% later.
% 
% The ORL database was downloaded on 2018-11-14 from 
% https://www.cl.cam.ac.uk/research/dtg/attarchive/facedatabase.html
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-14
% 
% 
% function convertORL(datadir)
% 
% Input   | Description
% ------------------------------------------------------------------------------
% datadir | Location of ORL database

function convertORL(datadir)
  
  % Specify constants for the ORL database
  K  = 40;  % Number of subjects (classes)
  N  = 10;  % Number of images per subject
  nx = 112; % Number of pixels in x direction
  ny = 92;  % Number of pixels in y direction
  
  % Create the data structure to hold the data
  data = zeros(K, N, nx, ny);
  
  % Read all the images
  for k = 1:K
    dirtmp = sprintf('%s/s%d', datadir, k);
    for n = 1:N
      data(k,n,:,:) = imread(sprintf('%s/%d.pgm', dirtmp, n));
    end
  end
  
  % Save
  save('orl.mat', 'data', '-v7.3');
  
end
