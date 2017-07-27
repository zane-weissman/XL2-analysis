hotelling = [];

figure;
hold on
[counts, levels] = createPeopleScatter(vertcat(secsMeta_6_19_jordan,secsMeta_6_25_jordan,secsMeta_7_1_jordan,secsMeta_7_7_jordan),range);
scatter(counts(levels < 60),levels(levels <60))
[fit,S] = polyfit(counts(levels < 60), levels(levels < 60), npoly);
fit
plot(polyval(fit,[2:30]))
for n = 1:max(size(levels))
    if levels(n) < 60
        hotelling = [hotelling; 1 counts(n) levels(n)];
    end
end

[counts, levels] = createPeopleScatter(vertcat(secsMeta_7_18_jordan,secsMeta_7_19_jordan,secsMeta_7_20_jordan),range);
scatter(counts(levels < 60),levels(levels <60))
[fit,S] = polyfit(counts(levels < 60), levels(levels < 60), npoly);
fit
plot(polyval(fit,[2:30]))
for n = 1:max(size(levels))
    if levels(n) < 60
        hotelling = [hotelling; 2 counts(n) levels(n)];
    end
end

T2Hot2ihe(hotelling)