function self_mvnrnd1(varargin)%可自定义参数的函数
if(nargin==12)%判定输入参数是否为12
w1=mvnrnd(varargin{1},varargin{2},varargin{3});%第一类高斯函数密度值
w2=mvnrnd(varargin{5},varargin{6},varargin{7});%第二类
w3=mvnrnd(varargin{9},varargin{10},varargin{11});
figure(1);
plot(w1(:,1),w1(:,2),'bo');%蓝色o为第一类
hold on
plot(w2(:,1),w2(:,2),'g*');%绿色*为第二类
hold on
plot(w3(:,1),w3(:,2),'r^')
title('300个随机样本，蓝色o为第一类，绿色*为第二类,红色-为第三类');
w=[w1;w2;w3];
n1=0;%第一类正确个数
n2=0;%第二类正确个数
n3=0;%第三类正确的个数
figure(2);
%贝叶斯分类器
for i=1:(varargin{3}+varargin{7}+varargin{11})
    x=w(i,1);
    y=w(i,2);
    g1=mvnpdf([x,y],varargin{1},varargin{2})*varargin{4};
    g2=mvnpdf([x,y],varargin{5},varargin{6})*varargin{8};
    g3=mvnpdf([x,y],varargin{9},varargin{10})*varargin{12};
     if g1>g3&&g1>g2
        if 1<=i&&i<=varargin{3}
            n1=n1+1;%第一类正确个数
            plot(x,y,'bo');%蓝色o表示正确分为第一类的样本
            hold on;
        else
            plot(x,y,'k^');%红色的上三角形表示第一类错误分为第二类
            hold on;
        end   
     end
     if g2>g3&&g2>g1
        if varargin{3}<=i&&i<=(varargin{3}+varargin{7})
            n2=n2+1;%第一类正确个数
            plot(x,y,'g*');%绿色o表示正确分为第二类的样本
            hold on;
        else
            plot(x,y,'y+');%红色的上三角形表示第一类错误分为第二类
            hold on;
        end   
     end
    if g3>g1&&g3>g2
        if (varargin{3}+varargin{7})<=i&&i<=(+varargin{7}+varargin{3}+varargin{11})
            n3=n3+1;%第一类正确个数
            plot(x,y,'r^');%绿色o表示正确分为第二类的样本
            hold on;
        else
            plot(x,y,'ms');%红色的上三角形表示第一类错误分为第二类
            hold on;
        end   
     end
end
r1_rate=0;
r2_rate=0;
r3_rate=0;
r1_rate=n1/varargin{3}
r2_rate=n2/varargin{7}
r3_rate=n3/varargin{11}
print(r1_rate)
print(r2_rate)
print(r3_rate)
end
%%%%%%%%%
 main.m
 self_mvnrnd1([1 3],[1.5,0;0,1],100,0.2,[3,1],[1,0.5;0.5,2],100,0.4,[-1,-2],[ 1,0.5;0.5,2],100,0.4)
