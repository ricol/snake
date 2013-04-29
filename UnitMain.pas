unit UnitMain;

interface

{
CONTACT: WANGXINGHE1983@GMAIL.COM
}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls;

type
  TPoint = record
    i, j: integer;
  end;

  TFlag = (TOLEFT, TOUP, TORIGHT, TODOWN);

  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuGame: TMenuItem;
    MenuConfig: TMenuItem;
    MenuHelp: TMenuItem;
    MenuGameStart: TMenuItem;
    MenuGameEnd: TMenuItem;
    MenuGameSeperator: TMenuItem;
    MenuGameQuit: TMenuItem;
    MenuHelpAbout: TMenuItem;
    MenuConfigDifficulty: TMenuItem;
    PanelMain: TPanel;
    PaintBoxMain: TPaintBox;
    Timer1: TTimer;
    MenuPrimary: TMenuItem;
    MenuMedium: TMenuItem;
    MenuAdvance: TMenuItem;
    MenuSpecial: TMenuItem;
    MenuConfigAdvance: TMenuItem;
    MenuSelfPenetrate: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxMainPaint(Sender: TObject);
    procedure MenuGameQuitClick(Sender: TObject);
    procedure MenuGameStartClick(Sender: TObject);
    procedure MenuGameEndClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuPrimaryClick(Sender: TObject);
    procedure MenuMediumClick(Sender: TObject);
    procedure MenuAdvanceClick(Sender: TObject);
    procedure MenuSpecialClick(Sender: TObject);
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuSelfPenetrateClick(Sender: TObject);
  private
    Snake: array of TPoint;
    SnakeFlag: TFlag;
    TempFood: TPoint;
    SnakeLength: integer;
    procedure InitSnakeData(var tmpSnake: array of TPoint);
    procedure ShowSnake(tmpSnake: array of TPoint);
    procedure ShowWall();
    procedure ShowData(tmp: TPoint; tmpColor: TColor);
    procedure ShowFood(tmp: TPoint);
    procedure ShowBackGround();
    procedure GenerateFood(var tmpFood: TPoint);
    procedure AddFoodToSnake(tmpFood: TPoint);
    procedure SnakeMove(tmpFlag: TFlag);
    procedure EraseTail(tmp: TPoint);
    procedure SetArrow(tmp: TPoint; tmpFlag: TFlag);
    function IToX(i: integer): integer;
    function JToY(j: integer): integer;
    function InSnake(tmp: TPoint; tmpSnake: array of TPoint): boolean;
    function PointEqualPoint(tmpOne, tmpTwo: TPoint): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

const
  SNAKELEN = 25;
  LEN = 19;
  MULX = 20;
  MULY = 20;
  ADDX = 0;
  ADDY = 0;
  MAXX = 30;
  MAXY = 20;
  STARTX = 1;
  STARTY = 1;
  ENDX = MAXX - 2;
  ENDY = MAXY - 2;

procedure TFormMain.AddFoodToSnake(tmpFood: TPoint);
var
  tmpData: array of TPoint;
  i: integer;
begin
  SetLength(tmpData, SnakeLength);
  for i := Low(Snake) to High(Snake) do
  begin
    tmpData[i].i := Snake[i].i;
    tmpData[i].j := Snake[i].j;
  end;
  inc(SnakeLength);
  SetLength(Snake, SnakeLength);
  for i := Low(tmpData) to High(tmpData) do
    Snake[i] := tmpData[i];
  Snake[High(Snake)] := tmpFood;
  SetLength(tmpData, 0);
end;

procedure TFormMain.EraseTail(tmp: TPoint);
begin
  ShowData(tmp, clBlack);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  randomize();
  SnakeLength := SNAKELEN;
  SnakeFlag := TORIGHT;
  SetLength(Snake, SnakeLength);
  InitSnakeData(Snake);
  GenerateFood(TempFood);
  Self.ClientWidth := IToX(MAXX);
  Self.ClientHeight := JToY(MAXY);
  ShowWall();
  ShowSnake(Snake);
  ShowFood(TempFood);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if SnakeLength <> 0 then
  begin
    SetLength(Snake, 0);
    SnakeLength := 0;
  end;
end;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_UP then
  begin
    if SnakeFlag <> TODOWN then
      SnakeFlag := TOUP;
  end
  else if Key = VK_RIGHT then
  begin
    if SnakeFlag <> TOLEFT then
      SnakeFlag := TORIGHT;
  end
  else if Key = VK_DOWN then
  begin
    if SnakeFlag <> TOUP then
      SnakeFlag := TODOWN;
  end
  else if Key = VK_LEFT then
  begin
    if SnakeFlag <> TORIGHT then
      SnakeFlag := TOLEFT;
  end
  else if Key = VK_F1 then
    Timer1.Interval := 100
  else if Key = VK_F2 then
    Timer1.Interval := 2000
  else if Key = VK_ESCAPE then
    Timer1.Enabled := not Timer1.Enabled;
end;

procedure TFormMain.GenerateFood(var tmpFood: TPoint);
begin
  repeat
    tmpFood.i := random(ENDX - 1) + 1;
    tmpFood.j := random(ENDY - 1) + 1;
  until not InSnake(tmpFood, Snake);
end;

procedure TFormMain.InitSnakeData(var tmpSnake: array of TPoint);
var
  i: integer;
begin
  for i := Low(tmpSnake) to High(tmpSnake) do
  begin
    tmpSnake[i].i := i + STARTX;
    tmpSnake[i].j := STARTY;
  end;
end;

function TFormMain.InSnake(tmp: TPoint;
  tmpSnake: array of TPoint): boolean;
var
  i: integer;
begin
  result := false;
  for i := Low(tmpSnake) to High(tmpSnake) do
  begin
    if PointEqualPoint(tmp, tmpSnake[i]) then
    begin
      result := true;
      break;
    end;
  end;
end;

function TFormMain.IToX(i: integer): integer;
begin
  result := i * MULX + ADDX;
end;

function TFormMain.JToY(j: integer): integer;
begin
  result := j * MULY + ADDY;
end;

procedure TFormMain.MenuAdvanceClick(Sender: TObject);
begin
  Timer1.Enabled := false;
  Timer1.Interval := 100;
  Timer1.Enabled := true;
end;

procedure TFormMain.MenuGameEndClick(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TFormMain.MenuGameQuitClick(Sender: TObject);
begin
  Close();
end;

procedure TFormMain.MenuGameStartClick(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TFormMain.MenuHelpAboutClick(Sender: TObject);
begin
  MessageBox(Self.Handle, '游戏名称：贪吃蛇 v1.0' + sLineBreak +
                          '开发者：RICOL' + sLineBreak +
                          '联系：WANGXINGHE1983@GMAIL.COM', '关于', MB_OK);
end;

procedure TFormMain.MenuMediumClick(Sender: TObject);
begin
  Timer1.Enabled := false;
  Timer1.Interval := 200;
  Timer1.Enabled := true;
end;

procedure TFormMain.MenuPrimaryClick(Sender: TObject);
begin
  Timer1.Enabled := false;
  Timer1.Interval := 500;
  Timer1.Enabled := true;
end;

procedure TFormMain.MenuSelfPenetrateClick(Sender: TObject);
begin
  MenuSelfPenetrate.Checked := not MenuSelfPenetrate.Checked;
end;

procedure TFormMain.MenuSpecialClick(Sender: TObject);
begin
  Timer1.Enabled := false;
  Timer1.Interval := 50;
  Timer1.Enabled := true;
end;

procedure TFormMain.PaintBoxMainPaint(Sender: TObject);
begin
  ShowWall();
  ShowSnake(Snake);
  ShowFood(TempFood);
end;

function TFormMain.PointEqualPoint(tmpOne, tmpTwo: TPoint): boolean;
begin
  result := false;
  if (tmpOne.i = tmpTwo.i) and (tmpOne.j = tmpTwo.j) then
    result := true;
end;

procedure TFormMain.SetArrow(tmp: TPoint; tmpFlag: TFlag);
var
  tmpX, tmpY: integer;
begin
  tmpX := IToX(tmp.i);
  tmpY := JToY(tmp.j);
  case tmpFlag of
    TOLEFT: PaintBoxMain.Canvas.TextOut(tmpX + LEN div 4, tmpY + LEN div 4, '←');
    TOUP: PaintBoxMain.Canvas.TextOut(tmpX + LEN div 4, tmpY + LEN div 4, '↑');
    TORIGHT: PaintBoxMain.Canvas.TextOut(tmpX + LEN div 4, tmpY + LEN div 4, '→');
    TODOWN: PaintBoxMain.Canvas.TextOut(tmpX + LEN div 4, tmpY + LEN div 4, '↓');
  end;
end;

procedure TFormMain.ShowBackGround;
begin
  PaintBoxMain.Canvas.Pen.Color := clBlack;
  PaintBoxMain.Canvas.Brush.Color := clBlack;
  PaintBoxMain.Canvas.Rectangle(0, 0, PaintBoxMain.Width, PaintBoxMain.Height);
end;

procedure TFormMain.ShowData(tmp: TPoint; tmpColor: TColor);
var
  tmpX, tmpY: integer;
begin
  tmpX := IToX(tmp.i);
  tmpY := JToY(tmp.j);
  PaintBoxMain.Canvas.Pen.Color := tmpColor;
  PaintBoxMain.Canvas.Brush.Color := tmpColor;
  PaintBoxMain.Canvas.Rectangle(tmpX, tmpY, tmpX + LEN, tmpY + LEN);
end;

procedure TFormMain.ShowFood(tmp: TPoint);
begin
  ShowData(tmp, clBlue);
end;

procedure TFormMain.ShowSnake(tmpSnake: array of TPoint);
var
  i: integer;
begin
  for i := Low(tmpSnake) to High(tmpSnake) do
    ShowData(tmpSnake[i], clWhite);
  ShowData(tmpSnake[High(tmpSnake)], clRed);
  SetArrow(tmpSnake[High(tmpSnake)], SnakeFlag);
end;

procedure TFormMain.ShowWall;
var
  i, j: integer;
  tmpPoint: TPoint;
begin
  ShowBackGround();
  for i := 0 to MAXX - 1 do
  begin
    tmpPoint.i := i;
    tmpPoint.j := 0;
    ShowData(tmpPoint, clGreen);
    tmpPoint.i := i;
    tmpPoint.j := MAXY - 1;
    ShowData(tmpPoint, clGreen);
  end;
  for j := 0 to MAXY - 1 do
  begin
    tmpPoint.i := 0;
    tmpPoint.j := j;
    ShowData(tmpPoint, clGreen);
    tmpPoint.i := MAXX - 1;
    tmpPoint.j := j;
    ShowData(tmpPoint, clGreen);
  end;
end;

procedure TFormMain.SnakeMove(tmpFlag: TFlag);
var
  tmpTail, tmpHead, i: integer;
  tmpNextHead, tmpPoint: TPoint;
begin
  tmpTail := Low(Snake);
  tmpHead := High(Snake);
  tmpNextHead := Snake[tmpHead];
  tmpPoint := Snake[tmpHead];
  case tmpFlag of
    TOLEFT:
    begin
      tmpNextHead.i := tmpNextHead.i - 1;
      if tmpNextHead.i < STARTX then
        tmpNextHead.i := STARTX;
    end;
    TOUP:
    begin
      tmpNextHead.j := tmpNextHead.j - 1;
      if tmpNextHead.j < STARTY then
        tmpNextHead.j := STARTY;
    end;
    TORIGHT:
    begin
      tmpNextHead.i := tmpNextHead.i + 1;
      if tmpNextHead.i > ENDX then
        tmpNextHead.i := ENDX;
    end;
    TODOWN:
    begin
      tmpNextHead.j := tmpNextHead.j + 1;
      if tmpNextHead.j > ENDY then
        tmpNextHead.j := ENDY;
    end;
  end;
  if PointEqualPoint(TempFood, tmpNextHead) then
  begin
    AddFoodToSnake(TempFood);
    GenerateFood(TempFood);
    ShowFood(TempFood);
  end
  else if (not MenuSelfPenetrate.Checked) and InSnake(tmpNextHead, Snake) then
  begin
    exit;
  end
  else
  begin
    case tmpFlag of
      TOLEFT:
      begin
        if Snake[tmpHead].i > STARTX then
        begin
          Snake[tmpHead].i := Snake[tmpHead].i - 1;
          EraseTail(Snake[tmpTail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := tmpPoint;
        end;
      end;
      TOUP:
      begin
        if Snake[tmpHead].j > STARTY then
        begin
          Snake[tmpHead].j := Snake[tmpHead].j - 1;
          EraseTail(Snake[tmpTail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := tmpPoint;
        end;
      end;
      TORIGHT:
      begin
        if Snake[tmpHead].i < ENDX then
        begin
          Snake[tmpHead].i := Snake[tmpHead].i + 1;
          EraseTail(Snake[tmpTail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := tmpPoint;
        end;
      end;
      TODOWN:
      begin
        if Snake[tmpHead].j < ENDY then
        begin
          Snake[tmpHead].j := Snake[tmpHead].j + 1;
          EraseTail(Snake[tmpTail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := tmpPoint;
        end;
      end;
    end;
  end;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  SnakeMove(SnakeFlag);
  ShowSnake(Snake);
end;

end.
