% File name: Anti-Glare
% Desc: Uses a mobile camera connected to pc via IP to get the image of the windsheild and the brighetest spot on the windshield 
%       is detected by image processing. A calibrated servo motor is used to position a polaroid lens exactly in front of the brightest 
%       spot detected 
% Mobile App: IP Webcam

clear all
clc

%change according to your values

url = 'http://192.168.43.1:8080/shot.jpg';  
k=0;

port= 'COM17';
board='Uno';
ard_board=arduino(port,board,'Libraries','Servo');
servo_motor=servo(ard_board,'D9');
servo_motor2=servo(ard_board,'D8');


%%
%To get x value:

all_box=0;
writePosition(servo_motor2,0);
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');

while(1)
    img  = imread(url);
    grey=rgb2gray(img);
    imshow(img);
    bi=im2bw(img,0.99);
    bi=bwareaopen(bi,20);
    bi=imfill(bi,'holes');
    
       
  %%bounding box
  %
  measurements = regionprops(bi, 'BoundingBox', 'Area');
  allAreas = [measurements.Area];
  [mValue, mIndex]=max(allAreas);
  k=mIndex;
   
  if k>0
     
  thisBB = measurements(k).BoundingBox;
  if ( (thisBB(3)>50) && (thisBB(4)>50) )
    all_box(k) = thisBB(3)*thisBB(4);
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
    'EdgeColor','b','LineWidth',2 )

    xval=thisBB(1)+(thisBB(3)/2);
    yval=thisBB(2)+(thisBB(4)/2);
  
  
 
 %% To control sevo motor
% values given according to my hardware
gxval=xval/100;
r=6.1;
theta=(gxval/r);
angle=1-theta;
writePosition(servo_motor,angle);
writePosition(servo_motor2,0.5);


  end
  end
  
%pause(0.8);


%%
%button to stop
  if ~ishandle(ButtonHandle)
    disp('Loop stopped by user');
    break;
  end
  pause(0.02)
end
  

