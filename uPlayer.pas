unit uPlayer;

interface

uses
  GLScene, GLObjects, GLFireFX, GLColor, VectorGeometry, VectorTypes,
  ODEImport2, ODEGL2, uClasses, uKeyBoard, uOde, uConsts, uCollisions,
  uAudio, Bass, uInterfaces, Dialogs, SysUtils;

type
  TPlayer = class(TGLDummyCube)
  private
    FV: Single;
    Fk: Single;
    Fa: Single;
  public
    Eff: TGLDummyCube;
    Explode: TGLFireFXManager;
    isExplode: Boolean;
    pPlayer: TGLPlane;
    OnGround: Boolean;
    DoubleJump: Boolean;
    OnKeyJump: Boolean;
    OnKeyJump2: Boolean;
    OnKeyShoot: Boolean;
    FireBall: Boolean;
    Dir: Integer;
    vx1,vx2,vy1,vy2: Single;
    Mass: Single;
    ODEManager: TODEManager;
    Camera: TGLCamera;
    Game: TGame;
    HSName: AnsiString;
    AY: Single;

    procedure HandleMovement(Speed: Single);
    procedure HandleAnimation(Frame: Integer);
    procedure HandleCamera;
    //
    procedure Init;
    procedure Step(DeltaTime: Double);
  end;

implementation

//* TPlayer *//

procedure TPlayer.HandleMovement(Speed: Single);
Var
  Force: TVector2f;
  vd: PdVector3;
  X,Y,Z: Integer;
  a: Single;
  Snowball: TBall;
  i: Integer;
begin
  Force[0]:= 0; Force[1]:= 0;

  if (OnKey(KeyUpArrow)) or (OnKey(KeyW)) then
  begin
    if (OnGround) and (not OnKeyJump) then
    begin
      Force[1]:= 750;
      OnKeyJump:= True;
    end;
  end else
  begin
    OnKeyJump:= False;
  end;

  if (OnKey(KeyRightArrow)) or (OnKey(KeyD)) then
  begin
    Force[0]:= 40;
    //if Force[1] = 750 then dPlayer.RollAngle:= -45;
  end else
  if (OnKey(KeyLeftArrow)) or (OnKey(KeyA)) then
  begin
    Force[0]:= -40;
    //if Force[1] = 750 then dPlayer.RollAngle:= 45;
  end;// else dPlayer.RollAngle:= 0;

  if DoubleJump then
  begin
    if (OnKey(KeyUpArrow)) or (OnKey(KeyW)) then
    begin
      if (not OnGround) and (not OnKeyJump2) and (not OnKeyJump) then
      begin
        Force[1]:= 750;
        OnKeyJump2:= True;
      end;
    end;

    if OnGround then OnKeyJump2:= False;
  end;

  //if Force[0] = 0 then
  begin
    if OnGround then
    begin
      vd:= dBodyGetLinearVel(ODEManager.GetObj('Player').Body);
      a:= vd[1];
      vd[1]:= 0;
      dBodySetLinearVel(ODEManager.GetObj('Player').Body,vd[0] * 0.9,a,vd[2] * 0.9);
    end else
    begin
      vd:= dBodyGetLinearVel(ODEManager.GetObj('Player').Body);
      a:= vd[1];
      vd[1]:= 0;
      dBodySetLinearVel(ODEManager.GetObj('Player').Body,vd[0] * 0.99,a,vd[2] * 0.99);
    end;
  end;

  //if Player.OnGround then
  begin
    vd:= dBodyGetLinearVel(ODEManager.GetObj('Player').Body);
    dBodySetForce(ODEManager.GetObj('Player').Body,0,Force[1],0);

    if dVector3Length(vd) < 4 then
    begin
      //dBodySetTorque(ODEManager.GetObj('Player').Body,0,0,-Force[0] * 2);
      dBodySetForce(ODEManager.GetObj('Player').Body,Force[0],Force[1],0);
    end;
  end;

  if Force[0] >  0 then Dir:=  1;
  if Force[0] <  0 then Dir:= -1;

  if (OnKey(KeyControl)) or (OnKey(KeyE)) then
    if not OnkeyShoot then
    begin

    end;

  if (not OnKey(KeyControl)) and (not OnKey(KeyE)) then OnKeyShoot:= False;

  if Force[0] <> 0 then HandleAnimation(0)
  else HandleAnimation(1);
  //pPlayer.Roll(Force[0] / 4);
  //dBodySetForce(ODEManager.GetObj('Player').Body,Force[0],Force[1],0);
end;

procedure TPlayer.HandleCamera;
begin
  if Camera.TargetObject.Position.X + 4.75 < Game.MaxPosCam[0] then
  begin
    if Position.X > Camera.TargetObject.Position.X + cCameraClampX then
       Camera.TargetObject.Position.X:= Position.X - cCameraClampX;
  end else Camera.TargetObject.Position.X:= Game.MaxPosCam[0] - 4.74;

  if Camera.TargetObject.Position.X - 4.75 > 1 then
  begin
    if Position.X < Camera.TargetObject.Position.X - cCameraClampX then
       Camera.TargetObject.Position.X:= Position.X + cCameraClampX;
  end else Camera.TargetObject.Position.X:= 5.75;
  //
  if Camera.TargetObject.Position.Y + 3.8 < 1 then
  begin
  if Position.Y > Camera.TargetObject.Position.Y + cCameraClampY then
       Camera.TargetObject.Position.Y:= Position.Y - cCameraClampY;
  end else Camera.TargetObject.Position.Y:= -2.8;

  if Camera.TargetObject.Position.Y - 3.8 > Game.MaxPosCam[1] then
  begin
    if Position.Y < Camera.TargetObject.Position.Y - cCameraClampY then
       Camera.TargetObject.Position.Y:= Position.Y + cCameraClampY;
  end else Camera.TargetObject.Position.Y:= Game.MaxPosCam[1] + 3.7;
end;

procedure TPlayer.Init;
begin
  Explode:= TGLFireFXManager.Create(nil);
  Eff:= TGLDummyCube(Scene.Objects.AddNewChild(TGLDummyCube));
  Eff.Scale.SetVector(0.15,0.15,0.15);
  Eff.Tag:= 999;

  with Explode do
  begin
    Disabled:= True;
    InnerColor.Color:= clrWhite;
    OuterColor.Color:= clrGray;
    ParticleLife:= 10;
    ParticleSize:= 5;
    FireBurst:= 1;
    FireBurst:= 0;
    FireDensity:= 0.5;
    FireRadius:= 0.5;
    MaxParticles:= 124;
  end;

  Mass:= 0.4;
  Game.Lives:= 9;
  Name:= 'Player';
  Tag:= 999;

  with ODEManager.AddObj(Self,otDynamic,gtSphere) do
  begin
    SetRadius(0.4);
    Init;
    Tag:= 999;
  end;

  GetOrCreateFireFX(Eff).Manager:= Explode;
  HSName:= 'Player';
  pPlayer.Scale.Y:= 1.2;
  //pPlayer.Position.Y:= 1.2;

  AY:= 0.4;
  Fa:= 0.01;
  Fk:= 1;
end;

procedure TPlayer.Step(DeltaTime: Double);
Var
  t: Integer;
  i,j: Integer;
  Obj: TGLBaseSceneObject;
  Pos: PdVector3;
  c: AnsiString;
  w: Single;
  ch: Char;
  alpha: Single;
  V1,V2: SIngle;
  F1,F2: Single;
  m,a1,a2: Single;
  mass: TdMass;
  F,A: Single;
begin
  //dPlayer.Scale.X:= 0.8 + (sqr(dBodyGetLinearVel(ODEManager.GetObj('Player').Body)[0])/100);
  //dPlayer.Scale.Y:= 0.8 + (sqr(dBodyGetLinearVel(ODEManager.GetObj('Player').Body)[1])/500);

  dBodyGetMass(ODEManager.GetObj('Player').Body,mass);
  m:= mass.mass;

  V1:= dBodyGetLinearVel(ODEManager.GetObj('Player').Body)[0];
  V2:= dBodyGetLinearVel(ODEManager.GetObj('Player').Body)[1];

  A1:= V1*deltaTime;
  A2:= V2*deltaTime;

  F1:= dBodyGetForce(ODEManager.GetObj('Player').Body)[0];
  F2:= dBodyGetForce(ODEManager.GetObj('Player').Body)[1];

  F:= sqrt(sqr(F1)+sqr(F2));
  A:= sqrt(sqr(A1)+sqr(A2));

  alpha:= F/(m*a);
  //alpha:= (180/pi)*alpha;
  alpha:= arccos(alpha);

  //dPlayer.RollAngle:= alpha*10;
  //Game.Score:= Round(alpha*10);
  //Game.Lives:= 99;
  //dPlayer.RollAngle:= sin(dBodyGetLinearVel(ODEManager.GetObj('Player').Body)[1])/
  //                    cos(dBodyGetLinearVel(ODEManager.GetObj('Player').Body)[0]);

  HandleMovement(cSpeed * DeltaTime);
  HandleCamera;

  Pos:= dGeomGetPosition(ODEManager.GetObj(Name).Geom);
  dGeomSetPosition(ODEManager.GetObj(Name).Geom,Pos[0],Pos[1],0);

  if Collision(Game.CollisionsList,Self,1,0.8,0.8,0.2,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Gems_Collect.ogg',False);
    (TagObject as TBPoint).Explode.RingExplosion(1,15,0.1,XVector,YVector);

    Game.Points.Add((TagObject as TBPoint).Name);
    Game.Score:= Game.Score + 1;

    (TagObject as TBPoint).Visible:= False;
  end;

  if Collision(Game.CollisionsList,Self,2,0.8,0.8,0.2,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Gems_Collect.ogg',False);
    (TagObject as TBPoint).Explode.RingExplosion(1,15,0.1,XVector,YVector);

    Game.Points.Add((TagObject as TBPoint).Name);
    Game.Score:= Game.Score + 10;

    (TagObject as TBPoint).Visible:= False;
  end;

  if Collision(Game.CollisionsList,Self,3,0.8,0.8,0.2,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Gems_Collect.ogg',False);
    (TagObject as TBPoint).Explode.RingExplosion(1,15,0.1,XVector,YVector);

    Game.Points.Add((TagObject as TBPoint).Name);
    Game.Score:= Game.Score + 50;

    (TagObject as TBPoint).Visible:= False;
  end;

  if Collision(Game.CollisionsList,Self,4,0.8,0.8,0.2,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Gems_Collect.ogg',False);
    (TagObject as TBPoint).Explode.RingExplosion(1,15,0.1,XVector,YVector);

    Game.Points.Add((TagObject as TBPoint).Name);
    Game.Score:= Game.Score + 100;

    (TagObject as TBPoint).Visible:= False;
  end;

  if Collision(Game.CollisionsList,Self,930,1,2,1,1) then
  begin
    Game.Points.Add((TagObject as TGLBaseSceneObject).Name);
    Game.White.Material.FrontProperties.Diffuse.Alpha:= 0.9;
    Game.Dialog.ModulateColor.Alpha:= 1;
    Game.Dialog.Text:= 'Игра сохранена!';
    Game.Save(Game.MainDir + '\Save.sav');
    (TagObject as TGLBaseSceneObject).Visible:= False;
  end;

  if Collision(Game.CollisionsList,Self,940,2,1,1,1) then
  begin
    Game.Points.Add((TagObject as TGLBaseSceneObject).Name);
    Game.White.Material.FrontProperties.Diffuse.Alpha:= 0.9;
    Game.Dialog.ModulateColor.Alpha:= 1;
    Game.Dialog.Text:= 'Игра сохранена!';
    Game.Save(Game.MainDir + '\Save.sav');
    (TagObject as TGLBaseSceneObject).Visible:= False;
  end;

  Game.ReadDialog:= False;

  for i:= 1 to 9 do
  begin
    if Collision(Game.CollisionsList,Self,4000+i) then
    begin
      if OnKey(keySpace) then
      begin
        Game.DialogTimer:= 200;
        Game.DialogTimer2:= 200;
        Game.Dialog.ModulateColor.Alpha:= 1;

        Game.PanelsManager.Panel('MessageBKLeft').Leav.Material.FrontProperties.Diffuse.Alpha:= 1;
        Game.PanelsManager.Panel('MessageBKRight').Leav.Material.FrontProperties.Diffuse.Alpha:= 1;
        Game.PanelsManager.Panel('MessageBKCenter').Leav.Material.FrontProperties.Diffuse.Alpha:= 1;
        Game.PanelsManager.Panel('MessageBKPimp').Leav.Material.FrontProperties.Diffuse.Alpha:= 1;

        //Game.PanelsManager.Panel('MessageBKCenter').Leav.Width:=
        w:= 0;
        c:= '';

        for j:= 1 to Length(Game.Dialog.Text) do
        begin
          c:= Copy(Game.Dialog.Text,j,1);
          ch:= c[1];
          w:= w + (Game.MainFont.GetCharWidth(ch)/2);
        end;

        w:= w + 25;

        Game.PanelsManager.Panel('MessageBKCenter').Leav.Width:= w;
        Game.PanelsManager.Panel('MessageBKLeft').Leav.Position.X:= 400 - (w / 2) - 6;
        Game.PanelsManager.Panel('MessageBKRight').Leav.Position.X:= 400 + (w / 2) + 6;
        
        Game.Dialog.Text:= Game.HelpText[i];
        //Game.ReadDialog:= True;
      end;
    end;
  end;

  if Collision(Game.CollisionsList,Self,6,0.8,0.8,0.2,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Health_Collect.ogg',False);
    (TagObject as TBPoint).Explode.RingExplosion(1,15,0.1,XVector,YVector);
    Game.Points.Add((TagObject as TBPoint).Name);
    (TagObject as TBPoint).Visible:= False;;
    Game.Lives:= Game.Lives + 1;
  end;

  if Collision(Game.CollisionsList,Self,5,0.8,0.8,0.2,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Health_Collect.ogg',False);
    (TagObject as TBPoint).Explode.RingExplosion(1,15,0.1,XVector,YVector);
    (TagObject as TBPoint).Visible:= False;
    DoubleJump:= True;
  end;

  if Collision(Game.CollisionsList,Self,8,0.8,0.8,0.5,0.5)then
  begin
    if ((TagObject as TEnemy).God) or (dBodyGetLinearVel(ODEManager.GetObj('Player').Body)[1] >= -0.5) then
    begin
      if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Enemy_NoHit.ogg',False);
      if Position.X > (TagObject as TGLBaseSceneObject).Position.X then t:= 1
      else t:= -1;

      vy1:= cJump;
      dBodySetForce(ODEManager.GetObj('Player').Body,t * 250,250,0);
      Game.Lives:= Game.Lives - 1;
    end else
    begin
      if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Enemy_Kicked.ogg',False);
      dBodySetForce(ODEManager.GetObj('Player').Body,0,1000,0);
      (TagObject as TEnemy).Health:= (TagObject as TEnemy).Health - 1;
      if (TagObject as TEnemy).Health <= 0 then
      begin
        Game.Points.Add((TagObject as TEnemy).Name);
        //(TagObject as TEnemy).Destroy;
        //(TagObject as TEnemy).Visible:= False;
      end;
    end;
  end;

  if Collision(Game.CollisionsList,Self,500,0.5,0.5,0.5,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Enemy_NoHit.ogg',False);
    dBodySetForce(ODEManager.GetObj('Player').Body,0,500,0);
    Game.Lives:= Game.Lives - 1;
  end;

  if Collision(Game.CollisionsList,Self,503) then
  begin
    dBodyAddForce(ODEManager.GetObj('Player').Body,0,40,0);
  end;

  if Collision(Game.CollisionsList,Self,501,0.5,0.5,0.5,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Enemy_NoHit.ogg',False);
    dBodySetForce(ODEManager.GetObj('Player').Body,0,-500,0);
    Game.Lives:= Game.Lives - 1;
  end;

  if Collision(Game.CollisionsList,Self,9,0.8,0.8,0.2,0.2) then
  begin
    if Game.onSound then PlayAudio(Game.BassStream,Game.MainDir + '\Sound\Enemy_NoHit.ogg',False);
    t:= (TagObject as TBall).Dir;
    //(TagObject as TBall).Destroy;
    //Player.vx1:= t;
    vy1:= cJump;
    dBodySetForce(ODEManager.GetObj('Player').Body,t * 250,250,0);
    Game.Lives:= Game.Lives - 1;
  end;

  if Collision(Game.CollisionsList,Self,10) then
  begin
    //if Game.CurrentLevel = 20 then Game.Timer:= 700
    {else} Game.Timer:= 400;

    Game.Points.Clear;
    Game.CollisionsList.Clear;
    Game.StepsList.Clear;
    Game.ButtonsList.Clear;
    //Game.RoomsManager.GoToRoom('Level');
  end;

  if OnKey(keyE) then
  begin
    //if Game.CurrentLevel = 20 then Game.Timer:= 700
    {else} Game.Timer:= 400;
    
    Game.Points.Clear;
    Game.CollisionsList.Clear;
    Game.StepsList.Clear;
    Game.ButtonsList.Clear;
  end;

  {for i:= 0 to Scene.Objects.Count - 1 do
  if (Scene.Objects[i].Tag = 0) then
  begin
    obj:= Scene.Objects[i];

    if (Player.Position.X < Obj.Position.X + 0.5) and
       (Player.Position.X > Obj.Position.X - 0.5) then
    begin
      if (Player.Position.Y - cRadius < Obj.Position.Y + (Obj.TagFloat / 2)) then
      begin
        if ((Player.Position.Y + cRadius > Obj.Position.Y + 0.2)) then
          Player.OnGround[-cY]:= True;
      end else Player.OnGround[-cY]:= False;
    end;

    if (Player.Position.X < Obj.Position.X + 0.5) and
       (Player.Position.X > Obj.Position.X - 0.5) then
    begin
      if (Player.Position.Y + cRadius > Obj.Position.Y - (Obj.TagFloat / 2)) then
      begin
        if (Player.Position.Y - cRadius < Obj.Position.Y + 0.2) then
          Player.OnGround[cY]:= True;
      end else Player.OnGround[cY]:= False;
    end;

    if (Player.Position.X - cRadius < Obj.Position.X + 0.5) and
       (Player.Position.X > Obj.Position.X - 0.5) then
    begin
      if (Player.Position.Y - cRadius < Obj.Position.Y + (Obj.TagFloat / 2) - 0.1) then
      begin
        if ((Player.Position.Y + cRadius > Obj.Position.Y - (Obj.TagFloat / 2) - 0.1)) then
          Player.OnGround[-cX]:= True;
      end else Player.OnGround[-cX]:= False;
    end;

    if (Player.Position.X < Obj.Position.X + 0.5) and
       (Player.Position.X + cRadius > Obj.Position.X - 0.5) then
    begin
      if (Player.Position.Y - cRadius < Obj.Position.Y + (Obj.TagFloat / 2) - 0.1) then
      begin
        if ((Player.Position.Y + cRadius > Obj.Position.Y - (Obj.TagFloat / 2) - 0.1)) then
          Player.OnGround[cX]:= True;
      end else Player.OnGround[cX]:= False;
    end;
  end;}
end;

procedure TPlayer.HandleAnimation(Frame: Integer);
begin
  if Frame = 0 then
  begin
    if OnGround then
    begin
      AY:= AY - FV;
      Fa:= 0.01;

      if AY <= 0.2 then
      begin
        FV:= -0.06*Fk;
        Fa:= 0;
      end;

      FV:= FV + Fa;
    end;
  end;
  if Frame = 1 then
  begin
    if OnGround then
    begin
      AY:= AY - FV;
      Fa:= 0.01;

      if AY <= 0.2 then
      begin
        FV:= 0;
        Fa:= 0;
      end;

      FV:= FV + Fa;
    end;
  end;
end;

end.
