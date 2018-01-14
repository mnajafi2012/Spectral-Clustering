function Y = gety(eigvecs)
% function GETY

% input arguments
% eigvecs: vectors of size nxk
% output arguments
% Y: y_i is a vector of size k filling in each row of Y
%    Y is a matrix containing y_i's

% author: Maryam Najafi
% date: Nov 21, 2016

for i= 1 : size(eigvecs,1)
    Y(i,:) = eigvecs (i, :);
end


end