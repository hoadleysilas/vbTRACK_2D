function [v_bead_state,idx_bead_state] = get_bead_get_state(data, IDNum,STATENum)
size(data)
IDNum
STATENum

if isfield(data, 'id')
    idx = find(data.id == IDNum);
    v.id= data.id(idx);
    v.t = data.t(idx);
    v.frame = data.frame(idx);
    v.x = data.x(idx);
    v.y = data.y(idx);
    v.r = data.r(idx);
    if isfield(data,'roll');    v.roll = data.roll(idx);    end;
    if isfield(data,'pitch');   v.pitch= data.pitch(idx);   end;
    if isfield(data,'yaw');     v.yaw  = data.yaw(idx);     end;                    
else
 idx_bead = find(data(:,3)==IDNum);
 v_bead = data(idx_bead,:);
    idx_bead_state = find(v_bead(:,7)==STATENum);   % col changed 2018_10_01 gh
    v_bead_state = v_bead(idx_bead_state,:);
    
end  
return