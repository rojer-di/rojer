close all;
clear;
N=400;
for i=1:N
    im{i}=imread(['D:\新建文件夹\data\3\',int2str(i),'.jpg']);
    [feature]=hog_feature_vector(im{i});
    I{i}=feature';
end
%求平均值
ave=zeros(144,1);
for i=1:N
    ave=ave+I{1,i};
end
average=ave/N;
%求xie方差
E=zeros(144,144);
for i=1:N
    E=E+(I{1,i}-average)*(I{1,i}-average)';
end
conv=E/N;
det(conv)
P1=zeros(1,144);
% for i=1:N
%     P1=P1+(1/sqrt(2*pi)).*(1/sqrt(det(conv))).*exp((-1/2.*(I{1,i}-average)*(inv(conv))*(I{1,i}-average)'));
% end