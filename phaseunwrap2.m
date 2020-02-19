function[slice]=phaseunwrap2(fringepath,xmin,xmax,ymin,ymax,fx,direction)
% direction=0;%��ʱͶ��������ƣ����Ӧ�ڼ�row��
% 
% slicepath=['E:\mk\����\��һ\����\ʵ��\5_18�Ż����д���'];
% t1=19;
% t2=20;
% t3=21;
% xmin=1;
% ymin=1;
% xmax=2160;
% ymax=3840;

%%

t2 = fx;
t1 = fx-1;
t3 = fx+1;
camR=xmax-xmin+1;
camC=ymax-ymin+1;
t12 = t1 * t2 / (t2 - t1);
t23 = t2 * t3 / (t3 - t2);
t123 = t12 * t23 / (t23 - t12);

%%

%h = waitbar(0,'������Ƭ��ȴ�');
%tic
img1=zeros(camR,camC,3);
img2=zeros(camR,camC,3);
img3=zeros(camR,camC,3);
img4=zeros(camR,camC,3);
if(direction==0)%��row��
    j=1;
    for i=[t1 t2 t3]
        filename1=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_1.bmp'];
        filename2=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_2.bmp'];
        filename3=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_3.bmp'];
        filename4=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_4.bmp'];
        img00P=double(imread(filename1));
        img05P=double(imread(filename2));
        img10P=double(imread(filename3));
        img15P=double(imread(filename4));
        img1(:,:,i-t1+1)=double(img00P(xmin:xmax,ymin:ymax));
        img2(:,:,i-t1+1)=double(img05P(xmin:xmax,ymin:ymax));
        img3(:,:,i-t1+1)=double(img10P(xmin:xmax,ymin:ymax));
        img4(:,:,i-t1+1)=double(img15P(xmin:xmax,ymin:ymax));
    end
else
    i=1;
    for j=[t1 t2 t3]
        filename1=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_1.bmp'];
        filename2=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_2.bmp'];
        filename3=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_3.bmp'];
        filename4=[fringepath,'\phase fx',num2str(i),'_fy',num2str(j),'_4.bmp'];
        img00P=double(imread(filename1));
        img05P=double(imread(filename2));
        img10P=double(imread(filename3));
        img15P=double(imread(filename4));
        img1(:,:,j-t1+1)=double(img00P(xmin:xmax,ymin:ymax));
        img2(:,:,j-t1+1)=double(img05P(xmin:xmax,ymin:ymax));
        img3(:,:,j-t1+1)=double(img10P(xmin:xmax,ymin:ymax));
        img4(:,:,j-t1+1)=double(img15P(xmin:xmax,ymin:ymax));
    end
    
end
%%�ֱ��������Ƶ�ʵĴ��ظ�����λ
a11 = double(img4(:,:,1)) - double(img2(:,:,1));%2asin����
a12 = double(img1(:,:,1)) - double(img3(:,:,1));%2acos����
a21 = double(img4(:,:,2)) - double(img2(:,:,2));
a22 = double(img1(:,:,2)) - double(img3(:,:,2));
a31 = double(img4(:,:,3)) - double(img2(:,:,3));
a32 = double(img1(:,:,3)) - double(img3(:,:,3));
%%atan2(Y,X)��Χ�� [-pi/2,pi/2]
phase1 = atan2(a11, a12);
phase2 = atan2(a21, a22);
phase3 = atan2(a31, a32);
%  figure ,
%  imshow(phase1,[]);
%  figure ,
%  imshow(phase2,[]);
%��������Ƶ��������λֵ
phase12 = phase1 - phase2;

phase23 = phase2 - phase3;
phase12(phase12<0)=phase12(phase12<0)+2*pi;
phase23(phase23<0)=phase23(phase23<0)+2*pi;
% for i = 1:1:camR
%     for j = 1:1:camC
% %         if phase12(i, j) > 2 * pi
% %             phase12(i, j) = phase12(i, j) - 2 * pi;
% %         else
%         if phase12(i, j) < 0
%             phase12(i, j) = phase12(i, j) + 2 * pi;
%         end
% %         if phase23(i, j) > 2 * pi
% %             phase23(i, j) = phase23(i, j) - 2 * pi;
% %         else
%         if phase23(i, j) < 0
%             phase23(i, j) = phase23(i, j) + 2 * pi;
%         end
%     end
% end
phase123 = phase12 - phase23;
phase123(phase123<0)=phase123(phase123<0)+2*pi;
% for i = 1:1:camR
%     for j = 1:1:camC
%         if phase123(i, j) > 2 * pi
%             phase123(i, j) = phase123(i, j) - 2 * pi;
%         end
% %         else
%         if phase123(i, j) < 0
%             phase123(i, j) = phase123(i, j) + 2 * pi;
%         end
%     end
% end
%phase123��0-2pi����λֵ�����������phase12�ı�������������fringeorder����phase12��λչ����
rectphase12=phase12 + 2 * pi * round(1 / (2 * pi) * (double(t123) / double(t12) * phase123 - phase12));
%  figure ,
%  imshow(rectphase12,[]);
%wangyu ע��20190506
rectphase23 = phase23 + 2 * pi * round(1 / (2 * pi) * (double(t123) / double(t23) * phase123 - phase23));
rectphase1 = phase1 + 2 * pi * round(1 / (2 * pi) * (double(t12) /double( t1) * rectphase12 - phase1));
rectphase2 = phase2 + 2 * pi * round(1 / (2 * pi) * (double(t12) /double( t2) * rectphase12 - phase2));
rectphase3= phase3 + 2 * pi * round(1 / (2 * pi) * (double(t23) / double(t3) * rectphase23 - phase3));

%wangyuע��20190516
%  figure ,
%  imshow(rectphase1,[]);

% figure ,
% imshow(rectphase2,[]);
% figure ,
% imshow(rectphase3,[]);
%%
%���ת��Ϊ���ص�λ����2pi��Ƶ�ʼ������ƿ��
% pixphase1=round(rectphase1/(2*pi)*t1);
% pixphase2=round(rectphase2/(2*pi)*t2);
% pixphase3=round(rectphase3/(2*pi)*t3);
%10.21ȥ��round
pixphase1=rectphase1/(2*pi)*t1;
pixphase2=rectphase2/(2*pi)*t2;
pixphase3=rectphase3/(2*pi)*t3;
meanphase=(pixphase1+pixphase2+pixphase3)/3;

%�����������������ë�̵��
if(direction==0)%��row��
    meanphaseleft=meanphase(:,2:end);
    meanphaseleft=[meanphaseleft,meanphase(:,end)];
    meanphaseright=meanphase(:,1:end-1);
    meanphaseright=[meanphase(:,1),meanphaseright];
    mask=abs(2*meanphase-meanphaseleft-meanphaseright)>4;
  %  Mask=((meanphase<(meanphaseleft-4)&&meanphase<(meanphaseright-4))||(meanphase>(meanphaseleft+4)&&meanphase>(meanphaseright+4)));
    %10.15���Ĺ�����֤mask�Ĵ�Сһ�£����ǿ��ܲ�һ����Ӧ��ȷ��Ч����ע���Ժ�����Ż�
    maskleft=mask(:,2:end);
    %maskleft=[maskleft,mask(:,end)];
    maskleft=[maskleft,mask(:,1)];
    maskright=mask(:,1:end-1);
    %maskright=[mask(:,1),maskright];
    maskright=[mask(:,end),maskright];
    meanphase(mask)=(meanphase(maskleft)+meanphase(maskright))/2;
else
    meanphaseup=meanphase(2:end,:);
    meanphaseup=[meanphaseup;meanphase(end,:)+2];
    meanphasedown=meanphase(1:end-1,:);
    meanphasedown=[meanphase(1,:);meanphasedown];
    mask=abs(2*meanphase-meanphaseup-meanphasedown)>4;
    %�����maskҲ����һ��
    maskup=mask(2:end,:);
    maskup=[maskup;mask(1,:)];
    maskdown=mask(1:end-1,:);
    maskdown=[mask(end,:);maskdown];
    meanphase(mask)=(meanphase(maskup)+meanphase(maskdown))/2;
  
end

% if(mode==0)%��row��
%     mask=(meanphase>camR);
%     maskup=mask(2:end,:);
%     maskup=[maskup;mask(end,:)];
%     masklow=mask(1:end-1,:);
%     masklow=[mask(1,:);masklow];
%     meanphase(mask)=(meanphase(maskup)+meanphase(masklow))/2;
% else
%     mask=(meanphase>6000);
%     maskleft=mask(:,2:end);
%     maskleft=[maskleft,mask(:,end)];
%     maskright=mask(:,1:end-1);
%     maskright=[mask(:,1),maskright];
%     meanphase(mask)=(meanphase(maskleft)+meanphase(maskright))/2;
% end
%meanphase=meanphase+1;
meanphase=meanphase+1;
slice=meanphase;
%figure(123);
%imshow(phase123, []);
% figure,
% imshow(meanphase,[]);
end