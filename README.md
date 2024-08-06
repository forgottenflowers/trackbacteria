# trackbacteria
Files used for object recognition and tracking of videos of moving bacteria

Step-1: Rename nd2 files
I normally rename files by prepending with the date created. Open the command prompt (using Cortana, or run ‘cmd’). Use the command:
FOR /R "pathname" %Z IN (*.nd2) DO @( FOR /F "Tokens=1-6 delims=:-\/. " %A IN ("%~tZ") DO @( ren "%~dpnxZ" "%~C%~A%~B%~D%~E%~F%~nZ%~xZ") )
For example:
FOR /R "Z:\8.21.18-24hr\Async\" %Z IN (*.nd2) DO @( FOR /F "Tokens=1-6 delims=:-\/. " %A IN ("%~tZ") DO @( ren "%~dpnxZ" "%~C%~A%~B%~D%~E%~F%~nZ%~xZ") )

Step-2: Convert to multipage tiff files
Open NIS Elements Analysis. File > Export to tiff 
Select input folder
Select files using shift key, click ‘feed’
Select output folder
Make sure multipage tiff is selected (it usually is)
Click Export

Step-3: Set the parameters
Create a folder called ‘testforsingle’ (see the example folder)
Open any of the tiff files on ImageJ 
Use the scroll bar to select any slice of the video
Choose Image > duplicate. This creates a single image of the slice.
File > Save As > Tiff
Name it ‘single’, store it in the same file as single
Copy the code ‘pross2’ and ‘back’ into the folder (these are already copied in the example folder)
On Matlab, type: pross2(‘single.tif’) and press enter to execute this code (please open new instance of matlab, don’t close old ones)
Look at the generated graphs and change parameters as necessary -> this may take longer than you expect

Step-4: Make binary files
Use the code batchpromain() to batch process all the tiff files at once. This will process whatever files are present in the folder. Make sure to change the parameters in this code based on the values you got from pross2. Also, change the path names correctly, otherwise the code won’t execute. Open the code in matlab to change these.
Change line 22 to change pathname. For example, in the following code, the name of the output file starts from 11th position of the pathname, hence 11:length(nem). This is because maybe for that particular file, the path goes like  D:/ … /…/ 2018… so over here the position of the digit ‘2’ is at 11th position. Choose this position number accordingly.

To change the parameters, go to line 30 onwards from where pross2 starts.
This takes time depending on the data volumes being analyzed
Creates Mod files

Step-5: Shutter times
Execute the code batchtime() to create matlab data files in the current folder containing shutter times information. Change (‘what file name starts with*.tif’)
Creates _Times files from .nd2 files

Step-6: Track
Execute the code batchtrack() to do the tracking simultaneously for all the files. The code trackem() needs to be located in the same folder for this. 
This code creates Matlab data files for corresponding tracks in the same folder and also displays plots showing histograms for every analyzed video.m

Step-7: Make plots
Execute plottimepoint() to generate a histogram combining all histograms in this timepoint.

Step-8: Make Excel Plots
Double click ‘AllVelocitieshr sta.mat’ to open up workspace
>> mean (AvgVel)
>> std (AvgVel)
Copy numbers into an excel sheet
>> clear
Open next time point and repeat



