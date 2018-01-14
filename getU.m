function U = getU(V)
% GETU
% author: Maryam Najafi
% date: Dec 3, 2016

% input arguments
% V: an nbyk matrix contaiing the eigenvectors
% output arguments
% U: an nbyk matrix of normalized v's

for i = 1 : size(V,2)
    U(:,i) = V(:,i)/sqrt(sum((V(:,i).^2)));
end

end

