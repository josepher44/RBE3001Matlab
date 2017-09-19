function out = generateVelocity( armPos, ballPos )
%Takes in vector representations of the current task space position of the
%robot, and the target location, and produces a proportionally scaled
%velocity setpoint for the robot to pursue the target. It also provides
%deadband functionality around the target. 

deadband = 0.1
netVector = threeDVector(armPos, ballPos);
if (norm(netVector)>deadband)
    out = velocityFromVector(netVector);
else
    out = [0;
           0;
           0];

end

