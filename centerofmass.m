%%This script allows you to find the center of mass of a grayscale
%%image. You need to enter the path of the image in the first line of code.
%%The program will then ask you to select the part of the image whose
%%center of mass is to be found. 

%% The algorithm first finds the point of maximmum intensity for each cell and then normalizes the intensity of each of the pixel in the cell by dividing each pixel value with the value of the maximum intensity of a pixel in the cell(now each value lies between zero and one). Then it applies a filter that filters out the pixels with intensities less than a certain threshold(15%) and then it finds the weighted centre of mass(centre of intensity) of each of the cells. THis is the Rok Focus of the cells

%%
clear all;
res=0.106; % this is determined by the microscopes, it is 0.2125 if you have 0.2125 microns per pixel, 0.1417 for spn

%%Loading the data
load('/Users/eesh/centerofmass_wildtype/Membranes--vertices--Vertex-x.mat');
datax=data;
cell_number=size(datax,3); % This just assigns 109 to the cel_number for the given file
load('/Users/eesh/centerofmass_wildtype/Membranes--vertices--Vertex-y.mat'); %this loads the y 
datay=data;
cell_number=size(datay,3); % This just assigns 109 to the cel_number for the given file
COM=zeros(cell_number,2);


%nox_vertices=zeros(1,cell_number);
%for i=1:cell_number,
%    nox_vertices(i) = size(data{1,1,i},1); %this is
%end
%nox_vertices;

A=imread('RokProj_z008_c001.tif'); 
M=imread('MyosinProj_z008_c003.tif'); 
C=imread('CellsProj_z008_c003.tif'); 
imshow(A);
A=double(A);
%%REMEMBER: IF YOU to output a grayscale image you must convert it to
%%uint8(use imshow(A) , after doing double(A), and it wont show output,
%%nothing wrong with the matrix, but it just wont show output
hold on;


COM_threshold = cell(cell_number,2,7);   %for thresholding, holding com for different thresholds

threshold=0.80 ;

for cell_index=1:cell_number, %this mega for loop calculates the COM for all the cells which are taken from the edge output
    
    tx = datax{1,1,cell_index}'./res;

    ty = datay{1,1,cell_index}'./res;

     vert_cell=size(tx,2);
   t_poly=zeros(vert_cell,2);

   for i=1:vert_cell,
       t_poly(i ,1)=tx(i);
       t_poly(i ,2)=ty(i);
   end

   t_poly;
    
%now i just need to use the vertices(i already know how to access them, i
%just have to use roipoly with vertices and i am done.
%%


%%THe center of mass is stored in the variables COM_X and COM_Y and an
%%image is outputed by the program(the tiny red dot is the center of mass)

  %just enter the image file, make sure you enter the file is added to MATLAB's path
    
    BW=roipoly(A,tx,ty);
    BW=double(BW);
    SE = strel('octagon',3);
    BW = imerode(BW,SE);    %eroding the edges
    cell(cell_index).ANS=BW.*A;
    %imshow(ANS);
    g = mat2gray(cell(cell_index).ANS);
    ANS = im2bw(g, threshold);
cell(cell_index).ANS=uint8(cell(cell_index).ANS); %we can now use this to plot whatever cell we want!
%% This part of the code is for finding the x coordinate of the center of mass
%ANS is the variable with the image that has been cut using roipoly
    X_pixels=size(A,1);
    Y_pixels=size(A,2);
    xtotals = sum(ANS~=0,1);
%the for loop just adds 1s to the places where there are zeros so there is
%no division by zero 
    for i=1:Y_pixels,
        if(xtotals(i)==0) xtotals(i)=xtotals(i)+1;
        end
    end
    
    x_totals=xtotals;
    T=sum(ANS,1);
    X=T./x_totals;
    COM_X=0;
    SUM_X=sum(X);
    
    for j=1:Y_pixels,
        COM_X= j*X(j)+COM_X;
    end
    
    COM_X=COM_X/SUM_X;



%% This part of the code finds the y coordinate of the center of mass

    ytotals = sum(ANS~=0,2);
    for i=1:X_pixels,
        if(ytotals(i)==0) ytotals(i)=ytotals(i)+1;
        end
    end
    
    y_totals=ytotals;

    T=sum(ANS,2);

    Y=T./y_totals;
    COM_Y=0;
    SUM_Y=sum(Y);
    for j=1:X_pixels,
        COM_Y= j*Y(j)+COM_Y;
    end
    COM_Y=COM_Y/SUM_Y;


    cell(cell_index).COM_X=COM_X;
    cell(cell_index).COM_Y=COM_Y;

    if 0
        %%HERE I ATTEMPT TO FIND THE position of the maxima of intensity
        [maxValue, linearIndexesOfMaxes] = max(ANS(:));

        [rowsOfMaxes colsOfMaxes] = find(ANS == maxValue);
        COM_Y=rowsOfMaxes(1);
        COM_X=colsOfMaxes(1);
    end
%% the following code plots the center of mass onto the figure
%imshow(ANS);
%hold on;
%tx and ty are the vertices' x and y coordinates for the cell corresponding to this loops iteration in a vertex form)


%%
    plot(COM_X, COM_Y, 'rx');
    h = fill(tx,ty,'r');
    set(h,'FaceColor','None');
    COM;

hold on;
    %%DO NOT FORGET TO HOLD ON
    
    %%RADIAL INTENSITY FOR THE ROK
    %%NOW THE UNIT VECTOR PART BEGINS
    
    cospiby8=0.92387953251;
    sinpiby8=0.38268343236;
    %%+0
    line=[COM_X COM_Y 0 1];
     intersect=intersectLinePolygon(line, t_poly);
     h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
     %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
    y=[COM_Y intersect(1,2)];
         C1=improfile(A,x,y);
     
     %%+45
    line=[COM_X COM_Y 1 1];
     intersect=intersectLinePolygon(line, t_poly);
       h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
      %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
    y=[COM_Y intersect(1,2)];
         C2=improfile(A,x,y);
     
         %%+90
    line=[COM_X COM_Y 1 0];
     intersect=intersectLinePolygon(line, t_poly);
       h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
      %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
    y=[COM_Y intersect(1,2)];
         C3=improfile(A,x,y);
     
         %%+-45
    line=[COM_X COM_Y 1 -1];
     intersect=intersectLinePolygon(line, t_poly);
     h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
 %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C4=improfile(A,x,y);
         
         %%+22.5+45
    line=[COM_X COM_Y sinpiby8 cospiby8];
     intersect=intersectLinePolygon(line, t_poly);
     h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
 %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C5=improfile(A,x,y);
         
         %%22.5
    line=[COM_X COM_Y cospiby8 sinpiby8];
     intersect=intersectLinePolygon(line, t_poly);
     h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
 %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C6=improfile(A,x,y);
         
         %%-22.5
    line=[COM_X COM_Y cospiby8 -sinpiby8];
     intersect=intersectLinePolygon(line, t_poly);
     h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
 %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C7=improfile(A,x,y);
         
      %%-22.5-45
    line=[COM_X COM_Y -cospiby8 sinpiby8];
     intersect=intersectLinePolygon(line, t_poly);
     h = fill([COM_X intersect(1,1)],[COM_Y intersect(1,2)],'r');
    set(h,'FaceColor','None');
    h = fill([COM_X intersect(2,1)],[COM_Y intersect(2,2)],'r');
    set(h,'FaceColor','None');
 %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C8=improfile(A,x,y);
         
         
%%THIS PLOTS THE CELL NUMBER ONTO THE CELL
  text( COM_X, COM_Y, [num2str(cell_index)],'Color', 'm');   
   
  
  
  %%NOW TO FIND THE AVERAGE
    LOL=[size(C1,1),size(C2,1),size(C3,1),size(C4,1),size(C5,1),size(C6,1),size(C7,1),size(C8,1) ];
    max_index=max(LOL);
    %%PADDING ZEROS for finding average easily
    C1 = vertcat(C1,NaN(max_index-size(C1,1),1));
    C2 = vertcat(C2,NaN(max_index-size(C2,1),1)); 
    C3 = vertcat(C3,NaN(max_index-size(C3,1),1)); 
    C4 = vertcat(C4,NaN(max_index-size(C4,1),1));
    C5 = vertcat(C5,NaN(max_index-size(C5,1),1));
    C6 = vertcat(C6,NaN(max_index-size(C6,1),1));
    C7 = vertcat(C7,NaN(max_index-size(C7,1),1));
    C8 = vertcat(C8,NaN(max_index-size(C8,1),1));
    %USE NaN instead of zeros
    C=[C1 C2 C3 C4 C5 C6 C7 C8];
    mean_C = nanmean(C,2);
    stdev_C = nanstd(C',1);
  
    cell(cell_index).index = cell_index;
    cell(cell_index).mean = mean_C;
    cell(cell_index).C = C;
    cell(cell_index).stdev = stdev_C;
    
    
end


%%THE PLOTS USING SUBPLOT FOR ROK
%COM_threshold(:,:,threshold)=COM;
k = waitforbuttonpress ;
    hold off;
    
    start_cell=91;
    end_cell=100;
for cell_index=start_cell:end_cell%just selecting cell indices for plotting randomly
 %%plot the shadederrorbars
    
    cell(cell_index).mean';
    %plot(mean_C')
    
    subplot(2,5,cell_index-start_cell+1);%subtract the first index -1 here so that the subplot input never goes above 20
 % imshow( cell(cell_index).ANS);
    
   %hold on;
  
   shadedErrorBar(1:size( cell(cell_index).mean',2), cell(cell_index).mean',cell(cell_index).stdev,'g');
    axis([0,40,0,190]);
     title(cell(cell_index).index)
     hold on

end





%%SAVING ALL THE DATA for ROK into cell_rok

cell_rok=cell;







%%plotting myosin onto the Rok plots
%%The mysoin_distribution is stored in a different file for sanity
%%NOW WE PLOT MYOSIN DISTRIBUTION PLOTS IN RED
    %%NOW THE UNIT VECTOR PART BEGINS
 A=M;
    
    for cell_index=1:cell_number,
        
         tx = datax{1,1,cell_index}'./res;

    ty = datay{1,1,cell_index}'./res;

     vert_cell=size(tx,2);
   t_poly=zeros(vert_cell,2);

   for i=1:vert_cell,
       t_poly(i ,1)=tx(i);
       t_poly(i ,2)=ty(i);
   end

   t_poly;
    
   
    cospiby8=0.92387953251;
    sinpiby8=0.38268343236;
    %%+0
    COM_X=cell(cell_index).COM_X;
    COM_Y=cell(cell_index).COM_Y;
    line=[COM_X COM_Y 0 1];
     intersect=intersectLinePolygon(line, t_poly);
          %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
    y=[COM_Y intersect(1,2)];
         C1=improfile(A,x,y);
     
     %%+45
    line=[COM_X COM_Y 1 1];
     intersect=intersectLinePolygon(line, t_poly);
         %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
    y=[COM_Y intersect(1,2)];
         C2=improfile(A,x,y);
     
         %%+90
    line=[COM_X COM_Y 1 0];
     intersect=intersectLinePolygon(line, t_poly);
            %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
    y=[COM_Y intersect(1,2)];
         C3=improfile(A,x,y);
     
         %%+-45
    line=[COM_X COM_Y 1 -1];
     intersect=intersectLinePolygon(line, t_poly);
     %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C4=improfile(A,x,y);
         
         %%+22.5+45
    line=[COM_X COM_Y sinpiby8 cospiby8];
     intersect=intersectLinePolygon(line, t_poly);
     %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C5=improfile(A,x,y);
         
         %%22.5
    line=[COM_X COM_Y cospiby8 sinpiby8];
     intersect=intersectLinePolygon(line, t_poly);
     %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C6=improfile(A,x,y);
         
         %%-22.5
    line=[COM_X COM_Y cospiby8 -sinpiby8];
     intersect=intersectLinePolygon(line, t_poly);
     %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C7=improfile(A,x,y);
         
      %%-22.5-45
    line=[COM_X COM_Y -cospiby8 sinpiby8];
     intersect=intersectLinePolygon(line, t_poly);
     %NOW TO SAVE THE INTENSITIES IN A MATRIX
     x=[COM_X intersect(1,1)];
     y=[COM_Y intersect(1,2)];
         C8=improfile(A,x,y);
         
            
   
  
  
  %%NOW TO FIND THE AVERAGE
    LOL=[size(C1,1),size(C2,1),size(C3,1),size(C4,1),size(C5,1),size(C6,1),size(C7,1),size(C8,1) ];
    max_index=max(LOL);
    %%PADDING NaNs for finding average easily
    C1 = vertcat(C1,NaN(max_index-size(C1,1),1));
    C2 = vertcat(C2,NaN(max_index-size(C2,1),1)); 
    C3 = vertcat(C3,NaN(max_index-size(C3,1),1)); 
    C4 = vertcat(C4,NaN(max_index-size(C4,1),1));
    C5 = vertcat(C5,NaN(max_index-size(C5,1),1));
    C6 = vertcat(C6,NaN(max_index-size(C6,1),1));
    C7 = vertcat(C7,NaN(max_index-size(C7,1),1));
    C8 = vertcat(C8,NaN(max_index-size(C8,1),1));
    %USE NaN instead of zeros
    C=[C1 C2 C3 C4 C5 C6 C7 C8];
    mean_C = nanmean(C,2);
    stdev_C = nanstd(C',1);
  
    cell(cell_index).index = cell_index;
    cell(cell_index).mean = mean_C;
    cell(cell_index).C = C;
    cell(cell_index).stdev = stdev_C;
    
    
end


%%THE PLOTS USING SUBPLOT FOR MYOSIN
%COM_threshold(:,:,threshold)=COM;

    
  
for cell_index=start_cell:end_cell,%just selecting cell indices for plotting randomly
 %%plot the shadederrorbars
    
    cell(cell_index).mean';
    %plot(mean_C')
    
    subplot(2,5,cell_index-start_cell+1);%subtract the first index -1 here so that the subplot input never goes above 20
 % imshow( cell(cell_index).ANS);
    
   %hold on;
  
   shadedErrorBar(1:size( cell(cell_index).mean',2), cell(cell_index).mean',cell(cell_index).stdev,'r');
    axis([0,40,0,190]);
    title(cell(cell_index).index)
     

end

%%SAVING ALL THE DATA for MYOSIN into cell_myosin

cell_myosin=cell;





%%PLOTTING the AVERAGE intensity Distribution for The Cell
cell=cell_rok;
k = waitforbuttonpress ;
    hold off;
    max_size=0;
for cell_index=1:cell_number,
  
    if(max_size<=size(cell(cell_index).mean)),
        max_size=size(cell(cell_index).mean);
    end
end
max_size;
for cell_index=1:cell_number,
  
    cell(cell_index).mean = vertcat(cell(cell_index).mean,NaN(max_size(1)-size(cell(cell_index).mean,1),1));
end
  
C=[];

for cell_index=1:cell_number,
  
    C=[C cell(cell_index).mean];
end

    average_C = nanmean(C,2);
    stdev_C = nanstd(C',1);
 figure  
 shadedErrorBar(1:size( average_C',2), average_C',stdev_C,'g');
 
 hold on
 
 
 
 cell=cell_myosin;

    max_size=0;
for cell_index=1:cell_number,
  
    if(max_size<=size(cell(cell_index).mean)),
        max_size=size(cell(cell_index).mean);
    end
end
max_size;
for cell_index=1:cell_number,
  
    cell(cell_index).mean = vertcat(cell(cell_index).mean,NaN(max_size(1)-size(cell(cell_index).mean,1),1));
end
  
C=[];

for cell_index=1:cell_number,
  
    C=[C cell(cell_index).mean];
end

    average_C = nanmean(C,2);
    stdev_C = nanstd(C',1);

 shadedErrorBar(1:size( average_C',2), average_C',stdev_C,'r');