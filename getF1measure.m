function F = getF1measure(X , Y, k)
% function EVALUATE_RESULT two input vectors are compared to each other
%                          the result is the percentage of the accuracy

% input arguments
% X: an nx1 vector
% Y: an nx1 vector
% output arguments
% acc: a numerical value in R showing the percentage

% author: Maryam Najafi
% date: Dec 4, 2016

n = length(X);

for i = 1 : k
    list = find(X == i);
    n_i = length(list);
    
    for j = 1 : k
        list2 = find(Y == j);
        n_j = length(list2);
        
        n_ij = sum(ismember(list, list2));
        
        % 1. Recall
        recall = n_ij/n_i;
        
        % 2. Precision
        precision = n_ij/n_j;
        
        f(i,j) = (2 * recall * precision) / (recall + precision);
    end
      
end
f(isnan(f)) =0;
F = 0;
% 3. F measure
% take the weighted average of all values
for i = 1 : k
    list = find(X == i);
    n_i = length(list);
    F = F + (n_i/n) * max(f(i, :));
end

end