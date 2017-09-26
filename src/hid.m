
clc; clear; close all; delete *.csv;
javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

pp = PacketProcessor(7);

%%PID%%
baseConstants = [0.001; 0; 0.01];
shoulderConstants = [0.002; 0.00002; 0.01];
elbowConstants = [0.002; 0; 0.01];
pidConstants = [baseConstants; shoulderConstants; elbowConstants; 0;0;0;0;0;0;];
pidJunk = pp.command(39, pidConstants);
%%%%%%%

%constant that maps ticks to degrees
baseScalingFactor = 11.44;


values = zeros(15, 1, 'single');

tic;

currentSetpoint = [0,0,0];


set =   [100,100,100;
    200,200,350;
    350,200,150];

setpoints = [interpolate(set(1,:),set(2,:),20); interpolate(set(2,:),set(3,:),20); interpolate(set(3,:),set(1,:),20);]

while 1
    
    values = zeros(15, 1, 'single');
    
    returnValues = goToEnc(0,0,0);
    
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
pp.shutdown()
clear java;