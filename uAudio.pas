//* Автор [Xakep] *//

unit uAudio;

interface

uses
  Bass, Windows;

procedure InitAudio(Handle: Hwnd);
procedure FreeAudio(Stream: HStream);
procedure PlayAudio(Stream: HStream; FileName: String; Loop: Boolean);

implementation

procedure InitAudio(Handle: Hwnd);
begin
  BASS_Init(-1,44100,0,Handle,0);
  BASS_Start();
end;

procedure FreeAudio(Stream: HStream);
begin
  BASS_Stop();
  BASS_ChannelStop(Stream);
  BASS_StreamFree(Stream);
  BASS_Free();
end;

procedure PlayAudio(Stream: HStream; FileName: String; Loop: Boolean);
begin
  if not Loop then
    Stream:= BASS_StreamCreateFile(False,PChar(FileName),0,0,0)
  else
    Stream:= BASS_StreamCreateFile(False,PChar(FileName),0,0,BASS_SAMPLE_LOOP);

  BASS_ChannelPlay(Stream,True);
end;

end.
