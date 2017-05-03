% Example state matrix: light chasing.

sma = NewStateMatrix();
                
sma = AddState(sma, 'Name', 'Port1Active1', ...
    'Timer', .001,...
    'StateChangeConditions', {'Port1In', 'Port2Active1'},...
    'OutputActions', {'PWM1', 255});
sma = AddState(sma, 'Name', 'Port2Active1', ...
    'Timer', 1,...
    'StateChangeConditions', {'Port2In', 'Port3Active1'},...
    'OutputActions', {'PWM2', 255});
sma = AddState(sma, 'Name', 'Port3Active1', ...
    'Timer', .001,...
    'StateChangeConditions', {'Port3In', 'Port1Active2'},...
    'OutputActions', {'PWM3', 255});
sma = AddState(sma, 'Name', 'Port1Active2', ...
    'Timer', .001,...
    'StateChangeConditions', {'Port1In', 'Port2Active2'},...
    'OutputActions', {'PWM1', 255});
sma = AddState(sma, 'Name', 'Port2Active2', ...
    'Timer', .001,...
    'StateChangeConditions', {'Port2In', 'Port3Active2'},...
    'OutputActions', {'PWM2', 255});
sma = AddState(sma, 'Name', 'Port3Active2', ...
    'Timer', .001,...
    'StateChangeConditions', {'Port3In', 'exit'},...
    'OutputActions', {'PWM3', 255});
