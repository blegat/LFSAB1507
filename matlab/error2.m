function [err] = error2(I)
diff = I(:,2:end) - I(:,1:end-1);
err = sum(sum(diff.^2));
end