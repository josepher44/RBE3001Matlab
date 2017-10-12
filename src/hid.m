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

% plot initialization
xStuff = [0,0,0,0,0];
yStuff = [0,0,0,0,0];
zStuff = [0,0,0,0,0];
plotVar = plot3(xStuff, yStuff, zStuff);



%%PID%%
baseConstants = [0.001; 0.0002; 0.01];
shoulderConstants = [0.002; 0.00025; 0.01];
elbowConstants = [0.002; 0.0004; 0.01];
pidConstants = [baseConstants; shoulderConstants; elbowConstants; 0;0;0;0;0;0;];
pidConstants=single(pidConstants);
pidJunk = pp.command(39, pidConstants);
%%%%%%%

success = false;
iterator=0;
if(~exist('cam','var'))
    cam=webcam();
end

gripper = zeros(15,1,'single');
time = 0;

success=false;

img =fliplr(flipud(snapshot(cam)));
[color, x,y] = findColorFast(img);


while(~success)
    %move to a position out of the way of the camera
    img =fliplr(flipud(snapshot(cam)));
    [color, x,y] = findColorFast(img);
    [success,returnValues]=goToEnc(0,90*11.4,0*11.4,pp);
    baseEncoder = returnValues(1);
    shoulderEncoder = returnValues(4);
    elbowEncoder = returnValues(7);
    
    baseScalingFactor = 11.44;
    baseDeg = baseEncoder / baseScalingFactor;
    shoulderDeg = shoulderEncoder/ baseScalingFactor;
    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
    
    [gravComp1, gravComp2]=gravityComp(shoulderDeg,elbowDeg-90);
    gripper(1) = 0;
    forces = pp.command(42, gripper);
    forces = [forces(1),forces(2)+gravComp1,forces(3)+gravComp2];
    
    plot3d(forces,returnValues,plotVar);
end

success=false;
while(~success)
    %move to a position out of the way of the camera
    
    img =fliplr(flipud(snapshot(cam)));
    [color, x,y] = findColorFast(img);
    [success,returnValues]=goToEnc(0,90*11.4,90*11.4,pp);
    
    baseEncoder = returnValues(1);
    shoulderEncoder = returnValues(4);
    elbowEncoder = returnValues(7);
    
    baseScalingFactor = 11.44;
    %encoder values mapped to degrees
    baseDeg = baseEncoder / baseScalingFactor;
    shoulderDeg = shoulderEncoder/ baseScalingFactor;
    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
    
    [gravComp1, gravComp2]=gravityComp(shoulderDeg,elbowDeg-90);
    gripper(1) = 0;
    forces = pp.command(42, gripper);
    forces = [forces(1),forces(2)+gravComp1,forces(3)+gravComp2];
    
    plot3d(forces,returnValues,plotVar);
    
end

pause(0.5);

while 1
    
    %check if any centroids
    img =fliplr(flipud(snapshot(cam)));
    [color, x,y] = findColorFast(img);
    
    [success,returnValues]=goToEnc(0,90*11.4,90*11.4,pp);
    baseEncoder = returnValues(1);
    shoulderEncoder = returnValues(4);
    elbowEncoder = returnValues(7);
    
    baseScalingFactor = 11.44;
    baseDeg = baseEncoder / baseScalingFactor;
    shoulderDeg = shoulderEncoder/ baseScalingFactor;
    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
    plot3d(forces,returnValues,plotVar);
    
    
    if (length(x)>0)
        %we didnt find anything
        if(x<-8000)
            %dont do anything, go to SLAM position
            success=false;
            while(~success)
                %move to a position out of the way of the camera
                [success,returnValues]=goToEnc(0,90*11.4,90*11.4,pp);
                baseEncoder = returnValues(1);
                shoulderEncoder = returnValues(4);
                elbowEncoder = returnValues(7);
                
                baseScalingFactor = 11.44;
                baseDeg = baseEncoder / baseScalingFactor;
                shoulderDeg = shoulderEncoder/ baseScalingFactor;
                elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                plot3d(forces,returnValues,plotVar);
            end
        else
            
            img =fliplr(flipud(snapshot(cam)));
            [color, x,y] = findColorFast(img);
            
            success=false;
            while(~success)
                %go to an arbitrary height above the centroid
                [success, returnValues] = goToXYZ(x-0.5,-y,15,pp);
                
                baseEncoder = returnValues(1);
                shoulderEncoder = returnValues(4);
                elbowEncoder = returnValues(7);
                
                baseScalingFactor = 11.44;
                baseDeg = baseEncoder / baseScalingFactor;
                shoulderDeg = shoulderEncoder/ baseScalingFactor;
                elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                plot3d(forces,returnValues,plotVar);
                
            end
            
            %make setpoints to descend
            setpoints = trajectory3d(x-0.5, -y, 15, x-0.5, -y, 2);
            for num = 1:length(setpoints)
                success=false;
                while(~success)
                    [success, returnValues] = goToXYZ(setpoints(num,1),setpoints(num,2),setpoints(num,3),pp);
                    
                    baseEncoder = returnValues(1);
                    shoulderEncoder = returnValues(4);
                    elbowEncoder = returnValues(7);
                    
                    baseScalingFactor = 11.44;
                    baseDeg = baseEncoder / baseScalingFactor;
                    shoulderDeg = shoulderEncoder/ baseScalingFactor;
                    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                    plot3d(forces,returnValues,plotVar);
                    pause(0.25);
                end
            end
            
            %close the gripper
            baseEncoder = returnValues(1);
            shoulderEncoder = returnValues(4);
            elbowEncoder = returnValues(7);
            
            baseScalingFactor = 11.44;
            %encoder values mapped to degrees
            baseDeg = baseEncoder / baseScalingFactor;
            shoulderDeg = shoulderEncoder/ baseScalingFactor;
            elbowDeg = (elbowEncoder/baseScalingFactor)-90;
            
            [gravComp1, gravComp2]=gravityComp(shoulderDeg,elbowDeg-90);
            gripper(1) = 1;
            forces = pp.command(42, gripper);
            forces = [forces(1),forces(2)+gravComp1,forces(3)+gravComp2];
            
            plot3d(forces,returnValues,plotVar);
            pause(1);
            
            setpoints = trajectory3d(x-0.5, -y, 2, x-0.5, -y, 5);
            for num = 1:length(setpoints)
                success=false;
                while(~success)
                    [success, returnValues] = goToXYZLoose(setpoints(num,1),setpoints(num,2),setpoints(num,3),pp);
                    
                    baseEncoder = returnValues(1);
                    shoulderEncoder = returnValues(4);
                    elbowEncoder = returnValues(7);
                    
                    baseScalingFactor = 11.44;
                    baseDeg = baseEncoder / baseScalingFactor;
                    shoulderDeg = shoulderEncoder/ baseScalingFactor;
                    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                    plot3d(forces,returnValues,plotVar);
                end
            end
            
            setpoints = trajectory3d(x-0.5, -y, 5, 3.5, 0, 36.6);
            for num = 1:length(setpoints)
                success=false;
                while(~success)
                    [success, returnValues] = goToXYZ(setpoints(num,1),setpoints(num,2),setpoints(num,3),pp);
                    
                    baseEncoder = returnValues(1);
                    shoulderEncoder = returnValues(4);
                    elbowEncoder = returnValues(7);
                    
                    baseScalingFactor = 11.44;
                    baseDeg = baseEncoder / baseScalingFactor;
                    shoulderDeg = shoulderEncoder/ baseScalingFactor;
                    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                    plot3d(forces,returnValues,plotVar);
                    pause(0.1);
                end
            end
            
            while(~success)
                [success,returnValues]=goToEnc(0,90*11.4,0*11.4,pp);
                baseEncoder = returnValues(1);
                shoulderEncoder = returnValues(4);
                elbowEncoder = returnValues(7);
                
                baseScalingFactor = 11.44;
                baseDeg = baseEncoder / baseScalingFactor;
                shoulderDeg = shoulderEncoder/ baseScalingFactor;
                elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                plot3d(forces,returnValues,plotVar);
            end
            
            %weight it
            pause(1);
            for iter = 1:30
                [gravComp1, gravComp2]=gravityComp(shoulderDeg,elbowDeg-90);
                forces = pp.command(42, gripper);
                forces = [forces(1),forces(2)+gravComp1,forces(3)+gravComp2];
                if(iter==1)
                    averageForce = forces(3)/30;
                else
                    averageForce =  averageForce+ forces(3)/30;
                end
                
            end
            
            if averageForce>0.15
                heavy = 1;
            else
                heavy = 0;
            end
            [xdrop, ydrop, zdrop] = getDropSetpoints(heavy, color)
            setpoints = trajectory3d(3.5, 0, 36.6, xdrop, ydrop, zdrop);
            for num = 1:length(setpoints)
                success=false;
                while(~success)
                    heavy, color
                    [success, returnValues] = goToXYZLoose(setpoints(num,1),setpoints(num,2),setpoints(num,3),pp);
                    
                    baseEncoder = returnValues(1);
                    shoulderEncoder = returnValues(4);
                    elbowEncoder = returnValues(7);
                    
                    baseScalingFactor = 11.44;
                    baseDeg = baseEncoder / baseScalingFactor;
                    shoulderDeg = shoulderEncoder/ baseScalingFactor;
                    elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                    plot3d(forces,returnValues,plotVar);
                    pause(0.25);
                end
            end
            
            %close the gripper
            baseEncoder = returnValues(1);
            shoulderEncoder = returnValues(4);
            elbowEncoder = returnValues(7);
            
            baseScalingFactor = 11.44;
            %encoder values mapped to degrees
            baseDeg = baseEncoder / baseScalingFactor;
            shoulderDeg = shoulderEncoder/ baseScalingFactor;
            elbowDeg = (elbowEncoder/baseScalingFactor)-90;
            
            [gravComp1, gravComp2]=gravityComp(shoulderDeg,elbowDeg-90);
            gripper(1) = 0;
            forces = pp.command(42, gripper);
            forces = [forces(1),forces(2)+gravComp1,forces(3)+gravComp2];
            
            plot3d(forces,returnValues,plotVar);
            pause(1);
            
            
            success=false;
            while(~success)
                %move to a position out of the way of the camera
                [success,returnValues]=goToEnc(0,90*11.4,90*11.4,pp);
                baseEncoder = returnValues(1);
                shoulderEncoder = returnValues(4);
                elbowEncoder = returnValues(7);
                
                baseScalingFactor = 11.44;
                baseDeg = baseEncoder / baseScalingFactor;
                shoulderDeg = shoulderEncoder/ baseScalingFactor;
                elbowDeg = (elbowEncoder/baseScalingFactor)-90;
                plot3d(forces,returnValues,plotVar);
            end
            
            
            
            
            
        end
        
    end
    
    
    
    %if no, done!
    %pick first centroid, and save its color
    %move to centroid + z height
    %trajectory generate down to position and grab
    %wait a little
    %trajectory directly up
    %trajectory to weighing position
    %do weight comparison
    %sort to a place
    %drop it
    %start over
    
end
pp.shutdown();
clear java;