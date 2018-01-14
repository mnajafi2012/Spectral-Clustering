function D = getDmatrix(W)
% function GETDMATRIX

% input arguments
% W: weighted matrix of size nxn (num of input samples)
% output arguments
% D: a matrix of size nxn

% author: Maryam Najafi
% date: Nov 21, 2016

D = zeros(size(W));
n = size(W, 1);

for i = 1 : n
    D(i,i) = sum (W (i, :));
end

end