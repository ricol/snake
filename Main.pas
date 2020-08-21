unit Main;

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
    procedure InitSnakeData(var snake: array of TPoint);
    procedure ShowSnake(snake: array of TPoint);
    procedure ShowWall();
    procedure ShowData(p: TPoint; color: TColor);
    procedure ShowFood(f: TPoint);
    procedure ShowBackGround();
    procedure GenerateFood(var food: TPoint);
    procedure AddFoodToSnake(food: TPoint);
    procedure SnakeMove(flag: TFlag);
    procedure EraseTail(point: TPoint);
    procedure SetArrow(p: TPoint; flag: TFlag);
    function IToX(i: integer): integer;
    function JToY(j: integer): integer;
    function InSnake(p: TPoint; snake: array of TPoint): boolean;
    function PointEqualPoint(one, two: TPoint): boolean;
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

procedure TFormMain.AddFoodToSnake(food: TPoint);
var
  points: array of TPoint;
  i: integer;
begin
  SetLength(points, SnakeLength);
  for i := Low(Snake) to High(Snake) do
  begin
    points[i].i := Snake[i].i;
    points[i].j := Snake[i].j;
  end;
  inc(SnakeLength);
  SetLength(Snake, SnakeLength);
  for i := Low(points) to High(points) do
    Snake[i] := points[i];
  Snake[High(Snake)] := food;
  SetLength(points, 0);
end;

procedure TFormMain.EraseTail(point: TPoint);
begin
  ShowData(point, clBlack);
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

procedure TFormMain.GenerateFood(var food: TPoint);
begin
  repeat
    food.i := random(ENDX - 1) + 1;
    food.j := random(ENDY - 1) + 1;
  until not InSnake(food, Snake);
end;

procedure TFormMain.InitSnakeData(var snake: array of TPoint);
var
  i: integer;
begin
  for i := Low(snake) to High(snake) do
  begin
    snake[i].i := i + STARTX;
    snake[i].j := STARTY;
  end;
end;

function TFormMain.InSnake(p: TPoint;
  snake: array of TPoint): boolean;
var
  i: integer;
begin
  result := false;
  for i := Low(snake) to High(snake) do
  begin
    if PointEqualPoint(p, snake[i]) then
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

function TFormMain.PointEqualPoint(one, two: TPoint): boolean;
begin
  result := false;
  if (one.i = two.i) and (one.j = two.j) then
    result := true;
end;

procedure TFormMain.SetArrow(p: TPoint; flag: TFlag);
var
  x, y: integer;
begin
  x := IToX(p.i);
  y := JToY(p.j);
  case flag of
    TOLEFT: PaintBoxMain.Canvas.TextOut(x + LEN div 4, y + LEN div 4, '←');
    TOUP: PaintBoxMain.Canvas.TextOut(x + LEN div 4, y + LEN div 4, '↑');
    TORIGHT: PaintBoxMain.Canvas.TextOut(x + LEN div 4, y + LEN div 4, '→');
    TODOWN: PaintBoxMain.Canvas.TextOut(x + LEN div 4, y + LEN div 4, '↓');
  end;
end;

procedure TFormMain.ShowBackGround;
begin
  PaintBoxMain.Canvas.Pen.Color := clBlack;
  PaintBoxMain.Canvas.Brush.Color := clBlack;
  PaintBoxMain.Canvas.Rectangle(0, 0, PaintBoxMain.Width, PaintBoxMain.Height);
end;

procedure TFormMain.ShowData(p: TPoint; color: TColor);
var
  x, y: integer;
begin
  x := IToX(p.i);
  y := JToY(p.j);
  PaintBoxMain.Canvas.Pen.Color := color;
  PaintBoxMain.Canvas.Brush.Color := color;
  PaintBoxMain.Canvas.Rectangle(x, y, x + LEN, y + LEN);
end;

procedure TFormMain.ShowFood(f: TPoint);
begin
  ShowData(f, clBlue);
end;

procedure TFormMain.ShowSnake(snake: array of TPoint);
var
  i: integer;
begin
  for i := Low(snake) to High(snake) do
    ShowData(snake[i], clWhite);
  ShowData(snake[High(snake)], clRed);
  SetArrow(snake[High(snake)], SnakeFlag);
end;

procedure TFormMain.ShowWall;
var
  i, j: integer;
  p: TPoint;
begin
  ShowBackGround();
  for i := 0 to MAXX - 1 do
  begin
    p.i := i;
    p.j := 0;
    ShowData(p, clGreen);
    p.i := i;
    p.j := MAXY - 1;
    ShowData(p, clGreen);
  end;
  for j := 0 to MAXY - 1 do
  begin
    p.i := 0;
    p.j := j;
    ShowData(p, clGreen);
    p.i := MAXX - 1;
    p.j := j;
    ShowData(p, clGreen);
  end;
end;

procedure TFormMain.SnakeMove(flag: TFlag);
var
  tail, head, i: integer;
  nextHead, point: TPoint;
begin
  tail := Low(Snake);
  head := High(Snake);
  nextHead := Snake[head];
  point := Snake[head];
  case flag of
    TOLEFT:
    begin
      nextHead.i := nextHead.i - 1;
      if nextHead.i < STARTX then
        nextHead.i := STARTX;
    end;
    TOUP:
    begin
      nextHead.j := nextHead.j - 1;
      if nextHead.j < STARTY then
        nextHead.j := STARTY;
    end;
    TORIGHT:
    begin
      nextHead.i := nextHead.i + 1;
      if nextHead.i > ENDX then
        nextHead.i := ENDX;
    end;
    TODOWN:
    begin
      nextHead.j := nextHead.j + 1;
      if nextHead.j > ENDY then
        nextHead.j := ENDY;
    end;
  end;
  if PointEqualPoint(TempFood, nextHead) then
  begin
    AddFoodToSnake(TempFood);
    GenerateFood(TempFood);
    ShowFood(TempFood);
  end
  else if (not MenuSelfPenetrate.Checked) and InSnake(nextHead, Snake) then
  begin
    exit;
  end
  else
  begin
    case flag of
      TOLEFT:
      begin
        if Snake[head].i > STARTX then
        begin
          Snake[head].i := Snake[head].i - 1;
          EraseTail(Snake[tail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := point;
        end;
      end;
      TOUP:
      begin
        if Snake[head].j > STARTY then
        begin
          Snake[head].j := Snake[head].j - 1;
          EraseTail(Snake[tail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := point;
        end;
      end;
      TORIGHT:
      begin
        if Snake[head].i < ENDX then
        begin
          Snake[head].i := Snake[head].i + 1;
          EraseTail(Snake[tail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := point;
        end;
      end;
      TODOWN:
      begin
        if Snake[head].j < ENDY then
        begin
          Snake[head].j := Snake[head].j + 1;
          EraseTail(Snake[tail]);
          for i := Low(Snake) to High(Snake) - 1 do
            Snake[i] := Snake[i + 1];
          Snake[High(Snake) - 1] := point;
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
