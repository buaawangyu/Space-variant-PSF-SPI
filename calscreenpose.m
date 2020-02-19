function[rotationMatrix,translationVector,reprojerr]=calscreenpose(fringepath,prjX,prjY,fx)
%The last parameter is the center frequency of the phase-shifted fringe

filename1=[fringepath,'\phase fx',num2str(1),'_fy',num2str(fx),'_1.bmp'];

tempimg=double(imread(filename1));

[row,col]=size(tempimg);
xmin=5;
ymin=5;
xmax=row-5;
ymax=col-5;

slicer=phaseunwrap2(fringepath,xmin,xmax,ymin,ymax,fx,0);%0 is row
slicec=phaseunwrap2(fringepath,xmin,xmax,ymin,ymax,fx,1);
camX=xmax-xmin+1;
camY=ymax-ymin+1;
%Read the internal parameters of the camera

load('goodcampara2.mat');

cameraParams2.IntrinsicMatrix
%imagePoints=xmin:xmax;
k=1;
%imagePoints=zeros(camX*camY,2);
%The image coordinate system x goes to the right, y goes down
for row=1:50:xmax-xmin+1-200
    for col=1:50:ymax-ymin+1
        
        imagePoints(k,2)=row+xmin-1;
        imagePoints(k,1)=col+ymin-1;
        k=k+1;
    end
end
undistpts=undistortPoints(imagePoints,cameraParams2);
k=1;
%worldPoints=zeros(camX*camY,2);
%The world coordinate :x- down and y - right
%pixelsize=0.1373;
pixelsize=0.1373;% 23.8 inchs, h=29.65cm,w=52.71cm;pixelsize=296.5/2160
%but the params pixelpitch of the LCD is 0.2715
for row=1:50:xmax-xmin+1-200
    for col=1:50:ymax-ymin+1
        worldPoints(k,1)=slicer(row,col)*pixelsize;
        worldPoints(k,2)=slicec(row,col)*pixelsize;

        k=k+1;
    end
end


[rotationMatrix,translationVector]=extrinsics(undistpts,worldPoints,cameraParams2);
worldPoints(:,end+1)=0;
worldPoints(:,end+1)=1;
camMatrix=cameraMatrix(cameraParams2,rotationMatrix,translationVector);
estimate_pt=worldPoints*camMatrix;
%And then we go from homogeneous to inhomogeneous
estimgpt(:,1)=estimate_pt(:,1)./estimate_pt(:,3);
estimgpt(:,2)=estimate_pt(:,2)./estimate_pt(:,3);

xyfang=(undistpts-estimgpt).*(undistpts-estimgpt);
reprojerr=sum(xyfang,2);
reprojerr=sum((reprojerr).^(1/2),1)/(size(imagePoints,1))






end