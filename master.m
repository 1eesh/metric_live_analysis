%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%master.m (the first script that you would call when you start analysing

%%USEFUL OUTPUT VARIABLES

%%cell_rok is the structure containing all the relevant information for Rok
%%cell_myosin is the structure containing all the relevant information for Rok


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%master->maxima_distance->load and plot->rok_organization


rok=1;          %Flag to recognize when to plot rok and when to plot myosin



A_hold=A;                                   %Save the original uint8 Rok image into A_hold(enables imshow(A_hold)

%%Converting all variables to a double
A=double(A);                                %Converts A to double for computation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%UNCOMMENT THIS LINE IF YOU ARE DOING ROK VS MBS 

%Q=M;    















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Loop over all the cells in the image and find the center of mass of each.
%I call various scripts in this program and I specifically mark the
%location of each script with a line of stars. The address needs to change
%depending on where you execute the scripts.


    

    
%*************************************************************************%     
    %%SCRIPT TO FIND CENTER OF MASS OF A CELL 
    run('/Users/eesh/Desktop/metric_live_analysis/centerofmass_cell');
%*************************************************************************% 
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This section plots the center of mass onto the image for visual inspection
    %plot(COM_X, COM_Y, 'rx');
   
    %%This section just draws the edges of the polygon of the cell onto the
    %%image of the cell.tx and ty are x and y coordinates of the vertices
    %%in pixels(they were calculated in the centerofmass_cell script.
    %h = fill(tx,ty,'r');
    %set(h,'FaceColor','None');
  
    %hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
  
%*************************************************************************% 
    %%SCRIPT TO FIND THE RADIAL INTENSITY DISTRIBUTION FOR ROK
    run('/Users/eesh/Desktop/metric_live_analysis/radial_distribution.m');
%*************************************************************************% 


    %%The following line plots text number onto the cell image(for visual
    %%inspection)
    %text( cell(cell_index).COM_X, cell(cell_index).COM_Y, [num2str(cell_index)],'Color', 'g');   
    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


