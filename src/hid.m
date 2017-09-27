
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

currentSetpoint = [0,0,0];


set =   [100,100,100;
    200,200,350;
    350,200,150];


success = 0;

tip = [0,0,0,0];


%initialize plot stuff
figure(1);
xStuff = [0 0 0 0];
yStuff = [0 0 0 0];
zStuff = [0 0 0 0];
plotVar = plot3(xStuff,yStuff,zStuff);

%setpoints
currentBase = 0;
currentShoulder = 0;
currentElbow = 0;
setpointIncrementer=0;
%setpoints = [interpolate(set(1,:),set(2,:),20); interpolate(set(2,:),set(3,:),20); interpolate(set(3,:),set(1,:),20);];
setpoints = [trajectory3d(10,10,10,20,20,35); trajectory3d(20,20,35,35,20,15); trajectory3d(35,20,15,10,10,10)]; 
%setpoints = [30,-30,100;30,30,100];
% setpoints = [trajectory3d(30,-30,100,-30,-30,100); trajectory3d(-30,-30,100,-30,30,100); 
%             trajectory3d(-30,30,100,30,30,100);trajectory3d(30,30,100,30,-30,100);
%             trajectory3d(30,-30,100,90,0,100); trajectory3d(90,0,100,70,10,100); 
%             trajectory3d(70,10,100,90,10,100); trajectory3d(90,10,100,90,20,100);
%             trajectory3d(90,20,100,50,20,100); trajectory3d(50,20,100,30,30,100)];

%%PID%%
baseConstants = [0.001; 0; 0.01];
shoulderConstants = [0.002; 0.00002; 0.01];
elbowConstants = [0.002; 0; 0.01];
pidConstants = [baseConstants; shoulderConstants; elbowConstants; 0;0;0;0;0;0;];
pidConstants=single(pidConstants);
pidJunk = pp.command(39, pidConstants);
%%%%%%%

while 1
    
    values = zeros(15, 1, 'single');
    
    if success
        setpointIncrementer=setpointIncrementer+1;
        currentBase=setpoints(setpointIncrementer,1); 
        currentShoulder=setpoints(setpointIncrementer,2);
        currentElbow=setpoints(setpointIncrementer,3);
    end
    
    if setpointIncrementer==(length(setpoints)-1)
        setpointIncrementer=0;
    end
    
    [success, returnValues] = goToXYZ(currentBase,currentShoulder,currentElbow,pp);
    
    %encoder values read from returnValues
    baseEncoder = returnValues(1);
    shoulderEncoder = returnValues(4);
    elbowEncoder = returnValues(7);
    
    currentEncoders = [baseEncoder shoulderEncoder elbowEncoder];
    
    %encoder values mapped to degrees
    baseDeg = baseEncoder / baseScalingFactor;
    shoulderDeg = shoulderEncoder/ baseScalingFactor;
    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
    
    tip = plot3d(returnValues,currentSetpoint,plotVar,setpoints,tip);
    pause(0.1);
end
pp.shutdown()
clear java;