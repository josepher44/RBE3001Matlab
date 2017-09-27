function [output] = trajectory3d(x1, y1, z1, x2, y2, z2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

xValues = trajectory(0,5,0,0,x1,x2,0.1);
yValues = trajectory(0,5,0,0,y1,y2,0.1);
zValues = trajectory(0,5,0,0,z1,z2,0.1);

time = xValues(:,1);


xPos = xValues(:,2);
xVel = xValues(:,3);
xAccel = xValues(:,4);

yPos = yValues(:,2);
yVel = yValues(:,3);
yAccel = yValues(:,4);

zPos = zValues(:,2);
zVel = zValues(:,3);
zAccel = zValues(:,4);


% figure(2)
% plot(time,xPos,time,yPos,time,zPos);
% legend('x','y','z');
% figure(3)
% plot(time,xVel,time,yVel,time,zVel);
% legend('x','y','z');
% figure(4)
% plot(time,xAccel,time,yAccel,time,zAccel);
% legend('x','y','z');

x = xPos;
y = yPos;
z = zPos;
output=[x,y,z];
end

