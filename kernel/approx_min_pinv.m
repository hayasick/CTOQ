function approx_min = approx_min_pinv(K, lambda, b, k)
% Approximately compute min_v (1/2) * v'Av - v'b
% Note that it is NOT argmin
%
  n = length(b);
  
  ind = randperm(n, k);
  K_sub = K(ind, ind);
  b_sub = b(ind);
  
  %warning('off');
  %opts.issym = 1;
  %opts.disp = 0;
  %smallest_eig = eigs(K_sub, 1, 'sm', opts);
  smallest_eig = 0;
  A_sub = K_sub - smallest_eig * eye(k);
  d_sub = ones(k, 1) * (smallest_eig + lambda) * k / n;
  b_sub *= k / n; 
  
  %%% solve by pseudo inverse
  C_sub = A_sub + diag(d_sub);
  v_sub = pinv(C_sub) * b_sub;
  min_sub = (1/2) * v_sub' * C_sub * v_sub - v_sub' * b_sub;
  approx_min = ((n / k) ** 2) * min_sub;

  %[v_sub, min_sub] = qp(v_sub, C_sub, -b_sub);
  %min_sub
  
  %csvwrite('K.csv', K);
  %csvwrite('b.csv', b);
  %csvwrite('K_sub.csv', K_sub);

  
%  v_sub
%  A
%  b
%  scale