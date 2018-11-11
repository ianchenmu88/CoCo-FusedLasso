close all
clear all
%generate random data
a=50; %number of observasions;
b=120; %number of variables;
betas=zeros(b,1); %beta_star
betas(1)=3;
betas(2)=1.5;
betas(5)=2;
betas=smooth(betas);
sigma=3; %cov of response variable: Y
tao=0.75; % cov of addictive error A/cov of multiplitive error M
for i=1:a %cov matrix of AR
for j=1:b
SigmaX(i,j)=0.5^abs(i-j);
end
end;
%for i=1:a %cov matrix fo CS
% for j=1:b
% if i==j
% SigmaX(i,j)=0.5+0.5;
% else SigmaX(i,j)=0.5;
% end;
% end;
%end;
for k=1:50
for i=1:a
X(i,:)=normrnd(0,SigmaX(i,:),1,b);
end
r=0.25; %missing ratio
%for j=1:b
% M(:,j)=rand(a,1);
% M(:,j)=(M(:,j)>p);
%end;
xbs=X*betas; %generate y
Y=xbs+normrnd(0,sigma,a,1);
A=normrnd(0,tao,a,b);
%M=lognrnd(0,tao,a,b);
%Um=mean(M) ;
Xz_additive=X+A;
%Xz_multiple=X.*M;
%cocolasso and positive semi definte
sigmah_additive=(1/a)*Xz_additive'*Xz_additive-tao^2*eye(b,b);
%sigmah_multiple=(1/a)*Xz_multiple'*Xz_multiple./((1/a)*M'*M+Um'*Um);
cvx_begin
variable sigmat(b,b) semidefinite
minimize( norm( sigmah_additive-sigmat,inf ) )
cvx_end
n=a;
zt=chol(n*sigmat);
yt=inv(zt')*Xz_additive'*Y;
[lasso_coco,FitInfo]=lasso(zt,yt,'CV',5);
lassoPlot(lasso_coco,FitInfo,'PlotType','CV');
MSE(k)=norm(betas-lasso_coco(:,FitInfo.IndexMinMSE))
PE(k)=(1/a)*(betas-lasso_coco(:,FitInfo.IndexMinMSE))'*X'*X*(betas-lasso_coco(:,FitInfo.IndexMinMSE))
end
semse=std(MSE)/sqrt(a)
sepe=std(PE)/sqrt(a)
