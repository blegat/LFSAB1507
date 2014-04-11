function bg = background_estimator (diff, len, angle)
% TODO make the diff between the blurred bg

rd = imrotate(diff, -angle);
rbg = zeros(size(rd));
for i = 1:size(rd,1)
    for j = len:size(rd,2)-len+1
        % FIXME if len == 0
        % u'(0) \approx (U_{h} - U_{-h}) / 2h
        % number of foreground pixels
        flen = round(rd(i,j)/255*len);
        slope = sign(rd(i,j+1) - rd(i,j-1));
        if slope >= 0
            start = j+len-flen;
        else
            start = j;
        end
        for k = start:start+flen-1
            rbg(i,k) = rbg(i,k) + 1/len;
        end
    end
end
save_image(rbg*255, 'rbg', 2);
bg = imrotate(rbg, angle);
% do it after or before the rotation ? That is the question !
%bg(bg < 0.5) = 0;
%bg(bg >= 0.5) = 255;
bg = bg * 255;
end