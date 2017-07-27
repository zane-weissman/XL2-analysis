function [avgDiffCounts,sums] = createDiffHists(secsMeta, obsStrings, edges, closeRange, ...
    broadRange)
%% description
% finds all points from the array secsMeta with an observation matching the
% strings in the vector obsStrings. For each point, 3 histograms are created, each using
% bins specified by the vector edges (see doc histograms for more info).
%   1. incidence of noise levels in the range closeRange. closeRange
%   specifies how many adjacent minutes will be included (i.e. closeRange =
%   0 => only use the minute of the occurrence, closeRange = 1 => use 3
%   minutes total
%   2. incidence of noise levels in the range broadRange, not including
%   closeRange. broadRange specifies range in the same way as closeRange.
%   3. differential incidence - essentially histogram 1 minus histogram 2. 
% 
% Finally, creates an average differential histogram - the average of all
% of the histogram 3's
% 
% Returns the associated "counts" for the average differential - the values
% for each bin of the final average differential histogram

%% identiify all points tagged with elements of obsStrings
obsPoints = [];
for str = obsStrings
    obsPoints = vertcat(obsPoints, secsMeta(hasobs(secsMeta,obsStrings)));
end

%% for each point, generate 3 histograms, add to running total
sums = 0;
for point = obsPoints'
    %% 1st hist
    % create start/finish datetimes
    start = point.dt;
    finish = point.dt;
    start.Minute = start.Minute - closeRange;
    finish.Minute = finish.Minute + closeRange;
    
    % gather points
    hist1points = secsMeta(inMinutes(secsMeta, start, finish));
    % create histogram
    figure;
    hist1 = histogram(int8([hist1points.dB]),edges,'normalization','probability');
    hold on;
    %% 2nd hist
    % create start/finish datetimes
    % 2 sets this time - for before and after the closeRange
    start1 = point.dt;
    finish1 = point.dt;
    start2 = point.dt;
    finish2 = point.dt;
    start1.Minute = start1.Minute - broadRange;
    finish1.Minute = finish1.Minute - closeRange - 1;
    start2.Minute = start2.Minute + closeRange + 1;
    finish2.Minute = finish2.Minute + broadRange;
    
    % gather points
    hist2points = vertcat(secsMeta(inMinutes(secsMeta, start1, finish1)),...
                          secsMeta(inMinutes(secsMeta, start2, finish2)));
    % create histogram
    hist2 = histogram(int8([hist2points.dB]),edges,'normalization','probability');
    
    %% 3rd hist 
    
    hist3values = hist1.Values - hist2.Values;
    close
    figure;
    hist3 = histogram([],'Values', hist3values, 'BinEdges', edges);
    close
    sums = sums + hist3values;
end

%% compute average, generate avg hist, return avg diff counts
avgDiffCounts = sums/max(size(obsPoints));
figure;
histogram([],'Values', avgDiffCounts, 'BinEdges', edges)
end