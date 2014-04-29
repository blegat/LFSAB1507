function [F] = squareborder (f, b)
s = min(size(f,1),size(f,2)) - 2*b;
F = f(crop(size(f,1), s), crop(size(f, 2), s));
end
function [inter] = crop(from, to)
left = floor((from - to) / 2);
right = from - to - left;
inter = 1+left:from-right;
end