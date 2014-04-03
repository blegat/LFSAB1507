
%% Autoroute
% n = 16;
% A = cell(1,n);
% for i = 1:n
%     A{i} = imread(sprintf('%02d.jpg', i));
% end


%% Terrase
n = 29;
A = cell(1,n);
for i = 1:n
    A{i} = imread(sprintf('P1030%03d.jpg', i));
end

	% Detection du background
 tic
 Out = uint8(DetectBackgroundColor(A)); %Gere les couleurs, moins rapide
 Out = uint8(DetectBackground(A)); % Que en noir et blanc 
 toc
 imshow(Out)


%% Bureau 
n=19;
A=cell(1,n);

for i=1:n
    I = compression(rgb2gray(imread(sprintf('IMG_39%d.JPG',75+i))));
    A{i} = I;
end
   % Detection du background
tic

Out = DetectBackgroundColor(A); %Gere les couleurs, moins rapide
%Out = DetectBackground(A); % Que en noir et blanc 
toc
imshow(uint8(Out{1}));
