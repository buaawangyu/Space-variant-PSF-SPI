function [ jetImg ] = gray2jet( grayImg )
%GRAY2JET Summary of this function goes here
%   Detailed explanation goes here
c=jet(256);
Imgsize=size(grayImg);
if(~isa(grayImg,'uint8'))
   grayImg=im2uint8(grayImg);
end
grayImg=uint8(grayImg);
jetImg=zeros(Imgsize(1),Imgsize(2),3);
for i=1:Imgsize(1)
    for j=1:Imgsize(2)
        jetImg(i,j,1)=c(grayImg(i,j)+1,1)*255;
         jetImg(i,j,2)=c(grayImg(i,j)+1,2)*255;
          jetImg(i,j,3)=c(grayImg(i,j)+1,3)*255;
    end
end

end

