
%% Autoroute
% A1 = imread('1.jpg');
% A2 = imread('2.jpg');
% A3 = imread('3.jpg');
% A4 = imread('4.jpg');
% A5 = imread('5.jpg');
% A6 = imread('6.jpg');
% A7 = imread('7.jpg');
% A8 = imread('8.jpg');
% A9 = imread('9.jpg');
% A10 = imread('10.jpg');
% A11 = imread('11.jpg');
% A12 = imread('12.jpg');
% A13 = imread('13.jpg');
% A14 = imread('14.jpg');
% A15 = imread('15.jpg');
% A16 = imread('16.jpg');
% A = {A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16};




%% Terrase
% 
% 
% A1 = imread('P1020998.jpg');
% A2 = imread('P1020999.jpg');
% A3 = imread('P1030001.jpg');
% A4 = imread('P1030002.jpg');
% A5 = imread('P1030003.jpg');
% A6 = imread('P1030004.jpg');
% A7 = imread('P1030005.jpg');
% A8 = imread('P1030006.jpg');
% A9 = imread('P1030007.jpg');
% A10 = imread('P1030008.jpg');
% A11 = imread('P1030009.jpg');
% A12 = imread('P1030010.jpg');
% A13 = imread('P1030011.jpg');
% A14 = imread('P1030012.jpg');
% A15 = imread('P1030013.jpg');
% A16 = imread('P1030014.jpg');
% A17 = imread('P1030015.jpg');
% A18 = imread('P1030016.jpg');
% A19 = imread('P1030017.jpg');
% A20 = imread('P1030018.jpg');
% A21 = imread('P1030019.jpg');
% A22 = imread('P1030020.jpg');
% A23 = imread('P1030021.jpg');
% A24 = imread('P1030022.jpg');
% A25 = imread('P1030023.jpg');
% A26 = imread('P1030024.jpg');
% A27 = imread('P1030025.jpg');
% A28 = imread('P1030026.jpg');
% A29 = imread('P1030027.jpg');
% A30 = imread('P1030028.jpg');
% A31 = imread('P1030029.jpg');
% A = {A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A30 A31};
% 
% Detection du background
% tic
% Out = uint8(DetectBackgroundColor(A)); %Gere les couleurs, moins rapide
% Out = uint8(DetectBackground(A)); % Que en noir et blanc 
% toc
% imshow(Out)


%% Bureau 
n=19;
A=cell(1,n);

for i=1:n
    I = compression(rgb2gray(imread(sprintf('IMG_39%d.JPG',75+i))));
    A{i} = I;
end
   % Detection du background
tic
Out = uint8(DetectBackgroundColor(A)); %Gere les couleurs, moins rapide
%Out = uint8(DetectBackground(A)); % Que en noir et blanc 
toc
imshow(Out)