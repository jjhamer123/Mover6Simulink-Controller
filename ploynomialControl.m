function ploynomialControl(filename,startPoint,endPoint,duration,Sample_time)
%ploynomial Control written by jack hamer written on 13/12/2025 this will
%generate a path based on polynomial pathing from the input of inital
%postion and end position
arguments (Input)
    filename
    startPoint
    endPoint
    duration
    Sample_time
end

%get the amout of joints
jointlen=length(startPoint);
numofSamples=floor(duration/Sample_time)+1;

path=zeros(numofSamples,jointlen);

%add a t to the path
t = linspace(0, (numofSamples-1) * Sample_time, numofSamples);

%create Ploynomial Controller

% Calculate polynomial coefficients for each joint
coefficents=[zeros(1,4)];
for i = 1:jointlen
    path_start=startPoint(i);
    path_end = endPoint(i);

    coefficents(4)=path_start; %inital pos
    coefficents(3) = 0; %no inital v
    coefficents(2) = 3 * (path_end - path_start) / duration^2; % Quadratic coefficient
    coefficents(1) = -2*(path_end - path_start) / duration^3; % Cubic coefficient
    path(:, i) = polyval(coefficents, t); % Evaluate polynomial for the joint

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