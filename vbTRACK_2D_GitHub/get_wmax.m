function dummy = get_wmax(framedelta,window)
% determines wmax such that window(wmax)< max(frames)for this bead.
% 2013_01_18 gholz
% _2013_04_03 eliminated beadID from variable list

dummy =1;  % initialize
for w=2:length(window)
    if (window(w)<framedelta)
        dummy=dummy+1;
    else
    end
end
return

