function approx_min = nystrom_min(K, lambda, b, k)
% Approximately compute min_v (1/2) * v'Av - v'b
% Note that it is NOT argmin
%
  n = length(b);
  
  ind = randperm(n, k);
  Wp = pinv(K(ind, ind));
  C = K(:, ind);
  A = inv(lambda * eye(k) + Wp * C' * C);
  v = 1/lambda * (b - C * A * Wp * C' * b);
  
  approx_min = 1/2 * v' * b - 1/2;