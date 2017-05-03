% Bpod cli run
% function to run the protocol in the cli(command line) mode of Bpod
% almost a non-gui version of the LaunchManager
function cliRun(subjectName, protocolName)
  global BpodSystem
  DummySubjectString = 'Dummy Subject';
  disp('hi')

  %find the protocols
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
  if sum(ismember(ProtocolNames, protocolName)) ==1
    disp('Protocol found')
  else
    disp('protocol not found choose from this list:')
    disp(ProtocolNames)
    return
  end
 
  BpodSystem.CurrentProtocolName = protocolName;
  % preparing
  addpath(fullfile(BpodSystem.BpodPath, 'Protocols', protocolName));
  DataPath = fullfile(BpodSystem.BpodPath,'Data',DummySubjectString);
  ProtocolName = BpodSystem.CurrentProtocolName;
  ProtocolPath = fullfile(BpodSystem.BpodPath,'Protocols',ProtocolName);
  SettingsPath = fullfile(DataPath,ProtocolName,'Session Settings');
  DefaultSettingsPath = fullfile(ProtocolPath,'SessionSettings.mat');
  
  %Make standard folders for this protocol.  This will fail silently if the folders exist
  mkdir(DataPath, ProtocolName);
  mkdir(fullfile(DataPath,ProtocolName,'Session Data'))
  mkdir(fullfile(DataPath,ProtocolName,'Session Settings'))
  
  % Ensure that a default settings file exists
  DefaultSettingsFilePath = fullfile(DataPath,ProtocolName,'Session Settings', 'DefaultSettings.mat');
  if ~exist(DefaultSettingsFilePath)
      ProtocolSettings = struct;
      save(DefaultSettingsFilePath, 'ProtocolSettings')
  end
  SettingsFileName = 'DefaultSettings';

  % Make a list of the names of all subjects who already have a folder for this
% protocol.

  DataPath = fullfile(BpodSystem.BpodPath,'Data');
  CandidateSubjects = dir(DataPath);
  SubjectNames = cell(1);
  nSubjects = 1;
  SubjectNames{1} = DummySubjectString;
  for x = 1:length(CandidateSubjects)
      if x > 2
          if CandidateSubjects(x).isdir
              if ~strcmp(CandidateSubjects(x).name, DummySubjectString)
                  Testpath = fullfile(DataPath,CandidateSubjects(x).name,ProtocolName);
                  if exist(Testpath) == 7
                      nSubjects = nSubjects + 1;
                      SubjectNames{nSubjects} = CandidateSubjects(x).name;
                  end
              end
          end
      end
  end
  % here consider adding new subjects
  if sum(ismember(SubjectNames,subjectName)) ==1
    disp('subject name found')
  else
    disp('subject name NOT found')
    if yes_or_no('Do you want to continue by creating this subject:')
      NewName = Spaces2Underscores(subjectName);
      % Check to see if subject already exists
      ProtocolName = BpodSystem.CurrentProtocolName;
      Testpath = fullfile(BpodSystem.BpodPath,'Data',NewName);
      Testpath2 = fullfile(Testpath,ProtocolName);
      ProtocolPath = fullfile(BpodSystem.BpodPath,'Protocols',ProtocolName);
      NewAnimal = 0;
      if exist(Testpath) ~= 7
        mkdir(Testpath);
        NewAnimal = 1;
      end 
      if exist(Testpath2) ~= 7
        mkdir( fullfile(Testpath,ProtocolName));
        mkdir( fullfile(Testpath,ProtocolName,'Session Data'))
        mkdir( fullfile(Testpath,ProtocolName,'Session Settings'))
        SettingsPath = fullfile(Testpath,ProtocolName,'Session Settings');
        DefaultSettingsPath = fullfile(SettingsPath,'DefaultSettings.mat');
        % Ensure that a default settings file exists
        ProtocolSettings = struct;
        save(DefaultSettingsPath, 'ProtocolSettings')
        if NewAnimal == 0
          warning(['Existing test subject ' NewName ' has now been registered for ' ProtocolName '.'], 'Modal')
        end
      end
    else
      return
    end
  end
  % Now go for lunch, no not lunch! but go for lunching the protocol
  ProtocolName = BpodSystem.CurrentProtocolName;
  FormattedDate = [datestr(now, 3) datestr(now, 7) '_' datestr(now, 10)];
  DataFolder = fullfile(BpodSystem.BpodPath,'Data',subjectName,protocolName, 'Session Data');
  Candidates = dir(DataFolder);
  nSessionsToday = 0;
  for x = 1:length(Candidates)
      if x > 2
          if strfind(Candidates(x).name, FormattedDate)
              nSessionsToday = nSessionsToday + 1;
          end
      end
  end
  DataPath = fullfile(BpodSystem.BpodPath,'Data',subjectName,...
              protocolName,'Session Data',...
              [subjectName '_' protocolName '_'...
              FormattedDate '_Session' num2str(nSessionsToday+1) '.mat']);
  SettingsPath = fullfile(BpodSystem.BpodPath,'Data',subjectName,...
              protocolName, 'Session Settings',[SettingsFileName '.mat']);
  BpodSystem.DataPath = DataPath;
  BpodSystem.SettingsPath = SettingsPath;
  ProtocolPath = fullfile(BpodSystem.BpodPath,'Protocols',protocolName,[ProtocolName '.m']);
  BpodSystem.Live = 1;
  SettingStruct = load(SettingsPath);
  F = fieldnames(SettingStruct);
  FieldName = F{1};
  BpodSystem.ProtocolSettings = eval(['SettingStruct.' FieldName]);
  BpodSystem.Data = struct;
  addpath(ProtocolPath);
  BpodSystem.BeingUsed = 1;
  BpodSystem.ProtocolStartTime = now;
  run(ProtocolPath);
end
