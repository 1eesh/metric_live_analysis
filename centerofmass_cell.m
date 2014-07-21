%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FINDS THE CENTER OF MASS OF AN INDIVIDUAL CELL

%The algorithm first finds the point of maximmum intensity for each cell 
%and then normalizes the intensity of each of the pixel in the cell by 
%dividing each pixel value with the value of the maximum intensity of a
%pixel in the cell(now each value lies between zero and one). 
%Then it applies a filter that filters out the pixels with intensities 
%less than a certain threshold(20%) and then it finds the weighted 
%centre of mass(centre of intensity) of each of the cells after the threshold. 
%This is the Rok Focus of the cells

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reads the EDGE data and stores it into usable variables
%Dividing each of these by res. The EDGE data is in microns and we need to
%convert them back to pixels so that we can segment cells using the EDGE
%data

tx = datax{time,1,cell_index}'./res;   %x coordinates of polygon for the cell
ty = datay{time,1,cell_index}'./res;   %y coordinates of polygon for the cell




%This part of the code is not used in this script. Ignore for now.
vert_cell=size(tx,2);               
t_poly=zeros(vert_cell,2);          

for i=1:vert_cell,
    t_poly(i ,1)=tx(i);
    t_poly(i ,2)=ty(i);
end
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%











%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ANS =  cell(cell_index).ANS;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The rest of the script operates on ANS. It simply finds the weighted
%center of intensity for ANS. No tricks here. The intelligent part was the
%previous section where we used the maximum intensity in a cell to arrive
%at a thresholded image that we use for the rest of the code.

%If how we get ANS is unclear to you, just email eeshit.vaishnav@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%X coordinate of the center of mass of ANS
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

    
    %%TRYING THE CENTROID OF 15% MAXIMA, AFTER TESTING, I CONCLUDE THAT MY
    %%METHOD WORKS BETTER
    if 0
    QWERT=regionprops(BW, 'Centroid');
    COM_X=QWERT.Centroid(1);
    COM_Y=QWERT.Centroid(2);
    end
    
    
    %%
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
