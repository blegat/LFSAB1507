function Out = DetectBackground(Serie)%, InitialBackground)
% Prend une serie d'images en input et en output renvoie le background de
% la caméra de cette série. Serie est une "matrice" à 3 dimensions

Dim = size(Serie{1});
Moy = zeros(Dim(1),Dim(2));
Med = zeros(Dim(1),Dim(2));
Quartinf = zeros(Dim(1),Dim(2));
Quartsup = zeros(Dim(1),Dim(2));
Interquart = zeros(Dim(1),Dim(2));
for i = 1:Dim(1)
    for j = 1:Dim(2)
        Tmp2 = VecSerie(Serie, i, j);
        Tmp = quantile(Tmp2,[.25 .50 .75]);
        Quartinf(i,j) = Tmp(1);
        Med(i,j) = Tmp(2);
        Quartsup(i,j) = Tmp(3);
        Interquart(i,j) = Quartsup(i,j) - Quartinf(i,j);
        Moy(i,j) = round(F1(Tmp2, Interquart(i,j), Med(i,j)));
    end
end

Out = Moy;

end

function A = F1(vec, Interquart, Med)
% calcule la nouvelle moyenne de vec sans tenir compte des valeurs de vac
% qui sont en dehors de [Med - 1.5 Interquart; Med + 1.5 Interquart]
binf = Med - 1*Interquart;
bsup = Med + 1*Interquart;
Tmp = length(vec);
for i = 1:length(vec)
    if (vec(i) < binf) || (vec(i) > bsup)
        vec(i) = 0;
        Tmp = Tmp - 1;
    end
end
A = sum(vec)/Tmp;
end

function Vec = VecSerie(Serie, i, j)
vec = zeros(1,length(Serie));
for a = 1:length(Serie)
    vec(a) = Serie{a}(i,j);
end
Vec = vec;
end