function L = getLaplacianMatrixUnnormalized(D, W)
% function GETLAPLACIANMATRIX

% input arguments
% D: degree matrix of size nxn
% W: weighted adjacency matrix of size nxn
% output arguments
% L: laplacian matrix of size nxn

% author: Maryam Najafi
% date: Nov 21, 2016

L = D - W;

end