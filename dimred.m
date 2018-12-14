% dimred
% 
% Calculate the reduced dimension to use in PCA and its variants. The reduced
% dimension will be chosen to explain a given percent variation of the data.
% 
% author: Steven Whitaker
% group members: Chunan Huang, Jieru Shi, Steven Whitaker, Dan Zhao
% date created: 2018-11-29
% updated: 2018-11-30, Allow p > 1 to specify d (instead of having to figure out
%                      what p to provide to get the desired d)
% updated: 2018-12-11, Don't loop if p == 1, just return N
% 
% 
% function [d] = dimred(lambda, p)
% 
% Input  | Description
% ------------------------------------------------------------------------------
% lambda | Eigenvalues of training data, sorted in descending order
% p      | Percent variation to explain; 0 <= p <= 1
%        | Or, if p > 1, then d = p (note that p = 0 -> d = 1)
% 
% Output | Description
% ------------------------------------------------------------------------------
% d      | Reduced dimension

function [d] = dimred(lambda, p)
  
  if p > 1
    d = p;
    return;
  end
  
  N = length(lambda);
  if p == 1
    d = N;
    return;
  end
  total = sum(lambda);
  s = 0;
  for d = 1:N
    s = s + lambda(d);
    if s / total >= p
      break;
    end
  end
  
end
