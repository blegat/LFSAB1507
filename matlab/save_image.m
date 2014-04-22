function [] = save_image (L, name, graph)
% graph: 1 export in png
%        2 just show
%        else do nothing
if graph == 1 || graph == 2
    figure();
    if graph == 1
        set(gcf,'Visible','off');
    end
    colormap(gray);
    title(name);
    imshow(double(L)/255);
    axis off;
    if graph == 1
        %saveas(gcf, name, 'png');
        saveas(gcf, sprintf('../Images/%s',name), 'png');
    end
end
end