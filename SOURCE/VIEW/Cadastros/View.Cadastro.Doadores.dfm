inherited frmDoadores: TfrmDoadores
  Caption = 'frmDoadores'
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
        inherited dbgCadastro: TDBGrid
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        end
      end
      inherited pnlManutencaoDados: TPanel [1]
        object Label1: TLabel [2]
          Left = 12
          Top = 170
          Width = 38
          Height = 15
          Caption = 'Celular'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label2: TLabel [3]
          Left = 136
          Top = 171
          Width = 34
          Height = 15
          Caption = 'E-Mail'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label3: TLabel [4]
          Left = 12
          Top = 107
          Width = 34
          Height = 15
          Caption = 'Nome'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label4: TLabel [5]
          Left = 303
          Top = 107
          Width = 20
          Height = 15
          Caption = 'CPF'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label5: TLabel [6]
          Left = 405
          Top = 107
          Width = 95
          Height = 15
          Caption = 'Data Nascimento'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        object Label6: TLabel [7]
          Left = 517
          Top = 107
          Width = 54
          Height = 15
          Caption = 'Tipo Sang'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          Font.Quality = fqClearTypeNatural
          ParentFont = False
        end
        inherited Panel1: TPanel
          TabOrder = 6
        end
        object edtPES_NOME: TEdit
          Left = 9
          Top = 128
          Width = 288
          Height = 23
          CharCase = ecUpperCase
          TabOrder = 0
          Text = 'EDTPES_NOME'
        end
        object edtPES_DATANASC: TDateTimePicker
          Left = 405
          Top = 128
          Width = 106
          Height = 23
          Date = 44602.000000000000000000
          Time = 0.551163194446417000
          TabOrder = 2
        end
        object edtPES_CPF: TEdit
          Left = 302
          Top = 128
          Width = 98
          Height = 23
          TabOrder = 1
          Text = '021.753.617-48'
        end
        object edtPES_TIPOSANG: TComboBox
          Left = 516
          Top = 128
          Width = 55
          Height = 23
          ItemIndex = 0
          TabOrder = 3
          Text = 'A+'
          Items.Strings = (
            'A+'
            'B+'
            'AB+'
            'O+'
            'A-'
            'B-'
            'AB-'
            'O-')
        end
        object edtPES_CELULAR: TEdit
          Left = 9
          Top = 189
          Width = 121
          Height = 23
          TabOrder = 4
          Text = '021.753.617-48'
        end
        object edtPES_EMAIL: TEdit
          Left = 136
          Top = 189
          Width = 435
          Height = 23
          CharCase = ecLowerCase
          TabOrder = 5
          Text = '\'
        end
      end
    end
  end
  inherited bhFormBase: TBalloonHint
    Left = 187
    Top = 53
  end
  inherited aclFormBase: TActionList
    Left = 100
    Top = 53
  end
  inherited img32: TImageList
    Left = 24
    Top = 54
  end
end
