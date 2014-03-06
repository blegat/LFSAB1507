function [t] = radontest(theta)
close all;
load fille;
%I = imread('guy.jpg');
len = 50;
h = fspecial('motion', len, theta);
f = imfilter(I,h,'replicate');
save_image(f,'MotionBlur',2);
figure
k = 5;

% iptsetpref('ImshowAxesVisible','on')
%
thetas = 10:180;
[R,xp] = radon(f,thetas);
IdRad = radon(ones(size(f)), thetas);
for i = 1:size(IdRad, 1)
    for j = 1:size(IdRad, 2)
        if IdRad(i,j) > 0
            R(i, j) = R(i, j) / IdRad(i, j);
        end
    end
end
%R = R ./ radon(ones(size(f)), thetas);
plot(xp, R);
sumk = zeros(numel(thetas), 1);
for i = 1:numel(thetas)
    s = sort(R(:,i), 'descend');
    sumk(i) = sum(s(1:k));
end

leg = {};

[ssumk index] = sort(sumk, 'descend');
[ssumk]
thetas(index)

t = thetas(index(1));
for i = 1:numel(thetas)
    leg{i} = num2str(thetas(i));
end
legend(leg);
% figure
% imshow(R,[],'Xdata',thetas,'Ydata',xp,...
%             'InitialMagnification','fit')
% xlabel('\thetas (degrees)')
% ylabel('x''')
% colormap(hot), colorbar
% iptsetpref('ImshowAxesVisible','off')
