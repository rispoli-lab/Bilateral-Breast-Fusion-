% calculate FGT volume percentage, input is breast with 0 1 2 3 4 5 6 where
% they are freespace fat 25% 50% 75% 100% and skin respectively
function percentage = FGTpercent(Breast)
FGT = length(find(Breast==2))+ length(find(Breast==3)) +length(find(Breast==4))+length(find(Breast==5));
total = length(find(Breast));
percentage = FGT/total;
end