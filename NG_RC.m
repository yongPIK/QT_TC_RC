clc;
clear all;

P_datas = load('data_Lorenz.dat');
data = P_datas';
data(1,:)=data(1,:)./max(abs(data(1,:))); %normalized
data(2,:)=data(2,:)./max(abs(data(2,:)));
data(3,:)=data(3,:)./max(abs(data(3,:)));

trainLen = 5000;
init0=1000;
testLen = 3000;
prelength_matrix=zeros(5,50);
k=2;
s=1;
initLen = (k-1)*s+init0;
inSize = 3;
outSize =3;
index=2;
num_index = nchoosek(inSize*k + index - 1, index); 
resSize=1+inSize*k+num_index ; 
reg=10^-6;

% train
X = zeros(resSize,trainLen-initLen);                                           
Yt = data(:,initLen+2:trainLen+1);
for t = initLen+1:trainLen
    x_lin=[];
    for i=1:k
        u=data(:,t-(i-1)*s);
        x_lin=[x_lin;u];
    end
    phi = poly_terms(x_lin, index);
    x_nonlin=phi';
    X(:,t-initLen) = [1;x_lin;x_nonlin];                          
end
X_T = X';
Wout = Yt*X_T / (X*X_T + reg*eye(resSize));                             

% pre
Y = zeros(outSize,testLen);
data1=data;
for t = trainLen+1:trainLen+testLen 
    x_lin=[];
    for i=1:k
        u=data1(:,t-(i-1)*s);
        x_lin=[x_lin;u];
    end
    phi = poly_terms(x_lin, index);
    x_nonlin=phi';
    Y(:,t-trainLen) = Wout*[1;x_lin;x_nonlin];
    data1(:,t+1)=Wout*[1;x_lin;x_nonlin];
   
end
errorLen = testLen;
Y_t =data(:,trainLen+2:trainLen+errorLen+1);
mse = sum((Y_t(1,1:errorLen)-Y(1,1:errorLen)).^2)./errorLen;
rmse = sqrt(mse);
disp( ['RMSE = ', num2str( rmse )] );

% figure(1);
% plot( Y_t(1,1:errorLen), 'color', [0,0.75,0] );
% hold on;
% plot( Y(1,1:errorLen), 'b' );
% hold off;
% axis tight;
% title('The predicted and true values of the Lorenz system');
% legend('Target signal', ' predicted signal');
% figure(2);%pre
% plot3( Y(1,1:errorLen), Y(2,1:errorLen), Y(3,1:errorLen) );
% figure(3);% true
% plot3( Y_t(1,1:errorLen), Y_t(2,1:errorLen), Y_t(3,1:errorLen) );

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



