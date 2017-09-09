clc; 
clear;
close all;
javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;


pp = PacketProcessor(7);

%Create an array of 32 bit floating point zeros to load an pass to the
%packet processor
x = 0;
while 1
    x= x+ 1;
    values = zeros(15, 1, 'single');
    sinWaveInc = 10.0;
    range = 400.0;
    %Iterate through a sine wave for joint values
     for k=1:sinWaveInc
         for j=0:10
             %Joint 1
             values(1) = 50; 
             %Send junk data for velocity and force targets
             values(2) = 0;
             values(3) = 3;
             %Joint 2
             values(4) = 40; 
             %Send junk data for velocity and force targets
             values(5) = 0;
             values(6) = 3;
             %Joint 3
             values(7) = 30; 
             %Send junk data for velocity and force targets
             values(8) = 0;
             values(9) = 3;
         end
         tic
         %Process command and print the returning values
         returnValues = pp.command(38, values);
         toc
         disp('sent');
         disp(values);
         disp('got');
         disp(returnValues);
         %Concatenate "loop incrementer" to encoder values
         toWrite = cat(1, x,returnValues);
         %pause(0.1) %timeit(returnValues)
         dlmwrite('Lab1CSV.csv', transpose(toWrite), '-append');
     end
     %pause(.01)
     %wait
     
     %constant that maps ticks to degrees
     baseScalingFactor = 11.44;
     
     %encoder values read from returnValues
     baseEncoder = returnValues(1);
     shoulderEncoder = returnValues(4);
     elbowEncoder = returnValues(7);
     
     %encoder values mapped to degrees
     baseDeg = baseEncoder / baseScalingFactor;
     shoulderDeg = shoulderEncoder/ baseScalingFactor;
     elbowDeg = elbowEncoder/baseScalingFactor;
     
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
     x3 = x2 + cosd(elbowDeg) * linkLength;
     y3 = y2 + sind(elbowDeg) * linkLength;
     
     link1 = [0 x1; 0 y1];
     link2 = [x1 x2; y1 y2];
     link3 = [x2 x3; y2 y3];
     M = [link1; link2; link3];
     
     hold on;
     axis([0 300 0 300]);
     plot([0 x1 x2 x3], [0 y1 y2 y3],'-o');
     drawnow;
     hold off;
     pause(0.1);
     clf;
     
     
     Array=csvread('Lab1CSV.csv');
     col1 = Array(:, 1);
     col2 = (Array(:, 2))/baseScalingFactor;
     %hold on;
     %axis([-100 100 -100 100]);
     %x1 = cosd(deg)*100;
     %y1 = sind(deg)*100;
     %vals = [0 x1; 0 y1];
     %plot(col1, col2)
     %plotv(vals, '-o')
     %drawnow;
     %hold off;
     %pause(0.1);
     %clf;
     
end

pp.shutdown()
clear java;
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