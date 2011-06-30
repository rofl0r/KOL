object Form3: TForm3
  Left = 192
  Top = 128
  Width = 159
  Height = 134
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Form3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 16
  object KOLProj: TKOLProject
    Locked = False
    Localizy = False
    projectName = 'TestKOLService'
    projectDest = 'TestKOLService'
    sourcePath = 'G:\KIN\PAS\TestKOLServiceN\'
    outdcuPath = 'G:\KIN\PAS\TestKOLServiceN\'
    dprResource = False
    protectFiles = True
    showReport = False
    isKOLProject = True
    autoBuild = True
    autoBuildDelay = 500
    BUILD = False
    consoleOut = False
    SupportAnsiMnemonics = 0
    PaintType = ptWYSIWIG
    ShowHint = False
    Left = 8
    Top = 8
  end
  object Service: TKOLServiceEx
    formUnit = 'Unit3'
    formMain = True
    ServiceName = 'KOL_ServiceA'
    OnStart = ServiceStart
    OnExecute = ServiceExecute
    OnControl = ServiceControl
    OnStop = ServiceStop
    Data = 0
    AcceptControl = [ACCEPT_STOP, ACCEPT_PAUSE_CONTINUE, ACCEPT_SHUTDOWN]
    OnPause = ServicePause
    OnResume = ServiceResume
    OnShutdown = ServiceShutdown
    MCKForm = 'Unit1'
    Left = 48
    Top = 8
  end
end
