function out = plot3d(forces,returnValues, plotVar)
%UNTITLED5 Summary of this function goes here
        baseEncoder = returnValues(1);
        shoulderEncoder = returnValues(4);
        elbowEncoder = returnValues(7);

        baseScalingFactor = 11.44;
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

        %      3D plot

        [xMan,yMan,zMan]=manualTorquesToVector(forces(1),forces(2),forces(3),baseDeg,shoulderDeg,elbowDeg);
        xStuff = [0 x1 x2 x3 x3+10*xMan];
        yStuff = [0 y1 y2 y3 y3+10*yMan];
        zStuff = [0 z1 z2 z3 z3+10*zMan];

        hold on;
        figure(1);
        xlim([-300 300]);
        ylim([-300 300]);
        zlim([0 300]);
        set(plotVar,'xData',xStuff,'yData',yStuff,'zData',zStuff);
        axis([-300 300 -300 300 0 300]);
        hold off;
end

