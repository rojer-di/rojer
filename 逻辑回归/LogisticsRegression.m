function LR=LogisticsRegression(N,yita)%训练轮次N 训练步长yita
%% 读取手写体3 %%
train_data_3= [];
N1_train=400;
for i=1:1:N1_train
    im = imread(['D:\新建文件夹\模式识别\data\3\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);  % hog(1,144)
    train_data_3=[train_data_3,hog'];
end
%% 读取手写体5 %%
train_data_5= [];
N2_train=400;
for i=1:1:N2_train
    im = imread(['D:\新建文件夹\模式识别\data\5\',int2str(i),'.jpg']);
    hog = hog_feature_vector (im);
    train_data_5=[train_data_5,hog'];
end
%% 读取测试数据 %%
N_train=800;%训练样本总数
N_test = 200; % 测试样本总数
test_data= [];
for i=1:1:N_test/2
    im = imread(['D:\新建文件夹\模式识别\data\3\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data,hog'];
end
for i=1:1:N_test/2
    im = imread(['D:\新建文件夹\模式识别\data\5\',int2str(i+400),'.jpg']);
    hog = hog_feature_vector (im);
%     disp(hog);
    test_data=[test_data,hog'];
end
%% 参数初始化 %%
%W参数初始化
W=0.5.*ones(144,1);
%W和梯度
deltaE=zeros(144,1);
%% 训练W %%
%训练轮次N
% N=30;
% %训练步长
% yita=2;
for n=1:N
    %训练集为3，标签为1
    for i=1:1:400
        xn=train_data_3(:,i);
        %目标函数
        yn=1./(1+exp(-W'*xn));
        deltaE=deltaE-(1-yn).*xn;
    end
    W=W-yita*deltaE;
    %训练集为5，标签为0
    for i=1:1:400
        xn=train_data_5(:,i);
        %目标函数
        yn=1./(1+exp(-W'*xn));
        deltaE=deltaE-(0-yn).*xn;
    end
    W=W-yita*deltaE;
end
%% 预测结果 %%
test_result=[];     %最终的识别结果
p1_result=[];       %每次识别为3的
p2_result=[];       %每次识别为5的
Y=[];
predict=0;
for i= 1:200
    xn=test_data(:,i);
    %目标函数
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
%% 画图，按照前面test集的制定，前100都是3，后100都是5，画出实际识别 %%
x1=1:1:100;
y1=3*x1.^0;
x2=1:1:100;
y2=5*x2.^0;
ee=[y1 y2];
e=ee-test_result;
e=sum(sum(e~=0));
% disp([' 错误次数 ','错误率%']);
% disp([e,e./200.*100]);
plot(Y,'*');
hold on;
text(80,0.4,strcat('错误次数：',num2str(e),'  错误率：',num2str(e./2),'%'));
text(80,0.5,strcat('训练轮次:',num2str(N),'  训练步长:',num2str(yita)));
title('前100全为3(1)的预测，后100全为5(0)的预测');
%标出预测点的坐标
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