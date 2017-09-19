tic;
clc; 
clear;
close all;
javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

delete *.csv;

pp = PacketProcessor(7);

%Create an array of 32 bit floating point zeros to load an pass to the
%packet processor
x = 0;
y = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  PID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
baseConstants = [0.005; 0; 0.002;];
shoulderConstants = [0.004; 0.00002; 0.005;];
elbowConstants = [0.004; 0; 0.005];
pidConstants = [baseConstants; shoulderConstants; elbowConstants; 0;0;0;0;0;0;];

%send the constants, receive junk from nucleo (dummy values)
pidJunk = pp.command(39, pidConstants);


%constant that maps ticks to degrees
baseScalingFactor = 11.44;

incrementer = 1;
timer = 0;
%0,365,-295
%0,-100,825
%0,777,-140

% %6-8
% setpoints1 = [0 0 0 0 0 -1];
% setpoints2 = [1030 667 311 29 1268 -1];
% setpoints3 = [1030 1417 2109 985 2049 -1];

%9
 setpoints1 = [300 -200 150 0];
 setpoints2 = [777 -100 365 777];
 setpoints3 = [-140 825 -295 -140];

% 10 raw interpolation
% Array=csvread('10-point-triangle.csv~');
% setpoints1 = Array(:, 1);
% setpoints2 = Array(:, 2);
% setpoints3 = Array(:, 3);
% 
% disp(setpoints2);
% 
 currentSetpoint = [setpoints1(incrementer) setpoints2(incrementer) setpoints3(incrementer)];
 currentEncoders = [0 0 0];
%%Lab 3
%cam = webcam();
% while 1
%     for times = 1:5
%         max=100;
%         for z = 10:max
%             u=z/max;
%             result = findRedCircle(cam,u);
%             dlmwrite('Lab5CircleTime.csv', [u result], '-append');
%         end
%         Array = csvread('Lab5CircleTime.csv');
%         col1 = Array(:, 1);
%         col2 = Array(:, 2);
%         scatter(col1,col2,4);
%         x = lsline
%         disp(lsline)
%         disp("done");
%     end
%         
% end




tic;
while 1
    x= x+ 1;

    values = zeros(15, 1, 'single');
    
    %if(incrementer<6)
    if(incrementer<35)
    
        if (isAtSetpoints(currentSetpoint, currentEncoders)==3)
            timer = timer+1;
        else
            timer = 0;
        end
        if (timer>=5)
            incrementer = incrementer+1;
            if(incrementer==30)
                incrementer=0;
            end
            currentSetpoint = [setpoints1(incrementer) setpoints2(incrementer) setpoints3(incrementer)];
            timer=0;
        end
        disp(timer);
        disp(incrementer);
        values(1)=setpoints1(incrementer);
        values(4)=setpoints2(incrementer);
        values(7)=setpoints3(incrementer);
    
    end
    
    
    tic
    %Process command and print the returning values
    returnValues = pp.command(38, values);
    %          toc
    %          disp('sent');
    %          disp(values);
    %          disp('got');
    %          disp(returnValues);
    disp('Current setpoints');
    disp(currentSetpoint);
    disp(currentEncoders);
    %Concatenate "loop incrementer" to encoder values
    toWrite = cat(1, x,returnValues);
    %pause(0.1) %timeit(returnValues)
    %dlmwrite('Lab1CSV.csv', transpose(toWrite), '-append');
         
     
     %pause(.01)
     %wait
     
     
     
    
     
     %encoder values read from returnValues
     baseEncoder = returnValues(1);
     shoulderEncoder = returnValues(4);
     elbowEncoder = returnValues(7);
     
     currentEncoders = [baseEncoder shoulderEncoder elbowEncoder];
     
     %encoder values mapped to degrees
     baseDeg = baseEncoder / baseScalingFactor;
     shoulderDeg = shoulderEncoder/ baseScalingFactor;
     elbowDeg = (elbowEncoder/baseScalingFactor-90);
     
     %velocity values read
     baseVel = returnValues(2);
     shoulderVel=returnValues(5);
     elbowVel = returnValues(8);
     
     linkLength = 100;

     %find setpoint in degrees
     baseSetDeg = currentSetpoint(1)/baseScalingFactor;
     shoulderSetDeg = currentSetpoint(2)/baseScalingFactor;
     elbowSetDeg = currentSetpoint(3)/baseScalingFactor;

    %3D Forward Position Kinematics
     %top of link 1 (base)
     x1 = 0;
     y1 = 0;
     z1 = linkLength;
     
     %top of link 2 (shoulder)
     x2 = sind(baseDeg) * (x1 + cosd(shoulderDeg) * linkLength);
     y2 = cosd(baseDeg) * (y1 + cosd(shoulderDeg) * linkLength);
     z2 = z1 + sind(shoulderDeg) * linkLength;
     
     %top of link 3 (elbow)
     x3 = sind(baseDeg) * (x2 + cosd(elbowDeg+shoulderDeg) * linkLength);
     y3 = cosd(baseDeg) * (y2 + cosd(elbowDeg+shoulderDeg) * linkLength);
     z3 = z2 + sind(elbowDeg+shoulderDeg) * linkLength;
     
     %find setpoint in degrees
     baseSetDeg = currentSetpoint(1)/baseScalingFactor;
     shoulderSetDeg = currentSetpoint(2)/baseScalingFactor;
     elbowSetDeg = currentSetpoint(3)/baseScalingFactor;
     
     %top of arm setpoint
     sx1 = 0;
     sy1 = 0;
     sz1 = linkLength;
     
     %top of shoulder setpoint
     sx2 = sind(baseDeg) * (sx1 + cosd(shoulderDeg) * linkLength);
     sy2 = cosd(baseDeg) * (sy1 + cosd(shoulderDeg) * linkLength);
     sz2 = sz1 + sind(shoulderDeg) * linkLength;
     
     %top of elbow setpoint
     sx3 = sind(baseDeg) * (sx2 + cosd(elbowDeg+shoulderDeg) * linkLength);
     sy3 = cosd(baseDeg) * (sy2 + cosd(elbowDeg+shoulderDeg) * linkLength);
     sz3 = sz2 + sind(elbowDeg+shoulderDeg) * linkLength;
     
     
% %     2D Forward Position Kinematics
%      %top of link 1 (base)
%      x1 = 0;
%      y1 = linkLength;
%      
%      %top of link 2 (shoulder)
%      x2 = x1 + cosd(shoulderDeg) * linkLength;
%      y2 = y1 + sind(shoulderDeg) * linkLength;
%      
%      %top of link 3 (elbow)
%      x3 = x2 + sind(elbowDeg+shoulderDeg) * linkLength;
%      y3 = y2 - cosd(elbowDeg+shoulderDeg) * linkLength;
%
%      
%      %top of arm setpoint
%      sx1 = 0;
%      sy1 = linkLength;
%      
%      %top of shoulder setpoint
%      sx2 = sx1 + cosd(shoulderSetDeg) * linkLength;
%      sy2 = sy1 + sind(shoulderSetDeg) * linkLength;
%      
%      %top of elbow setpoint
%      sx3 = sx2 + sind(elbowSetDeg+shoulderSetDeg) * linkLength;
%      sy3 = sy2 - cosd(elbowSetDeg+shoulderSetDeg) * linkLength;
     
     
%      %Write tip position to csv
%      dlmwrite('Lab2CSV.csv', transpose([x3; y3]), '-append');
%      
%      %Write encoder values to csv
%      dlmwrite('Lab2CSV-setpoints.csv', [baseEncoder shoulderEncoder elbowEncoder], '-append');
% 
%     
%      
%      
%      hold on;
%      axis([-300 300 0 300])cosd;
%      plot([0 x1 x2 x3], [0 y1 y2 y3],'-o');
%      plot([0 sx1 sx2 sx3], [0 sy1 sy2 sy3],'-o');
%      drawnow;
%      hold off;
%      %pause(0.1);
%      clf;


%      3D plot
       
       
       plot3([0 x1 x2 x3], [0 y1 y2 y3], [0 z1 z2 z3]);
       xlim([-300 300]);
       ylim([-300 300]);
       zlim([-300 300]);
       %plot([0 sx1 sx2 sx3], [0 sy1 sy2 sy3],'-o');
       drawnow;
       
       %pause(0.1);
       clf;

%      
%      
%      Array=csvread('Lab2CSV.csv');
%      col1 = Array(:, 1);
%      col2 = Array(:, 2);
%      %axis([-100 100 -100 100]);
%      %x1 = cosd(deg)*100;
%      %y1 = sind(deg)*100;
%      %vals = [0 x1; 0 y1];
%      plot(col1, col2)
     %plotv(vals, '-o')
     %pause(0.1);
     %camera runs at 9/sec
     %try running the camera on a seperate thread
%        findRedCircle();

%      r = img(:,:,1);
%      g = img(:,:,2);
%      b = img(:,:,3);
     
end
pp.shutdown()
clear java;