%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Thank You MATHWORKS
clear all;close all;


img_size = 100; % Size of image
img = zeros(img_size,img_size);


% place kernel off center...make curves interesting
patch = hamming(0.75*img_size)*hamming(0.75*img_size)';
img(1:0.75*img_size,1:0.75*img_size) = patch;
center = [img_size img_size]/2;


f=figure(1);
pos = get(f,'position');
set(f,'position',[(pos(1)-pos(4)/2) pos(2) 2*pos(3) pos(4)]); %Resize
subplot(121);
imagesc(img);axis([1 img_size 1 img_size]);colormap(gray);
axis square; hold;


% Create the meshgrid to be used in resampling
[X,Y] = meshgrid(1:img_size,1:img_size);


for radius = 1:round(0.4*img_size),
    
    % To avoid redundancy, sample at roughly 1 px distances
    num_pxls = 2*pi*radius;
    theta = 0:1/num_pxls:2*pi;
    
    x = center(1) + radius*cos(theta);
    y = center(2) + radius*sin(theta);


    sampled_radial_slice = interp2(X,Y,img,x,y);
    radial_average(radius) = mean(sampled_radial_slice);
    
    subplot(121);
    if(radius>1)
        delete(p);
    end
    p=plot(x,y,'y.',x(1),y(1),'r*'); % Starts at green spot and goes counter clockwise
    
    subplot(122)
    plot(theta,sampled_radial_slice);axis([0 2*pi 0 1]);axis square;
    title(sprintf('radius: %d',radius));
    pause
end


figure(2);
r = 1:round(0.4*img_size);
plot(r,radial_average);
title('Radial average');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
