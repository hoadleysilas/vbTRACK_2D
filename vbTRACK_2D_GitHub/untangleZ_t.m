% untangleZ_t.m

% This program untangles the random numerical assignments of Z and puts
% them in order of occurence in time
fprintf('Step 5.1. Begin untangleZ_t\n');

% For each Gaussian bZ in each mixture model aZ, find the data points
% assigned to it.
indexofZ = cell(5,5);
for aZ = kmin:K        % Column of z_hat
%       for aZ = 1:5        % Column of z_hat
    for bZ = 1:aZ   % looking for this
        indexofZ{bZ,aZ}=(find(z_hat{1,aZ}==bZ))';
    end
end

% For each mixture model aZ, sort the Gaussians according to order of
% appearance. 
unsorted = ones(5,5);
unsorted = unsorted*10000;
for aZ2 = 1:5
    for bZ2 = 1:aZ2
        if ~isempty(indexofZ{bZ2,aZ2})
        unsorted(bZ2,aZ2) = indexofZ{bZ2,aZ2}(1,1);
        else
            unsorted(bZ2,aZ2) = 10000;
        end
    end
end


[sorted newZ] = sort(unsorted,1);


