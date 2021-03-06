function createMinutely(secCSVPath)
%%CREATEMINUTELY 
%   takes an argument "secondsCSVPath" - a string specifying the location 
%   of a CSV file generated by createCSV.py or in the same format,
%   containing LAeq data parsed from an XL2 acoustic analyzer.

%   creates a new CSV file and writes into it the same data, but 
%   as if LAeq were sampled once per minute.


%% prepare new CSV
% if old CSV path was foo/bar.baz.csv, 
% new path will be    foo/bar.baz.min.csv

minCSVPath = strsplit(secCSVPath, '.'); % split around .'s
minCSVPath(end+1) = minCSVPath(end); % copy file extension
minCSVPath(end-1) = {'min'}; % insert 'min' just before file extension
disp('New file will be created at:')
minCSVPath = ['mins' filesep strjoin(minCSVPath,'.')] % insert .'s 

%% compute and write minute-level averages

secs = csvread(secCSVPath);
%mins = zeros(size(secs)-[0,1]); % needs one less column, no seconds

lastMin = Inf; % placeholder to indicate start of loop
dBs = Inf(1,60); % placeholder
mins_ind = 1; % index for minutes array
for n = 1:size(secs,1) % loop through rows
    currMin = secs(n, 5);
    
    %% new minute
    if currMin ~= lastMin 
        % wrap up old vector
        if dBs ~= Inf(1, 60) % if there is actual data in the old vector
            % store previous time and avg of collected dBs
            mins(mins_ind,:) = [secs(n-1,1:5),dBavg(dBs)];
            mins_ind = mins_ind + 1; 
            %dBs
        end
        % start new vector
        dBs = Inf(1,60); % create empty vector of dBs for this minute
                         % use Inf as placeholder
    end
    
    %% on each iteration
    dBs(find(dBs==inf,1)) = secs(n, 7); % put dB into first non-placeholder
    lastMin = secs(n, 5);
end
%% one last new minute was not accounted for
% store previous time and avg of collected dBs
mins(mins_ind,:) = [secs(n-1,1:5),dBavg(dBs)];
fid = fopen(minCSVPath,'wt');
fprintf(fid,'%s',['year, mo, day, hr, min, db, obs, T, hum, wind spd, prec, cover, people' 10]);
dlmwrite (minCSVPath, mins, '-append');
%csvwrite(minCSVPath,mins);
end

