function secsMeta = packMetadata(secs, minMeta)
% packs minutely data with metadata and per-second data into a much more
% readable format

% preallocate cell arrays. these will be written into during the loop, then
% turned into an array of structs
dt_c = cell(size(secs, 1),1);
dB_c = cell(size(secs, 1),1);
obs_c = cell(size(secs, 1),1);
weather_c = cell(size(secs, 1),1);
people_c = cell(size(secs, 1),1);
for n = 1:size(secs,1)
    dt = datetime(secs(n, 1:6));
    dB = secs(n, 7);
    obs = {}; % placeholder
    weather = []; % placeholder
    people = []; % placeholder
    if  dt.Second == 0 % start of minute
        % create a logical index for the corresponding minute
        minInd = (minMeta{1} == dt.Year & ... where year matches...
                  minMeta{2} == dt.Month & ... and month
                  minMeta{3} == dt.Day & ... and day
                  minMeta{4} == dt.Hour &... and hour
                  minMeta{5} == dt.Minute... and minute
                 );
        obs = minMeta{7}(minInd); % get observations                           
        obs = strsplit(obs{end}, ', '); % split by ,
        
        weather = struct( ...
                         'T',     minMeta{8}(minInd),  ...
                         'hum',   minMeta{9}(minInd),  ...
                         'wind',  minMeta{10}(minInd),  ...
                         'prec',  minMeta{11}(minInd),  ...
                         'cover', minMeta{12}(minInd)  ...
                         );
        people = minMeta{13}(minInd);
    end
    % write data into cell arrays
    dt_c{n} = dt;
    dB_c{n} = dB;
    obs_c{n} = obs;
    weather_c{n} = weather;
    people_c{n} = people;
end
% create final struct
secsMeta = struct('dt', dt_c, 'dB', dB_c, 'obs', obs_c, ...
                         'weather', weather_c, 'people', people_c);
end