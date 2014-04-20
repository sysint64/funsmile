//* Автор [Xakep] *//

unit uDrawPanels;

interface

uses
  GLScene, uClasses, uInterfaces, JPEG, GLTexture, GLMaterial, OffSetAnim,
  uPngCopy, Dialogs, SysUtils;

procedure DrawLobosoft(PanelsManager: TPanelsManager; Pak: TPak);
procedure DrawHellroom(PanelsManager: TPanelsManager; Pak: TPak);
procedure DrawMainMenu(PanelsManager: TPanelsManager; Pak: TPak);
procedure DrawLevelPanels(PanelsManager: TPanelsManager; Pak: TPak; World: Integer);
procedure DrawHightScorePanels(PanelsManager: TPanelsManager; Pak: TPak);
procedure DrawWinPanels(PanelsManager: TPanelsManager; Pak: TPak);

implementation

procedure DrawHellroom(PanelsManager: TPanelsManager; Pak: TPak);
begin
  try
    Pak.OpenPak(Pak.MainDir + '\Packeges\MainMenu.pak');

    with PanelsManager.Add(400,300,800,600) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        Image.LoadFromFile(Pak.ExtractFormPak('hellroom.jpg'));
        TextureMode:= tmReplace;
      end;

      Active:= False;
    end;
  finally
    Pak.ClosePak;
  end;
end;

procedure DrawLobosoft(PanelsManager: TPanelsManager; Pak: TPak);
begin
  try
    Pak.OpenPak(Pak.MainDir + '\Packeges\MainMenu.pak');

    with PanelsManager.Add(400,300,800,600) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        Image.LoadFromFile(Pak.ExtractFormPak('lobosoft.jpg'));
        TextureMode:= tmReplace;
      end;

      Active:= False;
    end;
  finally
    Pak.ClosePak;
  end;
end;

procedure DrawMainMenu(PanelsManager: TPanelsManager; Pak: TPak);
Var
  Buttons: Array[0..2] of String;
  i: Integer;
begin
  try
    Buttons[0]:= 'btnStartGame';
    Buttons[1]:= 'btnLoadGame';
    Buttons[2]:= 'btnExitGame';

    Pak.OpenPak(Pak.MainDir + '\Packeges\MainMenu.pak');

    with PanelsManager.Add(400,300,800,600) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak('Back.png'),Leav.Material);
        TextureMode:= tmReplace;
      end;

      Active:= False;
    end;

    for i:= 0 to 2 do
      with PanelsManager.Add(400,300 + (70 * i),204,64) do
      begin
        with Leav.Material.Texture do
        begin
          Enabled:= True;
          SetMaterialPngTexture(Pak.ExtractFormPak(Buttons[i] + 'Leav.png'),Leav.Material);
          TextureMode:= tmReplace;
        end;

        with Enter.Material.Texture do
        begin
          Enabled:= True;
          SetMaterialPngTexture(Pak.ExtractFormPak(Buttons[i] + 'Enter.png'),Enter.Material);
          TextureMode:= tmReplace;
        end;

        Name:= Buttons[i];
        Active:= True;
      end;

  finally
    Pak.ClosePak;
  end;
end;

procedure DrawLevelPanels(PanelsManager: TPanelsManager; Pak: TPak; World: Integer);
Var
  Panels: Array[0..4] of String;
  i: Integer;
begin
  try
    Panels[0]:= 'PausedBack';
    Panels[1]:= 'PausedText';
    Panels[2]:= 'Panel';
    Panels[3]:= 'btnRestartGameP';
    Panels[4]:= 'btnExitGameP';

    Pak.OpenPak(Pak.MainDir + '\Packeges\World'+IntToStr(World)+'.pak');

    with PanelsManager.Add(112,48,204,76) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak(Panels[2] + '.png'),Leav.Material);
        TextureMode:= tmModulate;
        Leav.Material.BlendingMode:= bmTransparency;
        SetGammaImage(Leav.Material,255);
      end;

      Name:= Panels[2];
      Active:= False;
    end;

    for i:= 0 to 1 do
      with PanelsManager.Add(400,300,100,52) do
      begin
        with Leav.Material.Texture do
        begin
          Enabled:= True;
          SetMaterialPngTexture(Pak.ExtractFormPak(Panels[i] + '.png'),Leav.Material);
          TextureMode:= tmModulate;
          Leav.Material.BlendingMode:= bmTransparency;
          SetGammaImage(Leav.Material,255);
        end;

        Visible:= False;
        Name:= Panels[i];
        Active:= False;
      end;

    //for i:= 0 to 1 do
      with PanelsManager.Add(346,332,100,32) do
      begin
       with Leav.Material.Texture do
        begin
          Enabled:= True;
          SetMaterialPngTexture(Pak.ExtractFormPak(Panels[3] + 'Leav.png'),Leav.Material);
          SetMaterialPngTexture(Pak.ExtractFormPak(Panels[3] + 'Enter.png'),Enter.Material);
          TextureMode:= tmModulate;
          Leav.Material.BlendingMode:= bmTransparency;
          SetGammaImage(Leav.Material,255);
          Enter.Material.BlendingMode:= bmTransparency;
          SetGammaImage(Enter.Material,255);
        end;

        Visible:= False;
        Name:= Panels[3];
        Active:= True;
      end;

      with PanelsManager.Add(454,332,100,32) do
      begin
       with Leav.Material.Texture do
        begin
          Enabled:= True;
          SetMaterialPngTexture(Pak.ExtractFormPak(Panels[4] + 'Leav.png'),Leav.Material);
          SetMaterialPngTexture(Pak.ExtractFormPak(Panels[4] + 'Enter.png'),Enter.Material);
          TextureMode:= tmModulate;
          Leav.Material.BlendingMode:= bmTransparency;
          SetGammaImage(Leav.Material,255);
          Enter.Material.BlendingMode:= bmTransparency;
          SetGammaImage(Enter.Material,255);
        end;

        Visible:= False;
        Name:= Panels[4];
        Active:= True;
      end;

    // Message

    with PanelsManager.Add(350,200,12,32) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak('MessageBKLeft.png'),Leav.Material);
        TextureMode:= tmModulate;
        TextureWrap:= twNone;
        Leav.Material.BlendingMode:= bmTransparency;
        SetGammaImage(Leav.Material,255);
        Leav.Material.FrontProperties.Diffuse.Alpha:= 0;
      end;

      Name:= 'MessageBKLeft';
      Active:= False;
    end;

    with PanelsManager.Add(452,200,12,32) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak('MessageBKRight.png'),Leav.Material);
        TextureMode:= tmModulate;
        TextureWrap:= twNone;
        Leav.Material.BlendingMode:= bmTransparency;
        SetGammaImage(Leav.Material,255);
        Leav.Material.FrontProperties.Diffuse.Alpha:= 0;
      end;

      Name:= 'MessageBKRight';
      Active:= False;
    end;

    with PanelsManager.Add(400,200,100,32) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak('MessageBKCenter.png'),Leav.Material);
        TextureMode:= tmModulate;
        Leav.Material.BlendingMode:= bmTransparency;
        SetGammaImage(Leav.Material,255);
        Leav.Material.FrontProperties.Diffuse.Alpha:= 0;
      end;

      Name:= 'MessageBKCenter';
      Active:= False;
    end;

    with PanelsManager.Add(400,222,12,12) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak('MessageBKPimp.png'),Leav.Material);
        TextureMode:= tmModulate;
        Leav.Material.BlendingMode:= bmTransparency;
        SetGammaImage(Leav.Material,255);
        Leav.Material.FrontProperties.Diffuse.Alpha:= 0;
      end;

      Name:= 'MessageBKPimp';
      Active:= False;
    end;
  finally
    Pak.ClosePak;
  end;
end;

procedure DrawHightScorePanels(PanelsManager: TPanelsManager; Pak: TPak);
begin
  try
    Pak.OpenPak(Pak.MainDir + '\Packeges\MainMenu.pak');

    with PanelsManager.Add(400,300,800,600) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak('Back.png'),Leav.Material);
        TextureMode:= tmReplace;
      end;

      Active:= False;
    end;
  finally
    Pak.ClosePak;
  end;
end;

procedure DrawWinPanels(PanelsManager: TPanelsManager; Pak: TPak);
begin
  try
    Pak.OpenPak(Pak.MainDir + '\Packeges\MainMenu.pak');

    with PanelsManager.Add(400,300,800,600) do
    begin
      with Leav.Material.Texture do
      begin
        Enabled:= True;
        SetMaterialPngTexture(Pak.ExtractFormPak('endbg.png'),Leav.Material);
        TextureMode:= tmReplace;
      end;

      Active:= False;
    end;
  finally
    Pak.ClosePak;
  end;
end;

end.
