%% Here we try and get the Covariance as a function of the distance between maximas(basically we try and see whether the maximas in Pearson corelation correspond to the lag equal to the maximal distance
%load('spn6_45');
for cell_index=1:cell_number, %%which cell we are looking at


pcc_tick=8;

%%the average distance between maxima for each cell
   if (size(cell_rok(cell_index).mean,1) >25)
myo_pcc=cell_myosin(cell_index).mean(1:25,:);
rok_pcc=cell_rok(cell_index).mean(1:25,:);
   end

  if (size(cell_rok(cell_index).mean,1) <=25)
myo_pcc=cell_myosin(cell_index).mean(:,:);
rok_pcc=cell_rok(cell_index).mean(:,:);
end

figure
subplot(2,1,1)

myo=plot(myo_pcc,'Color',[0 0 1]);
grid on;
hold on;
rok=plot(rok_pcc,'Color',[0 1 0]);
l1=legend('Myosin','Rok');
set(l1,'Location','northeast')
ylabel('Intensity');
xlabel('Distance from Rok Focus of the Cell');
title(strcat('Intensity of Myosin and Rok as a function of Distance from Rok Focus | Cell #',num2str(cell_index)));

subplot(2,1,2)
% Plot lag vs intensity
pcc_lag=xcov(myo_pcc,rok_pcc,pcc_tick,'coeff');
plot(pcc_lag)
set(gca,'XTick', [0:1:2*pcc_tick+1] )
set(gca,'XTickLabel',[-pcc_tick:1:pcc_tick] ); 
%# vertical line of error bars between the two(because I am not using point of maximum intensity as center but I am using the point of 15% threshold as center
hx_2 = graph2d.constantline(pcc_tick, 'Color',[0 0 0]);
changedependvar(hx_2,'x');
hx_1 = graph2d.constantline(cell(cell_index).average_maxima_distance+pcc_tick, 'Color',[1 0 0]);
changedependvar(hx_1,'x');

%legend
l2=legend('PCC for different lags','Myosin-Rok mean maximal distance ');
set(l2,'Location','best')

%axes and titles
ylabel('Pearson Correlation Coefficient(PCC)');
xlabel('Lag');
title(strcat('Pearson Correlation Coefficient as a function of lag(relative shift) in Myosin and Rok plots | Cell #',num2str(cell_index)));
grid on;


%#
filename=strcat('/Users/eesh/Desktop/eesh_summer_14/Documentation/Presentation_June5/rokxmyosin_spn/','rokxmyosin_spn_radialintensity_pcclag_cell_',num2str(cell_index));
print('-depsc', filename);
hold off

close all
end