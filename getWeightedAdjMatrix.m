function W = getWeightedAdjMatrix (S, approach, eps, k_knn)
% function GETWEIGHTEDADJMATRIX

% input arguments
% S: similarity matrix of size nxn
% eps: a real-numberical value for the e-neighborhood graph approach
% output arguments
% W: weighted adjacency matrix of size nxn

% author: Maryam Najafi
% date: Nov 21, 2016

global Pattern

W = S;
n = size(W,1);

% create the weighted adj. matrix using:
switch lower(approach)
    case {'eps'}
        % 1_1. e_neighborhood graph approach to create the similarity graph from S (sim. matrix)
        W(S<eps) = 0;
    case 'mutual_knn'
        % 1_3. mutual k_nearest neighbor
        IDX = knnsearch(Pattern, Pattern, 'K', k_knn);
%         IDX = knnsearch(S,S,'K', k_knn);
        S = zeros(size(W)); sigma = 2;
        for i = 1 : n
            for j = 1 : n
                tmp = find(IDX(i,:) == j);
                if ~isempty(tmp)
                    tmp = (norm(Pattern(i,:) - Pattern(j, : ), 2))^2;
                     S(i,j) = exp(-1 * (tmp /(2 *sigma^2)));
                end
            end
        end
        W = S;
    otherwise
        % 1_4. Gaussian kernel similarity function (fully connected graph)
        disp('Gaussian');
end

end