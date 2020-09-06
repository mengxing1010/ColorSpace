function scale_image_Lab

    %%
    
    clear
    clc
    
    %% Inputs
    
    filename = 'IMG_2901.jpg';
    
    scale_default  = [1 1 1];
    offset_default = [0 0 0];
    
    %%
    
    RGB_orig   = imread(filename); % input
    RGB_down   = [];
    RGB_scaled = RGB_orig; % output
    
    name      = regexprep(filename,'\..+','');
    extension = regexprep(filename,'.+\.','');
    column_split = round(size(RGB_orig,2)/2);
    specs = '';
         
    %% Set up GUI elements
        
    figure(4)
        clf
        set(gcf,'color','white')
        pos = get(gcf,'position');
        set(gcf,'position',[pos(1:2) 450 450])
    
        Slider.pos_x = 190;
        Slider.pos_y = 410;
        
        Slider.dims = [250 20]; % px
        Slider.spacing_small = 30;
        Slider.spacing_large = 60;

        Text.font_size = 8;
        Text.dims = [200 20];
        Text.pos_x = Slider.pos_x-Text.dims(1)-10;

        Slider.Lightness_Scale.lims = [0 5];
        Slider.Lightness_Scale.pos = [Slider.pos_x Slider.pos_y Slider.dims];
        Slider.Lightness_Scale.handle = uicontrol('Style','slider','Min',min(Slider.Lightness_Scale.lims),'Max',max(Slider.Lightness_Scale.lims),'Value',1.0,'Position',Slider.Lightness_Scale.pos);
        set(Slider.Lightness_Scale.handle,'Callback',@(hObject,eventdata) update_figures)
        uicontrol('Style','text','String',['Value Scale, ' num2str(min(Slider.Lightness_Scale.lims)) ' to ' num2str(max(Slider.Lightness_Scale.lims))],'Position',[Text.pos_x Slider.Lightness_Scale.pos(2) Text.dims],'FontSize',Text.font_size,'BackgroundColor','w','HorizontalAlignment','right');
        
        Slider.Lightness_Offset.lims = [-100 100];
        Slider.Lightness_Offset.pos = [Slider.pos_x Slider.Lightness_Scale.pos(2)-Slider.spacing_small Slider.dims];
        Slider.Lightness_Offset.handle = uicontrol('Style','slider','Min',min(Slider.Lightness_Offset.lims),'Max',max(Slider.Lightness_Offset.lims),'Value',0,'Position',Slider.Lightness_Offset.pos);
        set(Slider.Lightness_Offset.handle,'Callback',@(hObject,eventdata) update_figures)
        uicontrol('Style','text','String',['Value Offset, ' num2str(min(Slider.Lightness_Offset.lims)) ' to ' num2str(max(Slider.Lightness_Offset.lims))],'Position',[Text.pos_x Slider.Lightness_Offset.pos(2) Text.dims],'FontSize',Text.font_size,'BackgroundColor','w','HorizontalAlignment','right');
        
        Slider.Hue_Scale.lims = [0 10];
        Slider.Hue_Scale.pos = [Slider.pos_x Slider.Lightness_Offset.pos(2)-Slider.spacing_large Slider.dims];
        Slider.Hue_Scale.handle = uicontrol('Style','slider','Min',min(Slider.Hue_Scale.lims),'Max',max(Slider.Hue_Scale.lims),'Value',1.0,'Position',Slider.Hue_Scale.pos);
        set(Slider.Hue_Scale.handle,'Callback',@(hObject,eventdata) update_figures)
        uicontrol('Style','text','String',['Hue Scale, ' num2str(min(Slider.Hue_Scale.lims)) ' to ' num2str(max(Slider.Hue_Scale.lims))],'Position',[Text.pos_x Slider.Hue_Scale.pos(2) Text.dims],'FontSize',Text.font_size,'BackgroundColor','w','HorizontalAlignment','right');
        
        Slider.Hue_Offset.lims = [0 360];
        Slider.Hue_Offset.pos = [Slider.pos_x Slider.Hue_Scale.pos(2)-Slider.spacing_small Slider.dims];
        Slider.Hue_Offset.handle = uicontrol('Style','slider','Min',min(Slider.Hue_Offset.lims),'Max',max(Slider.Hue_Offset.lims),'Value',0,'Position',Slider.Hue_Offset.pos);
        set(Slider.Hue_Offset.handle,'Callback',@(hObject,eventdata) update_figures)
        uicontrol('Style','text','String',['Hue Offset, ' num2str(min(Slider.Hue_Offset.lims)) ' to ' num2str(max(Slider.Hue_Offset.lims)) '°'],'Position',[Text.pos_x Slider.Hue_Offset.pos(2) Text.dims],'FontSize',Text.font_size,'BackgroundColor','w','HorizontalAlignment','right');
        
        Slider.Saturation_Scale.lims = [0 10];
        Slider.Saturation_Scale.pos = [Slider.pos_x Slider.Hue_Offset.pos(2)-Slider.spacing_large Slider.dims];
        Slider.Saturation_Scale.handle = uicontrol('Style','slider','Min',min(Slider.Saturation_Scale.lims),'Max',max(Slider.Saturation_Scale.lims),'Value',1.0,'Position',Slider.Saturation_Scale.pos);
        set(Slider.Saturation_Scale.handle,'Callback',@(hObject,eventdata) update_figures)
        uicontrol('Style','text','String',['Saturation Scale, ' num2str(min(Slider.Saturation_Scale.lims)) ' to ' num2str(max(Slider.Saturation_Scale.lims))],'Position',[Text.pos_x Slider.Saturation_Scale.pos(2) Text.dims],'FontSize',Text.font_size,'BackgroundColor','w','HorizontalAlignment','right');
        
        Slider.Saturation_Offset.lims = [-50 50];
        Slider.Saturation_Offset.pos = [Slider.pos_x Slider.Saturation_Scale.pos(2)-Slider.spacing_small Slider.dims];
        Slider.Saturation_Offset.handle = uicontrol('Style','slider','Min',min(Slider.Saturation_Offset.lims),'Max',max(Slider.Saturation_Offset.lims),'Value',0,'Position',Slider.Saturation_Offset.pos);
        set(Slider.Saturation_Offset.handle,'Callback',@(hObject,eventdata) update_figures)
        uicontrol('Style','text','String',['Saturation Offset, ' num2str(min(Slider.Saturation_Offset.lims)) ' to ' num2str(max(Slider.Saturation_Offset.lims))],'Position',[Text.pos_x Slider.Saturation_Offset.pos(2) Text.dims],'FontSize',Text.font_size,'BackgroundColor','w','HorizontalAlignment','right');
        
        Slider.Preview_Resolution.lims = [100 1000];
        Slider.Preview_Resolution.pos = [Slider.pos_x Slider.Saturation_Offset.pos(2)-Slider.spacing_large Slider.dims];
        Slider.Preview_Resolution.handle = uicontrol('Style','slider','Min',min(Slider.Preview_Resolution.lims),'Max',max(Slider.Preview_Resolution.lims),'Value',round(mean(Slider.Preview_Resolution.lims)),'Position',Slider.Preview_Resolution.pos);
        set(Slider.Preview_Resolution.handle,'Callback',@(hObject,eventdata) update_figures)
        uicontrol('Style','text','String',['Preview Resolution, ' num2str(min(Slider.Preview_Resolution.lims)) ' to ' num2str(max(Slider.Preview_Resolution.lims)) ' px'],'Position',[Text.pos_x Slider.Preview_Resolution.pos(2) Text.dims],'FontSize',Text.font_size,'BackgroundColor','w','HorizontalAlignment','right');
        
        Button.Restore_Defaults.pos = [Slider.pos_x Slider.Preview_Resolution.pos(2)-Slider.spacing_large Slider.dims];
        Button.Restore_Defaults.handle = uicontrol('Style', 'pushbutton', 'String', 'Restore Defaults','Position', Button.Restore_Defaults.pos,'BackgroundColor',zeros(1,3)+0.85,'FontSize',Text.font_size,'Value',0);
        set(Button.Restore_Defaults.handle,'Callback',@(hObject,eventdata) restore_defaults)
        
        Button.Compare_Images.pos = [Slider.pos_x Button.Restore_Defaults.pos(2)-Slider.spacing_small Slider.dims];
        Button.Compare_Images.handle = uicontrol('Style', 'pushbutton', 'String', 'Compare Images','Position', Button.Compare_Images.pos,'BackgroundColor',zeros(1,3)+0.85,'FontSize',Text.font_size,'Value',0);
        set(Button.Compare_Images.handle,'Callback',@(hObject,eventdata) compare_images)
        
        Button.Export_Image.pos = [Slider.pos_x Button.Compare_Images.pos(2)-Slider.spacing_small Slider.dims];
        Button.Export_Image.handle = uicontrol('Style', 'pushbutton', 'String', 'Export Image','Position', Button.Export_Image.pos,'BackgroundColor',zeros(1,3)+0.85,'FontSize',Text.font_size,'Value',0);
        set(Button.Export_Image.handle,'Callback',@(hObject,eventdata) update_figures)
        
    update_figures

    %% Main body

    function update_figures
        
        specs = [
                    '_L_scl_' num2str(get(Slider.Lightness_Scale.handle,'value'))...
                    '_L_off_' num2str(get(Slider.Lightness_Offset.handle,'value'))...
                    '_H_scl_' num2str(get(Slider.Hue_Scale.handle,'value'))...
                    '_H_off_' num2str(get(Slider.Hue_Offset.handle,'value'))...
                    '_S_scl_' num2str(get(Slider.Saturation_Scale.handle,'value'))...
                    '_S_off_' num2str(get(Slider.Saturation_Offset.handle,'value'))...
                ];
        
        % Prepare images

        if get(Button.Export_Image.handle,'value')
            res_limit = Inf; % full-size
        else
            res_limit = get(Slider.Preview_Resolution.handle,'value');
        end
        
        RGB_down = downsample_image(RGB_orig, res_limit);
        Lab_down = rgb2lab(RGB_down);

        L = Lab_down(:,:,1);
        a = Lab_down(:,:,2);
        b = Lab_down(:,:,3);
        L = L(:);
        a = a(:);
        b = b(:);
        
%         figure(1)
%             clf
%             set(gcf,'color','white')
%             image(RGB_down)
%             axis tight
%             axis equal
        
        % 1: Value
        % 2: Hue (Angle)
        % 3: Saturation (Radius)

        scale  = [  
                    get(Slider.Lightness_Scale.handle, 'value')
                    get(Slider.Hue_Scale.handle,       'value')
                    get(Slider.Saturation_Scale.handle,'value')
                 ];

        offset = [
                    get(Slider.Lightness_Offset.handle,'value')
                    get(Slider.Hue_Offset.handle,'value')
                    get(Slider.Saturation_Offset.handle,'value')
                 ];
        
        % Scale image in Lab space

        Lab_scaled = Lab_down;
        
        Properties_Original = zeros(numel(Lab_down(:,:,1)),3);
        Properties_Scaled   = zeros(numel(Lab_down(:,:,1)),3);

        Angle  = atan2d(b,a);
        Radius = sqrt(a.^2+b.^2);
        
        Properties_Original(:,1) = L;
        Properties_Original(:,2) = Angle;
        Properties_Original(:,3) = Radius;

        % Perform linear transforms
        L_     = L*     scale(1)+offset(1);
        Angle  = Angle *scale(2)+offset(2);
        Radius = Radius*scale(3)+offset(3);
        
        Properties_Scaled(:,1) = L_;
        Properties_Scaled(:,2) = Angle;
        Properties_Scaled(:,3) = Radius;

        a_ = cosd(Angle).*Radius;
        b_ = sind(Angle).*Radius;

        sz = [size(Lab_down,1) size(Lab_down,2)];
        Lab_scaled(:,:,1) = reshape(L_,sz);
        Lab_scaled(:,:,2) = reshape(a_,sz);
        Lab_scaled(:,:,3) = reshape(b_,sz);

        RGB_scaled = uint8(lab2rgb(Lab_scaled)*255);

        % %

        figure(2)
            clf
            set(gcf,'color','white')

            bin_qty = 256;

            for iter = 1:2

                bin_edges   = zeros(bin_qty+1,3);
                bin_centers = zeros(bin_qty,  3);
                bin_counts  = zeros(size(bin_centers));

                lim_min = zeros(1,3);
                lim_max = zeros(1,3);
                range = zeros(1,3);

                switch iter
                    case 1
                        I = Properties_Original;
                        plot_linecolor = 'k';
                        plot_linestyle = '-';
                        plot_linewidth = 1;
                    case 2
                        I = Properties_Scaled;
                        plot_linecolor = 'r';
                        plot_linestyle = '--';
                        plot_linewidth = 1;
                end

                for cc = 1:3

                    lim_min(cc) = min(I(:,cc));
                    lim_max(cc) = max(I(:,cc));
                    range(cc)   = lim_max(cc)-lim_min(cc);

                    bin_edges(:,cc) = linspace(lim_min(cc),lim_max(cc),bin_qty+1);
                    bin_width = abs(diff(bin_edges(1:2,:)));
                    bin_centers(:,cc) = bin_edges(1:end-1,cc) + bin_width(cc)/2;
                    [n,~] = histcounts(I(:,cc),bin_edges(:,cc));
                    bin_counts(:,cc) = n;

                    subplot(3,1,cc)
                        hold on
                        plot(bin_centers(:,cc),bin_counts(:,cc),'Color',plot_linecolor,'LineStyle',plot_linestyle,'LineWidth',plot_linewidth)
                        switch cc
                            case 1
                                xlim([0 100])
                                xlabel('Value, Distance Along Neutral Axis')
                            case 2
                                xlabel('Hue, Angle About Neutral Axis, °')
                            case 3
                                xlim([0 100])
                                xlabel('Saturation, Radius From Neutral Axis')
                        end
                        ylabel('Number of Pixels')

                    if iter==2
                        legend({'Original','Scaled'},'location','northwest')
                        grid on
                        grid minor
                    end

                end

            end

        figure(3)
            clf
            set(gcf,'color','white')
            image(RGB_scaled)
            title(['\rm' regexprep(specs(2:end),'_','\\_')])
            axis equal
            axis tight
            
        if get(Button.Export_Image.handle,'value')

            RGB_comp = [RGB_orig(:,1:column_split,:), RGB_scaled(:,column_split+1:end,:)]; % comparison image

            name_result  = [name          specs '.' extension];
            name_compare = [name '_comp' specs '.' extension];
            
            imwrite(RGB_scaled,name_result)
            imwrite(RGB_comp,  name_compare)
            
            disp(['Saved ' name_result])
            disp(['Saved ' name_compare])
            
        end
        
        figure(4) % return focus to control panel
        
    end

    %% Button functions

    function restore_defaults
        
        set(Slider.Lightness_Scale.handle,   'value', scale_default(1))
        set(Slider.Hue_Scale.handle,         'value', scale_default(2))
        set(Slider.Saturation_Scale.handle,  'value', scale_default(3))

        set(Slider.Lightness_Offset.handle,  'value', offset_default(1))
        set(Slider.Hue_Offset.handle,        'value', offset_default(2))
        set(Slider.Saturation_Offset.handle, 'value', offset_default(3))

        set(Slider.Preview_Resolution.handle,'value', round(mean(Slider.Preview_Resolution.lims)))

        update_figures
        
    end

    function compare_images
        figure(3)
            clf
            
            image(RGB_down)
            axis equal
            axis tight
            
            drawnow
            pause(1)
            
            image(RGB_scaled)
            axis equal
            axis tight
            title(['\rm' regexprep(specs(2:end),'_','\\_')])
            drawnow

    end

end



















































