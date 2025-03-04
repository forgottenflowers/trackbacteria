% this code recognizes and tracks the movement of bacteria frame-by-frame through a video.
% also generates plots and video if desired.

function trackem(stackin)
%tracking for single video
%takes about 80 seconds
%saves result as matlab data file and displays histograms
%can look at video if you want to, but that would take 2 hrs

tic
%to keep track of the time it takes

maxtrackspots=4; %filter can be adjusted, or adjust cost

%localize
var=imfinfo(stackin);
z=length(var); %z is number of frames
positions(z)=struct();
totspots=0;
for i=1:z
    [cents,nums]=lokalize(double(imread(stackin,i)));
    positions(i).ForEachFrame=cents;
    totspots=totspots+nums;
end
totspots
mainmat=zeros(totspots,4); %posx posy time identifier

%from metadata
nhm=[stackin(5:length(stackin)-4) '_times.mat'];
load(nhm);

siz=0;
for i=1:z
    temp=siz+size(positions(i).ForEachFrame,1);
    mainmat(siz+1:temp,1:2)=positions(i).ForEachFrame;
    %mainmat(siz+1:temp,3)=i; %can later make it metadata_time(i)
    mainmat(siz+1:temp,3)=timez(i); %here it is! Choose only one
    siz=temp;
end

%track
idfier=size(positions(1).ForEachFrame,1);
for i=1:idfier
    mainmat(i,4)=i;
end
next=0;
secind=0;
for i=1:z-1
    %i
    start=positions(i).ForEachFrame;
    stop=positions(i+1).ForEachFrame;
    [trek,unt]=tracost(start,stop);
    next=next+size(start,1);
    for m=1:size(trek,1)
        mainmat(trek(m,2)+next,4)=mainmat(trek(m,1)+secind,4);
    end
    secind=next;
    for m=1:size(unt,1)
        idfier=idfier+1;
        mainmat(unt(m)+next,4)=idfier;
    end
end
matrix=sortrows(mainmat,4);

%get velocities
velo=[];
for i=2:size(matrix,1)
    if matrix(i-1,4)~=matrix(i,4)
        continue
    end
    velo=[velo; sqrt((matrix(i,1)-matrix(i-1,1))^2+(matrix(i,2)-matrix(i-1,2))^2)/...
        (matrix(i,3)-matrix(i-1,3)) matrix(i,4)];
end

%adjust scale
velo(:,1)=velo(:,1).*108.33; %1px=0.108um, 1s=1000ms, speed is in um/s
%mind you, this is 2d projection of actual motion
%the real velocity peak will be sqrt(3/2) of peak value

%avg velocities
avgvelo=[];
start=1;
filter=[]; %filter
for i=2:size(velo,1)
    if velo(i,2)~=velo(i-1,2)
        if length(start:i-1)>maxtrackspots
            avgvelo=[avgvelo; mean(velo(start:i-1,1)) velo(i-1,2)];
        else
            filter=[filter start:i-1];
        end
        start=i;
    end
end
if length(start:size(velo,1))>3
    avgvelo=[avgvelo; mean(velo(start:size(velo,1),1)) velo(size(velo,1),2)];
else
    filter=[filter start:size(velo,1)];
end
velo=removerowz(velo,filter);

%plot histogram
plotem(avgvelo(:,1),velo(:,1))

%save('Matrix','matrix')
nameit=['Matrix_' stackin(5:length(stackin)-4) '.mat'];
save(nameit,'matrix','velo','avgvelo')
toc

%generate video - optional - lets you watch and save video
%suppress plotting histogram if you call this, since they interfere
%beware! This may take 2 hours!
%also, one track (last one) may not show up
%watchvideo(stackin,matrix)
end

function [centerz,numspots]=lokalize(I)
Im=im2bw(I); %figure converted to 2d boolean array
s=regionprops(Im,'centroid'); %structure with info on regions
numspots=length(s);
centerz=zeros(numspots,2);
for j=1:numspots
    temp=s(j).Centroid;
    centerz(j,1)=temp(1);
    centerz(j,2)=temp(2);
end
end

function [traco,unt]=tracost(start,stop)
cost=zeros(size(start,1),size(stop,1));
for k=1:size(start,1)
      diff=stop-repmat(start(k,:),[size(stop,1),1]);
      cost(k,:)=sqrt(sum(diff.^2,2));
end
%[assignment,unassignedTracks,unassignedDetections] = assignDetectionsToTracks(cost,20);
%incorrect: [assignment,unassignedTracks,~] = assignDetectionsToTracks(cost,20);
[assignment,~,unassignedDetections] = assignDetectionsToTracks(cost,20);
traco=assignment;
unt=unassignedDetections;
end

function plotem(timevel,timevels)
npts=25;
figure
[xhist,edges]=histcounts(timevel,npts);
yhist=zeros(1,npts);
for i=1:npts
yhist(i)=(edges(i)+edges(i+1))/2;
end
plot(xhist,yhist)
title('Average BB Velocities');
hold on
npts=25;
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

function watchvideo(stackin,matrix)
var=imfinfo(stackin);
z=length(var);
for i=1:z
    vews(double(imread(stackin,i)),matrix)
    F(i)=getframe(gcf);
    drawnow
end
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 10;
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);
implay('myVideo.avi');
end


function vews(pic,matrix)
image(pic);
pcolor(pic)
colormap([0 0 0; 1 1 1]);
axis image
shading flat
axis square
hold on
start=1;
for i=2:size(matrix,1)
    if matrix(i,4)~=matrix(i-1,4)
        plot(matrix(start:i-1,1),matrix(start:i-1,2));
        start=i;
    end
end
hold off
end

function removerowz=removerowz(matrix,rows)
idex=true(1,size(matrix,1));
%idex([3, 9]) = false;
idex(rows)=false;
removerowz=matrix(idex,:);
end



