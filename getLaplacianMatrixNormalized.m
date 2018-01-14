function L = getLaplacianMatrixNormalized(D, W)
% function GETLAPLACIANMATRIX

% input arguments
% D: degree matrix of size nxn
% W: weighted adjacency matrix of size nxn
% output arguments
% L: laplacian matrix of size nxn

% author: Maryam Najafi
% date: Dec 3, 2016

I = eye(size(D));

% random walk Laplacian normalized spectral clustering
L = I - D\W;

% symm. Laplacian normalized spectral clustering
% L = I - D^(-1/2) * W * D^(-1/2);

end