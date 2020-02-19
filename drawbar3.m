% function[psfimg]= drawbar3(psfimg,titlename)
% psfimg=double(psfimg)/max(max(double(psfimg)));
% psfimg=double(psfimg);
% figure('name',titlename),psf=bar3(psfimg);
%     colorbar
%          for k=1:length(psf)
%              zdata=psf(k).ZData;
%              psf(k).CData=zdata;
%              psf(k).FaceColor='interp';
%          end
function[psfimg]= drawbar3(psfimg,titlename)
psfimg=double(psfimg)/max(max(double(psfimg)));
psfimg=double(psfimg);
figure('name',titlename),psf=bar3(psfimg);
    xlabel('u/pixel','FontName','Times New Roman','FontSize',24);
    ylabel('v/pixel','FontName','Times New Roman','FontSize',24);
    zlabel('Normalized intensity','FontName','Times New Roman','FontSize',24);

   hcb=colorbar;
   set(hcb,'ytick',[0:0.2:1],'FontName','Times New Roman','FontSize',24);
         for k=1:length(psf)
             zdata=psf(k).ZData;
             psf(k).CData=zdata;
             psf(k).FaceColor='interp';
         end