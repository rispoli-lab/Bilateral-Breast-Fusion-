% fill empty space between two layers in the 1st dimension
function filled = fillcon(unfill)
ref= unfill;
ref(ref ~=0 ) = 1;
ref = logical(ref);
for j = 1:size(unfill,2)
    for k = 1:size(unfill,3)
        a = find(ref(:,j,k),1,'first');
        b = find(ref(:,j,k),1,'last');
        for i = a:b
            if ref(i,j,k) ==0
                unfill(i,j,k) = 1;
            end
        end
    end
end
filled = unfill;
end