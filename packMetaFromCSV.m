function secsMeta = packMetaFromCSV(secsPath, minMetaPath)
    secs = csvread(secsPath);
    fid = fopen(minMetaPath);
    minMeta = textscan(fid, '%d %d %d %d %d %f32 %q %q %q %q %q %q %d', 'HeaderLines', 1, 'Delimiter',',');
    secsMeta = packMetadata(secs, minMeta);
end