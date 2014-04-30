function [] = save_imageCam (f, name, graph,directory,i)
% graph: 1 export in png
%        2 just show
%        else do nothing
if graph == 1 || graph == 2
    figure();
    if graph == 1
        set(gcf,'Visible','off');
    end
    colormap(gray);
    full_name = build_full_name(name);
    title(full_name);
    set(gcf,'name',full_name,'numbertitle','off');
    %imshow(f/255);
    imshow(double(f)/255);
    axis off;
    if graph == 1
        %saveas(gcf, name, 'png');
        saveas(gcf, sprintf('%s\\%s-%d', directory,full_name, i), 'png');
    end
end
end
