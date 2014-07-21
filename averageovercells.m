%%%%%%%%
%averageovercells.m
%This code averages 

%%%%%%%%THRESHOLDIING 
%{
%spn1_70
soline_ring=[96,100,3,13,24,26,38,39,41,43,47,52,63,65,68,71,73,74,76,82,84,85,86,102,103,104];
soline_focus=[79,49,2,6,7,9,14,15,19,21,23,28,31,32,35,45,49,50,58,60,61,62,64,78,79,80,81,83,90,95,101,106];
soline_diffused=[16,1,8,10,12,17,18,20,22,25,27,30,33,34,37,40,42,46,53,54,55,56,57,59,66,67,69,72,75,77,91,92,93,94,97,98,99,105,107,108,109,111,112];

size(soline_ring)
%}

%%%%%%%%THRESHOLDIING 
%{
%spn6_45 

soline_ring=find(area_plot>1);
soline_diffused=find(area_plot<=1& area_plot>0) ;
soline_focus=find(area_plot==0);

size(soline_focus)

%}
%%%%%%%%THRESHOLDIING 
%spn5_30
%{
soline_ring=find(area_plot>1.25);
soline_diffused=find(area_plot<=1.25 & area_plot>0) ;
soline_focus=find(area_plot==0);

size(soline_focus)
%}
%%%%%%%%


%%%%%%%%THRESHOLDIING 
%spn3_40_actin 
%
soline_ring=find(area_plot>1.2);
soline_diffused=find(area_plot<=1.2 & area_plot>0) ;
soline_focus=find(area_plot==0);

size(soline_focus)

%}
%%%%%%%%
use=soline_ring;

max_size=0;
for cell_index=use,
    %%this segment normalizes the intensities between zero and one for each
  %%cell individually
    [r,t]=max(cell(cell_index).mean);
    cell(cell_index).mean = cell(cell_index).mean/r ; 

  %%
    
    if(max_size<=size(cell(cell_index).mean)),
        max_size=size(cell(cell_index).mean);
    end
end
max_size;
for cell_index=use,
  
    cell(cell_index).mean = vertcat(cell(cell_index).mean,NaN(max_size(1)-size(cell(cell_index).mean,1),1));
end
  
C=[];

for cell_index=use,
  
    C=[C cell(cell_index).mean];
end



    average_C = nanmean(C,2);
    stdev_C = nanstd(C',1);

    stdv=stdev_C(:,1:25);
    AVeG=average_C';
    
    %%PLOTTING BEGINS WITH FLAGS
    if(wild)
        subplot(1,1,1) 
   
        
    if(rok),
    shadedErrorBar(1*res:1*res:25*res, AVeG(:,1:25),stdv,'g');
    hold on
    end
    
    if(~rok & flag),
    shadedErrorBar(1*res:1*res:25*res, AVeG(:,1:25),stdv,'r');
    hold on
    end
    
    if(~rok & ~flag),
    shadedErrorBar(1*res:1*res:25*res, AVeG(:,1:25),stdv,'c');
    hold on
    end
    
    
    end
    
    %{
     if(~wild)
        subplot(2,1,2) 
    if(rok),
   
 shadedErrorBar(1:1:15, AVeG(:,1:15),stdv,'g');
 
  hold on
    end
    
      if(~rok),
 
 shadedErrorBar(1:1:15, AVeG(:,1:15),stdv,'r');
 
  hold on
      end
    end
    %}
    
    