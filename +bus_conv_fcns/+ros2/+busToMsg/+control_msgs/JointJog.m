function rosmsgOut = JointJog(slBusIn, rosmsgOut)
%#codegen
%   Copyright 2021 The MathWorks, Inc.
    rosmsgOut.header = bus_conv_fcns.ros2.busToMsg.std_msgs.Header(slBusIn.header,rosmsgOut.header(1));
    for iter=1:slBusIn.joint_names_SL_Info.CurrentLength
        rosmsgOut.joint_names{iter} = char(slBusIn.joint_names(iter).data).';
        maxlen = length(slBusIn.joint_names(iter).data);
        if slBusIn.joint_names(iter).data_SL_Info.CurrentLength < maxlen
        rosmsgOut.joint_names{iter}(slBusIn.joint_names(iter).data_SL_Info.CurrentLength+1:maxlen) = [];
        end
    end
    if slBusIn.joint_names_SL_Info.CurrentLength < numel(rosmsgOut.joint_names)
        rosmsgOut.joint_names(slBusIn.joint_names_SL_Info.CurrentLength+1:numel(rosmsgOut.joint_names)) = [];
    end
    rosmsgOut.joint_names = rosmsgOut.joint_names.';
    rosmsgOut.displacements = double(slBusIn.displacements(1:slBusIn.displacements_SL_Info.CurrentLength));
    rosmsgOut.velocities = double(slBusIn.velocities(1:slBusIn.velocities_SL_Info.CurrentLength));
    rosmsgOut.duration = double(slBusIn.duration);
end
