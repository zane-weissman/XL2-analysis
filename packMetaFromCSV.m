function secsMeta = packMetaFromCSV(secsPath, minMetaPath)
%%
% Creates a secsMeta structure array from the CSVs located at the file paths 
% secsPath and minMetaPath
% This structure has the following fields:
% - dt: a datetime object specifying a time at which a noise level was recorded
% - dB: the equivalent A-weighted noise level in dB(A)
% - obs: a cell array of strings - one for each observation corresponding to
%    the time
% - weather: a structure containing the following fields with data about the 
%    weather at the corresponding time:
%   - T: the temperature in degrees F
%   - hum: the humidity in relative percent
%   - wind: wind speed in mph
%   - prec: the amount of precipitation in inches
%   - cover: the amount of cloud cover, as a string
% - people: the number of people in a panoramic photo taken at the 
%    corresponding time

    secs = csvread(secsPath);
    fid = fopen(minMetaPath);
    minMeta = textscan(fid, '%d %d %d %d %d %f32 %q %q %q %q %q %q %d', 'HeaderLines', 1, 'Delimiter',',');
    secsMeta = packMetadata(secs, minMeta);
end
