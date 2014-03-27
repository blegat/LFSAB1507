function [x, y] =  max_coord_mat (A)
[max_in_col, ind_in_col] = max(A);
[max_max, ind_col] = max(max_in_col);
y = ind_col;
x = ind_in_col(ind_col);
end