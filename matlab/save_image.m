function [] = save_image (f, name, graph)
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
    imshow(double(f)/255);
    axis off;
    if graph == 1
        %saveas(gcf, name, 'png');
        saveas(gcf, sprintf('../Images/%s',full_name), 'png');
    end
end
end