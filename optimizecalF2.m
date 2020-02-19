function [Freal,Fimag]=optimizecalF2(fringepath,fringeX,fringeY,dataPts,width)
%P=1024; %条纹有效CCD坐标为243-991 301-1299 ，
%Q=1280;
% X=720;%归一化框大小，即投射条纹的区域大小
% Y=1120;
%fringeX=24;%投射条纹分辨率大小100*125
%fringeY=24;
%参数
b=1;
k0=1;

%F=zeros(fringeX,fringeY,xmax-xmin+1,ymax-ymin+1);  %储存单个单像素接收到的傅里叶系数
Freal=int16(zeros(fringeX,fringeY,width,width,(length(dataPts))));
Fimag=int16(zeros(fringeX,fringeY,width,width,(length(dataPts))));
% PSF=zeros(11,11);%储存坐标p，q的
%已经解算了（300-400，200-800）

h = waitbar(0,'计算傅里叶系数请等待');
r_1=(width-1)/2;
%每次计算一个点，都需要重新读入图像，非常影响速度
for i=1:1:fringeX/2+1%i,j表示投射频率,M取50，N取50，生成的图像大小为50*50
    %for i=1:1:M
        for j=1:1:fringeY 
                
               % img=zeros(1200,1600,4);
               % for m=1:4
               %     filename=[fringepath,'\stripe fx',num2str(i),'_fy',num2str(j),'_',num2str(m),'.bmp'];
                %    img(:,:,m)=double(imread(filename));
                %end
                filename1=[fringepath,'\stripe fx',num2str(i),'_fy',num2str(j),'_1.bmp'];
                filename2=[fringepath,'\stripe fx',num2str(i),'_fy',num2str(j),'_2.bmp']; 
                filename3=[fringepath,'\stripe fx',num2str(i),'_fy',num2str(j),'_3.bmp'];
                filename4=[fringepath,'\stripe fx',num2str(i),'_fy',num2str(j),'_4.bmp'];
                img00P=double(imread(filename1));
                img05P=double(imread(filename2));
                img10P=double(imread(filename3));
                img15P=double(imread(filename4));
             
                for k=1:1:length(dataPts)%不能使用parfor的原因是这个内层循环存在的结果
                    
                    xmin=dataPts(k,1)-r_1;
                    xmax=dataPts(k,1)+r_1;
                    ymin=dataPts(k,2)-r_1;
                    ymax=dataPts(k,2)+r_1;
                      Freal(i,j,:,:,k)=1/(2*b*k0) * (img00P(xmin:xmax,ymin:ymax)-img10P(xmin:xmax,ymin:ymax));
                     Fimag(i,j,:,:,k)=1/(2*b*k0) * (img05P(xmin:xmax,ymin:ymax)-img15P(xmin:xmax,ymin:ymax));
                end
                   
                %取的是拍摄图里坐标为300——400区域的点反算即相机坐标系下值
                    %投影仪坐标系原点在相机坐标系为499，102
                    %该区域对应的投影仪坐标系下的像素点为
               % j
              %  i
        
        waitbar((i*fringeY+j)/((fringeX/2+1)*fringeY));
        end      
end


       % clear;
  %通过共轭条件计算所有的傅里叶系数
   for k=1:1:length(dataPts)
  for i=fringeX/2+2:1:fringeX
            for j=1:1:fringeY
                if(j==1)
                   % F(i,j,:,:)=conj(F(fringeX-i+2,j,:,:));
                    Freal(i,j,:,:,k)=Freal(fringeX-i+2,j,:,:,k);
                    Fimag(i,j,:,:,k)=-Fimag(fringeX-i+2,j,:,:,k);
                else             
                    %F(i,j,:,:)=conj(F(fringeX-i+2,fringeY-j+2,:,:));
                    Freal(i,j,:,:,k)=Freal(fringeX-i+2,fringeY-j+2,:,:,k);
                    Fimag(i,j,:,:,k)=-Fimag(fringeX-i+2,fringeY-j+2,:,:,k);
                end              
            end
  end
    
   end
   close(h);
end

