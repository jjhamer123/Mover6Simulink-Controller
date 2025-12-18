function TrapazodialControl(filename,startPoint,endPoint,duration,Sample_time)
%TRAPAZODIALCONTROL written by jack hamer on 13/12/2025 this will generate
%the trapizoidal contol for a robot arm given the intial joint angle and
%end joint angle
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

%+1 as the first colum is t
path=zeros(numofSamples,jointlen);

%add a t to the path
t = linspace(0, (numofSamples-1) * Sample_time, numofSamples);

%joint and generating trapazoidal control for each of the parts
accUpTime=duration/4;
accDownTime = duration*3/4;
constantvel=duration - (accUpTime*2);

for i = 1:jointlen
    %calculate the max V for the joint it can go to
    Vmax=(endPoint(i)-startPoint(i))/(constantvel+accUpTime);
    
    %calculate v at a point
    v=zeros(numofSamples,1);

    for k=1:numofSamples
        %if at the first quarter accelarate
        if t(k)<accUpTime
            v(k)=Vmax*(t(k)/accUpTime);

        %if in the last quarter deccelarate
        elseif t(k)>accDownTime
            v(k) = Vmax * (1 - (t(k) - accDownTime) / (duration - accDownTime));
        else
            %if not set the v to the max
            v(k)=Vmax;
        end
    end

    %from the start position integrate it at every point
    path(:,i)=startPoint(i)+cumtrapz(t,v);

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

