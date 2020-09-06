function [outputImg, meanColors] = quantize_RGB(origImg, k)

[rows, cols, channels] = size(double(origImg));
reshapeCol = rows*cols;
newImage = reshape(double(origImg),reshapeCol, channels);

[idx, meanColors] = kmeans(newImage, k);
idx = reshape(idx, rows, cols);
outputImg = uint8(zeros(rows,cols,channels));
    
    i = 1;
    while(i <= rows)
        j = 1;
        while(j <= cols)
            k2 = 1;
            while(k2 <= k)
                if idx(i,j)==k2
                    l = 1;
                    while(l <= channels)
                        outputImg(i,j,l)= meanColors(k2,l);
                        l = l + 1;
                    end  
                end
                k2 = k2 + 1;
            end
            j = j + 1;
        end
        i = i + 1;
    end
end