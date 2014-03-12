function plothot(R, thetas, xp)
if nargin < 2
    [x y] = size(R);
    thetas = 1:x;
    xp = 1:y;
end
figure
iptsetpref('ImshowAxesVisible','on')
imshow(R,[],'Xdata',thetas,'Ydata',xp,...
            'InitialMagnification','fit');
colormap(hot), colorbar
iptsetpref('ImshowAxesVisible','off')
end
