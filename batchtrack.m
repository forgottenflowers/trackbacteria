function batchtrack()
files = dir('m*.tif');
for k = 1:numel(files)
    disp(files(k).name);
    trackem(files(k).name);
end
end
