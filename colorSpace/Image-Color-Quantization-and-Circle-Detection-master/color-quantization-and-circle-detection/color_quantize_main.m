
origImg = imread ('D:\MatlabFiles\colorSpace\Image-Color-Quantization-and-Circle-Detection-master\examples\caomei3.jpg');

[im5, meanColors] = quantize_RGB(origImg,5); 
figure
subplot(2,2,1)
imshow(im5)
title('RGB k = 5')
rgbError5 = compute_Quantization_Error(origImg, im5)
% 
[im5, meanHues] = quantize_HSV(origImg, 5);
subplot(2,2,2)
imshow(im5);
hsvError5 = compute_Quantization_Error(origImg, im5)
title('HSV k = 5')
% 
[im25, meanColors] = quantize_RGB(origImg,25);
subplot(2,2,3)
imshow(im25)
rgbError25 = compute_Quantization_Error(origImg, im25)
title('RGB k = 25')
% 
[im25, meanHues] = quantize_HSV(origImg, 25);
subplot(2,2,4)
imshow(im25);
hsvError25 = compute_Quantization_Error(origImg, im25)
title('HSV k = 25')
%
[histEqual, histClustered] = get_Hue_Hists(origImg, 5);
figure
subplot(1, 2, 1);
title('Equal');
hist(histEqual,5);
subplot(1, 2, 2);
title('Clustered');
hist(histClustered, 5);
%
[histEqual, histClustered] = get_Hue_Hists(origImg, 25);
figure
subplot(1, 2, 1);
title('Equal');
hist(histEqual,25);
subplot(1, 2, 2);
title('Clustered');
hist(histClustered, 25);


