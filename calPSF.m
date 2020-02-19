function[img]=calPSF(Fimg,loclength,slicer,slicec,fringeX,fringeY,width,height,prjM,prjN)
%This function restores the correct distribution of the PSF
img=zeros(loclength,loclength);
tempresult=abs(ifft2(Fimg));

centerr=rem(slicer-1,fringeX)+1;
centerc=rem(slicec-1,fringeY)+1;
if(centerr<fringeX/2)
    centerr=centerr+fringeX;
else
    centerr=centerr;
end
if(centerc<fringeY/2)
    centerc=centerc+fringeY;
else
    centerc=centerc;
end
represult=repmat(tempresult,[2,2]);%Replicate Matrix
img=represult(centerr-height:centerr+height,centerc-width:centerc+width);