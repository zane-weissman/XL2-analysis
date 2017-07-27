function createDayGraph(secsMeta, weights, strs, dotscale)
%% usage
% plots dB measurements against times. smooths dB measurements first by
% cross-correlating weights and secsMeta. For best results, ensure that
% sum(weights) = 1 to avoid scaling all results.
%
% then adds a scatter of points with observations matching the strings in
% the vector [strs]. Each point will have an area of the default area times
% dotscale

%% preparatory stuff
% compute actual area
dotArea = dotscale * 36;
% warn if weights will scale results
if sum(weights) ~= 1
    warning('sum(weights) =/= 1; results will be scaled')
end
% number of elements in weights
n_weights = max(size(weights));
%delete(findobj(gca, 'type', 'patch'));figure;
%% plot dBs and times
% compute smoothed dB values
db_smoothed = conv([secsMeta.dB],weights);
% store times
times = [secsMeta.dt];
% shave off both ends to get rid of sums including zeroes (natural
% byproduct of convolution for weighting)
db_smoothed = db_smoothed(n_weights:end-n_weights);
times = times(1:end-n_weights);
plot(times,db_smoothed)
hold on;
%% scatter metadata points
for s = strs
    scatter(datenum([secsMeta(hasobs(secsMeta,s)).dt]),...
        db_smoothed(hasobs(secsMeta,s)), dotArea,...[0.8500 0.3250 0.0980],...
        'filled')
end
hold off;
end
