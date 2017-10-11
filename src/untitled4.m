while 1
   img = snapshot(cam);
   img3 = fliplr(flipud(img));
   [x,y] = findColorFast(img3);
   x
end