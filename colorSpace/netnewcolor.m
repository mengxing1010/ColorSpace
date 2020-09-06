f = imread('caomei3.jpg');
fd = double(f);
h = fspecial('sobel');
g = sqrt(imfilter(fd,h,'replicate').^2+imfilter(fd,h','replicate').^2); % 梯度幅度
L = watershed(g);                               % 分水岭变换
wr = L ==0;                                     % 分水岭脊线
% 可以观察到部分由大量局部最小区域导致的过分割结果

rm = imregionalmin(g);
% 观察到多数局部最小区域位置非常浅，有许多于分割问题不相关的细节

im = imextendedmin(f,2);                         % 获取内部标记符集合
fim = f;                                        % 2为高度阈值
fim(im) = 175;
% 在原图像上以灰色气泡形式叠加扩展的局部最小区域位置

Lim = watershed(bwdist(im));                    % 获取外部标记符
em = Lim ==0;
% 显示em的分水岭脊线

g2 = imimposemin(g , im | em);                  % 强制最小技术
% 修改灰度级图像，以便局部最小区域仅出现在标记的位置

L2 = watershed(g2);
f2 = f;
f2(L2 ==0) = 255;
% 修改了标记符的梯度图像的分水岭脊线

subplot(3,3,1);imshow(f);title('原凝胶图像');
subplot(3,3,2);imshow(wr);title('分水岭变换过分割');
subplot(3,3,3);imshow(rm);title('梯度幅值的局部最小区域');
subplot(3,3,4);imshow(fim);title('内部标记符');
subplot(3,3,5);imshow(em);title('外部标记符');
subplot(3,3,6);imshow(g2,[]);title('修改后的梯度幅值');
subplot(3,3,8);imshow(f2);title('分割结果');