function[slicer,slicec,lcdmapccd]=optimizeqiepian3(fringepath,prjX,prjY,xmin,xmax,ymin,ymax,fx)
%The last parameter is the center frequency of the phase-shifted fringe


slicer=(phaseunwrap2(fringepath,xmin,xmax,ymin,ymax,fx,0));%0Ϊrow  21*21
slicec=(phaseunwrap2(fringepath,xmin,xmax,ymin,ymax,fx,1));
slicer=round(slicer);%0 is row  21*21
slicec=round(slicec);
%slice(i,j): LCD screen coordinate(slicer(i,j),slicec(i,j))corresponding to camera coordiante(i,j)

lcdmapccd=cell(prjX,prjY);%2160*3840
camX=xmax-xmin+1;
camY=ymax-ymin+1;

  for i=1:1:camX%21
      for j=1:1:camY
          lcdmapccd{slicer(i,j),slicec(i,j)}=[i,j];%The coordinates of CCD pixels can be indexed by the coordinates of the LCD
      end
  end
end