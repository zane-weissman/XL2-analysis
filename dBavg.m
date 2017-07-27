function avg = dBavg( dBs )
%DBAVG Summary of this function goes here
%   returns the the power average avg of an array of decibel levels dBs
%   discards any elements of dBs equal to inf

sum = 0;
d_count = 0;
for d = dBs
    if d ~= inf
        sum = sum + db2pow(d);
        d_count = d_count+1;
    end
end
meanPow = sum/d_count;
avg = pow2db(meanPow);
end

