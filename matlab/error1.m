function [err] = error1(I)
diff = I(:,2:end) - I(:,1:end-1);
err = sum(sum(abs(diff)));
end