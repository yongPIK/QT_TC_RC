function W_r = gene_Wr(n,k,eig_rho,W_r_type)

% define W_r
if W_r_type == 1
    W_r=sprandsym(n,k/n); % symmeric, normally distributed, with mean 0 and variance 1.
elseif W_r_type == 2
    k = round(k);
    index1=repmat(1:n,1,k)'; % asymmeric, uniformly distributed between 0 and 1
    index2=randperm(n*k)';
    index2(:,2)=repmat(1:n,1,k)';
    index2=sortrows(index2,1);
    index1(:,2)=index2(:,2);
    W_r=sparse(index1(:,1),index1(:,2),rand(size(index1,1),1),n,n); 
elseif W_r_type == 3
    W_r = 2*rand(n,n)-1;
else
    fprintf('res_net type error\n');
    return
end
% W_r, adjacency matrix of the hidden layer, i.e. the reservoir network
% rescale eig
eig_D=eigs(W_r,1); %only use the biggest one. Warning about the others is harmless
W_r=(eig_rho/(abs(eig_D))).*W_r;
W_r=full(W_r);

end