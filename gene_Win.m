function W_in = gene_Win(n,dim,add_dim,W_in_a,W_in_type)

% define W_in  
if W_in_type == 1
    W_in = W_in_a*(2*rand(n,dim+add_dim)-1);
elseif W_in_type == 2
    % each node is inputed with with one dimenson of real data
    % and all the tuning parameters
    W_in=zeros(n,dim+add_dim);
    n_win = n-mod(n,dim);  % make n_win be the multiple of dim
    index=randperm(n_win);
    index=reshape(index,n_win/dim,dim);
    for d_i=1:dim
        W_in(index(:,d_i),d_i)=W_in_a*(2*rand(n_win/dim,1)-1);
    end
    if add_dim ==1
        W_in(:,dim+add_dim) = W_in_a*(2*rand(n,add_dim)-1);%deal with para channel's linear combine alone
    end
elseif W_in_type == 3   % deal with the normal channel and para channel together like type 2,sometimes make the last colmun to be the random number between -1 and 1 alone
    dim_sep = dim+add_dim;
    W_in = zeros(n,dim_sep);
    n_win = n - mod(n,dim_sep);
    index = randperm(n_win); 
    index = reshape(index,n_win/dim_sep,dim_sep);
    for d_i=1:dim_sep
        W_in(index(:,d_i),d_i) = W_in_a*(2*rand(n_win/dim_sep,1)-1);
    end
%     W_in(:,end) = W_in_a*(2*rand(n,1)-1);
else
    fprintf('W_in type error\n');
    return
end