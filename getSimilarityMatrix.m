function S = getSimilarityMatrix(Pattern, sigma)

% function GETSIMILARITYMATRIX

% input arguments
% Pattern: input samples
% output arguments
% sim_matrix: similarity matrix of size nxn

% author: Maryam Najafi
% date: Nov 21, 2016

n = size(Pattern,1);
S = zeros(n,n);

% different similarity approaches are applied
% 1. Gaussian Similarity Function
for i = 1 : n
    for j = 1 : n
        tmp = (norm(Pattern(i,:) - Pattern(j, : ), 2))^2;
        S(i,j) = exp(-1 * (tmp /(2 *sigma^2)));
%         S(i,j) = tmp; % euclidean distance;
    end
end



end