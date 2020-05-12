clear;
clc;
%% 读取手写体3 %%
train_data_3= [];
N1_train=400;
for i=1:1:N1_train
    im = imread(['D:\新建文件夹\模式识别\data\3\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);  % hog(1,144)
    train_data_3=[train_data_3;hog];
end
%% 读取手写体5 %%
train_data_5= [];
N2_train=400;
for i=1:1:N2_train
    im = imread(['D:\新建文件夹\模式识别\data\5\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);
    train_data_5=[train_data_5;hog];
end
%% 读取测试数据 %%
N_train=800;%训练样本总数
N_test = 200; % 测试样本总数
test_data= [];
for i=1:1:N_test/2
    im = imread(['D:\新建文件夹\模式识别\data\3\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data;hog];
end
for i=1:1:N_test/2
    im = imread(['D:\新建文件夹\模式识别\data\5\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data;hog];
end
%初始样本数据计算 
% 求样本均值
u1 = mean(train_data_3); u2 = mean(train_data_5);
% 求样本协方差矩阵
%% 测试,公式求协方差 %%
s1=zeros(144,144);
for i=1:1:size(train_data_3,1)
    s1=s1+(train_data_3(i,:)-u1)'*(train_data_3(i,:)-u1);
end
s1=s1./400;
s2=zeros(144,144);
for i=1:1:size(train_data_5,1)
    s2=s2+(train_data_5(i,:)-u2)'*(train_data_5(i,:)-u2);
end
s2=1./400.*s2;
% 求协方差矩阵的逆矩阵
S1_ = inv(s1); S2_ = inv(s2);
%% 直接调用函数求协方差 %%
S1 = cov(train_data_3,1); S2 = cov(train_data_5,1);
% 求协方差矩阵的逆矩阵
% S1_ = inv(S1); S2_ = inv(S2);
%% 求协方差矩阵的行列式 %%
S11 = det(s1); S22 = det(s2); % 为什么都是等于0
%% 先验概率
Pw1 = N1_train/N_train; Pw2 = N2_train/N_train; %都等于1/2
%% 计算测试样本的后验概率 %%
test_result=[];     %最终的识别结果
p1_result=[];       %每次识别为3的
p2_result=[];       %每次识别为5的
for k = 1 : N_test
    Pxw1 = -1/2*(test_data(k,:)-u1)*S1_*(test_data(k,:)-u1)'+log(Pw1);%-1./2*log(S11)为无穷大
    Pxw2 = -1/2*(test_data(k,:)-u2)*S2_*(test_data(k,:)-u2)'+log(Pw2);%-1./2*log(S11)为无穷大影响判别
    p1_result=[p1_result,Pxw1];
    p2_result=[p2_result,Pxw2];
    P = [Pxw1 Pxw2];
    Pmax = max(P);  % 取后验概率最大的那一类
    if Pmax == Pxw1
        test_result=[test_result,3];
    elseif Pmax == Pxw2
        test_result=[test_result,5];
    else
        return
    end
end
%% 画图，按照前面test集的制定，前100都是3，后100都是5，画出实际识别 %%
plot(test_result,'o');
x1=1:1:100;
y1=3*x1.^0;
x2=1:1:100;
y2=5*x2.^0;
ee=[y1 y2];
e=ee-test_result;
e=sum(sum(e~=0));
disp([' 错误次数 ','错误率%']);
disp([e,e./N_test.*100]);
figure;
x=1:1:200;
plot(x,p1_result,'-or',x,p2_result,'--*b');legend('识别为3','识别为5');