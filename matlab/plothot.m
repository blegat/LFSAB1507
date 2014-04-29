function plothot(R, thetas, xp, name, graph)
if nargin < 2
    graph = 2;
    [x y] = size(R);
    thetas = 1:x;
    xp = 1:y;
end
figure
full_name = build_full_name(name);
set(gcf,'name',full_name,'numbertitle','off');
iptsetpref('ImshowAxesVisible','on')
imshow(R,[],'Xdata',thetas,'Ydata',xp,...
            'InitialMagnification','fit');
colormap(hot), colorbar
if graph == 1
    saveas(gcf, sprintf('../Images/%s', full_name), 'png');
end
iptsetpref('ImshowAxesVisible','off')
end
