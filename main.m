%% I. Add paths

addpath(genpath(pwd));


%% III. Create the pattern size text file.

disp("Step 1: Getting Grid Size In mm")
pattern_size = input('Enter the grid size in mm:\n');

file = fopen('pattern_sz.txt', 'w+');

fprintf(file, '%d', pattern_size);

fclose(file);

copyfile('pattern_sz.txt', 'pattern_size.txt');
delete('pattern_sz.txt')

%% Flow of the calibration.

% if the centers of the micro-lenses are not known beforehand, run 
% LightFieldCalib_Step1_MicroLensCenter

% Assumed that the micro-lens centers are extracted.

% I. Extract the central sub-aperture image 

% % Plenoptic_GeoCalibration_Step2_Center_Image
selection = input("Step 2: Running file 'Plenoptic_GeoCalibration_Step2_Center_Image'. \nSelect the checkerboard grid you want to use. Do you understand? y/n: ", 's');
if selection == "y"
    Plenoptic_GeoCalibration_Step2_Center_Image;
else
    disp("You answered 'n' or you put in an invalid input, the program has stopped executing");
    return
end

% II. Detect the micro-lens centers near the corners.

% % centersNearWorldCorners
disp("Step 3: Select the data for 'centersNearWorldCorners'w. This file finds all the corners located in each microlens of the microlens array.");
centersNearWorldCorners;


% III. Find the corners in the image (this works for one image only).

% % microImageCornerDetection
% THIS IS THE SCRIPT THAT TAKES A LONG TIME TO RUN! TAKES AROUND 4-6
% MINUTES. This script uses parallelization.

disp("Step 4: Running file 'microImageCornerDetection'. Select the data for 'microImageCornerDetection'.\nThis step may take about 5-10 minutes, so please be patient. (Note: This is also where the 'transformation' is happening in the program.");
microImageCornerDetection;

% IV. Find the corresponding centers that observe these corners.

% % centersFromCorners
 
disp("Step 5: Running file 'centersFromCorners'. Select the data for 'centersFromCorners'.\nThis file takes matches/correlates an image from the corners to the center of a microlens.");
centersFromCorners;


% V. Classify micro-lenses based on focus measure

% % clusterCornerPointsLocal

disp("Step 6: Select the data for 'clusterCornerPointsLocal'. Running file 'clusterCornerPointsLocal'. This file clusters the local areas of a microlens");
clusterCornerPointsLocal;

% % typeClassificationUsingCircularRegion

disp("Step 7: Running file 'typeClassificationUsingCircularRegion'. This file classifies the different lens types.");
typeClassificationUsingCircularRegion;

% % makeGridTypeGeneral

disp("Step 8: Running file 'makeGridTypeGeneral'. This section of the program exports out general data that applies for the individual grid types.");
makeGridTypeGeneral;

% VI. Assign the correspondences

% % cornerCorrespondences

disp("Step 9: Running file 'cornerCorrespondences'. This file");
cornerCorrespondences;

% VII. Calibrate.

% % cornerLinearSolutionManyImages

disp("Step 10: Running file 'cornerLinearSolutionManyImages' This file ");
cornerLinearSolutionManyImages;












