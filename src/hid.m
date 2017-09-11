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

% #define kp 0.001
% #define ki 0
% #define kd 0
% 
% baseConstants = [0.001; 0; 0;];
% shoulderConstants = [0.001; 0; 0;];
% elbowConstants = [0.001; 0; 0;];

pidConstants = [0.005; 0; 0.002; 0.004; 0.00002; 0.005; 0.004; 0; 0.005;   0;0;0;0;0;0;];

pidJunk = pp.command(39, pidConstants);

%constant that maps ticks to degrees
baseScalingFactor = 11.44;

incrementer = 1;
timer = 0;
%0,365,-295
%0,-100,825
%0,777,-140

%6-8
%setpoints1 = [0 0 0 0 0 -1];
%setpoints2 = [1030 667 311 29 1268 -1];
%setpoints3 = [1030 1417 2109 985 2049 -1];

%9
setpoints1 = [0 0 0 0 0 -1];
setpoints2 = [777 -100 365 29 1268 -1];
setpoints3 = [-140 825 -295 985 2049 -1];

%10
% hugeMatrix = [badInterpol(365,-295,-100,825) badInterpol(-100,825,777,-140) badInterpol(777,-140,365,-295)];
% setpoints1= zeros(30, 1, 'single');
% setpoints2 = hugeMatrix(1:1,:);
% setpoints3 = hugeMatrix(2:2,:);

currentSetpoint = [setpoints1(incrementer) setpoints2(incrementer) setpoints3(incrementer)];
currentEncoders = [0 0 0];


while 1
    x= x+ 1;

    values = zeros(15, 1, 'single');
    
    %if(incrementer<6)
    if(incrementer<31)
    
        if (isAtSetpoints(currentSetpoint, currentEncoders)==3)
            timer = timer+1;
        end
        if (timer>=5)
            incrementer = incrementer+1;
            if(incrementer==30);
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
    dlmwrite('Lab1CSV.csv', transpose(toWrite), '-append');
         
     
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
     elbowDeg = (elbowEncoder/baseScalingFactor);
     
     %velocity values read
     baseVel = returnValues(2);
     shoulderVel=returnValues(5);
     elbowVel = returnValues(8);
     
     linkLength = 100;
     %top of link 1 (base)
     x1 = 0;
     y1 = linkLength;
     
     %top of link 2 (shoulder)
     x2 = x1 + cosd(shoulderDeg) * linkLength;
     y2 = y1 + sind(shoulderDeg) * linkLength;
     
     %top of link 3 (elbow)
     x3 = x2 + sind(elbowDeg+shoulderDeg) * linkLength;
     y3 = y2 - cosd(elbowDeg+shoulderDeg) * linkLength;
     
     %find setpoint in degrees
     baseSetDeg = currentSetpoint(1)/baseScalingFactor;
     shoulderSetDeg = currentSetpoint(2)/baseScalingFactor;
     elbowSetDeg = currentSetpoint(3)/baseScalingFactor;
     
     %top of arm setpoint
     sx1 = 0;
     sy1 = linkLength;
     
     %top of shoulder setpoint
     sx2 = sx1 + cosd(shoulderSetDeg) * linkLength;
     sy2 = sy1 + sind(shoulderSetDeg) * linkLength;
     
     %top of elbow setpoint
     sx3 = sx2 + sind(elbowSetDeg+shoulderSetDeg) * linkLength;
     sy3 = sy2 - cosd(elbowSetDeg+shoulderSetDeg) * linkLength;
     
     
     %Write tip position to csv
     dlmwrite('Lab2CSV.csv', transpose([x3; y3]), '-append');

     
     hold on;
     axis([-300 300 0 300]);
     plot([0 x1 x2 x3], [0 y1 y2 y3],'-o');
     plot([0 sx1 sx2 sx3], [0 sy1 sy2 sy3],'-o');
     drawnow;
     hold off;
     %pause(0.1);
     clf;
     
     
     Array=csvread('Lab2CSV.csv');
     col1 = Array(:, 1);
     col2 = Array(:, 2);
     %axis([-100 100 -100 100]);
     %x1 = cosd(deg)*100;
     %y1 = sind(deg)*100;
     %vals = [0 x1; 0 y1];
     plot(col1, col2)
     %plotv(vals, '-o')
     %pause(0.1);
     
end
pp.shutdown()
clear java;


%Link 2: -2826 -4311

%Link 3: -1693 to -4450
%Load the xml file
% xDoc = xmlread('seaArm.xml');
% %All Arms
% allAppendage =xDoc.getElementsByTagName('appendage');
% %All walking legs
% %allAppendage =xDoc.getElementsByTagName('leg');
% %All drivabel wheels
% %allAppendage =xDoc.getElementsByTagName('drivable');
% %All steerable wheels
% %allAppendage =xDoc.getElementsByTagName('steerable');
% %Grab the first appendage
% appendages = allAppendage.item(0);
% %all the D-H parameter tags
% allListitems = appendages.getElementsByTagName('DHParameters');
% %Load the transfrom of home to the base of the arm
% baseTransform = appendages.getElementsByTagName('baseToZframe').item(0);
% %Print all the values
% printTag(baseTransform,'x');
% printTag(baseTransform,'y');
% printTag(baseTransform,'z');
% printTag(baseTransform,'rotw');
% printTag(baseTransform,'rotx');
% printTag(baseTransform,'roty');
% printTag(baseTransform,'rotz');
% % Print D-H parameters
% for k = 0:allListitems.getLength-1
%    thisListitem = allListitems.item(k);
%    fprintf('\nLink %i\n',k);
%    % Get the label element. In this file, each
%    % listitem contains only one label.
%    printTag(thisListitem,'Delta');
%    printTag(thisListitem,'Theta');
%    printTag(thisListitem,'Radius');
%    printTag(thisListitem,'Alpha');
% end
% % Get the value stored in a tag
% function value = tagValue(thisListitem,name)
%    % listitem contains only one label.
%    thisList = thisListitem.getElementsByTagName(name);
%    thisElement = thisList.item(0);
%    data  = thisElement.getFirstChild.getData;
%    value = str2double(data);
% end
% %Print out the tag name with its value
% function printTag(thisListitem,name)
%    data  = tagValue(thisListitem,name);
%    fprintf('%s \t%f\n',name,data);
% end
% -224
% 341
% -789