function beadIDmax = get_beadIDmax(data)
% Extracts the maximum beadID in dataset.
%  06/27/05 - jcribb.
%  changed return variable v ->beadIDmax  gholz
% _2013_04_01
%
video_tracking_constants2;

% determine whether the input data is in the table or structure of vectors
% format...
if isfield(data, 'id')
    beadIDmax = max(data.id);
else
    beadIDmax = max(data(:, ID));  % ID =3 in video_tracking_constants2
end
