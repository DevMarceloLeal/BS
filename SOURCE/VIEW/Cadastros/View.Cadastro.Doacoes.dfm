inherited frmDoacoes: TfrmDoacoes
  Caption = 'frmDoacoes'
  PixelsPerInch = 96
  TextHeight = 15
  inherited pnlCabecalho: TPanel
    inherited lblTitulo: TLabel
      Width = 583
      Height = 38
    end
  end
  inherited pnlTrabalho: TPanel
    inherited pnlJanelaDados: TPanel
      inherited pnlDBGrid: TPanel [0]
      end
      inherited pnlManutencaoDados: TPanel [1]
        object Label3: TLabel [2]
          Left = 12
          Top = 107
          Width = 13
          Height = 15
          Caption = 'ID'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label1: TLabel [3]
          Left = 63
          Top = 107
          Width = 95
          Height = 15
          Caption = 'Nome do Doador'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label2: TLabel [4]
          Left = 274
          Top = 107
          Width = 31
          Height = 15
          Caption = 'Idade'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label5: TLabel [5]
          Left = 325
          Top = 107
          Width = 86
          Height = 15
          Caption = 'Data da Doa'#231#227'o'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label4: TLabel [6]
          Left = 440
          Top = 107
          Width = 28
          Height = 15
          Caption = 'Qtde'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object lblStatusDoacao: TLabel [7]
          Left = 9
          Top = 24
          Width = 256
          Height = 32
          Alignment = taCenter
          AutoSize = False
          Caption = 'Data da Doa'#231#227'o'
          Color = clMaroon
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clSilver
          Font.Height = -24
          Font.Name = 'Segoe UI'
          Font.Style = []
          Font.Quality = fqClearTypeNatural
          ParentColor = False
          ParentFont = False
          Transparent = False
          Layout = tlCenter
          Visible = False
          StyleElements = [seClient, seBorder]
        end
        object edtPES_ID: TEdit
          Left = 9
          Top = 128
          Width = 48
          Height = 23
          Alignment = taRightJustify
          CharCase = ecUpperCase
          TabOrder = 1
          Text = 'EDTPES_NOME'
          OnExit = edtPES_IDExit
        end
        object edtNomeDoador: TEdit
          Left = 63
          Top = 128
          Width = 202
          Height = 23
          TabStop = False
          CharCase = ecUpperCase
          TabOrder = 2
          Text = 'EDTPES_NOME'
        end
        object edtIdadeDoador: TEdit
          Left = 271
          Top = 128
          Width = 48
          Height = 23
          TabStop = False
          Alignment = taRightJustify
          CharCase = ecUpperCase
          ReadOnly = True
          TabOrder = 3
          Text = 'EDTPES_NOME'
        end
        object edtDOA_DATA: TDateTimePicker
          Left = 325
          Top = 128
          Width = 106
          Height = 23
          Date = 44602.000000000000000000
          Time = 0.551163194446417000
          TabOrder = 4
        end
        object edtDOA_QTDE: TEdit
          Left = 437
          Top = 128
          Width = 48
          Height = 23
          Alignment = taRightJustify
          CharCase = ecUpperCase
          TabOrder = 5
          Text = 'EDTPES_NOME'
          OnExit = edtDOA_QTDEExit
        end
      end
    end
  end
  inherited bhFormBase: TBalloonHint
    Left = 435
    Top = 389
  end
  inherited aclFormBase: TActionList
    Left = 324
    Top = 389
  end
  inherited img32: TImageList
    Left = 208
    Top = 382
  end
end
