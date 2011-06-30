object Form4: TForm4
  Left = 329
  Top = 129
  Width = 143
  Height = 120
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Form4'
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
  object Service: TKOLServiceEx
    formUnit = 'Unit4'
    formMain = False
    ServiceName = 'KOL_ServiceB'
    OnStart = ServiceStart
    OnExecute = ServiceExecute
    OnControl = ServiceControl
    OnStop = ServiceStop
    Data = 0
    AcceptControl = [ACCEPT_STOP, ACCEPT_PAUSE_CONTINUE, ACCEPT_SHUTDOWN]
    OnPause = ServicePause
    OnResume = ServiceResume
    MCKForm = 'Unit2'
    Left = 8
    Top = 8
  end
end
