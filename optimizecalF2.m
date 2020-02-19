function [Freal,Fimag]=optimizecalF2(fringepath,fringeX,fringeY,dataPts,width)
%P=1024; %������ЧCCD����Ϊ243-991 301-1299 ��
%Q=1280;
% X=720;%��һ�����С����Ͷ�����Ƶ������С
% Y=1120;
%fringeX=24;%Ͷ�����Ʒֱ��ʴ�С100*125
%fringeY=24;
%����
b=1;
k0=1;

%F=zeros(fringeX,fringeY,xmax-xmin+1,ymax-ymin+1);  %���浥�������ؽ��յ��ĸ���Ҷϵ��
Freal=int16(zeros(fringeX,fringeY,width,width,(length(dataPts))));
Fimag=int16(zeros(fringeX,fringeY,width,width,(length(dataPts))));
% PSF=zeros(11,11);%��������p��q��
%�Ѿ������ˣ�300-400��200-800��

h = waitbar(0,'���㸵��Ҷϵ����ȴ�');
r_1=(width-1)/2;
%ÿ�μ���һ���㣬����Ҫ���¶���ͼ�񣬷ǳ�Ӱ���ٶ�
for i=1:1:fringeX/2+1%i,j��ʾͶ��Ƶ��,Mȡ50��Nȡ50�����ɵ�ͼ���СΪ50*50
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
             
                for k=1:1:length(dataPts)%����ʹ��parfor��ԭ��������ڲ�ѭ�����ڵĽ��
                    
                    xmin=dataPts(k,1)-r_1;
                    xmax=dataPts(k,1)+r_1;
                    ymin=dataPts(k,2)-r_1;
                    ymax=dataPts(k,2)+r_1;
                      Freal(i,j,:,:,k)=1/(2*b*k0) * (img00P(xmin:xmax,ymin:ymax)-img10P(xmin:xmax,ymin:ymax));
                     Fimag(i,j,:,:,k)=1/(2*b*k0) * (img05P(xmin:xmax,ymin:ymax)-img15P(xmin:xmax,ymin:ymax));
                end
                   
                %ȡ��������ͼ������Ϊ300����400����ĵ㷴�㼴�������ϵ��ֵ
                    %ͶӰ������ϵԭ�����������ϵΪ499��102
                    %�������Ӧ��ͶӰ������ϵ�µ����ص�Ϊ
               % j
              %  i
        
        waitbar((i*fringeY+j)/((fringeX/2+1)*fringeY));
        end      
end


       % clear;
  %ͨ�����������������еĸ���Ҷϵ��
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

