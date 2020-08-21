object FormMain: TFormMain
  Left = 186
  Top = 161
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #36138#21507#34503' '#65293' RICOL'
  ClientHeight = 316
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 452
    Height = 316
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object PaintBoxMain: TPaintBox
      Left = 1
      Top = 1
      Width = 450
      Height = 314
      Align = alClient
      OnPaint = PaintBoxMainPaint
      ExplicitHeight = 306
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object MenuGame: TMenuItem
      Caption = #28216#25103
      object MenuGameStart: TMenuItem
        Caption = #24320#22987
        OnClick = MenuGameStartClick
      end
      object MenuGameEnd: TMenuItem
        Caption = #32467#26463
        OnClick = MenuGameEndClick
      end
      object MenuGameSeperator: TMenuItem
        Caption = '-'
      end
      object MenuGameQuit: TMenuItem
        Caption = #36864#20986
        OnClick = MenuGameQuitClick
      end
    end
    object MenuConfig: TMenuItem
      Caption = #35774#32622
      object MenuConfigDifficulty: TMenuItem
        Caption = #38590#24230
        object MenuPrimary: TMenuItem
          AutoCheck = True
          AutoHotkeys = maAutomatic
          Caption = #21021#32423
          Checked = True
          RadioItem = True
          OnClick = MenuPrimaryClick
        end
        object MenuMedium: TMenuItem
          AutoCheck = True
          AutoHotkeys = maAutomatic
          Caption = #20013#32423
          RadioItem = True
          OnClick = MenuMediumClick
        end
        object MenuAdvance: TMenuItem
          AutoCheck = True
          AutoHotkeys = maAutomatic
          Caption = #39640#32423
          RadioItem = True
          OnClick = MenuAdvanceClick
        end
        object MenuSpecial: TMenuItem
          AutoCheck = True
          AutoHotkeys = maAutomatic
          Caption = #29305#32423
          RadioItem = True
          OnClick = MenuSpecialClick
        end
      end
      object MenuConfigAdvance: TMenuItem
        Caption = #39640#32423
        object MenuSelfPenetrate: TMenuItem
          Caption = #33258#36523#31359#36879
          OnClick = MenuSelfPenetrateClick
        end
      end
    end
    object MenuHelp: TMenuItem
      Caption = #24110#21161
      object MenuHelpAbout: TMenuItem
        Caption = #20851#20110
        OnClick = MenuHelpAboutClick
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 150
    OnTimer = Timer1Timer
    Left = 56
    Top = 8
  end
end
