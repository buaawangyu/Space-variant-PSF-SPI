function[starimg]=recombinePSF(row,col,xmin,xmax,ymin,ymax,prjX,prjY,lcdimg,loclength,lcdmapccd)
%row和col为给出的LCD屏幕上一点，slicer和slicec存的是CCD像素对应LCD小框的中心点坐标
width=(loclength-1)/2;
height=(loclength-1)/2;

tempimg=zeros(prjX,prjY);
camX=xmax-xmin+1;
camY=ymax-ymin+1;
starimg=zeros(camX,camY);
for i=row-height:1:row+height
    for j=col-width:1:col+width
        if(~isempty(lcdmapccd{i,j}))
            ccdcoordinates=lcdmapccd{i,j};%用deal多个变量同时赋值
            ccdrow=ccdcoordinates(1);
            ccdcol=ccdcoordinates(2);
            tempimg(i-height:i+height,j-width:j+width)=lcdimg(:,:,ccdrow,ccdcol);%此时LCD上点i，j所对应的CCD点ccdrow，ccdcol形成的小图像放回prjX大图像里。
            %starimg(ccdrow,ccdcol)=lcdimg(row-i+1+height,col-j+1+width,ccdrow,ccdcol);
            starimg(ccdrow,ccdcol)=tempimg(row,col);%lcd后两维是相机坐标，前两维是lcd坐标
        end
        
        
    end
end