%{
----------------------------------------------------------------------------

This file is part of the Bpod Project
Copyright (C) 2014 Joshua I. Sanders, Cold Spring Harbor Laboratory, NY, USA

----------------------------------------------------------------------------

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3.

This program is distributed  WITHOUT ANY WARRANTY and without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
%}
function Bpod(varargin)
%global isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

try
    evalin('base', 'BpodSystem;');
    BpodErrorSound;
    disp('Bpod is already open.');
catch
    warning off
    global BpodSystem
    if exist('rng','file') == 2
        rng('shuffle', 'twister'); % Seed the random number generator by CPU clock
    else
        rand('twister', sum(100*fliplr(clock))); % For older versions of MATLAB
    end
    load SplashBGData;
    load SplashMessageData;
    BpodSystem = BpodObject;
    BpodSystem.IsOctave =  exist('OCTAVE_VERSION', 'builtin') ~= 0;
    BpodSystem.SplashData.BG = SplashBGData;
    BpodSystem.SplashData.Messages = SplashMessageData;
    clear SplashBGData SplashMessageData
    BpodSystem.cli = false;
    emulatorMode =false;
    userPort = 0;
    if nargin > 0
        for i=1:nargin
            if strcmp(varargin{i}, 'cli')
                BpodSystem.cli = true;
                break;
            elseif strcmp(varargin{i},'EMU')
                emulatorMode = true;
            else
                userPort = varargin{i};
            end
        end
    end
    if ~BpodSystem.cli
        BpodSystem.GUIHandles.SplashFig = figure('Position',[400 300 485 300],'name','Bpod','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
    end
        
    BpodSystem.LastTimestamp = 0;
    BpodSystem.InStateMatrix = 0;
    BpodSystem.BonsaiSocket.Connected = 0;
    if exist('BpodSystemSettings.mat') > 0
        load BpodSystemSettings;
        BpodSystem.SystemSettings = BpodSystemSettings;
    else
        BpodSystem.SystemSettings = struct;
    end
    BpodSystem.BlankStateMatrix = GenerateBlankStateMatrix;
    if BpodSystem.IsOctave
        BpodSystem.HostOS = computer;
    else
        BpodSystem.HostOS = system_dependent('getos');
    end
    
    
    
    BpodSplashScreen(1);
    
    % Load Bpod path
    FullBpodPath = which('Bpod');
    %    GraphicsPath = [FullBpodPath 'Bpod System Files/Internal Functions/Graphics/'];
    BpodSystem.BpodPath = FullBpodPath(1:strfind(FullBpodPath, 'Bpod System Files')-1);
    BpodSystem.GraphicsPath =  [BpodSystem.BpodPath 'Bpod System Files/Internal Functions/Graphics/Bitmap/'];
    %Check for Data folder
    dir_data = dir( fullfile(BpodSystem.BpodPath,'Data') );
    if length(dir_data) == 0, %then Data didn't exist.
        mkdir([BpodSystem.BpodPath,'/' 'Data']);
    end
    
    %Check for CalibrationFiles folder
    dir_calfiles = dir( fullfile(BpodSystem.BpodPath,'Calibration Files') );
    if length(dir_calfiles) == 0, %then Data didn't exist.
        mkdir([BpodSystem.BpodPath,'/' 'Calibration Files']);
        BpodSystem.CalibrationTables.LiquidCal = [];
    else
        try
            LiquidCalibrationFilePath = fullfile(BpodSystem.BpodPath, 'Calibration Files', 'LiquidCalibration.mat');
            load(LiquidCalibrationFilePath);
            BpodSystem.CalibrationTables.LiquidCal = LiquidCal;
        catch
            BpodSystem.CalibrationTables.LiquidCal = [];
        end
    end
    
    % Load input channel settings
    BpodSystem.InputConfigPath = fullfile(BpodSystem.BpodPath, 'Settings Files', 'BpodInputConfig.mat');
    load(BpodSystem.InputConfigPath);
    BpodSystem.InputsEnabled = BpodInputConfig;
    
    % Determine if PsychToolbox is installed. If so, serial communication
    % will proceed through lower latency psychtoolbox IOport serial interface (compiled for each platform).
    % Otherwise, Bpod defaults to MATLAB's Java based serial interface.
    try
        V = PsychtoolboxVersion;
        BpodSystem.UsesPsychToolbox = 1;
    catch
        BpodSystem.UsesPsychToolbox = 0;
    end
    
    % Try to find hardware. If none, prompt to run emulation mode.
    try
      if emulatorMode
        EmulatorDialog;
      elseif userPort
        InitializeHardware(userPort);
      else
        InitializeHardware;
      end
      SetupBpod;
      if BpodSystem.cli
        cliRun(varargin{2},varargin{3});
        % close everythin
        try
          RunProtocol('Stop');
        catch
        end
        EndBpod;
        clear BpodSystem;
        sca;
        disp('cleared')
      end      
    catch err
        disp(err)
        EmulatorDialog;
    end
    
end

function SetupBpod(hObject,event)
global BpodSystem
if BpodSystem.EmulatorMode == 1
    close(BpodSystem.GUIHandles.LaunchEmuFig);
    disp('Connection aborted. Bpod started in Emulator mode.')
end
BpodSplashScreen(2);
BpodSplashScreen(3);
if isfield(BpodSystem.SystemSettings, 'BonsaiAutoConnect')
    if BpodSystem.SystemSettings.BonsaiAutoConnect == 1
        try
            disp('Attempting to connect to Bonsai. Timeout in 10 seconds...')
            BpodSocketServer('connect', 11235);
            BpodSystem.BonsaiSocket.Connected = 1;
            disp('Connected to Bonsai on port: 11235')
        catch
            BpodErrorSound;
            disp('Warning: Auto-connect to Bonsai failed. Please connect manually.')
        end
    end
end
BpodSplashScreen(4);
BpodSplashScreen(5);
if ~BpodSystem.cli
  close(BpodSystem.GUIHandles.SplashFig);
  InitializeBpodGUI;
end
BpodSystem.BeingUsed = 0;
BpodSystem.Live = 0;
BpodSystem.Pause = 0;
BpodSystem.HardwareState.Valves = zeros(1,8);
BpodSystem.HardwareState.PWMLines = zeros(1,8);
BpodSystem.HardwareState.PortSensors = zeros(1,8);
BpodSystem.HardwareState.BNCInputs = zeros(1,2);
BpodSystem.HardwareState.BNCOutputs = zeros(1,2);
BpodSystem.HardwareState.WireInputs = zeros(1,4);
BpodSystem.HardwareState.WireOutputs = zeros(1,4);
BpodSystem.HardwareState.Serial1Code = 0;
BpodSystem.HardwareState.Serial2Code = 0;
BpodSystem.HardwareState.SoftCode = 0;
BpodSystem.LastHardwareState = BpodSystem.HardwareState;
BpodSystem.BNCOverrideState = zeros(1,4);
BpodSystem.EventNames = {'Port1In', 'Port1Out', 'Port2In', 'Port2Out', 'Port3In', 'Port3Out', 'Port4In', 'Port4Out', 'Port5In', 'Port5Out', ...
    'Port6In', 'Port6Out', 'Port7In', 'Port7Out', 'Port8In', 'Port8Out', 'BNC1High', 'BNC1Low', 'BNC2High', 'BNC2Low', ...
    'Wire1High', 'Wire1Low', 'Wire2High', 'Wire2Low', 'Wire3High', 'Wire3Low', 'Wire4High', 'Wire4Low', ...
    'SoftCode1', 'SoftCode2', 'SoftCode3', 'SoftCode4', 'SoftCode5', 'SoftCode6', 'SoftCode7', 'SoftCode8', 'SoftCode9', 'SoftCode10', ...
    'Unused', 'Tup', 'GlobalTimer1_End', 'GlobalTimer2_End', 'GlobalTimer3_End', 'GlobalTimer4_End', 'GlobalTimer5_End', ...
    'GlobalCounter1_End', 'GlobalCounter2_End', 'GlobalCounter3_End', 'GlobalCounter4_End', 'GlobalCounter5_End'};
BpodSystem.OutputActionNames = {'ValveState', 'BNCState', 'WireState', 'Serial1Code', 'Serial2Code', 'SoftCode', ...
    'GlobalTimerTrig', 'GlobalTimerCancel', 'GlobalCounterReset', 'PWM1', 'PWM2', 'PWM3', 'PWM4', 'PWM5', 'PWM6', 'PWM7', 'PWM8'};
BpodSystem.Birthdate = now;
BpodSystem.CurrentProtocolName = '';
evalin('base', 'global BpodSystem')

function CloseBpodHWNotFound(hObject,event)
global BpodSystem
lasterr
close(BpodSystem.GUIHandles.LaunchEmuFig);
close(BpodSystem.GUIHandles.SplashFig);
delete(BpodSystem)
clear BpodSystem SplashData Img StimuliDef Ports ha serialInfo x
disp('Error: Bpod device not found.')

function EmulatorDialog
global BpodSystem
if BpodSystem.cli
  disp('there is some problem here' )
  return
end

GP = BpodSystem.GraphicsPath;
BpodErrorSound;
BpodSystem.GUIHandles.LaunchEmuFig = figure('Position',[500 350 300 125],'name','ERROR','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
ha = axes('units','normalized', 'position',[0 0 1 1]);
%uistack(ha,'bottom');
BG = imread([GP 'DeviceNotFound.bmp']); image(BG); axis off;
BpodSystem.Graphics.CloseBpodButton =double( imread([GP 'CloseBpod.bmp']));
BpodSystem.Graphics.LaunchEMUButton = double(imread([GP 'StartInEmuMode.bmp']));
BpodSystem.GUIHandles.LaunchEmuModeButton = uicontrol('Style', 'pushbutton', 'String', 'LaunchEmulator', 'Position', [15 55 277 32], 'Callback', @SetupBpod,  'TooltipString', 'Start Bpod in emulation mode');
%'CData', BpodSystem.Graphics.LaunchEMUButton,
BpodSystem.GUIHandles.CloseBpodButton = uicontrol('Style', 'pushbutton', 'String', 'Close', 'Position', [15 15 277 32], 'Callback', @CloseBpodHWNotFound,'TooltipString', 'Close Bpod');
% 'CData', BpodSystem.Graphics.CloseBpodButton
BpodSystem.EmulatorMode = 1;

