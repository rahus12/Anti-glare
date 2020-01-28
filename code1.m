clc;
all_box=0;
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');
                     
cam=webcam;
for l = 1:1e6
    img=snapshot(cam);
    %subplot(2,2,1);
    imshow(img);
    bi=im2bw(img,0.99);   %arbitrary limit set 
    bi=bwareaopen(bi,20);
    bi=imfill(bi,'holes');
    
    %%binary iage
    %subplot(2,2,2)
    %imshow(bi);
    
  %%bounding box
  measurements = regionprops(bi, 'BoundingBox', 'Area');
  allAreas = [measurements.Area];
  [mValue, mIndex]=max(allAreas);
  k=mIndex;
  
  %To create a rectangle on the biggest Area
  if(k>0)
  thisBB = measurements(k).BoundingBox;
    all_box(k) = thisBB(3)*thisBB(4);
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
    'EdgeColor','b','LineWidth',2 )
    xval=thisBB(1)+(thisBB(3)/2)
  end
 
%%button to stop
  if ~ishandle(ButtonHandle)
    disp('Loop stopped by user');
    break;
  end
  pause(0.02)
end 
clear('cam');
