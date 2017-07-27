function [ tf ] = hasobs( data, str )
%HASOBS Summary of this function goes here
%   returns an array usable for logical indexing indicating whether or not
%   the elements of an array of "packed" data have a certain observation
%   associated with them

tf = false(max(size(data)),1);

for n = 1:max(size(data))
    if ~isempty(data(n).obs)
        f = strfind(data(n).obs, str);
        if iscell(f)
            if isequal(size(f),[1,])
                if f{:}
                    tf(n) = true;
                end
            else
                if [f{:}]
                    tf(n) = true;
                end
            end
        else
            if f
                tf(n) = true;
            else
                tf(n) = false;
            end
        end
    end

end
end

