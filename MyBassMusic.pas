unit MyBassMusic;

interface

uses System.Classes, FMX.Forms,Bass, winapi.windows,FMX.Platform.Win,
    system.SysUtils,BASS_FX;

type

  TMyMusicEngine = class(TComponent)
  private
    FParent: TForm;
    mods: array[0..128] of HMUSIC;
    modc: Integer;
    sams: array[0..128] of HSAMPLE;
    samc: Integer;
    strs: array[0..128] of HSTREAM;
    strc: Integer;
    procedure Error(msg: string);
  public
    chan: array [0..127] of DWORD;
    constructor Create( AOwner: TComponent); reintroduce; overload;
    destructor  Destroy; override;
    procedure MakeEngine(GameForm: TForm);
    procedure DestroyEngine;
    function LoadSound(filename: string):integer;
    procedure PlaySound(id: integer);
    procedure PlayChannel(Channelid: integer; Pan,Vol: single; Pitch: integer; Loop: boolean);
    function LoadMusic(filename: string): integer;
    procedure PlayMusic(id: integer; Loop: boolean);
    procedure ChannelChangePitch(channelid: integer; pitch: integer); //semitones [-60...0...+60]
    procedure ChannelChangeVolume(channelid:integer;volume: single); //volume 0...1
    procedure ChannelChangePan(channelid: integer; Pan: single);//-1 (full left) to +1 (full right), 0 = centre.
    procedure Load2Channel(Channelid: integer; filename: string);
    Function MusicPlaying(id: integer):boolean;
  end;

var
 Music: TMyMusicEngine;

implementation

constructor TMyMusicEngine.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FParent:=(AOwner as TForm);
end;

destructor TMyMusicEngine.Destroy;
begin
   inherited;
end;


procedure TMyMusicEngine.MakeEngine(GameForm: TForm);
begin
  Music:=TMyMusicEngine.Create(GameForm);
  Music.FParent:=GameForm;

  Music.modc := 0;		// music module count
	Music.samc := 0;		// sample count
	Music.strc := 0;		// stream count

    // check the correct BASS was loaded
	if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
	begin
		MessageBox(0,'An incorrect version of BASS.DLL was loaded',nil,MB_ICONERROR);
		Halt;
	end;

  // check the correct BASS_FX was loaded
  If (HiWord(BASS_FX_GetVersion()) <> BASSVERSION) then begin
    MessageBox(0,'An incorrect version of BASS_FX.DLL was loaded (2.4 is required)',nil,MB_ICONERROR);
    application.Terminate;
  end;

  // Initialize audio - default device, 44100hz, stereo, 16 bits
	if not BASS_Init(-1, 44100, 0,  FmxHandleToHWND((GameForm as TForm).Handle), nil) then
		Error('Error initializing audio!');

end;

procedure TMyMusicEngine.DestroyEngine;
var a:integer;
begin
  // Free stream
  if Music.strc > 0 then
    for a := 0 to Music.strc - 1 do
    	BASS_StreamFree(Music.strs[a]);

    // Free music
	if Music.modc > 0 then
		for a := 0 to Music.modc - 1 do
			BASS_MusicFree(Music.mods[a]);

	// Free samples
	if Music.samc > 0 then
		for a := 0 to Music.samc - 1 do
			BASS_SampleFree(Music.sams[a]);

	// Close BASS
	BASS_Free();

  Music.Free;
end;

procedure TMyMusicEngine.Error(msg: string);
var
	s: string;
begin
	s := msg + #13#10 + '(Error code: ' + IntToStr(BASS_ErrorGetCode) + ')';
	MessageBox(FmxHandleToHWND((FParent as TForm).Handle), PChar(s), nil, 0);
end;

function TMyMusicEngine.LoadSound(filename: string):integer;
var
  f: PChar;
begin
   f := PChar(FileName);
   sams[samc] := BASS_SampleLoad(FALSE, f, 0, 0, 3, BASS_SAMPLE_OVER_POS {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF} or BASS_SAMPLE_FX);
	 if sams[samc] <> 0 then Inc(samc)
   else Error('Error loading sample!');
   result:=samc-1;

end;

procedure TMyMusicEngine.PlayChannel(Channelid: integer; Pan,Vol: single; Pitch: integer; Loop: boolean);
var
  ch: HCHANNEL;
begin
  ch := Chan[Channelid];
  //BASS_ChannelSetAttribute(ch, BASS_ATTRIB_PAN, Pan);
  //BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, vol);
  //BASS_ChannelSetAttribute(ch,BASS_ATTRIB_TEMPO_PITCH,pitch);

  BASS_ChannelPlay(ch, Loop);

end;

procedure TMyMusicEngine.PlaySound(id: integer);
var
  ch: HCHANNEL;
begin
  ch := BASS_SampleGetChannel(sams[id], False);
  //BASS_ChannelSetAttribute(ch, BASS_ATTRIB_PAN, (Random(201) - 100) / 100);
  //BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, 0.5);
  if not BASS_ChannelPlay(ch, False) then
			Error('Error playing sample!');
end;

function TMyMusicEngine.LoadMusic(filename: string): integer;
var
  f: PChar;
begin
  f := PChar(FileName);
  strs[strc] := BASS_StreamCreateFile(False, f, 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
	if strs[strc] <> 0 then Inc(strc)
   else Error('Error loading music!');
  result:=strc-1;
end;

procedure TMyMusicEngine.PlayMusic(id: integer; Loop: boolean);
begin
  if not BASS_ChannelPlay(strs[id], Loop) then
			Error('Error playing sample!');
end;

Function TMyMusicEngine.MusicPlaying(id: integer):boolean;
begin

end;

procedure TMyMusicEngine.ChannelChangePitch(channelid: integer; pitch: integer); //semitones [-60...0...+60]
begin
    BASS_ChannelSetAttribute(chan[channelid],BASS_ATTRIB_TEMPO_PITCH,pitch);
end;

procedure TMyMusicEngine.ChannelChangeVolume(channelid:integer;volume: single); //volume 0...1
begin
    BASS_ChannelSetAttribute(chan[channelid], BASS_ATTRIB_VOL,volume);
end;

procedure TMyMusicEngine.ChannelChangePan(channelid: integer; Pan: single);//-1 (full left) to +1 (full right), 0 = centre.
begin
    BASS_ChannelSetAttribute(chan[channelid], BASS_ATTRIB_PAN,pan);
end;

procedure TMyMusicEngine.Load2Channel(Channelid: integer;filename: string);
var mystream: HStream;
    serror: string;
begin
   //BASS_StreamFree(chan[channelid]);
   BASS_SetDevice(2);
   mystream := BASS_StreamCreateFile(false, pChar(filename), 0, 0,BASS_SAMPLE_FLOAT or BASS_STREAM_DECODE );
   serror:=IntToStr(BASS_ErrorGetCode);
   //If chan[channelid] = 0 then
   // chan[channelid] := BASS_MusicLoad(FALSE, pChar(filename), 0, 0, BASS_MUSIC_RAMP or BASS_MUSIC_PRESCAN or BASS_MUSIC_DECODE, 0);
   //If chan[channelid] = 0 then
   // chan[channelid] := BASS_SampleLoad(FALSE, pChar(filename), 0, 0, 3, BASS_SAMPLE_OVER_POS  or BASS_UNICODE );
   // create a new stream - decoded & resampled :)
   chan[channelid] := BASS_FX_TempoCreate(mystream, BASS_FX_FREESOURCE or BASS_STREAM_AUTOFREE);

end;


end.
