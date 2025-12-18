%Mover6 path generator written: 13/12/2025
%written by Jack Hamer to generate paths of the Mover6 robot to produce
%multiple paths to the mover 6 including Trapizoidal control, Linear
%control and ploynomial control


% Desired end Cartesian Pose
XYZend = [0.3 0.5 1]    % meters
ABCend = [30 45 10]    % degrees (roll, pitch, yaw)

%inital varibles definition
duration=6;
sampletime=0.2;

% Import mover6
mover6=importrobot('CPMOVER6.urdf');

% Start Pose
startpos=mover6.homeConfiguration;
    
% Home position of the XYZ and ABC start postition
endEffector=mover6.BodyNames{end};


% Desired start Cartesian Pose but can specify a XYZ ABC instead
%if there is a current position know of the robot use that if not assume
%home position if the sim hasn't been ran yet
try
    startTransform=out.simout.Data(:,:,end);
catch exception
    startTransform=getTransform(mover6,startpos,endEffector);
end

XYZstart=tform2trvec(startTransform)
ABCstart=tform2eul(startTransform,"ZYX")

% Rotation from ABC + degree to rad covertion
Rstart = eul2rotm(deg2rad(ABCstart),'ZYX');
Rend = eul2rotm(deg2rad(ABCend), 'ZYX');

% Build Transform
tformend = trvec2tform(XYZend) * rotm2tform(Rend);
tforstart= trvec2tform(XYZstart)* rotm2tform(Rstart);

% Inverse kinematics
ik = inverseKinematics("RigidBodyTree", mover6);
weights = [0.25 0.25 0.25 1 1 1];
initialguess = mover6.homeConfiguration;

[configSolnstart, solnInfostart] = ik("link6", tforstart,weights,initialguess);
[configSolnend, solnInfoend] = ik("link6", tformend, weights, initialguess);


%Generate the paths to use for simulink signal generator
initaljointAngles = [configSolnstart.JointPosition];
finaljointAngles = [configSolnend.JointPosition];

% Generate the joint trajectory for the robot
%check which you want 
linearControl("LinearControlsig.mat",initaljointAngles,finaljointAngles,duration,sampletime)
TrapazodialControl("TrapzodialControlsig.mat",initaljointAngles,finaljointAngles,duration,sampletime)
ploynomialControl("ploynomialControlsig.mat",initaljointAngles,finaljointAngles,duration,sampletime)


%run the simulation
%just need to make sure the correct file is on the signal generator
sim("roboticSending.slx")