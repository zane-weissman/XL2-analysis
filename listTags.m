function tags = listTags(secsMeta)
tags = {''};
for obs = [secsMeta.obs]
    ob = [obs{:}];
    if ~strcmp(tags, ob)
        tags = {tags{:},ob};
    end
end
tags = sort(tags);
tags = tags';
end