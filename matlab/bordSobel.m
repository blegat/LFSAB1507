function [F] = bordSobel(I,meth,tresh,direction)
%
if nargin == 1
    meth=1;
    tresh=0.0215;
    direction='vertical';
end
if meth==1
    BW=edge(I,'sobel');%,tresh,direction);
end
if meth==2
    BW=edge(I,'prewitt');%, tresh, direction);
end
if meth==3
    BW=edge(I,'canny');%, tresh, direction);
end
global_blur=0;
t=0;
[m,n]=size(I);
for i=1:m
    for j=1:n
        if BW(i,j)==1
            [max,locs_max]=findpeaks(I(i,:));
            [min,locs_min]=findpeaks(-1.*I(i,:));
            indice_max_local=proxy(locs_max,j);
            indice_min_local=proxy(locs_min,j);
            local_blur=abs(indice_max_local-indice_min_local);
            global_blur=global_blur+local_blur;
            t=t+1;
        end
    end
end
F=global_blur/t;
end

function [v] = proxy(X,k)
q=abs(k-X(1));
v=X(1);
for i=2:length(X)
    if abs(k-X(i))<q
        q=abs(k-X(i));
        v=X(i);
    end
end
end
