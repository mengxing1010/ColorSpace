function [outputImg,meanHues ] = quantize_HSV(origImg, k )
hsvConvert = rgb2hsv(origImg);
extractHue = hsvConvert(:,:,1);
[rows, cols, ~] = size(extractHue);
reshapecol = rows*cols;
[idx,meanHues] = kmeans(double(reshape(extractHue,reshapecol,1)),k);
idx = reshape(idx,rows,cols);
[r,c]= size(idx); 
i = 1;
while(i <= r)
        j = 1;
        while(j <= c)
            k2 = 1;
            while(k2 <= k)
                if idx(i,j)==k2
                    l = 1;
                   while(l <= size(i,1))
                        extractHue(i(l,1),j(l,1)) = meanHues(k2,1);
                        l = l + 1;
                   end
                end 
                k2 = k2 + 1;
            end
            j = j + 1;
        end
        i = i + 1;
end

rownum = size(extractHue,1);
colnum = size(extractHue,2);

for m=1:rownum
    for n=1:colnum
       hsvConvert(m,n,1) = extractHue(m,n,1);
    end
end
finalImg = hsv2rgb(hsvConvert);
outputImg = finalImg;

end
