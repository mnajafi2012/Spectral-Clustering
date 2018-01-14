function labels =  k_means (samples, k)
% function K_MEANS

% input arguments
% samples: the same Y (y_i's) in spectral clustering; nxk matrix
% k: number of clusters
% output arguments
% Clusters: a matrix of k clouds; each cloud is a matrix of (<n)xk

% author: Maryam Najafi
% date: Nov 21, 2016
global Pattern
C = k;
n = size(samples,1);
labels = zeros(n, 1);
r = randsample(n, k); % first two hypothesized means (centroids)

% two first manually-choosen centroids
%   r = [65; 250]; % for jain
% r = [35; 100]; % for Compund dataset
% r = [60; 150]; % for toydataset2

% figure();
% plot the initial random centroids
% hold on
% scatter (Pattern(r(1), 1), Pattern (r(1), 2), 'x');
% hold on
% scatter (Pattern(r(2), 1), Pattern (r(2), 2), 'x');
centroids = samples(r, :);
thr = .001;
change = inf;
counter = 0;

% calculate the distance between each sample to the means
while (change > thr)
    centroids_prev = centroids;
    for i= 1: n
        min = inf;
        for k = 1 : C
            tmp = norm(samples(i, :) - centroids(k, :), 2) ^ 2;
            if (tmp < min)
                min = tmp;
                labels(i) = k;
            end

        end
    end
    
    % compute new centroids of created clouds (clusters' means)
    for k = 1 : C
        centroids(k, :) = mean(samples(labels == k, :), 1);
    end
    counter = counter + 1;
    % any changes happened?
    change = norm(centroids_prev - centroids, 2);
    if (change == 0)
        disp ('');
    end
end

% plot the updated centroids
% hold on
% scatter (centroids(1,1), centroids(2,1), 'O');
% hold on
% scatter (centroids(1,2), centroids(2,2), 'O');

end