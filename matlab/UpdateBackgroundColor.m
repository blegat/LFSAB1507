function Out = UpdateBackgroundColor(Initial, New)
%initial est la cellule contenant moyenne, moment2 et variance (donc chaque
%elements de la cellule est une matrice), new est une matrice (image)

Dim = size(Initial{1});
VariablesStat = cell(1,3);
VariablesStat{1} = zeros(Dim(1),Dim(2),3);
VariablesStat{2} = zeros(Dim(1),Dim(2),3);
VariablesStat{3} = zeros(Dim(1),Dim(2),3);

for i = 1:Dim(1)
    for j = 1:Dim(2)
        for k = 1:3
        NewMoy = Initial{1}(i,j,k)*0.99 + New(i,j,k)*0.01;
        NewMoment2 = Initial{2}(i,j,k)*0.99 + (New(i,j,k)^2)*0.01;
        NewVariance = NewMoment2 - NewMoy^2;
        VariablesStat{1}(i,j,k) = NewMoy;
        VariablesStat{2}(i,j,k) = NewMoment2;
        VariablesStat{3}(i,j,k) = NewVariance;
        end
    end
end

Out = VariablesStat;

end

