unit unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, Buttons;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private

  public

  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

{ TAboutForm }

procedure TAboutForm.Label1Click(Sender: TObject);
begin

end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Label2.Caption:='Every child is an artist. The problem is how to remain an artist once we grow up.'+
  LineEnding+'-Pablo Picasso.'+LineEnding;

  Image1.Picture.LoadFromFile(Application.Location+'graphics\Logo-2.png');

  Label2.Caption:=Label2.Caption+'Picasso is a photo viewer application designed to work fast on windows PC' +   LineEnding+ 'with a very minimalistic design. It is an opensource project on github'+LineEnding+
  'http://github.com/ohidurbappy/picasso'+LineEnding+
  'http://www.facebook.com/ohidurbappy';



  end;

procedure TAboutForm.Image1Click(Sender: TObject);
begin

end;

procedure TAboutForm.Label2Click(Sender: TObject);
begin

end;

procedure TAboutForm.Label3Click(Sender: TObject);
begin
  end;

end.

