function[] = blurring(fspec, len, theta, critEdge)
close all;
load fille;
%figure(2)
%save_image(I,I,2);

%fspecial has differents parameters, 'motion' is the one which is used to
%blur like the train 
h = fspecial(fspec, len, theta);
MotionBlur = imfilter(I,h,'replicate');
save_image(MotionBlur,MotionBlur,2);

%To find the edge following the criteria defined with critEdge
SobelFilter = edge(I,critEdge);
figure(3);
imshow(SobelFilter);
%save_image(SobelFilter,SobelFilter,2);


end
