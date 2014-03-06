function [H,V]=motion(L,theta)
%
%
%

theta=mod(theta,360);
arg=1; %
shift=0;
if (theta>90)&& (theta<180)
    theta=abs(theta-180);
    arg=0;

elseif (theta>=180) && (theta<270)
    theta=theta-180;
elseif (theta>270)
    theta=abs(theta-360);
    arg=0;
end
%split 45º
if(theta>45)
    theta=90-theta;
    shift=1;
end

if(theta<-45)
    theta=-90-theta;
    shift=1;
end

warning off MATLAB:divideByZero
theta=pi*theta/180;
L=L/2;

lx=ceil(L*cos(theta))+1;
ly=ceil(L*sin(theta))+1;


h=zeros(ly,lx);
V=[];
for iy=1:ly
    for ix=1:lx
        [A,v]=areapixel(ix,iy,L,theta);
        h(iy,ix)=A;
        V=[V; v];
    end
end

% [A,v]=areapixel(3,2,L,theta);
% V=v;

% h=h(end:-1:1,:);

if shift && arg
    h=h';
end

if shift && ~arg
    h=h';
end

[ly,lx]=size(h);
H=zeros(2*ly-1,2*lx-1);



if arg
   % angulo positivo
   H(ly:end,1:lx)=h(:,end:-1:1);   
   H(1:ly,lx:end)=h(end:-1:1,:); 
else
   % angulo negativo
   H(ly:end,lx:end)=h;
   H(1:ly,1:lx)=h(end:-1:1,end:-1:1);
end

H=H/sum(H(:));

warning on MATLAB:divideByZero


function [A,v]=areapixel(x,y,L,theta)
% precisao arredondamento
ee=1e-10;

I=[];

%pontos de interseccao da recta a
I=[I;...
   (x-1) tan(theta)*(x-1)+1;... % intersecção com X = x-1
    x    tan(theta)*x+1;...     % intersecção com X = x
    (y-2)/tan(theta) (y-1);...  % intersecção com Y = y-1
    (y-1)/tan(theta) y;];       % intersecção com Y = y


%pontos de interseccao da recta d
I=[I;...
   (x-1) tan(theta)*(x-1)-tan(theta);... % intersecção com X = x-1
    x    tan(theta)*x-tan(theta);...     % intersecção com X = x
    (y-1)/tan(theta)+1 (y-1);...  % intersecção com Y = y-1
    y/tan(theta)+1 y;];       % intersecção com Y = y

%pontos de interseccao da recta b
I=[I;...
    (x-1) L*sin(theta)+1; % intersecção com X=x-1
     x    L*sin(theta)+1; % intersecção com X=x
     L*cos(theta)+1 L*sin(theta)+1; % intersecção de b com c
     L*cos(theta) L*sin(theta)+1;   % intersecção de b com a
   ];

%pontos de interseccao da recta c
I=[I;...
     L*cos(theta)+1  (y-1); % intersecção com Y=y-1
     L*cos(theta)+1   y; % intersecção com Y=y
     L*cos(theta)+1 L*sin(theta);   % intersecção de c com d
   ];

%pontos fronteira do pixel
I=[I; x-1 y;x-1 y-1; x y; x y-1];


%eliminar pontos fora da casa que importa
indices=find(I(:,1)-x+1<-ee);
I(indices,:)=[];

indices=find(I(:,1)-x>ee);
I(indices,:)=[];

indices=find(I(:,2)-y>ee);
I(indices,:)=[];

indices=find(I(:,2)-y+1<-ee);
I(indices,:)=[];
    
%limite b    
indices=find(I(:,2)-L*sin(theta)-1>ee);
I(indices,:)=[];

%limite c
indices=find(I(:,1)-L*cos(theta)-1>ee);
I(indices,:)=[];

%limites recta a

indices=find(I(:,2)-I(:,1)*tan(theta)-1>ee);
 I(indices,:)=[];

%limites recta d
indices=find(I(:,2)-I(:,1)*tan(theta)+tan(theta)<-ee);
I(indices,:)=[];    

%find nan's
indices=find(isnan(I(:,1)));
I(indices,:)=[];  

%Correcção de arredondamentos: precisao 1e-10
ee=1e11;
I=round(I*ee)/ee;
% eliminar pontos repetidos
v=unique(I,'rows');
 
 if (isempty(v) || size(v,1)<3)
     A=0;
 else
%      fprintf('x=%g, y=%g\n',x,y);
     K=convhull(v(:,1),v(:,2));
     v=v(K,:);
     A=polyarea(v(:,1),v(:,2));
 end
