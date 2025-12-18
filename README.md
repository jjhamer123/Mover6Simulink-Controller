# Mover6Simulink-Controller
This is a matlab simulink controller for the mover 6 robot, are functions for the generation of pathing for any robot that will path with polynomial,linaer and trapezoidal control.

## Prequiresites
- Mover6 Driver - https://github.com/jonaitken/cpr_ros2#
- Ros 2 Version - jazzy
- Matlab Version - 2025b
- Matlab simulink 2025b
- MAtlab simulink robotics toolbox
## Usage
- Have the Ros 2 driver and running with the Mover6 arm Zeroed
- change the XYZTest.m varible to desired vaible
```
 % Desired end Cartesian Pose
XYZend = [0.3 0.5 1]    % meters
ABCend = [30 45 10]    % degrees (roll, pitch, yaw)

%inital varibles definition
duration=6;
sampletime=0.2;
```
- Run the XYZTest.m file (before running makesure all files are on the matlab path)
- This will assume the robot started at position where all the joints are 0, but will run and generate a path from the last known position the robot was in
- To change the path that is in use by the robot change the file in the signal editor to the following
  - LinearControl.mat for Linear control
  - ploynomialControl.mat for Polynomail Control
  - TrapzodialControl.m for trapizodial control
