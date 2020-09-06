function [ error ] = compute_Quantization_Error(origImg, quantizedImg )
doubles = (double(quantizedImg) - double(origImg)).^2;
[~,~,channels]= size(origImg);
for i=1:channels
    doubles = sum(doubles);
end
error = doubles;
end