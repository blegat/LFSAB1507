%% Terrase

%% background initial (10 images)

n = 10;
A = cell(1,n);
for i = 1:n
    A{i} = imread(sprintf('P1030%03d.jpg', i));
end
% Detection du background
tic
%Out = DetectBackgroundColor(A); %Gere les couleurs, moins rapide
Out = DetectBackground(A); % Que en noir et blanc 
toc
imshow(uint8(Out{1}))

%% changement dynamique du background
close all;
for i = 11:29
    NewBack  = UpdateBackground(Out, imread(sprintf('P1030%03d.jpg', i)));
    figure()
    imshow(uint8(NewBack{1}))
    Out = NewBack;
end
