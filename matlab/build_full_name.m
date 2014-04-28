function [full] = build_full_name(name)
global test_name;
global L;
global angle;
full = name;
if numel(test_name) > 0
    full = sprintf('%s-%s', test_name, full);
end
if numel(L) > 0 && numel(angle) > 0
    full = sprintf('%s-%d_%d', full, L, angle);
end
end