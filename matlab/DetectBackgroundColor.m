function Out = DetectBackgroundColor(Serie)%, InitialBackground)
% Take a serie of images in input and in output returns the background
% of the camera of this serie. Serie is a 3D matrix
if length(Serie) == 1
    Dim = size(Serie{1});
    VariablesStat = cell(1,3);
    VariablesStat{1} = double(Serie{1});
    VariablesStat{2} = zeros(Dim(1),Dim(2),3);
    VariablesStat{3} = zeros(Dim(1),Dim(2),3);
else
    Dim = size(Serie{1});
    VariablesStat = cell(1,3);
    VariablesStat{1} = zeros(Dim(1),Dim(2),3);
    VariablesStat{2} = zeros(Dim(1),Dim(2),3);
    VariablesStat{3} = zeros(Dim(1),Dim(2),3);
    Med = zeros(Dim(1),Dim(2),3);
    Quartinf = zeros(Dim(1),Dim(2),3);
    Quartsup = zeros(Dim(1),Dim(2),3);
    Interquart = zeros(Dim(1),Dim(2),3);
    for i = 1:Dim(1)
        for j = 1:Dim(2)
            for k = 1:3
                Tmp2 = VecSerie(Serie, i, j, k);
                Tmp = quantile(Tmp2,[.25 .50 .75]);
                Quartinf(i,j,k) = Tmp(1);
                Med(i,j,k) = Tmp(2);
                Quartsup(i,j,k) = Tmp(3);
                Interquart(i,j,k) = Quartsup(i,j,k) - Quartinf(i,j,k);
                Tmp2 = F1(Tmp2, Interquart(i,j,k), Med(i,j,k));
                VariablesStat{1}(i,j,k) = Tmp2(1);
                VariablesStat{2}(i,j,k) = Tmp2(2);
                VariablesStat{3}(i,j,k) = Tmp2(3);
            end
        end
    end
end

Out = VariablesStat;

end

function A = F1(vec, Interquart, Med)
% calcule la nouvelle moyenne de vec sans tenir compte des valeurs de vac
% qui sont en dehors de [Med - 1.5 Interquart; Med + 1.5 Interquart]
binf = Med - 1.5*Interquart;
bsup = Med + 1.5*Interquart;
Tmp = length(vec);
for i = 1:length(vec)
    if (vec(i) < binf) || (vec(i) > bsup)
        vec(i) = 0;
        Tmp = Tmp - 1;
    end
end
Moy = sum(vec)/Tmp;
Moment2 = sum(vec.^2)/Tmp;
Variance = Moment2 - Moy^2;
A = [Moy Moment2 Variance] ;
end

function Vec = VecSerie(Serie, i, j, k)
vec = zeros(1,length(Serie));
for a = 1:length(Serie)
    vec(a) = Serie{a}(i,j, k);
end
Vec = vec;
end

