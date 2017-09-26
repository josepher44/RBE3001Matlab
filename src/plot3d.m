function [] = plot3d(returnValues, currentSetpoints)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%constant that maps ticks to degrees
baseScalingFactor = 11.44;





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


end

