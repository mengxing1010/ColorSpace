function I_down = downsample_image(I_orig,res_limit)

    %% Catch errors
    
    if length(size(I_orig)) ~= 3
        error('Invalid input image')
    end
    
    %%

    ds = 1;
    
    while length(1:ds:size(I_orig,1))>res_limit || length(1:ds:size(I_orig,2))>res_limit
        ds = ds+1;
    end
    
    I_down = I_orig(1:ds:end, 1:ds:end, :);

end