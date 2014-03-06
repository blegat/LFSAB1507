function [F] = bordSobel(I,meth,tresh,direction)
if nargin == 1
    meth=1;
    tresh=0.0215;
    direction='vertical';
end
if meth==1
    BW=edge(I,'sobel',tresh,direction);
end
if meth==2
    BW=edge(I,'prewitt', tresh, direction);
end
