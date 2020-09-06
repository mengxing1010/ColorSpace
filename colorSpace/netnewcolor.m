f = imread('caomei3.jpg');
fd = double(f);
h = fspecial('sobel');
g = sqrt(imfilter(fd,h,'replicate').^2+imfilter(fd,h','replicate').^2); % �ݶȷ���
L = watershed(g);                               % ��ˮ��任
wr = L ==0;                                     % ��ˮ�뼹��
% ���Թ۲쵽�����ɴ����ֲ���С�����µĹ��ָ���

rm = imregionalmin(g);
% �۲쵽�����ֲ���С����λ�÷ǳ�ǳ��������ڷָ����ⲻ��ص�ϸ��

im = imextendedmin(f,2);                         % ��ȡ�ڲ���Ƿ�����
fim = f;                                        % 2Ϊ�߶���ֵ
fim(im) = 175;
% ��ԭͼ�����Ի�ɫ������ʽ������չ�ľֲ���С����λ��

Lim = watershed(bwdist(im));                    % ��ȡ�ⲿ��Ƿ�
em = Lim ==0;
% ��ʾem�ķ�ˮ�뼹��

g2 = imimposemin(g , im | em);                  % ǿ����С����
% �޸ĻҶȼ�ͼ���Ա�ֲ���С����������ڱ�ǵ�λ��

L2 = watershed(g2);
f2 = f;
f2(L2 ==0) = 255;
% �޸��˱�Ƿ����ݶ�ͼ��ķ�ˮ�뼹��

subplot(3,3,1);imshow(f);title('ԭ����ͼ��');
subplot(3,3,2);imshow(wr);title('��ˮ��任���ָ�');
subplot(3,3,3);imshow(rm);title('�ݶȷ�ֵ�ľֲ���С����');
subplot(3,3,4);imshow(fim);title('�ڲ���Ƿ�');
subplot(3,3,5);imshow(em);title('�ⲿ��Ƿ�');
subplot(3,3,6);imshow(g2,[]);title('�޸ĺ���ݶȷ�ֵ');
subplot(3,3,8);imshow(f2);title('�ָ���');