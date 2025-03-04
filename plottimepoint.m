function plottimepoint()
%generate histogram to view
%store combined data in matlab file
%later batch process everything and look at this as checkpoint
%name that as GenerateTimePoint

files = dir('*.mat');
once=1;
ttt='';
AvgVel=[];
InstVel=[];
for k = 1:numel(files)
    temp=files(k).name;
    lookfor=temp(1);
    if lookfor=='M'
        load(temp);
        AvgVel=[AvgVel; avgvelo(:,1)];
        InstVel=[InstVel; velo(:,1)];
        if once==1
            ttt=temp(16:21);
            once=2;
        end
    end
end

NumOfTracks=length(AvgVel);
%plotem(AvgVel,InstVel,NumOfTracks)
plotemrev(AvgVel,InstVel,NumOfTracks) %make upright graphs
pointname=['AllVelocities' ttt];
save(pointname,'AvgVel','InstVel','NumOfTracks')
end

function plotem(timevel,timevels,tracksn)
npts=400;
figure
[xhist,edges]=histcounts(timevel,npts);
yhist=zeros(1,npts);
for i=1:npts
yhist(i)=(edges(i)+edges(i+1))/2;
end
plot(xhist,yhist)
title(['Average BB Velocities: ' int2str(tracksn) ' Tracks']);
hold on
npts=100;
figure
[xhist,edges]=histcounts(timevels,npts);
yhist=zeros(1,npts);
for i=1:npts
yhist(i)=(edges(i)+edges(i+1))/2;
end
plot(xhist,yhist)
title('Instantaneous BB Velocities');
hold off
end

function plotemrev(timevel,timevels,tracksn)
npts=45;
figure
[xhist,edges]=histcounts(timevel,npts);
yhist=zeros(1,npts);
for i=1:npts
yhist(i)=(edges(i)+edges(i+1))/2;
end
plot(yhist,xhist)
title(['Average BB Velocities: ' int2str(tracksn) ' Tracks']);
hold on
npts=100;
figure
[xhist,edges]=histcounts(timevels,npts);
yhist=zeros(1,npts);
for i=1:npts
yhist(i)=(edges(i)+edges(i+1))/2;
end
plot(yhist,xhist)
title('Instantaneous BB Velocities');
hold off
end
