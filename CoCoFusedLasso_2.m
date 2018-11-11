for k=i:a
cd ..
cd ..
root=cd;
addpath(genpath([root '/SLEP']));
% add the functions in the folder SLEP to the path
% change to the original folder
cd Examples/fusedLasso;
rho=0.2; % rho = 0.1 % rho = 0.05 % the regularization parameter
% it is a ratio between (0,1), if .rFlag=1
%----------------------- Set optional items ------------------------
opts=[];
% Starting point
opts.init=2; % starting from a zero point
% termination criterion
opts.tFlag=5; % run .maxIter iterations
opts.maxIter=500; % maximum number of iterations
% normalization
opts.nFlag=0; % without normalization
% regularization
opts.rFlag=1; % the input parameter 'rho' is a ratio in (0, 1)
%opts.rsL2=0.01; % the squared two norm term
% fused penalty
opts.fusedPenalty=0.01;
% line search
opts.lFlag=0;
%----------------------- Run the code LeastR -----------------------
[x1, funVal1, ValueL1]= fusedLeastR(zt, yt, rho, opts);
%[x2, funVal2, ValueL2= fusedLeastR(Xz, Y, rho, opts);
Mse_coo(k)=norm(betas-x1)
PE(k)=(1/a)*(betas-x1)'*X'*X*(betas-x1)
end
