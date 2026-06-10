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
resSize = 10;
add_dim = 0;

delay=30;
lin_num=3
RESIZE=resSize*lin_num+resSize*lin_num*(1+resSize*lin_num)/2; 
a = 0.1; 
W_in_a = 1;
k =3;
eig_rho =0.2;
reg = 10^-6;  
W_in_type = 1;   W_r_type = 1;
Win = gene_Win(resSize,inSize,add_dim,W_in_a,W_in_type);
W = gene_Wr(resSize,k,eig_rho,W_r_type);
X = zeros(resSize,trainLen-initLen);   
X_ts = zeros(RESIZE,trainLen-initLen-delay*(lin_num-1)); 
Yt = data(:,initLen+delay*(lin_num-1)+2:trainLen+1);
x = zeros(resSize,1);
for t = 1:trainLen
    u = data(:,t);
    x = (1-a)*x + a*tanh( Win*u + W*x );                  
    if t > initLen
         X(:,t-initLen) = x;                      
    end
end
for t=(1+delay*(lin_num-1)):trainLen-initLen
    x_lin=[];
    x_nonlin=[];
    for i=1:lin_num
        temp1=X(:,t-(i-1)*delay);
        x_lin=[x_lin;temp1];
    end
    for i=1:length(x_lin)
        for j=i:length(x_lin)
            temp2=x_lin(i)*x_lin(j);
            x_nonlin=[x_nonlin;temp2];
        end
    end
    X_ts(:,t-delay*(lin_num-1))=[x_lin;x_nonlin];
end
X_T = X_ts';
Wout = Yt*X_T / (X_ts*X_T + reg*eye(RESIZE));                            
Y = zeros(outSize,testLen);
u = data(:,trainLen+1);
for t = 1:testLen 
    x = (1-a)*x + a*tanh( Win*u + W*x );                
    X=[X,x];
    x_ts=zeros(RESIZE,1);
    x_lin=[];
    x_nonlin=[];
    for i=1:lin_num
        temp1=X(:,t+trainLen-initLen-(i-1)*delay);
        x_lin=[x_lin;temp1];
    end
    for i=1:length(x_lin)
        for j=i:length(x_lin)
            temp2=x_lin(i)*x_lin(j);
            x_nonlin=[x_nonlin;temp2];
        end
    end
    x_ts=[x_lin;x_nonlin];
    u = Wout*x_ts;                            
    Y(:,t) = u;
end

errorLen = testLen;
Y_t =data(:,trainLen+2:trainLen+errorLen+1);
mse = sum((Y_t(1,1:errorLen)-Y(1,1:errorLen)).^2)./errorLen;
rmse = sqrt(mse);
disp( ['RMSE = ', num2str( rmse )] );

% plot some signals
% figure();
% subplot(3,1,1);
% plot( Y_t(1,1:errorLen), 'color', [0,0.75,0] );
% hold on;
% plot( Y(1,1:errorLen), 'b' );
% hold off;
% axis tight;
% % title('The predicted and true values of the Lorenz system');
% legend('Target signal', ' predicted signal');
% 
% subplot(3,1,2);
% plot( Y_t(2,1:errorLen), 'color', [0,0.75,0] );
% hold on;
% plot( Y(2,1:errorLen), 'b' );
% hold off;
% axis tight;
% % title('The predicted and true values of the Lorenz system');
% legend('Target signal', ' predicted signal');
% 
% subplot(3,1,3);
% plot( Y_t(3,1:errorLen), 'color', [0,0.75,0] );
% hold on;
% plot( Y(3,1:errorLen), 'b' );
% hold off;
% axis tight;
% % title('The predicted and true values of the Lorenz system');
% legend('Target signal', ' predicted signal');

pre_length=0;
threshold1=0.5;
for i=1:errorLen
    er=norm(Y_t(:,i)-Y(:,i))/norm(Y_t(:,i));
    pre_length=i;
    if (er>threshold1) 
        break;
    end
end
disp(pre_length);




