function out = dhToTransformMatrix( theta, d, a, alpha )
%Convert angles to radians

thetaR = theta * (pi/180);
alphaR = alpha * (pi/180);

%Define trig functions
ct = cos(thetaR);
st = sin(thetaR);
ca = cos(alphaR);
sa = sin(alphaR);

%Define individual transform matrices for each DH parameter
rotTheta = [ct -st 0 0;
            st ct 0 0;
            0 0 1 0;
            0 0 0 1];
        
transD = [1 0 0 0;
          0 1 0 0;
          0 0 1 d;
          0 0 0 1];
      
transA = [1 0 0 a;
          0 1 0 0;
          0 0 1 0;
          0 0 0 1];

rotAlpha = [1 0 0 0;
            0 ca -sa 0;
            0 sa ca 0;
            0 0 0 1];

%Calculate homogeneous transform
out = rotTheta * transD * transA * rotAlpha;


end

