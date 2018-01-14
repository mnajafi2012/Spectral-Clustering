function v = getEigVecs(L, k)
% function GETEIGVECS

% input arguments
% k: number of clusters
% L: laplacian matrix of size nxn
% output arguments
% eigVecs: eigen vectors of L

% author: Maryam Najafi
% date: Nov 21, 2016

[v, d] = eig(L); % v: eigen vectors; d: eigen values

base = ones(size(d,1),1);
% plot the eigenvalues

    for j = 1 : size(d,1)
        base(j,1) = j;
        base(j,2) = d(j,j);
    end


v = v(:, [1,k]); % the first lowest Lambda corresponding eigenvectors
end