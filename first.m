
clear all;% clearing the current workspace

res=0.212; % XY resolution
edge_erosion=3;
threshold=0.65;
%%The X coordinates of the vertices are stored in the variable datax
load('/Users/eesh/Desktop/metric_live_analysis_data/Rok_Gap_Spn10/Measurements/Membranes--vertices--Vertex-x.mat');
datax=data;

%%The Y coordinates of the vertices are stored in the variable datay
load('/Users/eesh/Desktop/metric_live_analysis_data/Rok_Gap_Spn10/Measurements/Membranes--vertices--Vertex-y.mat'); %this loads the y 
datay=data;



cell_number=size(datay,3); 
%%cell_number : total number of traked cells in the embryo 

time_number=size(datay,1);
%%time_number : total number of time points for the injection experiment.
rok=1;

for time=1:time_number,
    
    %storing the path of the image as a string, allows us to loop over images using file names differentiated only by the time point label
    image_path=strcat('/Users/eesh/Desktop/metric_live_analysis_data/Rok_Gap_Spn10/Rok_polished/Rok',sprintf('%03d',time-1),'.tif')  ;  
    %sprintf funcion: enforces integers to be formatted in a particular way
    %when converted to a string. Here it enforces the integers to be three
    %digit integers -> so 3 is '003' and 65 is '065'

    
    
    A=imread(image_path);   %Read the Image from the path
    A=rgb2gray(A);
    A_hold=A;               %A_hold holds the image in the uint8 format, use this variable to output images

    A=double(A);            %Converts A to a double variable to allow more precise computation
imshow(A_hold);
hold on;

    %%LOOP OVER CELLS IN THIS EMBRYO AT THIS POINT OF TIME
    for cell_index=1:cell_number, 

        %CHECK IF THE CELL IS TRACKED AT THIS POINT IN TIME
        if(~isnan(datax{time,1,cell_index})) 
        %The isnan check on the EDGE data is just an error check to make
        %sure our computations are done on a cell that is actually tracked
        %at the time point.    
            
            
        %USE THE RESOLUTION TO CONVERT MICRONS TO PIXELS
        tx = datax{time,1,cell_index}'./res;    %Contains the X coordinate of the vertices for this cell at this point in time
        ty = datay{time,1,cell_index}'./res;    %Contains the Y coordinate of the vertices for this cell at this point in time

        
        
        
        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%The section that segments the image into individual cells using EDGE data 
        BW=roipoly(A_hold,tx,ty);   %BW is binary mask for the cell
        BW=double(BW);              %Converting to double for higher precision
        SE = strel('octagon',3);    %Edge erosion structure to ignore edge aberrations
        BW = imerode(BW,SE);        %Eroding the edges using the octagonal erosion structure
        
        
        E(time).cell(cell_index).ANS=BW.*A;     %Multiply element by element the BW mask to the original image.
        
      %***************************im**********************************************%     
    %%SCRIPT TO FIND CENTER OF MASS OF A CELL 
    run('/Users/eesh/Desktop/metric_live_analysis/centerofmass_cell');
%*************************************************************************% 
   
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This section plots the center of mass onto the image for visual inspection
    plot(COM_X, COM_Y, 'rx');
   
    %%This section just draws the edges of the polygon of the cell onto the
    %%image of the cell.tx and ty are x and y coordinates of the vertices
    %%in pixels(they were calculated in the centerofmass_cell script.
    h = fill(tx,ty,'r');
    set(h,'FaceColor','None');
  
    hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%*************************************************************************% 
    %%SCRIPT TO FIND THE RADIAL INTENSITY DISTRIBUTION FOR ROK
    run('/Users/eesh/Desktop/metric_live_analysis/radial_distribution.m');
%*************************************************************************% 


        cell_rok=cell;  %%SAVING ALL THE DATA for ROK into cell_rok structure for future use

        E(time).cell(cell_index).mean = cell(cell_index).mean;
    
          cell_myosin=cell;
        
   
            end%end of nan check
    end %end cell loop

 %%STEP 2
        
            run('/Users/eesh/Desktop/metric_live_analysis/maxima_distance.m');
         
     
        
        
clear cell;

end

%
