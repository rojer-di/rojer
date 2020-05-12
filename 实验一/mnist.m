clear;
clc;
%% ��ȡ��д��3 %%
train_data_3= [];
N1_train=400;
for i=1:1:N1_train
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\3\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);  % hog(1,144)
    train_data_3=[train_data_3;hog];
end
%% ��ȡ��д��5 %%
train_data_5= [];
N2_train=400;
for i=1:1:N2_train
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\5\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);
    train_data_5=[train_data_5;hog];
end
%% ��ȡ�������� %%
N_train=800;%ѵ����������
N_test = 200; % ������������
test_data= [];
for i=1:1:N_test/2
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\3\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data;hog];
end
for i=1:1:N_test/2
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\5\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data;hog];
end
%��ʼ�������ݼ��� 
% ��������ֵ
u1 = mean(train_data_3); u2 = mean(train_data_5);
% ������Э�������
%% ����,��ʽ��Э���� %%
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
% ��Э�������������
S1_ = inv(s1); S2_ = inv(s2);
%% ֱ�ӵ��ú�����Э���� %%
S1 = cov(train_data_3,1); S2 = cov(train_data_5,1);
% ��Э�������������
% S1_ = inv(S1); S2_ = inv(S2);
%% ��Э������������ʽ %%
S11 = det(s1); S22 = det(s2); % Ϊʲô���ǵ���0
%% �������
Pw1 = N1_train/N_train; Pw2 = N2_train/N_train; %������1/2
%% ������������ĺ������ %%
test_result=[];     %���յ�ʶ����
p1_result=[];       %ÿ��ʶ��Ϊ3��
p2_result=[];       %ÿ��ʶ��Ϊ5��
for k = 1 : N_test
    Pxw1 = -1/2*(test_data(k,:)-u1)*S1_*(test_data(k,:)-u1)'+log(Pw1);%-1./2*log(S11)Ϊ�����
    Pxw2 = -1/2*(test_data(k,:)-u2)*S2_*(test_data(k,:)-u2)'+log(Pw2);%-1./2*log(S11)Ϊ�����Ӱ���б�
    p1_result=[p1_result,Pxw1];
    p2_result=[p2_result,Pxw2];
    P = [Pxw1 Pxw2];
    Pmax = max(P);  % ȡ�������������һ��
    if Pmax == Pxw1
        test_result=[test_result,3];
    elseif Pmax == Pxw2
        test_result=[test_result,5];
    else
        return
    end
end
%% ��ͼ������ǰ��test�����ƶ���ǰ100����3����100����5������ʵ��ʶ�� %%
plot(test_result,'o');
x1=1:1:100;
y1=3*x1.^0;
x2=1:1:100;
y2=5*x2.^0;
ee=[y1 y2];
e=ee-test_result;
e=sum(sum(e~=0));
disp([' ������� ','������%']);
disp([e,e./N_test.*100]);
figure;
x=1:1:200;
plot(x,p1_result,'-or',x,p2_result,'--*b');legend('ʶ��Ϊ3','ʶ��Ϊ5');