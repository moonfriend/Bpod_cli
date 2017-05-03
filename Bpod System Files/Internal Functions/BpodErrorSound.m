function ME= BpodErrorSound()
global BpodSystem;
ErrorSound = audioread([BpodSystem.BpodPath 'Bpod System Files/Internal Functions/Graphics/BpodError.wav']);
try
sound(ErrorSound, 44100);
catch 
  
end
