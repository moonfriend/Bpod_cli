% simple poke -> reward protocol
% all lights(3) are on and every poke into any hole will give water
% the animal should poke out to be able poke again and get a reward again

% this is now a special version for just two ports
function A0poke_light_water

global BpodSystem
ports = [1 3];
S = BpodSystem.ProtocolSettings;
if isempty(fieldnames(S))
    S.RewardAmount = 6;
    %S.timeToWait4Poke = 10;
    %S.timeToHoldPoke = 2;
end
S.GUI.TimeoutDuration = 5;  
S.GUI.RewardAmount = 10;
S.GUI.port1 =0;
S.GUI.port2 =0;
S.GUI.port3 =0;
S.GUI.finish =0;
if ~BpodSystem.cli
  BpodParameterGUI('init', S);
end

%
% trial types and amount
MaxTrials = 5000;
TrialTypes = ones(1,MaxTrials);
   
R = GetValveTimes(S.GUI.RewardAmount,ports); % Return the valve-open duration in seconds for valves 1 and 3
%LeftValveTime = R(1); MiddleValveTime=R(2); RightValveTime = R(3); 
valveTimes(1)= R(1);
valveTimes(2)= 0;
valveTimes(3)= R(2);
valveCode1 = bin2dec('00000001');
valveCode2 = bin2dec('00000010');
valveCode3 = bin2dec('00000100');
%state variables
lastChoice = 0;
%ports = [1:3];
for currentTrial = 1:MaxTrials
    disp(['currentTrial: ' num2str(currentTrial) '--- last Choice: ' num2str(lastChoice)])
%     disp(['last Choice' num2str(lastChoice)]);
    if ~BpodSystem.cli
      S = BpodParameterGUI('sync', S);
    end
    switch TrialTypes(currentTrial)
         case 1
             %LeftPortAction = 'Reward1';% RightPortAction = 'Timeout'; 
             
             %Stimulus = {'PWM1', 255}; ValveCode = 1; ValveTime = LeftValveTime;
%          case 2
%              LeftPortAction = 'Punish'; RightPortAction = 'Reward'; 
%              Stimulus = {'PWM3', 255}; ValveCode = 4; ValveTime = RightValveTime;
    end

% state table
sma = NewStateMatrix(); % Create a blank matrix to define the trial's finite state machine
sma = SetGlobalTimer(sma, 1, 12); 
stateChangeConditions = cell(1,1);
ind=0;
for i=ports(ports ~= lastChoice)
    ind = ind+1;
    stateChangeConditions{ind}= ['Port' num2str(i) 'In'];
    ind=ind+1;
    stateChangeConditions{ind} = ['ISI' num2str(i) ];    
end
sma = AddState(sma, 'Name', 'start',...
    'Timer',.001,...
    'StateChangeConditions', {'Tup', 'WaitForPoke'},...
    'OutputActions', {'GlobalTimerTrig', 1}); 
sma = AddState(sma, 'Name', 'WaitForPoke', ...
    'Timer', 10,...
    'StateChangeConditions', [stateChangeConditions ...
                            'GlobalTimer1_End', 'exit'],...
    'OutputActions', {} ); 
%     'StateChangeConditions', {'Port1In', 'ISI1','Port2In', 'ISI2','Port3In', 'ISI3',},...
    
% ISI: inter stimulus interval
ISI = 0.400;
sma = AddState(sma, 'Name', 'ISI1', ...
    'Timer', ISI,...
    'StateChangeConditions', {'Tup', 'Reward1'},...
    'OutputActions', {'PWM1', 255}); 
sma = AddState(sma, 'Name', 'ISI2', ...
    'Timer', ISI,...
    'StateChangeConditions', {'Tup', 'Reward2'},...
    'OutputActions', {'PWM2', 255}); 
sma = AddState(sma, 'Name', 'ISI3', ...
    'Timer', ISI,...
    'StateChangeConditions', {'Tup', 'Reward3'},...
    'OutputActions', {'PWM3', 255}); 
%rewards
sma = AddState(sma, 'Name', 'Reward1', ...
    'Timer', valveTimes(1),...
    'StateChangeConditions', {'Tup', 'waitOut1'},...
    'OutputActions', {'ValveState', valveCode1,'PWM1', 255}); 
 any(ports ==2)
    sma = AddState(sma, 'Name', 'Reward2', ...
    'Timer', valveTimes(2),...
    'StateChangeConditions', {'Tup', 'waitOut2'},...
    'OutputActions', {'ValveState', valveCode2,'PWM2', 255}); 

sma = AddState(sma, 'Name', 'Reward3', ...
    'Timer', valveTimes(3),...
    'StateChangeConditions', {'Tup', 'waitOut3'},...
    'OutputActions', {'ValveState', valveCode3,'PWM3', 255}); 
% end reward
%% wait finish drinking( keep the light on for 2 seconds
sma = AddState(sma, 'Name', 'waitOut1', ... % 
    'Timer', 2, ...
    'StateChangeConditions', {'Tup', 'wait2FinishGrace','Port1Out','wait2FinishGrace','Port2Out','wait2FinishGrace','Port3Out','wait2FinishGrace'},...
    'OutputActions',  {'PWM1', 255}); 
sma = AddState(sma, 'Name', 'waitOut2', ... % 
    'Timer', 2, ...
    'StateChangeConditions', {'Tup', 'wait2FinishGrace','Port1Out','wait2FinishGrace','Port2Out','wait2FinishGrace','Port3Out','wait2FinishGrace'},...
    'OutputActions',  {'PWM2', 255}); 
sma = AddState(sma, 'Name', 'waitOut3', ... % 
    'Timer', 2, ...
    'StateChangeConditions', {'Tup', 'wait2FinishGrace','Port1Out','wait2FinishGrace','Port2Out','wait2FinishGrace','Port3Out','wait2FinishGrace'},...
    'OutputActions',  {'PWM3', 255}); 

%% wait to exit
% sma = AddState(sma, 'Name', 'waitOut', ... % wait for the mouse to poke out 
%     'Timer', .1, ...
%     'StateChangeConditions', {'Port1Out','wait2FinishGrace','Port2Out','wait2FinishGrace','Port3Out','wait2FinishGrace',...
%     'OutputActions', {}); 

sma = AddState(sma, 'Name', 'wait2FinishGrace', ... %wait to restart the trial for the next trial
    'Timer', 1, ...
    'StateChangeConditions', {'Tup', 'exit',...
                              'Port1In', 'wait2FinishReset','Port2In', 'wait2FinishReset' ,'Port3In', 'wait2FinishReset',...
                              'Port1Out','wait2FinishReset','Port2Out','wait2FinishReset','Port3Out','wait2FinishReset'}, ...
    'OutputActions', {}); 
sma = AddState(sma, 'Name', 'wait2FinishReset', ... %wait to restart the trial for the next trial
    'Timer', .1, ...
    'StateChangeConditions', {'Tup', 'wait2FinishGrace'}, ...
    'OutputActions', {}); 
%%
% sma = AddState(sma, 'Name', 'waitOut', ... % wait for the mouse to poke out
%     'Timer', 2, ...
%     'StateChangeConditions', {'Tup', 'waitOut','Port1Out','wait2','Port2Out','wait2','Port3Out','wait2'}, ...
%     'OutputActions', {'PWM1', 255,'PWM2', 255,'PWM3', 255}); 
% sma = AddState(sma, 'Name', 'wait2', ... %wait to resart the trial
%     'Timer', .1, ...
%     'StateChangeConditions', {'Tup', 'exit'}, ...
%     'OutputActions', {'PWM1', 255,'PWM2', 255,'PWM3', 255}); 

SendStateMatrix(sma);
RawEvents = RunStateMatrix;
BpodSystem.Data = AddTrialEvents(BpodSystem.Data, RawEvents);
BpodSystem.Data.TrialSettings(currentTrial) = S;
BpodSystem.Data.TrialTypes(currentTrial) = TrialTypes(currentTrial);
SaveBpodSessionData;

% check performance here
%BpodSystem.Data.RawEvents.Trial{1,currentTrial}.States;
events= BpodSystem.Data.RawEvents.Trial{1,currentTrial}.Events;
states=BpodSystem.Data.RawEvents.Trial{1,currentTrial}.States;
% waitPeriod=states.WaitForPoke;
% port1In =0;port2In =0;port3In =0;
if isfield(events,'port1In')
    S.GUI.port1 = S.GUI.port1+1;
end
if isfield(events,'port2In')
    S.GUI.port2 = S.GUI.port2+1;
end
if isfield(events,'port3In')
    S.GUI.port3 = S.GUI.port3+1;
end

for i=1:3
% if isfield(states,['Reward' num2str(i)])
    if ~isnan(eval(['states.Reward' num2str(i)]))
        lastChoice = i;
    end
% end
end

% exit condition
if ~BpodSystem.cli
  S = BpodParameterGUI('sync', S);
end
if isfield(events, 'GlobalTimer1_End')
  disp('exit by time out')
  return
end

if S.GUI.finish
    disp('Finished by user command')
    return
end

end
end
