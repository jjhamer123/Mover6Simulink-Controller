function linearControl(filename,startPoint,endPoint,duration,Sample_time)
%LINEARCONTROL creates a path using linear control given the joint angle 
% written by jack Hamer written on 13/12/2025
arguments (Input)
    filename
    startPoint
    endPoint
    duration
    Sample_time
end

%get the number of joints
jointlen=length(startPoint);
numofSamples=floor(duration/Sample_time)+1;

%set aside memory
path=zeros(numofSamples,jointlen);

%generate a time of the joint positions
t = linspace(0, (numofSamples-1) * Sample_time, numofSamples);

%create the linear path
for i=1:jointlen
    path(:,i)=linspace(startPoint(i),endPoint(i),numofSamples);
end

%create the right data type of the signal editor
path_senario=Simulink.SimulationData.Dataset;

%for every start and put them into a timeseies object and add it to the
%simulink file with the right joint name
for i=1:jointlen
    ts = timeseries(path(:, i), t);
    sig = Simulink.SimulationData.Signal;
    sig.Values = ts;
    sig.Name = sprintf('Joint%d', i);

    % Add signal to dataset
    path_senario = path_senario.addElement(sig);
end

save(filename,"path_senario")
