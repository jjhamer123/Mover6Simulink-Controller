
%create a initial bodies
body1 = rigidBody('body1');
body2 = rigidBody('body2');
body3 = rigidBody('body3');
body4 = rigidBody('body4');

%create joint
jnt1 = rigidBodyJoint('jnt1','revolute');
jnt2 = rigidBodyJoint('jnt2','revolute');
jnt3 = rigidBodyJoint('jnt3','revolute');
jnt4 = rigidBodyJoint('jnt4','revolute');


%move the body to the fixed starting poing in space
tform1 = trvec2tform([0.25 0.25 0]);
setFixedTransform(jnt1,tform1)

tform2 =trvec2tform([1,0,0]);
setFixedTransform(jnt2,tform2)

tranlation3 =trvec2tform([0.6,-0.1,0]);
rotation3 = axang2tform([0 0 1 deg2rad(-90)]);
tform3=tranlation3*rotation3;
setFixedTransform(jnt3,tform3)

tform4 =trvec2tform([1,0,0]);
setFixedTransform(jnt4,tform4)

%HomePosition for each of the joints
jnt1.HomePosition=deg2rad(45);
jnt2.HomePosition=deg2rad(30);
jnt3.HomePosition=0;
jnt4.HomePosition=deg2rad(45);


%add joint to the body
body1.Joint=jnt1;
body2.Joint=jnt2;
body3.Joint=jnt3;
body4.Joint=jnt4;

%definerobottree
robot=rigidBodyTree;

%add body part with the joint to the tree
addBody(robot,body1,'base')
addBody(robot,body2,'body1')
addBody(robot,body3,'body2')
addBody(robot,body4,'body3')



robotconfighome=homeConfiguration(robot);
show(robot,robotconfighome);

transform1=getTransform(robot,robotconfighome,"base","body4")
transform2=getTransform(robot,robotconfighome,"body1","body4")