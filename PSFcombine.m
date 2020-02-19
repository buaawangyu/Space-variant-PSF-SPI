function [ PSFimg ] = PSFcombine( PSF,rowNum,colNum,PSFinterval )
%PSFCOMBINE Summary of this function goes here
%   Detailed explanation goes here
dataSize=size(PSF);
PSFwidth=dataSize(1);
PSFimg=255*zeros(rowNum*PSFwidth+(rowNum-1)*PSFinterval,colNum*PSFwidth+(colNum-1)*PSFinterval);

    for i=1:rowNum
        for j=1:colNum
            rowStart=1+(i-1)*(PSFwidth+PSFinterval);
            colStart=1+(j-1)*(PSFwidth+PSFinterval);
            singleImg=PSF(:,:,(i-1)*colNum+j);
            singleImg=singleImg;%-min(min(singleImg));
             PSFimg(rowStart:rowStart+PSFwidth-1,...
                 colStart:colStart+PSFwidth-1)=255*(singleImg)/(max(max(singleImg)));
             %=255*(singleImg-min(min(singleImg)))/(max(max(singleImg))-min(min(singleImg)));
        end
    end
   PSFimg=uint8(PSFimg);
end

