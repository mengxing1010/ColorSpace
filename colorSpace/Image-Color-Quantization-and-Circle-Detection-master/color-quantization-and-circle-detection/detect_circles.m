function [centers] = detect_circles(im, radius, useGradient)
gray = rgb2gray(im);
imgsize = (size(gray));
cent = [];

alledges = double(edge(gray,'Canny'));
[x1,y1] = find(alledges);
accumulator = zeros(imgsize);
[x2,y2] = size(alledges);
xlength = length(x1)+1;

switch (useGradient)
    case 1
        graydouble = double(gray);
        [x3,y3] = gradient(graydouble);
        array1 = atan2(x3 * -1,y3);
        array1 = double(array1);
        i = 0;
            while(i < xlength-1)
                val = array1(x1(i + 1),y1(i + 1));
                i2 = 1;
                mul1 = radius * cos(val);
                mul2 = radius * sin(val);
                while(i2 <= xlength-1)
                    first = double(x1(i2) + mul1);
                    second = double(y1(i2) + mul2);  
                    first = round(first);
                    second = round(second);
                    if(first < x2 + 1 && first >= 1)
                        if(second < y2 + 1 && second >= 1)
                            accumulator(first,second) = double(accumulator(first,second) + 1);
                        end
                    end
                    i2 = i2 + 1;
                end
                i = i + 1;
            end  
    case 0
        i = 0;
        while(i < xlength-1)
              i2 = 0;
              while(i2 <= 360)
                    mul1 = radius * cos(deg2rad(i2));
                    mul2 = radius * sin(deg2rad(i2));
                    first = double(x1(i + 1) + mul1);
                    second = double(y1(i + 1) + mul2);
                    first = round(first);
                    second = round(second);
                    if(first < x2 + 1 && first >= 1)
                        if(second < y2 + 1 && second >= 1)
                            accumulator(first,second) = double(accumulator(first,second) + 1);
                        end
                    end
                    i2 = i2 + 1;
              end
              i = i + 1;
        end  
end

    temp = max(accumulator(:));
    accumulator = double(accumulator / temp);
    thresh = 0.9;
    
    [c2,c1] = find(accumulator > thresh);
    lenc1 = length(c1);
    lenc1=lenc1+1;
    
    cent = zeros(lenc1-1,2);
    r = zeros(lenc1-1,1);
    
     numRow = size(cent,1);
     for i=1:numRow
         cent(i,1) = c1(i); 
         cent(i,2) = c2(i);
     end

    rlen = size(r,1);
     for i=1:rlen
         r(i,1) = radius; 
     end
    
    centers = cent;
    im(c1,c2,:) = 0;
    
    figure;
    imshow(im);
    viscircles(cent, r);
    
    figure;
    imagesc(accumulator);
end
