%%TODO
% encapsulate functions and organize everything
% trajectory generation (talk to gunnar about speeding that up)
% weight based on raw torque numbers (some kind of vector force filtering)
% 6 dropoff position function, takes weight and color
% add color recognition Y/G/B (take pixel sample at centroid)
% dont hit camera compensation
% probably lots of plots were missing
% other data and plots for the final
% gravity compensation
% cad display
% get signoffs
% force vector plot
% improve trajectory so it switches setpoints at some % of final setpoint,
% up to some percentage of setpoints


clc; clear; close all; delete *.csv;
javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

pp = PacketProcessor(7);


%constant that maps ticks to degrees
baseScalingFactor = 11.44;


values = zeros(15, 1, 'single');
returnValues=zeros(15, 1, 'single');

tic;

tip = [0,0,0,0];
deg = [0,0,0,0];

%initialize plot stuff
figure(1);
xStuff = [0 0 0 0];
yStuff = [0 0 0 0];
zStuff = [0 0 0 0];
plotVar = plot3(xStuff,yStuff,zStuff);

%%PID%%
baseConstants = [0.001; 0; 0.01];
shoulderConstants = [0.002; 0.00002; 0.01];
elbowConstants = [0.002; 0; 0.01];
pidConstants = [baseConstants; shoulderConstants; elbowConstants; 0;0;0;0;0;0;];
pidConstants=single(pidConstants);
pidJunk = pp.command(39, pidConstants);
%%%%%%%

success = false;
iterator=0;
if(~exist('cam','var')) 
    cam=webcam();
end

while(~success)
    [success,returnValues]=goToEnc(0,90*11.4,90*11.4,pp);
    img =fliplr(flipud(snapshot(cam)));
    [x,y] = findColorFast(img);
    [x,y]=[x(1),y(1)];
end

pause(0.5);
heightVar = 15;
gripper = zeros(15,1,'single');

while 1
    disp(x);
    disp(y);
    if(x>-1000)
        %7
        if(heightVar<2.1)
            gripper(1)=1;
            forces = pp.command(42, gripper);
            pause(2);
            heightVar=15;
            success=false;
            while(~success)
                [success, returnValues] = goToXYZ(x,-y,heightVar,pp);
            end
            success=false;
            while(~success)
                [success, returnValues] = goToEncDeg(45,0,90,pp);
            end
            pause(0.5);
            forces = pp.command(42, gripper);
            success=false;
            while(~success)
                [success,returnValues]=goToEnc(0,90*11.4,90*11.4,pp);
                img =fliplr(flipud(snapshot(cam)));
                [x,y] = findColorFast(img);
                [x,y]=[x(1),y(1)];
            end
        else
            heightVar = heightVar-0.25;
        end
        [success, returnValues] = goToXYZ(x,-y,heightVar,pp);
        values = zeros(15, 1, 'single');
    end
    
    
    forces = pp.command(42, gripper);
       
    %encoder values read from returnValues
    baseEncoder = returnValues(1);
    shoulderEncoder = returnValues(4);
    elbowEncoder = returnValues(7);
    
    currentEncoders = [baseEncoder shoulderEncoder elbowEncoder];
    
    %encoder values mapped to degrees
    baseDeg = baseEncoder / baseScalingFactor;
    shoulderDeg = shoulderEncoder/ baseScalingFactor;
    elbowDeg = (elbowEncoder/baseScalingFactor)-90;

end
pp.shutdown();
clear java;