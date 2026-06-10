function B = TC(A,gap,n)
    % 确保输入A是一个向量
    if ~isvector(A)
        error('Input A must be a vector.');
    end
    % gap为卷积间隔，n为一次卷积数目
    % 获取数组的长度
    N = length(A);
    
    % 初始化结果数组，长度为N-1
    B = zeros(N-(n-1)*gap, 1);
    
    % 循环遍历数组，将相邻元素相乘
    for i = 1:N-(n-1)*gap
        temp=A(i);
        for j = 1:n-1 
            temp = temp * A(i+j*gap);
        end 
        B(i)=temp;
    end
end


