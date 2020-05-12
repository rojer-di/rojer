function LR=LogisticsRegression(N,yita)%ѵ���ִ�N ѵ������yita
%% ��ȡ��д��3 %%
train_data_3= [];
N1_train=400;
for i=1:1:N1_train
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\3\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);  % hog(1,144)
    train_data_3=[train_data_3,hog'];
end
%% ��ȡ��д��5 %%
train_data_5= [];
N2_train=400;
for i=1:1:N2_train
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\5\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);
    train_data_5=[train_data_5,hog'];
end
%% ��ȡ�������� %%
N_train=800;%ѵ����������
N_test = 200; % ������������
test_data= [];
for i=1:1:N_test/2
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\3\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data,hog'];
end
for i=1:1:N_test/2
    im = imread(['D:\�½��ļ���\ģʽʶ��\data\5\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data,hog'];
end
%% ������ʼ�� %%
%W������ʼ��
W=0.5.*ones(144,1);
%W���ݶ�
deltaE=zeros(144,1);
%% ѵ��W %%
%ѵ���ִ�N
% N=30;
% %ѵ������
% yita=2;
for n=1:N
    %ѵ����Ϊ3����ǩΪ1
    for i=1:1:400
        xn=train_data_3(:,i);
        %Ŀ�꺯��
        yn=1./(1+exp(-W'*xn));
        deltaE=deltaE-(1-yn).*xn;
    end
    W=W-yita*deltaE;
    %ѵ����Ϊ5����ǩΪ0
    for i=1:1:400
        xn=train_data_5(:,i);
        %Ŀ�꺯��
        yn=1./(1+exp(-W'*xn));
        deltaE=deltaE-(0-yn).*xn;
    end
    W=W-yita*deltaE;
end
%% Ԥ���� %%
test_result=[];     %���յ�ʶ����
p1_result=[];       %ÿ��ʶ��Ϊ3��
p2_result=[];       %ÿ��ʶ��Ϊ5��
Y=[];
predict=0;
for i= 1:200
    xn=test_data(:,i);
    %Ŀ�꺯��
    predict=1./(1+exp(-W'*xn));
    Y=[Y,predict];
    if predict>=0.5
        test_result=[test_result,3];
    elseif predict<0.5
        test_result=[test_result,5];
    else
        return
    end
end
%% ��ͼ������ǰ��test�����ƶ���ǰ100����3����100����5������ʵ��ʶ�� %%
x1=1:1:100;
y1=3*x1.^0;
x2=1:1:100;
y2=5*x2.^0;
ee=[y1 y2];
e=ee-test_result;
e=sum(sum(e~=0));
% disp([' ������� ','������%']);
% disp([e,e./200.*100]);
plot(Y,'*');
hold on;
text(80,0.4,strcat('���������',num2str(e),'  �����ʣ�',num2str(e./2),'%'));
text(80,0.5,strcat('ѵ���ִ�:',num2str(N),'  ѵ������:',num2str(yita)));
title('ǰ100ȫΪ3(1)��Ԥ�⣬��100ȫΪ5(0)��Ԥ��');
%���Ԥ��������
for i=1:100
    if Y(i)<0.5
    plot(i,Y(i),'ro');
    end
end
for i=101:200
    if Y(i)>0.5
    plot(i,Y(i),'ro');
    end
end
return 