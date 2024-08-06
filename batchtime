function batchtime()
files = dir('t*.tif');
for k = 1:numel(files)
    nm=files(k).name;
    naym=[nm(1:length(nm)-4) '_times'];
    extracttime(files(k).name,[naym '.mat']);
end
end

function extracttime(stackin,naym)
var=imfinfo(stackin);
z=length(var);
%naym=stackin(1:z-4);
timez=zeros(z,1);
for i=1:z
    timez(i)=var(i).UnknownTags.Value;
end
save(naym,'timez')
end
