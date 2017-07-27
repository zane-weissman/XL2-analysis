function [counts, levels] = createPeopleScatter(data, eqRange)
%% usage
% creates a scatter plot of number of people vs sound level, with a point
% for each instance of number of people indicated within the array of
% data structs "data." The sound level will be the equivalent noise
% pressure of all minutes with the the range "eqRange" - i.e. if eqRange
% = 0 there will be only 1 minute used, for eqRange = n the equivalent
% noise pressure from t-n minutes to t+n minutes will be used for a total
% of (up to) 2n+1 minutes surrounding the minute when the number of people was
% recorded.

counts = []; % vector of people counts
levels = []; % vector of Leqs

for point = data'
    if point.people
        % get number of people and time
        counts(end+1) = point.people;
        t = point.dt;
        
        % generate start and finish times for the range
        start = t;
        finish = t;
        start.Minute = start.Minute - eqRange;
        finish.Minute = finish.Minute + eqRange;
        
        % collect data from range, create Leq
        eqData = data(inMinutes(data, start, finish));
        levels(end+1) = dBavg([eqData.dB]);
    end
end
end