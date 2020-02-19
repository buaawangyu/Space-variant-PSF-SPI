function [ xInit,yInit,xEnd,yEnd ] = calculate_screenRoi( fringepath,fx )
%
%CALCULATE_SCREENROI Summary of this function goes here
%   Detailed explanation goes here
%why not using£¨1,1£©£¬£¨1600,1200£©?but (100,100)(1500,1500)£¬
%to avoid the camera field of view is not fully covered by the display

slicerInit=(phaseunwrap2(fringepath,100,100,100,100,fx,0));%0Îªrow  21*21
slicecInit=(phaseunwrap2(fringepath,100,100,100,100,fx,1));%
slicerEnd=(phaseunwrap2(fringepath,1100,1100,1500,1500,fx,0));
slicecEnd=(phaseunwrap2(fringepath,1100,1100,1500,1500,fx,1));

yInit100=slicerInit(1,1);
xInit100=slicecInit(1,1);

yEnd1100=slicerEnd(1,1);
xEnd1500=slicecEnd(1,1);

xInit=xInit100-(xEnd1500-xInit100)/14;
yInit=yInit100-(yEnd1100-yInit100)/10;
xEnd=xEnd1500+(xEnd1500-xInit100)/14;
yEnd=yEnd1100+(yEnd1100-yInit100)/10;



end

