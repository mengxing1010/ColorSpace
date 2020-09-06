function [histEqual, histClustered] = get_Hue_Hists(origImg, k)

hsvConvert = rgb2hsv(origImg);

rownum = size(hsvConvert,1);
colnum = size(hsvConvert,2);
for m=1:rownum
    for n=1:colnum
       extractHue(m,n,1) = hsvConvert(m,n,1);
    end
end

[rows, cols, ~] = size(extractHue);
reshapecol = rows*cols;
histEqual = reshape(extractHue,reshapecol,1);
[idx,histmeans] = kmeans(double(reshape(extractHue,reshapecol,1)),k);
idx = reshape(idx,rows,cols);
[r,c]= size(idx);

i = 1;
while(i <= r)
        for j=1:c
            for k2=1:k
                if idx(i,j)==k2
                   for l=1:size(i,1)
                        extractHue(i(l,1),j(l,1)) = histmeans(k2,1);
                   end
                end  
            end
        end
        i = i + 1;
end

idx = reshape(idx,reshapecol, 1);
histClustered = hist(idx, k);
end


