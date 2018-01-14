function labels = unnormSpecClustering(k, S, approach, eps, k_knn)
% function UNNORMSPECCLUSTERING
% Objective Unnormalized Spectral Clustering Algorithm on given datasets

% input arguments
% k: number of clusters
% approach: 4 different approaches to construct a sim. graph
% eps: the threshold that belongs to the e-neighborhood approach
% 
% output arguments
% Clusters: the clusters A_1 ... A_k

% author: Maryam Najafi
% date: Nov 21, 2016

% 1. construct a similarity graph
W = getWeightedAdjMatrix(S, approach, eps, k_knn);

% 3. calculate D (degree matrix)
D = getDmatrix(W);

% 4. compute the unnormalized Laplacian L
L = getLaplacianMatrixUnnormalized(D, W);

% 5. compute the first k eigenvectors v_1 ... v_k of L
%    Introduce a matrix V (R nxk) containing the vectors v1...vk
eigvecs = getEigVecs(L, k);

% 6. create y_i (i=1:n) a matrix _ each row is a vector corresponding to 
% the ith row of the V matrix.
Y = gety(eigvecs);

% 7. cluster the points yi's with k_means algorithm into k clusters
%    return the clusters A_1 ... A_k

% Matlab built-in kmeans function
% [labels, centroids] = kmeans(Y,k); %figure;

if k==2
    % Author's kmeans function
    labels = k_means(Y, k); % works for k = 2
else
    % Matlab built-in kmeans function
    [labels, centroids] = kmeans(Y,k); %figure;
end

end