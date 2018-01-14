function labels = normSpecClustering(k, S, approach, eps, k_knn)
% function NORMSPECCLUSTERING
% Objective Normalized Spectral Clustering Algorithm on given datasets

% input arguments
% k: number of clusters
% approach: 4 different approaches to construct a sim. graph
% eps: the threshold that belongs to the e-neighborhood approach
% 
% output arguments
% Clusters: the clusters A_1 ... A_k

% author: Maryam Najafi
% date: Dec 3, 2016

% 1. construct a similarity graph
W = getWeightedAdjMatrix(S, approach, eps, k_knn);

% 3. calculate D (degree matrix)
D = getDmatrix(W);

% 4. compute the unnormalized Laplacian L
L = getLaplacianMatrixNormalized(D, W);

% 5. compute the first k eigenvectors v_1 ... v_k of L
%    Introduce a matrix V (R nxk) containing the vectors v1...vk
eigvecs = getEigVecs(L, k);

% 6. form the matrix U from eigvecs by normalizing the row sums to have
% norm 1
U = getU(eigvecs);

% 7. create y_i (i=1:n) a matrix _ each row is a vector corresponding to 
% the ith row of the V matrix.
Y = gety(U);

% 8. cluster the points yi's with k_means algorithm into k clusters
%    return the clusters A_1 ... A_k

if k==2
    % Author's kmeans function
    labels = k_means(Y, k); % works for k = 2
else
    % Matlab built-in kmeans function
    [labels, centroids] = kmeans(Y,k); %figure;
end

end