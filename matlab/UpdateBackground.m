function Out = UpdateBackground(Initial, New)
%initial est la cellule contenant moyenne, moment2 et variance (donc chaque
%elements de la cellule est une matrice), new est une matrice (image)

Dim = size(Initial{1});
VariablesStat = cell(1,3);
VariablesStat{1} = zeros(Dim(1),Dim(2));
VariablesStat{2} = zeros(Dim(1),Dim(2));
VariablesStat{3} = zeros(Dim(1),Dim(2));

for i = 1:Dim(1)
    for j = 1:Dim(2)
        NewMoy = Initial{1}(i,j)*0.999 + New(i,j)*0.001;
        NewMoment2 = Initial{2}(i,j)*0.999 + (New(i,j)^2)*0.001;
        NewVariance = NewMoment2 - NewMoy^2;
        VariablesStat{1}(i,j) = NewMoy;
        VariablesStat{2}(i,j) = NewMoment2;
        VariablesStat{3}(i,j) = 100-NewVariance;
    end
end

Out = VariablesStat;

end