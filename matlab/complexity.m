%% To compute the complexity of the different deconv, 
%be careful to adjust the tic toc.
% time = zeros(3,20)
% for j =1:3
%     for i=1:20
%         time(j,i) = testBlurDeblur(8,j,80,50,3,16,125*i)
%     end
% 
% end
close all;
load timebw.mat
xi = 1:20;
x = xi.^2;
nbpixelsrow = 125*linspace(1,20,20);
pl = polyfit(xi,time(1,:)/time(1,1),2)
pw = polyfit(xi,time(2,:)/time(2,1),2)
pr = polyfit(xi,time(3,:)/time(3,1),2)
yl = polyval(pl, xi);
yw = polyval(pw, xi);
yr = polyval(pr, xi);

figure()
plot(x, time(1,:)/time(1,1), 'b', x, time(2,:)/time(2,1), 'r', x, time(3,:)/time(3,1), 'g', x, x.^(9/8), 'm', x, x.^(3/4), 'k', x, yl, 'y');
figure()
plot(x, time(1,:)/time(1,1), 'b', x, time(2,:)/time(2,1), 'r', x, time(3,:)/time(3,1), 'g', x, yl, 'm', x, yw, 'c', x, yr, 'k');
legend('Lucy','Wiener','Reg.');
xlabel('number of pixels of picture/number of pixels of initial picture');
ylabel('time needed for picture/time needed for initial picture');
figure()
plot(nbpixelsrow.*nbpixelsrow, time(1,:), 'b', nbpixelsrow.*nbpixelsrow, time(2,:), 'r',nbpixelsrow.*nbpixelsrow, time(3,:), 'g');
%xlabel('$\frac{\textbf{size of picture}}{\textbf{size of initial picture}}$','Interpreter','Latex','FontSize',10);
%ylabel('$\frac{\textbf{time needed for picture}}{\textbf{time needed for initial picture}}$','Interpreter','Latex','FontSize',10)



%% To compute the complexity of length estimator and robust_angle_estimator
% be careful to adjust the tic toc.

time = zeros(1,20);

for i=1:20
    time(i) = testBlurDeblur(8,2,80,50,3,16,125*i)
end


x = 1:20;
x = x.^2;
plot(x, time(1,:)/time(1,1))
legend('Radon');
xlabel('number of pixels of picture/number of pixels of initial picture');
ylabel('time needed for picture/time needed for initial picture');

