function [ ratio Fchanged ] = compression( I, type )
%COMPRESSION Compress a picture

%Idct = dct(I);
%plothot(Idct);

d = size(I);
ratio = 1;
FchangedCenter = I;
FchangedCorner = I;    
if type ==1
    %256 is a standard size for picture and around 0.9 sec to compute
    %robust_angle_estimator
    if(d(1) > 256)
        centerI = d(1)/2;
        FchangedCenter = I(centerI-128:centerI+127,1:d(2));
        FchangedCorner = I(1:256,1:d(2));
        
    end
    if(d(2) > 256)
        centerI = d(2)/2;
        FchangedCenter = I(1:min(size(FchangedCenter)),centerI-128:centerI+127);
        FchangedCorner = I(1:min(size(FchangedCorner)),1:256);
    end
    
    %to check which is the most representative, ex : computerGray.jpg
    %We could add other areas
    if(d(1) >256 && d(2) >256)
        if(var(FchangedCenter(:))>var(FchangedCorner(:)))
            Fchanged = FchangedCenter;
        else
            Fchanged = FchangedCorner;
        end
    else
        Fchanged = I;
    end
    
    
elseif type ==2
    sizeFormat = 500;
    if max(d(1),d(2)) > sizeFormat
        ratio = sizeFormat/max(d(1),d(2)); % international norm TO BE CONFIRMED
    end
    tic
    Fchanged = imresize(I,ratio, 'Lanczos3');
    toc
else    
    Fchanged = I ;
end

end
