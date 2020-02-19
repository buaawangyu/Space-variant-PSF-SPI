function[starimg]=recombinePSF(row,col,xmin,xmax,ymin,ymax,prjX,prjY,lcdimg,loclength,lcdmapccd)
%row��colΪ������LCD��Ļ��һ�㣬slicer��slicec�����CCD���ض�ӦLCDС������ĵ�����
width=(loclength-1)/2;
height=(loclength-1)/2;

tempimg=zeros(prjX,prjY);
camX=xmax-xmin+1;
camY=ymax-ymin+1;
starimg=zeros(camX,camY);
for i=row-height:1:row+height
    for j=col-width:1:col+width
        if(~isempty(lcdmapccd{i,j}))
            ccdcoordinates=lcdmapccd{i,j};%��deal�������ͬʱ��ֵ
            ccdrow=ccdcoordinates(1);
            ccdcol=ccdcoordinates(2);
            tempimg(i-height:i+height,j-width:j+width)=lcdimg(:,:,ccdrow,ccdcol);%��ʱLCD�ϵ�i��j����Ӧ��CCD��ccdrow��ccdcol�γɵ�Сͼ��Ż�prjX��ͼ���
            %starimg(ccdrow,ccdcol)=lcdimg(row-i+1+height,col-j+1+width,ccdrow,ccdcol);
            starimg(ccdrow,ccdcol)=tempimg(row,col);%lcd����ά��������꣬ǰ��ά��lcd����
        end
        
        
    end
end