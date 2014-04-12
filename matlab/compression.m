function [ ratio Fchanged ] = compression( I, type )
%COMPRESSION Compress a picture

%Idct = dct(I);
%plothot(Idct);

d = size(I)
ratio = 1;

if type == 1
    if(d(1) > 251)
        centerI = d(1)/2;
       FchangedCenter = I(centerI-62:centerI+62,1:d(2));
        FchangedCorner = I(1:125,1:d(2));
        
    end
    if(d(2) > 251)
        centerI = d(2)/2;
        FchangedCenter = I(1:min(size(FchangedCenter)),centerI-62:centerI+62);
        FchangedCorner = I(1:min(size(FchangedCorner)),1:125);
    end 
    
    %to check which is the most representative, ex : computerGray.jpg
    %We could add other areas
    if(var(FchangedCenter(:))>var(FchangedCorner(:)))
        Fchanged = FchangedCenter;
    else
        Fchanged = FchangedCorner;
    end
        
else
    if max(d(1),d(2)) > 705
        ratio = 705/max(d(1),d(2)); % international norm TO BE CONFIRMED
    end
    Fchanged = imresize(I,ratio);
end

end
