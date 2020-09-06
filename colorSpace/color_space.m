clc;

clear;

im=imread('Lena.jpg');

im=double(im);     % 转换为[0,1]
im=rgb2hsv(im);    % 转换为hsv空间
H=im(:,:,1);       %hsi(:, :, 1)是色度分量，它的范围是[0, 360]；
S=im(:,:,2);       %hsi(:, :, 2)是饱和度分量，范围是[0, 1]；
V=im(:,:,3);       %hsi(:, :, 3)是亮度分量，范围是[0, 1]。

%将hsv空间非等间隔量化：
%  h量化成16级；
%  s量化成4级；
%  v量化成4级；

%量化H分量
[hm,hn]=size(H);
H = H*360;
for i=1:hm
    for j=1:hn
       if H(i,j)>=345 || H(i,j)<15
           H(i,j)=0;
       end
       if H(i,j)<25&&H(i,j)>=15
           H(i,j)=1;
       end
       if H(i,j)<45&&H(i,j)>=25
           H(i,j)=2;
       end
       if H(i,j)<55&&H(i,j)>=45
           H(i,j)=3;
       end
       if H(i,j)<80&&H(i,j)>=55
           H(i,j)=4;
       end
       if H(i,j)<108&&H(i,j)>=80
           H(i,j)=5;
       end
       if H(i,j)<140&&H(i,j)>=108
           H(i,j)=6;
       end
       if H(i,j)<165&&H(i,j)>=140
           H(i,j)=7;
       end
       if H(i,j)<190&&H(i,j)>=165
           H(i,j)=8;
       end
       if H(i,j)<220&&H(i,j)>=190
           H(i,j)=9;
       end
       if H(i,j)<255&&H(i,j)>=220
           H(i,j)=10;
       end
       if H(i,j)<275&&H(i,j)>=255
           H(i,j)=11;
       end
       if H(i,j)<290&&H(i,j)>=275
           H(i,j)=12;
       end
       if H(i,j)<316&&H(i,j)>=290
           H(i,j)=13;
       end
       if H(i,j)<330&&H(i,j)>=316
           H(i,j)=14;
       end
       if H(i,j)<345&&H(i,j)>=330
           H(i,j)=15;
       end
    end
end

 %量化S分量
 for i=1:hm
    for j=1:hn
       if S(i,j)>0 && S(i,j)<=0.15
           S(i,j)=0;
       end
       if S(i,j)<=0.4&&S(i,j)>0.15
           S(i,j)=1;
       end
       if S(i,j)<=0.75&&S(i,j)>0.4
           S(i,j)=2;
       end
       if S(i,j)<=1&&S(i,j)>0.75
           S(i,j)=3;
       end
    end
 end
 
 %量化V分量
 for i=1:hm
    for j=1:hn
       if V(i,j)>0 && V(i,j)<=0.15
           V(i,j)=0;
       end
       if V(i,j)<=0.4&&V(i,j)>0.15
           V(i,j)=1;
       end
       if V(i,j)<=0.75&&V(i,j)>0.4
           V(i,j)=2;
       end
       if V(i,j)<=1&&V(i,j)>0.75
           V(i,j)=3;
       end
    end
 end

 G=zeros(hm,hn);    % 存放每一个像素的颜色等级索引
 for i=1:hm
    for j=1:hn
        G(i,j)=H(i,j)*16+S(i,j)*4+V(i,j);
    end
 end
 
 center=[(1+hn)/2 (1+hm)/2];   % 图像的中心点
 hx=hn/2;hy=hm/2;             % 区域半径
 h=sqrt(hx^2+hy^2); 
 m=256;
 p=zeros(m,1);
for u=1:m
    s1=0;
    s2=0;
    for i=1:hm
       for j=1:hn
           temp_x=j;temp_y=i;    % 像素点的坐标
           distance=sqrt((center(1)-temp_x)^2+(center(2)-temp_y)^2);   % 像素点距离中心点的距离
           r=distance/h;
           % 计算此像素点的权重
           if(r<1)       
               k=1-r^2;
           else
               k=0;
           end
           % 判断颜色索引是否是u
           if(G(i,j)==u)
               delta=1;
           else
               delta=0;
           end
           s1=s1+k*delta;
           s2=s2+k;
       end
    end
   p(u)=s1/s2;
end
HIST=p;

 imhist(HIST);figure

 