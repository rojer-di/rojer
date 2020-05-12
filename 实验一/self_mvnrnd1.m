function self_mvnrnd1(varargin)%���Զ�������ĺ���
if(nargin==12)%�ж���������Ƿ�Ϊ12
w1=mvnrnd(varargin{1},varargin{2},varargin{3});%��һ���˹�����ܶ�ֵ
w2=mvnrnd(varargin{5},varargin{6},varargin{7});%�ڶ���
w3=mvnrnd(varargin{9},varargin{10},varargin{11});
figure(1);
plot(w1(:,1),w1(:,2),'bo');%��ɫoΪ��һ��
hold on
plot(w2(:,1),w2(:,2),'g*');%��ɫ*Ϊ�ڶ���
hold on
plot(w3(:,1),w3(:,2),'r^')
title('300�������������ɫoΪ��һ�࣬��ɫ*Ϊ�ڶ���,��ɫ-Ϊ������');
w=[w1;w2;w3];
n1=0;%��һ����ȷ����
n2=0;%�ڶ�����ȷ����
n3=0;%��������ȷ�ĸ���
figure(2);
%��Ҷ˹������
for i=1:(varargin{3}+varargin{7}+varargin{11})
    x=w(i,1);
    y=w(i,2);
    g1=mvnpdf([x,y],varargin{1},varargin{2})*varargin{4};
    g2=mvnpdf([x,y],varargin{5},varargin{6})*varargin{8};
    g3=mvnpdf([x,y],varargin{9},varargin{10})*varargin{12};
     if g1>g3&&g1>g2
        if 1<=i&&i<=varargin{3}
            n1=n1+1;%��һ����ȷ����
            plot(x,y,'bo');%��ɫo��ʾ��ȷ��Ϊ��һ�������
            hold on;
        else
            plot(x,y,'k^');%��ɫ���������α�ʾ��һ������Ϊ�ڶ���
            hold on;
        end   
     end
     if g2>g3&&g2>g1
        if varargin{3}<=i&&i<=(varargin{3}+varargin{7})
            n2=n2+1;%��һ����ȷ����
            plot(x,y,'g*');%��ɫo��ʾ��ȷ��Ϊ�ڶ��������
            hold on;
        else
            plot(x,y,'y+');%��ɫ���������α�ʾ��һ������Ϊ�ڶ���
            hold on;
        end   
     end
    if g3>g1&&g3>g2
        if (varargin{3}+varargin{7})<=i&&i<=(+varargin{7}+varargin{3}+varargin{11})
            n3=n3+1;%��һ����ȷ����
            plot(x,y,'r^');%��ɫo��ʾ��ȷ��Ϊ�ڶ��������
            hold on;
        else
            plot(x,y,'ms');%��ɫ���������α�ʾ��һ������Ϊ�ڶ���
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
