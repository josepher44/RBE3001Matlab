function [tip] = plot3d(returnValues, currentSetpoint, plotVar,setpoints,tip)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
Array = [0,0,0];
%constant that maps ticks to degrees
baseScalingFactor = 11.44;
baseDeg = 1;
shoulderDeg = 1;
elbowDeg = 1;
lastBase = 0;
lastShoulder = 0;
lastElbow = 0;
baseEncoder = 1;
shoulderEncoder = 1;
elbowEncoder = 1;
tipPos=[0;0;0];
x3=0;
y3=0;
z3=0;



%encoder values read from returnValues
baseEncoder = returnValues(1);
shoulderEncoder = returnValues(4);
elbowEncoder = returnValues(7);

currentEncoders = [baseEncoder shoulderEncoder elbowEncoder];

%encoder values mapped to degrees
baseDeg = baseEncoder / baseScalingFactor;
shoulderDeg = shoulderEncoder/ baseScalingFactor;
elbowDeg = (elbowEncoder/baseScalingFactor)-90;

linkLength=100;

%3D Forward Position Kinematics
%top of link 1 (base)
x1 = 0;
y1 = 0;
z1 = linkLength;

%top of link 2 (shoulder)
y2 = sind(baseDeg) * (x1 + cosd(shoulderDeg) * linkLength);
x2 = cosd(baseDeg) * (y1 + cosd(shoulderDeg) * linkLength);
z2 = z1 + sind(shoulderDeg) * linkLength;

l2rad = sqrt(x2^2+y2^2);

%top of link 3 (elbow)
y3 = sind(baseDeg) * (l2rad + cosd(elbowDeg+shoulderDeg) * linkLength);
x3 = cosd(baseDeg) * (l2rad + cosd(elbowDeg+shoulderDeg) * linkLength);
z3 = z2 + sind(elbowDeg+shoulderDeg) * linkLength;


%Write tip position to csv
time = toc;
% dlmwrite('tip.csv', transpose([x3; y3; z3; time]), '-append');
% 
% Array=csvread('tip.csv');


%find setpoint in degrees
baseSetDeg = currentSetpoint(1)/baseScalingFactor;
shoulderSetDeg = currentSetpoint(2)/baseScalingFactor;
elbowSetDeg = currentSetpoint(3)/baseScalingFactor;

%top of arm setpoint
sx1 = 0;
sy1 = 0;
sz1 = linkLength;

%top of shoulder setpoint
sx2 = sind(baseSetDeg) * (sx1 + cosd(shoulderSetDeg) * linkLength);
sy2 = cosd(baseSetDeg) * (sy1 + cosd(shoulderSetDeg) * linkLength);
sz2 = sz1 + sind(shoulderSetDeg) * linkLength;

sl2rad = sqrt(sx2^2+sy2^2);

%top of elbow setpoint
sx3 = sind(baseSetDeg) * (sl2rad + cosd(elbowSetDeg+shoulderSetDeg) * linkLength);
sy3 = cosd(baseSetDeg) * (sl2rad + cosd(elbowSetDeg+shoulderSetDeg) * linkLength);
sz3 = sz2 + sind(elbowSetDeg+shoulderSetDeg) * linkLength;

%      3D plot
figure(1)
xStuff = [0 x1 x2 x3];
yStuff = [0 y1 y2 y3];
zStuff = [0 z1 z2 z3];

set(plotVar,'xData',xStuff,'yData',yStuff,'zData',zStuff);
hold on;

plot3(Array(:,1),Array(:,2),Array(:,3));
%         plot3([0 sx1 sx2 sx3], [0 sy1 sy2 sy3],[0 sz1 sz2 sz3]);
xlim([-300 300]);
ylim([-300 300]);
zlim([0 300]);
hold off;

% figure(10)
% tip = [tip;time,x3,y3,z3];
% timeMatrix = tip(:,1);
% x3mult=tip(:,2);
% y3mult=tip(:,3);
% z3mult=tip(:,4);
% plot(timeMatrix,x3mult,timeMatrix,y3mult,timeMatrix,z3mult);

legend('x','y','z');
% plot(time,xAccel,time,yAccel,time,zAccel);
% 
% figure(11);
% plot(setpoints);

end

