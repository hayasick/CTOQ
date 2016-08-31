
clear all

args = argv();

%%%%%%%%%%%%%%%%%%%%%%%%% Generating data
n = str2num(args{1});
k = str2num(args{2});
s = str2num(args{3});
method = args{4};
dataset = str2num(args{5});
b = n;

seed = s;
rand('state',seed);
randn('state',seed);


switch dataset
%Same distribution
case 1
  n_de=n;
  n_nu=n;
  mu_de=1;
  mu_nu=1;
  sigma_de=1/2;
  sigma_nu=1/2;
  legend_position=1;
%Different distribution
 case 2
  n_de=200;
  n_nu=n;
  mu_de=1;
  mu_nu=1.5;
  sigma_de=1/4;
  sigma_nu=1/4;
  legend_position=2;
end

d=1;
alpha = 0.5;

x_de=mu_de+sigma_de*randn(d,n_de);
x_nu=mu_nu+sigma_nu*randn(d,n_nu);

x_disp=linspace(-0.5,3,100);

[K, h, lambda, sigma] = RuLSIF_mod(x_nu, x_de, x_disp, alpha, [], [], b, 5);

tic;
  if strcmp(method, 'approx')
    PE = - approx_min_pinv(K, lambda, h, k) - 1/2;
  elseif strcmp(method, 'nystrom')
    PE = nystrom_min(K, lambda, h, k);
  else
    disp('error!');
  end
time = toc;

output = sprintf('%d %d %d %s %d %f %f', n, k, s, method, dataset, PE, time);
disp(output);