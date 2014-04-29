function [] = save_plot(x, y, name, graph)
    figure();
    if graph == 1
        set(gcf,'Visible','off');
    end
    full_name = build_full_name(name);
    set(gcf,'name',full_name,'numbertitle','off');
    plot(x, y);
    if graph == 1
        saveas(gcf, sprintf('../Images/%s',full_name), 'png');
    end
end