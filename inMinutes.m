function [ tf ] = inMinutes( data, start, finish )
% Summary of this function goes here
%   returns an array usable for logical indexing indicating whether or not
%   the elements of an array of "packed" data fall within a range of
%   minutes from start to end, inclusive. start and end must be datetime objects.
%   seconds will be discarded. 

tf = false(max(size(data)),1);

for n = 1:max(size(data))
    if start <= data(n).dt && data(n).dt <= finish
        
        tf(n) = true;
    end
end
end

