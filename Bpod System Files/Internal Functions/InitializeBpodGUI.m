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
% GUI
global BpodSystem
BpodSystem.GUIHandles.MainFig = figure('Position',[80 100 800 400],'name','B-Pod v0.5 beta','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off', 'CloseRequestFcn', 'EndBpod');
%BpodSystem.GUIHandles.MainFig = figure('Position',[100 200 800 400],'name','B-Pod v0.5 beta','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
%BpodSystem.Graphics.GoButton = imread('PlayButton.bmp');
%BpodSystem.Graphics.PauseButton = imread('PauseButton.bmp');
%BpodSystem.Graphics.PauseRequestedButton = imread('PauseRequestedButton.bmp');
%BpodSystem.Graphics.StopButton = imread('StopButton.bmp');
BpodSystem.GUIHandles.RunButton = uicontrol('Style', 'pushbutton', 'String', 'Run', 'Position', [718 130 60 60], 'Callback', 'RunProtocol(''StartPause'')', 'TooltipString', 'Run selected protocol');
BpodSystem.GUIHandles.EndButton = uicontrol('Style', 'pushbutton', 'String', 'Stop', 'Position', [718 50 60 60], 'Callback', 'RunProtocol(''Stop'')', 'TooltipString', 'End session');


%BpodSystem.Graphics.OffButton = imread('ButtonOff.bmp');
%BpodSystem.Graphics.OffButtonDark = imread('ButtonOff_dark.bmp');
%BpodSystem.Graphics.OnButton = imread('ButtonOn.bmp');
%BpodSystem.Graphics.SoftTriggerButton = imread('BpodSoftTrigger.bmp');
%BpodSystem.Graphics.SoftTriggerActiveButton = imread('BpodSoftTrigger_active.bmp');
%BpodSystem.Graphics.SettingsButton = imread('SettingsButton.bmp');
%BpodSystem.Graphics.DocButton = imread('DocButton.bmp');
%BpodSystem.Graphics.AddProtocolButton = imread('AddProtocolIcon.bmp');
BpodSystem.GUIHandles.SettingsButton = uicontrol('Style', 'pushbutton', 'String', 'sett.', 'Position', [742 285 29 29], 'Callback', 'BpodSettingsMenu', 'TooltipString', 'Settings and calibration');
BpodSystem.GUIHandles.DocButton = uicontrol('Style', 'pushbutton', 'String', 'Doc', 'Position', [695 285 29 29], 'Callback', 'BpodWiki', 'TooltipString', 'Documentation wiki');

BpodSystem.GUIHandles.PortValveButton(1) = uicontrol('Style', 'pushbutton', 'String', 'V1', 'Position', [188 260 30 30], 'Callback', 'ManualOverride(1,1);', 'TooltipString', 'Toggle port 1 valve');
BpodSystem.GUIHandles.PortValveButton(2) = uicontrol('Style', 'pushbutton', 'String', 'V2', 'Position', [231 260 30 30], 'Callback', 'ManualOverride(1,2);', 'TooltipString', 'Toggle port 2 valve');
BpodSystem.GUIHandles.PortValveButton(3) = uicontrol('Style', 'pushbutton', 'String', 'V3', 'Position', [272 260 30 30], 'Callback', 'ManualOverride(1,3);', 'TooltipString', 'Toggle port 3 valve');
BpodSystem.GUIHandles.PortValveButton(4) = uicontrol('Style', 'pushbutton', 'String', 'V4', 'Position', [313 260 30 30], 'Callback', 'ManualOverride(1,4);', 'TooltipString', 'Toggle port 4 valve');
BpodSystem.GUIHandles.PortValveButton(5) = uicontrol('Style', 'pushbutton', 'String', 'V5', 'Position', [354 260 30 30], 'Callback', 'ManualOverride(1,5);',  'TooltipString', 'Toggle port 5 valve');
BpodSystem.GUIHandles.PortValveButton(6) = uicontrol('Style', 'pushbutton', 'String', 'V6', 'Position', [395 260 30 30], 'Callback', 'ManualOverride(1,6);', 'TooltipString', 'Toggle port 6 valve');
BpodSystem.GUIHandles.PortValveButton(7) = uicontrol('Style', 'pushbutton', 'String', 'V7', 'Position', [436 260 30 30], 'Callback', 'ManualOverride(1,7);', 'TooltipString', 'Toggle port 7 valve');
BpodSystem.GUIHandles.PortValveButton(8) = uicontrol('Style', 'pushbutton', 'String', 'V8', 'Position', [477 260 30 30], 'Callback', 'ManualOverride(1,8);', 'TooltipString', 'Toggle port 8 valve');

BpodSystem.GUIHandles.PortLEDButton(1) = uicontrol('Style', 'pushbutton', 'String', 'L1', 'Position', [188 220 30 30], 'Callback', 'ManualOverride(2,1);', 'TooltipString', 'Toggle port 1 LED');
BpodSystem.GUIHandles.PortLEDButton(2) = uicontrol('Style', 'pushbutton', 'String', 'L2', 'Position', [231 220 30 30], 'Callback', 'ManualOverride(2,2);','TooltipString', 'Toggle port 2 LED');
BpodSystem.GUIHandles.PortLEDButton(3) = uicontrol('Style', 'pushbutton', 'String', 'L3', 'Position', [272 220 30 30], 'Callback', 'ManualOverride(2,3);', 'TooltipString', 'Toggle port 3 LED');
BpodSystem.GUIHandles.PortLEDButton(4) = uicontrol('Style', 'pushbutton', 'String', 'L4', 'Position', [313 220 30 30], 'Callback', 'ManualOverride(2,4);', 'TooltipString', 'Toggle port 4 LED');
BpodSystem.GUIHandles.PortLEDButton(5) = uicontrol('Style', 'pushbutton', 'String', 'L5', 'Position', [354 220 30 30], 'Callback', 'ManualOverride(2,5);', 'TooltipString', 'Toggle port 5 LED');
BpodSystem.GUIHandles.PortLEDButton(6) = uicontrol('Style', 'pushbutton', 'String', 'L6', 'Position', [395 220 30 30], 'Callback', 'ManualOverride(2,6);', 'TooltipString', 'Toggle port 6 LED');
BpodSystem.GUIHandles.PortLEDButton(7) = uicontrol('Style', 'pushbutton', 'String', 'L7', 'Position', [436 220 30 30], 'Callback', 'ManualOverride(2,7);','TooltipString', 'Toggle port 7 LED');
BpodSystem.GUIHandles.PortLEDButton(8) = uicontrol('Style', 'pushbutton', 'String', 'L8', 'Position', [477 220 30 30], 'Callback', 'ManualOverride(2,8);', 'TooltipString', 'Toggle port 8 LED');

BpodSystem.GUIHandles.PortvPokeButton(1) = uicontrol('Style', 'pushbutton', 'String', 'P1', 'Position', [188 180 30 30], 'Callback', 'ManualOverride(3,1);', 'TooltipString', 'Port 1 virtual photogate');
BpodSystem.GUIHandles.PortvPokeButton(2) = uicontrol('Style', 'pushbutton', 'String', 'P2', 'Position', [231 180 30 30], 'Callback', 'ManualOverride(3,2);', 'TooltipString', 'Port 2 virtual photogate');
BpodSystem.GUIHandles.PortvPokeButton(3) = uicontrol('Style', 'pushbutton', 'String', 'P3', 'Position', [272 180 30 30], 'Callback', 'ManualOverride(3,3);', 'TooltipString', 'Port 3 virtual photogate');
BpodSystem.GUIHandles.PortvPokeButton(4) = uicontrol('Style', 'pushbutton', 'String', 'P4', 'Position', [313 180 30 30], 'Callback', 'ManualOverride(3,4);','TooltipString', 'Port 4 virtual photogate');
BpodSystem.GUIHandles.PortvPokeButton(5) = uicontrol('Style', 'pushbutton', 'String', 'P5', 'Position', [354 180 30 30], 'Callback', 'ManualOverride(3,5);', 'TooltipString', 'Port 5 virtual photogate');
BpodSystem.GUIHandles.PortvPokeButton(6) = uicontrol('Style', 'pushbutton', 'String', 'P6', 'Position', [395 180 30 30], 'Callback', 'ManualOverride(3,6);','TooltipString', 'Port 6 virtual photogate');
BpodSystem.GUIHandles.PortvPokeButton(7) = uicontrol('Style', 'pushbutton', 'String', 'P7', 'Position', [436 180 30 30], 'Callback', 'ManualOverride(3,7);', 'TooltipString', 'Port 7 virtual photogate');
BpodSystem.GUIHandles.PortvPokeButton(8) = uicontrol('Style', 'pushbutton', 'String', 'P8', 'Position', [477 180 30 30], 'Callback', 'ManualOverride(3,8);', 'TooltipString', 'Port 8 virtual photogate');

BpodSystem.GUIHandles.BNCInputButton(1) = uicontrol('Style', 'pushbutton', 'String', 'BNC1', 'Position', [525 243 30 30], 'Callback', 'ManualOverride(4,1);', 'TooltipString', 'Spoof BNC Input 1');
BpodSystem.GUIHandles.BNCInputButton(2) = uicontrol('Style', 'pushbutton', 'String', 'BNC2', 'Position', [565 243 30 30], 'Callback', 'ManualOverride(4,2);', 'TooltipString', 'Spoof BNC Input 2');

BpodSystem.GUIHandles.BNCOutputButton(1) = uicontrol('Style', 'pushbutton', 'String', 'BNCO1', 'Position', [605 243 30 30], 'Callback', 'ManualOverride(5,1);', 'TooltipString', 'Toggle TTL: BNC Output 1');
BpodSystem.GUIHandles.BNCOutputButton(2) = uicontrol('Style', 'pushbutton', 'String', 'BNCO2', 'Position', [645 243 30 30], 'Callback', 'ManualOverride(5,2);', 'TooltipString', 'Toggle TTL:BNC Output 2');

BpodSystem.GUIHandles.InputWireButton(1) = uicontrol('Style', 'pushbutton', 'String', 'W1', 'Position', [188 77 30 30], 'Callback', 'ManualOverride(6,1);', 'TooltipString', 'Spoof input wire 1');
BpodSystem.GUIHandles.InputWireButton(2) = uicontrol('Style', 'pushbutton', 'String', 'W2', 'Position', [231 77 30 30], 'Callback', 'ManualOverride(6,2);', 'TooltipString', 'Spoof input wire 1');
BpodSystem.GUIHandles.InputWireButton(3) = uicontrol('Style', 'pushbutton', 'String', 'W3', 'Position', [272 77 30 30], 'Callback', 'ManualOverride(6,3);', 'TooltipString', 'Spoof input wire 1');
BpodSystem.GUIHandles.InputWireButton(4) = uicontrol('Style', 'pushbutton', 'String', 'W4', 'Position', [313 77 30 30], 'Callback', 'ManualOverride(6,4);', 'TooltipString', 'Spoof input wire 1');


BpodSystem.GUIHandles.OutputWireButton(1) = uicontrol('Style', 'pushbutton', 'String', 'O1', 'Position', [188 36 30 30], 'Callback', 'ManualOverride(7,1);', 'TooltipString', 'Toggle TTL: output wire 1');
BpodSystem.GUIHandles.OutputWireButton(2) = uicontrol('Style', 'pushbutton', 'String', 'O2', 'Position', [231 36 30 30], 'Callback', 'ManualOverride(7,2);', 'TooltipString', 'Toggle TTL: output wire 1');
BpodSystem.GUIHandles.OutputWireButton(3) = uicontrol('Style', 'pushbutton', 'String', 'O3', 'Position', [272 36 30 30], 'Callback', 'ManualOverride(7,3);', 'TooltipString', 'Toggle TTL: output wire 1');
BpodSystem.GUIHandles.OutputWireButton(4) = uicontrol('Style', 'pushbutton', 'String', 'O4', 'Position', [313 36 30 30], 'Callback', 'ManualOverride(7,4);', 'TooltipString', 'Toggle TTL: output wire 1');

BpodSystem.GUIHandles.SoftTriggerButton = uicontrol('Style', 'pushbutton', 'String', 'SoftTrig', 'Position', [363 32 40 40], 'Callback', 'ManualOverride(8,0);', 'TooltipString', 'Send soft event code byte');

BpodSystem.GUIHandles.HWSerialTriggerButton1 = uicontrol('Style', 'pushbutton', 'String', 'HwSer1', 'Position', [414 32 40 40], 'Callback', 'ManualOverride(9,0);', 'TooltipString', 'Send byte to hardware serial port 1');
BpodSystem.GUIHandles.HWSerialTriggerButton2 = uicontrol('Style', 'pushbutton', 'String', 'HwSer2', 'Position', [465 32 40 40], 'Callback', 'ManualOverride(9,1);', 'TooltipString', 'Send byte to hardware serial port 2');

BpodSystem.GUIHandles.CurrentStateDisplay = uicontrol('Style', 'text', 'String', 'None', 'Position', [12 268 115 20], 'FontWeight', 'bold', 'FontSize', 9);
BpodSystem.GUIHandles.PreviousStateDisplay = uicontrol('Style', 'text', 'String', 'None', 'Position', [12 219 115 20], 'FontWeight', 'bold', 'FontSize', 9);
BpodSystem.GUIHandles.LastEventDisplay = uicontrol('Style', 'text', 'String', 'None', 'Position', [12 169 115 20], 'FontWeight', 'bold', 'FontSize', 9);
BpodSystem.GUIHandles.TimeDisplay = uicontrol('Style', 'text', 'String', '0', 'Position', [12 117 115 20], 'FontWeight', 'bold', 'FontSize', 9);
BpodSystem.GUIHandles.CxnDisplay = uicontrol('Style', 'text', 'String', 'Idle', 'Position', [12 62 115 20], 'FontWeight', 'bold', 'FontSize', 9);
BpodSystem.GUIHandles.ProtocolSelector = uicontrol('Style', 'listbox', 'String', 'None Loaded', 'Position', [520 45 185 150], 'FontWeight', 'bold', 'FontSize', 11, 'BackgroundColor', [.8 .8 .8]);
BpodSystem.GUIHandles.SoftCodeSelector = uicontrol('Style', 'edit', 'String', '0', 'Position', [363 80 40 25], 'FontWeight', 'bold', 'FontSize', 12, 'BackgroundColor', [.8 .8 .8], 'TooltipString', 'Enter byte code here (0-255; 0=no op)');
BpodSystem.GUIHandles.HWSerialCodeSelector1 = uicontrol('Style', 'edit', 'String', '0', 'Position', [414 80 40 25], 'FontWeight', 'bold', 'FontSize', 12, 'BackgroundColor', [.8 .8 .8], 'TooltipString', 'Enter byte code here (0-255; 0=no op)');
BpodSystem.GUIHandles.HWSerialCodeSelector2 = uicontrol('Style', 'edit', 'String', '0', 'Position', [465 80 40 25], 'FontWeight', 'bold', 'FontSize', 12, 'BackgroundColor', [.8 .8 .8], 'TooltipString', 'Enter byte code here (0-255; 0=no op)');

% Remove all the nasty borders around pushbuttons on platforms besides win7
if isempty(strfind(BpodSystem.HostOS, 'Windows 7'))
%    handles = findjobj('class', 'pushbutton');
%    set(handles, 'border', []);
end

try
    jScrollPane = findjobj(BpodSystem.GUIHandles.ProtocolSelector); % get the scroll-pane object
    jListbox = jScrollPane.getViewport.getComponent(0);
    set(jListbox, 'SelectionBackground',java.awt.Color.red); % option #1
catch
end

ha = axes('units','normalized', 'position',[0 0 1 1]);
%uistack(ha,'bottom');
GP = BpodSystem.GraphicsPath;
if BpodSystem.EmulatorMode == 0
    BG = imread([GP 'ConsoleBG.bmp']);
else
    BG = imread([GP 'ConsoleBG_EMU.bmp']);
end
image(BG); axis off;
set(ha,'handlevisibility','off','visible','off');
set(BpodSystem.GUIHandles.MainFig,'handlevisibility','off');
clear ha BG k PB

% Load protocols into selector
ProtocolPath = fullfile(BpodSystem.BpodPath,'Protocols');
Candidates = dir(ProtocolPath);
ProtocolNames = cell(1);
nCandidates = length(Candidates)-2;
nProtocols = 0;
if nCandidates > 0
    for x = 3:length(Candidates)
        if Candidates(x).isdir
            nProtocols = nProtocols + 1;
            ProtocolNames{nProtocols} = Candidates(x).name;
        end
    end
end
if isempty(ProtocolNames)
    ProtocolNames = {'No Protocols Found'};
end
set(BpodSystem.GUIHandles.ProtocolSelector, 'String', ProtocolNames);
clear BpodPath ProtocolPath Candidates ProtocolNames nProtocols Temp x Pos InList pos
