clc;
clear;
P_datas = load('data_Lorenz.dat');
data = P_datas';
for i=1:3
    data(i,:)=data(i,:)./max(abs(data(i,:))); %normalized
end

trainLen = 5000;
testLen = 3000;
initLen = 500;
inSize = 3;
outSize =3;
resSize = 100;
add_dim = 0;
a = 0.1 ; 
W_in_a =1;
k = 2;
eig_rho = 1.01;
reg = 10^-6; 
W_in_type = 1;   W_r_type = 1;
Win = gene_Win(resSize,inSize,add_dim,W_in_a,W_in_type);
W = gene_Wr(resSize,k,eig_rho,W_r_type);
X = zeros(resSize,trainLen-initLen);                                            
Yt = data(:,initLen+2:trainLen+1);
x = zeros(resSize,1);
for t = 1:trainLen
    u = data(:,t);
    x = (1-a)*x + a*tanh( Win*u + W*x );                   
    if t > initLen
         X(:,t-initLen) = x;                       
    end
end
X_T = X';
Wout = Yt*X_T / (X*X_T + reg*eye(resSize));                             
Y = zeros(outSize,testLen);
u = data(:,trainLen+1);
for t = 1:testLen 
    x = (1-a)*x + a*tanh( Win*u + W*x );               
    u = Wout*x;                            
    Y(:,t) = u;
end
errorLen = testLen;
Y_t =data(:,trainLen+2:trainLen+errorLen+1);
mse = sum((Y_t(1,1:errorLen)-Y(1,1:errorLen)).^2)./errorLen;
rmse = sqrt(mse);
disp( ['RMSE = ', num2str( rmse )] );

% figure();
% plot( Y_t(1,1:errorLen), 'color', [0,0.75,0] );
% hold on;
% plot( Y(1,1:errorLen), 'b' );
% hold off;
% axis tight;
% title('The predicted and true values of the Loernz system');
% legend('Target signal', ' predicted signal');
% figure();
% plot( Y(1,1:errorLen), Y(3,1:errorLen),'color', [0,0.75,0] );
% title('attractor of the Lorenz system');
pre_length=0;
threshold1=0.5;
for ii=1:errorLen
    er=norm(Y_t(:,ii)-Y(:,ii))/norm(Y_t(:,ii));
    pre_length=ii;
    if (er>threshold1)  
        break;
    end
end
disp(pre_length);




