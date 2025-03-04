% this code returns the processed binary image of a single frame from the video.
% plots are created for manual verification of image processing parameters if desired.

%still the oldest pross file, but creates separate plots for better view.

function pross2(pic)
%larger plots

img=double(imread(pic));

figure(1)
pcolor(img)
axis image
shading flat
colorbar
title('Original')

%background subtraction
imgback=img-back(img);
figure(2)
pcolor(imgback)
axis image
shading flat
colorbar
title('Background Subtracted')

%Large gaussian filter gets rid of BB and noise
blur=10;
imggaus=imgaussfilt(imgback, blur);


%subtract from background subtracted image to get BB and noise
imgbbn=imgback-imggaus;
figure(3)
pcolor(imgbbn)
axis image
shading flat
colorbar
title('Gaussian Filtered Short Noise Subtracted')

%make all positives
imgpos=abs(imgbbn);
figure(4)
pcolor(imgpos)
axis image
shading flat
colorbar
title('Positives')

%Weiner filter gets rid of noise
wein=14;
imgwein=wiener2(imgpos,[wein wein]);
figure(5)
pcolor(imgwein)
axis image
shading flat
colorbar
title('Weiner Filtered Noise Subtracted')

%enhance contrast
C=0.25;
i0=400;
imgcon=1+tanh((imgwein-i0)/C);
figure(6)
pcolor(imgcon)
axis image
shading flat
colorbar
title('Contrast Enhanced')

%make binary
bi=0.5;
imgbi=imbinarize(imgcon,bi);
figure(7)
pcolor(imgbi)
axis image
shading flat
colorbar
title('Binary')

%touch ups
s=2;
se=strel('disk',s); 
imgbw=imclose(imgbi,se); %close shapes
imgbw=imfill(imgbw,'holes'); %fill holes
speck=8;
imgbw=bwareaopen(imgbw,speck);%remove speckles
figure(8)
pcolor(imgbw)
axis image
shading flat
colorbar
title('Touch ups')

end




