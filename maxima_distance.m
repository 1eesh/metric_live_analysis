%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%master.m (the first script that you would call when you start analysing

%%USEFUL OUTPUT VARIABLES

%%cell_rok is the structure containing all the relevant information for Rok
%%cell_myosin is the structure containing all the relevant information for Rok


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear all;

%filename='spn3_40_actin';
maxthresh=15;

%load(strcat(filename,'_mbs'));
% cell_mbs=cell_myosin;



%load(filename);

     %%MBS PLOT

AVERAGE_spn=[];

%A_hold=imread('RokProj_z008_c001.tif');
imshow(A_hold)
hold on;
for cell_index=cell_length, %this mega for loop calculates the COM for all the cells which are taken from the edge output
 
 if(~isnan(datax{time,1,cell_index}))
     
    plot(cell_rok(cell_index).COM_X, cell_rok(cell_index).COM_Y, 'rx');
   
    hold on;

    %%DO NOT FORGET TO HOLD ON
   
    %%RADIAL INTENSITY DISTRIBUTION FOR ROK
    
    
    %%THIS PLOTS THE CELL NUMBER ONTO THE CELL
  text( cell(cell_index).COM_X, cell(cell_index).COM_Y, [num2str(cell_index)],'Color', 'g');   
    
  
  %%Average using the method Adam suggested
    cell(cell_index).maxima_distance = sqrt(sum(abs(cell_rok(cell_index).MAX - cell_myosin(cell_index).MAX).^2,2));
    
   cell(cell_index).average_maxima_distance_adam = mean(cell(cell_index).maxima_distance);
   
   
   %%THIS PLOTS THE Distance between maximas(adam) ONTO THE CELL
  %text( cell(cell_index).COM_X, cell(cell_index).COM_Y+5, [num2str(cell(cell_index).average_maxima_distance_adam)],'Color', 'y');  


  %%
 
  %%Average using average of averages
  if(size(cell_rok(cell_index).mean,1)>=15) 
   [r_rok,t_rok]=max_modified(cell_rok(cell_index).mean(1:15,:));
   [r_myosin,t_myosin]=max_modified(cell_myosin(cell_index).mean(1:15,:));
  end 
   
  if(size(cell_rok(cell_index).mean,1)<15) 
    [r_rok,t_rok]=max_modified(cell_rok(cell_index).mean);
   [r_myosin,t_myosin]=max_modified(cell_myosin(cell_index).mean);
  end
   cell(cell_index).average_maxima_distance = abs(t_myosin-t_rok);
  abs(t_myosin-t_rok);
   
   AVERAGE_spn=[AVERAGE_spn;cell(cell_index).average_maxima_distance]; 
   
   
   %%THIS PLOTS THE Distance between maximas(average of average) ONTO THE CELL
  text( cell(cell_index).COM_X, cell(cell_index).COM_Y+10, [num2str(cell(cell_index).average_maxima_distance)],'Color', 'b');  



 end%END NAN CHECK

end
 

%%
%%HERE WE JUST DO THE SAME FOR WILD TYPE
%load('wildtype_mbsxmyosin.mat');


AVERAGE_wildtype=[];

for cell_index=cell_length, %this mega for loop calculates the COM for all the cells which are taken from the edge output
 
 if(~isnan(datax{time,1,cell_index}))

  
  %%Average using the method Adam suggested
    cell(cell_index).maxima_distance = sqrt(sum(abs(cell_rok(cell_index).MAX - cell_myosin(cell_index).MAX).^2,2));
    
   cell(cell_index).average_maxima_distance_adam = mean(cell(cell_index).maxima_distance);
   


  %%
  %%Average using average of averages
  if(size(cell_rok(cell_index).mean,1)>=30) 
   [r_rok,t_rok]=max_modified(cell_rok(cell_index).mean(1:30,:));
   [r_myosin,t_myosin]=max_modified(cell_myosin(cell_index).mean(1:30,:));
  end 
   
  if(size(cell_rok(cell_index).mean,1)<30) 
    [r_rok,t_rok]=max_modified(cell_rok(cell_index).mean);
   [r_myosin,t_myosin]=max_modified(cell_myosin(cell_index).mean);
  end
   cell(cell_index).average_maxima_distance = abs(t_myosin-t_rok);
  
   
   AVERAGE_wildtype=[AVERAGE_wildtype;cell(cell_index).average_maxima_distance]; 
   
 

 end %END NAN CHECK

end

AVERAGE_wildtype;

%%

     close all;
     
     run('rok_organization');
     
     close all;