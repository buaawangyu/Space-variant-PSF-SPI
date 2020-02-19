%requirement£º
%Input£ºFilePAth£¬Pixel interval£¨100,200~£©£¬PSF size£¨21*21£©
%OutPut£ºPSF£¬depth
%parfor is used~
%calibration result do not influence the result of PSF

clc;
clear all;
tic
%step1:initial
imgWidth=1600;% resolution of image sensor
imgHeight=1200;
LCDH=2160;%resolution of LCD
LCDW=3840;%
fringeX=24;
fringeY=24;% max frequency of the Fourier fringe 
phasefx=20;% middel frequency phase-shifted sinusoidal fringe
PSFw=21;%resolution of PSF
width=(PSFw-1)/2;
height=(PSFw-1)/2;
interval=100;%Start at the (interval, interval) ,and compute PSF every interval

FilePath='C:\data';%path to save captured patterns
list=dir(FilePath);

for dirIndex=3:size(list,1)% read the folder under FilePath
  
    fileName=list(dirIndex).name;
    Fringepath=[FilePath '/' list(dirIndex).name,'\patterns_cap'];  
    % whether there is data in the folder
    if(~exist([Fringepath '\phase fx1_fy19_1.bmp'],'file'))
        continue;
    end
    
    mkdir(['resultdata\' fileName '\'],'SPIdata');%Create a folder to save the SPI data
    mkdir(['resultdata\' fileName '\'],'ObjectPSF');%Create a folder to save the PSF data
    %coordinates where to sovle the PSF result
    dataPts=zeros((imgWidth-2*interval)/interval*(imgHeight-2*interval)/interval,2);
    ptsNum=1;
    for i=1:(imgHeight-interval)/interval
        for j=1:(imgWidth-interval)/interval
           dataPts(ptsNum,1)=interval+(i-1)*interval;
            dataPts(ptsNum,2)=interval+(j-1)*interval;
            ptsNum=ptsNum+1;
        end
    end
    %
    SPIdata=zeros(PSFw,PSFw,ptsNum-1);
    PSFdata=zeros(PSFw,PSFw,ptsNum-1);
    %Calculate the screen coordinates of the area of the screen that in the
    %view of camera
    [ xInit,yInit,xEnd,yEnd]= calculate_screenRoi(Fringepath,phasefx);
    roiWidth=xEnd-xInit;
    roiHeight=yEnd-yInit;
    %Saves the screen coordinates for the screen area
    save(['resultdata\',fileName,'\srceenRoi.mat'],'xInit','yInit','xEnd','yEnd');
    disp(['screen roi width:' num2str(roiWidth)]);
    disp(['screen roi:height' num2str(roiHeight)]);
    %step2£ºdepth calculation
    tic
    [R,T,repjerr]=calscreenpose(Fringepath,LCDH,LCDW,phasefx);
    Rw2c=R;
    Tw2c=T;
    camT=-R'*T';
    camTc2w=camT;
    depth=camTc2w(3)
    disp(['depth =' num2str(depth)]);
    save(['resultdata\',fileName,'\camRT.mat'],'R','T','repjerr','camTc2w');
    disp('time to solve depth');
    toc
    
    tic
    %solve the Fourier coefficient:H(u,v, fx,fy);
    [FrealAll,FimagAll]=optimizecalF2(Fringepath,fringeX,fringeY,dataPts,21);
    disp("alg time is:");
    toc
    %step3 sovle the PSF by IFT
    
  tic
for k=1:ptsNum-1
        disp(['index of solved pt::',num2str(k)]);
        xmin=dataPts(k,1)-10;
        xmax=dataPts(k,1)+10;
        ymin=dataPts(k,2)-10;
        ymax=dataPts(k,2)+10;
        %Calculate the correspondence between object point and image point
        [slicer,slicec,lcdmapccd]=optimizeqiepian3(Fringepath,LCDH,LCDW,xmin,xmax,ymin,ymax,phasefx);

        Freal=FrealAll(:,:,:,:,k);
        Fimag=FimagAll(:,:,:,:,k);
   %%
   Row=slicer(width+1,height+1);
   Col=slicec(width+1,height+1);
   %%
        
        lcdimg=zeros(PSFw,PSFw,xmax-xmin+1,ymax-ymin+1);
        camX=xmax-xmin+1;
        camY=ymax-ymin+1;
        %%Inverse Fourier transform, and use parallel to restore the correct distribution
        for i =1:1:camX                                
         for j=1:1:camY
            %Freal,Fimag:The first two dimensions are located, and the last two dimensions are camera pixel positions
            tempF=double(Freal(:,:,i,j))+1i*double(Fimag(:,:,i,j));
            lcdimg(:,:,i,j)=calPSF(tempF,PSFw,slicer(i,j),slicec(i,j),fringeX,fringeY,width,height,LCDH,LCDW);
         end
        end
       %
       cofficients=lcdimg(:,:,11,11);
        %recombine the PSF result.
       
       startimg=recombinePSF(Row,Col,1,21,1,21,LCDW,LCDH,lcdimg,PSFw,lcdmapccd);
       startimg=uint8(255*startimg/(max(max(startimg))));
       
       SPIdata(:,:,k)=cofficients;
       PSFdata(:,:,k)=startimg;
       %%
        imwrite(cofficients/max(max(cofficients)),['resultdata\',fileName,'\SPIdata\SPI_',num2str(k),'.bmp']);
     
        imwrite(startimg,['resultdata\',fileName,'\ObjectPSF\PSF_',num2str(k),'.bmp']);
 
end 
    toc
    %combine the result
    rows=(imgHeight-interval)/interval;
    cols=(imgWidth-interval)/interval;
     [ SPIimg ] = PSFcombine( SPIdata,rows,cols,0 );
     imwrite(SPIimg,['resultdata\',fileName,'\SPIdata\SPIimg.bmp']);
     [ PSFimg ] = PSFcombine( PSFdata,rows,cols,0 );
      imwrite(PSFimg,['resultdata\',fileName,'\ObjectPSF\PSFimg.bmp']);
      
end 
disp('Total time£º');
toc





























