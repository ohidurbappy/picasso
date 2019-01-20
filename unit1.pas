unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ActnList, StdCtrls, Menus, ComCtrls, Buttons,ImagingTypes,
  Imaging,
  ImagingClasses,
  ImagingComponents,
  ImagingCanvases,
  ImagingBinary,
  ImagingUtility;

type

  TManipulationType = (mtFlip, mtMirror, mtRotate90CW, mtRotate90CCW,mtRotate180CW,
    mtFreeRotate, mtResize50,mtResize150, mtResize200, mtFreeResize,
    mtSwapRB, mtSwapRG, mtSwapGB, mtReduce1024,
    mtReduce256, mtReduce64, mtReduce16, mtReduce2);

  TPointTransform = (ptInvert, ptIncContrast, ptDecContrast, ptIncBrightness,
    ptDecBrightness, ptIncGamma, ptDecGamma, ptThreshold, ptLevelsLow,
    ptLevelsHigh, ptAlphaPreMult, ptAlphaUnPreMult);

  TNonLinearFilter = (nfMedian, nfMin, nfMax);
  TMorphology = (mpErode, mpDilate, mpOpen, mpClose);



  { TMainForm }

  TMainForm = class(TForm)
    Image: TImage;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuContrast: TMenuItem;
    MenuBrightness: TMenuItem;
    MenuItem15: TMenuItem;
    MenuContrastInc: TMenuItem;
    MenuContrastDec: TMenuItem;
    MenuBrightnessInc: TMenuItem;
    MenuBrightnessDec: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem29: TMenuItem;
    MenuRotate90CW: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuSave: TMenuItem;
    MenuGamma: TMenuItem;
    MenuGammaInc: TMenuItem;
    MenuGammaDec: TMenuItem;
    MenuSep: TMenuItem;
    MenuItem39: TMenuItem;
    MenuRotate90CCW: TMenuItem;
    MenuItem40: TMenuItem;
    MenuSaveAs: TMenuItem;
    MenuItem42: TMenuItem;
    MenuRotate180CW: TMenuItem;
    MenuFlipH: TMenuItem;
    MenuFlipV: TMenuItem;
    MenuRotateFree: TMenuItem;
    MenuItem9: TMenuItem;
    MenuZoomIn: TMenuItem;
    MenuZoomOut: TMenuItem;
    MenuFitToWindow: TMenuItem;
    MenuActualSize: TMenuItem;
    MenuFullScreen: TMenuItem;
    MenuResize: TMenuItem;
    MenuCrop: TMenuItem;
    MenuRotate: TMenuItem;
    MenuEdit: TMenuItem;
    MenuAbout: TMenuItem;
    MenuView: TMenuItem;
    MenuTools: TMenuItem;
    MenuHelp: TMenuItem;
    MenuOpen: TMenuItem;
    MenuPrint: TMenuItem;
    MenuClose: TMenuItem;
    MenuExit: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuActualSizeClick(Sender: TObject);
    procedure MenuBrightnessDecClick(Sender: TObject);
    procedure MenuBrightnessIncClick(Sender: TObject);
    procedure MenuFitToWindowClick(Sender: TObject);
    procedure MenuFlipHClick(Sender: TObject);
    procedure MenuFullScreenClick(Sender: TObject);
    procedure MenuGammaIncClick(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuContrastIncClick(Sender: TObject);
    procedure MenuContrastDecClick(Sender: TObject);
    procedure MenuGammaDecClick(Sender: TObject);
    procedure MenuFlipVClick(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuSaveAsClick(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuRotate180CWClick(Sender: TObject);
    procedure MenuRotate90CCWClick(Sender: TObject);
    procedure MenuRotate90CWClick(Sender: TObject);
    procedure MenuRotateFreeClick(Sender: TObject);
    procedure MenuSaveClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuOpenClick(Sender: TObject);
    procedure MenuPrintClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure AutoFit(Sender:TObject);
    procedure MenuZoomInClick(Sender: TObject);
    procedure MenuZoomOutClick(Sender: TObject);

  private
    FBitmap: TImagingBitmap;
    FImage: TMultiImage;
    FImageCanvas: TImagingCanvas;
    FFileName: string;
    FParam1, FParam2, FParam3: Integer;
    CurrentDir:string;   // keep track of the current directory
    CurrentFiles:TStringList; // hold the files in the current directory
    procedure UpdateView;
    procedure UpdateViewOnOpen;
    procedure OpenFile(const FileName:string);
    procedure SaveFile(const FileName: string);
    procedure OpenNextFile;
    procedure OpenPrevFile;
    function CheckCanvasFormat: Boolean;
    function InputInteger(const ACaption, APrompt: string;var Value: Integer):Boolean;
    procedure MeasureTime(const Msg: string; const OldTime: Int64);
    procedure ApplyConvolution(Kernel: Pointer; Size: LongInt; NeedsBlur: Boolean);
    procedure ApplyPointTransform(Transform: TPointTransform);
    procedure ApplyManipulation(ManipType: TManipulationType);
    procedure ApplyNonLinear(FilterType: TNonLinearFilter; FilterSize: Integer);
    procedure ApplyMorphology(MorphOp: TMorphology);
    procedure SelectSubimage(Index: LongInt);
    procedure FreeResizeInput;
  public

  end;

  Const
  startupImage='startup.png';

var
  MainForm: TMainForm;
  ParamArgs:array[0..10] of String; // to store the command line args
  PrevX, PrevY: Integer;
  MouseIsDown: Boolean;
  BitmapX:TBitmap;

implementation
uses
  unit2;


{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  count:Integer;
begin
  { initializing this variables }
  BitmapX:=TBitmap.Create;


  FImage := TMultiImage.Create;
  FBitmap := TImagingBitmap.Create;
  Image.Picture.Graphic := FBitmap;
  FImageCanvas := TImagingCanvas.Create;


  // putting the cmd args
  for  count:=0 to ParamCount do
       ParamArgs[count]:=ParamStr(count);

  // if any file is opened
  if ParamArgs[1] <>'' then

        OpenFile(ParamArgs[1])

  else
       OpenFile(Application.Location+startupImage);

end;


procedure TMainForm.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
begin
  // check for dropped files
  OpenFile(FileNames[0])
end;



procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // handle next and prev key down
   //ShowMessage(IntToStr(key));
   // check for left-arrow(37) and right-arrow(39) key
     if(key=37) then
          OpenPrevFile
     else if (key=39) then
         OpenNextFile;
end;

procedure TMainForm.OpenNextFile;
var
  currentIndex:Integer;

begin
  currentIndex:=CurrentFiles.IndexOf(ExtractFileName(FFileName));
     if(currentIndex<(CurrentFiles.Count-1)) then
         OpenFile(concat(CurrentDir,CurrentFiles[currentIndex+1]));

end;

procedure TMainForm.OpenPrevFile;
var
  currentIndex:Integer;
begin
    currentIndex:=CurrentFiles.IndexOf(ExtractFileName(FFileName));
    if(currentIndex>0) then
         OpenFile(concat(CurrentDir,CurrentFiles[currentIndex-1]));
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
AutoFit(Sender);
end;

procedure TMainForm.MenuAboutClick(Sender: TObject);
begin
  // show about information
AboutForm.ShowModal;
end;

procedure TMainForm.MenuActualSizeClick(Sender: TObject);
begin
  MenuFitToWindow.Checked:=False;
  MenuActualSize.Checked:=True;
  Image.Proportional:=False;
  Image.Stretch:=False;
end;

procedure TMainForm.MenuBrightnessDecClick(Sender: TObject);
begin
   ApplyPointTransform(ptDecBrightness);
end;

procedure TMainForm.MenuBrightnessIncClick(Sender: TObject);
begin
   ApplyPointTransform(ptIncBrightness);
end;

procedure TMainForm.MenuFitToWindowClick(Sender: TObject);
begin
     MenuFitToWindow.Checked:=True;
     MenuActualSize.Checked:=False;
     Image.Proportional:=True;
     Image.Stretch:=True;
end;
procedure TMainForm.MenuFlipHClick(Sender: TObject);
begin
  ApplyManipulation(mtFlip);
end;

procedure TMainForm.MenuFullScreenClick(Sender: TObject);
begin
  // TODO: Fullscreen view
end;

procedure TMainForm.MenuGammaIncClick(Sender: TObject);
begin
  ApplyPointTransform(ptIncGamma);
end;
procedure TMainForm.MenuItem10Click(Sender: TObject);
begin
   FParam1 := Ord(rfNearest);
  ApplyManipulation(mtResize200);
end;

procedure TMainForm.MenuItem11Click(Sender: TObject);
begin
    FParam1 := Ord(rfNearest);
    FreeResizeInput;
end;

procedure TMainForm.MenuItem12Click(Sender: TObject);
begin
   FParam1 := Ord(rfNearest);
  ApplyManipulation(mtResize150);
end;
procedure TMainForm.MenuContrastIncClick(Sender: TObject);
begin
   ApplyPointTransform(ptIncContrast);
end;

procedure TMainForm.MenuContrastDecClick(Sender: TObject);
begin
  ApplyPointTransform(ptDecContrast);
end;

procedure TMainForm.MenuGammaDecClick(Sender: TObject);
begin
  ApplyPointTransform(ptDecGamma);
end;

procedure TMainForm.MenuFlipVClick(Sender: TObject);
begin
  ApplyManipulation(mtMirror);
end;

procedure TMainForm.MenuItem21Click(Sender: TObject);
begin
  // sharpen filter
  ApplyConvolution(@FilterSharpen3x3, 3, False);
end;

procedure TMainForm.MenuItem22Click(Sender: TObject);
begin
  // emboss filter
   ApplyConvolution(@FilterEmboss3x3, 3, True);
end;

procedure TMainForm.MenuItem23Click(Sender: TObject);
begin
  // glow filter
  ApplyConvolution(@FilterGlow5x5, 5, False);
end;

procedure TMainForm.MenuItem24Click(Sender: TObject);
begin
  // filter edge enhance
  ApplyConvolution(@FilterEdgeEnhance3x3, 3, False);
end;

procedure TMainForm.MenuItem25Click(Sender: TObject);
begin
  // gaussian blur
  ApplyConvolution(@FilterGaussian3x3, 3, False);
end;

procedure TMainForm.MenuItem26Click(Sender: TObject);
begin
  // gaussian blur more
  ApplyConvolution(@FilterGaussian5x5, 5, False);
end;
procedure TMainForm.MenuItem29Click(Sender: TObject);
begin
  // invert the color
  ApplyPointTransform(ptInvert);
end;

procedure TMainForm.MenuItem30Click(Sender: TObject);
begin
  // thresholding
  ApplyPointTransform(ptThreshold);
end;

procedure TMainForm.MenuItem32Click(Sender: TObject);
begin
  // level low
   ApplyPointTransform(ptLevelsLow);
end;

procedure TMainForm.MenuItem33Click(Sender: TObject);
begin
  // level high
   ApplyPointTransform(ptLevelsHigh);
end;

procedure TMainForm.MenuItem40Click(Sender: TObject);
begin

end;

procedure TMainForm.MenuSaveAsClick(Sender: TObject);
begin
     SaveDialog.Filter := GetImageFileFormatsFilter(False);
  SaveDialog.FileName := ChangeFileExt(ExtractFileName(FFileName), '');
  SaveDialog.FilterIndex := GetFileNameFilterIndex(FFileName, False);
  if SaveDialog.Execute then
  begin
    FFileName := ChangeFileExt(SaveDialog.FileName, '.' + GetFilterIndexExtension(SaveDialog.FilterIndex, False));
    SaveFile(FFileName);
  end;
end;

procedure TMainForm.MenuItem9Click(Sender: TObject);
begin
   FParam1 := Ord(rfNearest);
  ApplyManipulation(mtResize50);
end;

procedure TMainForm.MenuRotate180CWClick(Sender: TObject);
begin
  ApplyManipulation(mtRotate180CW);
end;

procedure TMainForm.MenuRotate90CCWClick(Sender: TObject);
begin
  ApplyManipulation(mtRotate90CCW);
end;

procedure TMainForm.MenuRotate90CWClick(Sender: TObject);
begin
  ApplyManipulation(mtRotate90CW);
end;

procedure TMainForm.MenuRotateFreeClick(Sender: TObject);
begin
  if InputInteger('Free Rotate', 'Enter angle in degrees:', FParam1) then
    ApplyManipulation(mtFreeRotate);
end;

procedure TMainForm.MenuSaveClick(Sender: TObject);
begin
  if FFileName <> '' then
  begin
    case MessageDlg('File Exists','Do you want to replace?',mtConfirmation,mbYesNo,0) of
      mrYes:SaveFile(FFileName);
    end;
  end;

end;


function TMainForm.InputInteger(const ACaption, APrompt: string;
  var Value: Integer): Boolean;
var
  StrVal: string;
begin
  Result := False;
  if Dialogs.InputQuery(ACaption, APrompt, StrVal) then
  begin
    if TryStrToInt(StrVal, Value) then
      Exit(True)
    else
      MessageDlg('Cannot convert input to number', mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
  // show image information
  MessageDlg(ImageToStr(FImage.ImageDataPointer^), mtInformation, [mbOK], 0);
end;


// File > Open
procedure TMainForm.MenuOpenClick(Sender: TObject);
begin
     OpenDialog.Filter := GetImageFileFormatsFilter(True);
  if OpenDialog.Execute then
    OpenFile(OpenDialog.FileName);
end;


procedure TMainForm.OpenFile(const FileName: string);
var
  T: Int64;
begin
  FFileName := FileName;

  try
    T := GetTimeMicroseconds;
    FImage.LoadMultiFromFile(FileName);
    MeasureTime(Format('File %s opened in:', [ExtractFileName(FileName)]), T);
  except
    MessageDlg(GetExceptObject.Message, mtError, [mbOK], 0);
    FImage.CreateFromParams(32, 32, ifA8R8G8B8, 1);
  end;

  // select the first subimage and update the view
  FImage.ActiveImage := 0;
  UpdateViewOnOpen;

  // get the directory from the filename
  if CompareText(ExtractFilePath(FileName),CurrentDir)<>0 then
  begin
    try
     //store the current directory
     CurrentDir:=ExtractFilePath(FileName);
     // update the list of current files

     CurrentFiles:=FindAllFiles(CurrentDir,'*.png;*.xpm;*.bmp;*.jpeg;*.jpg;*.jpe;*.jfif;*.tif;*.tiff;*.gif;*.pbm;*.pgm;*.ppm',False);
     CurrentFiles.Sorted:=False;

     for T:=0 to CurrentFiles.Count-1 do
          begin
          CurrentFiles[T]:=ExtractFileName(CurrentFiles[T]);
          end;

     CurrentFiles.Sort;
    finally
   //ShowMessage('Total Files:'+IntToStr(CurrentFiles.Count)+LineEnding+'Current File Index:'+IntToStr(CurrentFiles.IndexOf(ExtractFileName(Filename)))+LineEnding+CurrentFiles[CurrentFiles.IndexOf(ExtractFileName(FileName))]);

    end;
  end;
end;

 procedure TMainForm.SaveFile(const FileName: string);
var
  T: Int64;
begin
  try
    T := GetTimeMicroseconds;
    FImage.SaveMultiToFile(FileName);
    MeasureTime(Format('File %s saved in:', [ExtractFileName(FileName)]), T);
  except
    MessageDlg(GetExceptObject.Message, mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.AutoFit(Sender:TObject);
begin
        // place the image at the center
        Image.Top:=MainForm.ClientHeight div 2-Image.Height div 2;
        Image.Left:=MainForm.ClientWidth div 2 - Image.Width div 2;
end;

procedure TMainForm.MenuZoomInClick(Sender: TObject);
begin
  // TODO: Zoom in
end;

procedure TMainForm.MenuZoomOutClick(Sender: TObject);
begin
  // TODO: zoom out
end;

// resize a given image
procedure ShrinkBitmap(Bitmap:TBitmap;const NewWidth,NewHeight:Integer);
begin
Bitmap.Canvas.StretchDraw(Rect(0,0,NewWidth,NewHeight),Bitmap);
Bitmap.SetSize(NewWidth,NewHeight);
end;

procedure TMainForm.MenuPrintClick(Sender: TObject);
begin
  // TODO: print command
end;

// File > Close
procedure TMainForm.MenuCloseClick(Sender: TObject);
begin
     OpenFile('startup.png');
end;

procedure TMainForm.MenuExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

// image manipulation procedure
function TMainForm.CheckCanvasFormat: Boolean;
begin
  Result := FImage.Format in FImageCanvas.GetSupportedFormats;
  if not Result then
    //MessageDlg('Image is in format that is not supported by TImagingCanvas.', mtError, [mbOK], 0);
    MessageDlg('Invalid Image Format', mtError, [mbOK], 0);
end;


procedure TMainForm.ApplyConvolution(Kernel: Pointer; Size: LongInt; NeedsBlur: Boolean);
var
  T: Int64;
begin
  if CheckCanvasFormat then
  begin
    FImageCanvas.CreateForImage(FImage);
    T := GetTimeMicroseconds;

    if NeedsBlur then
      FImageCanvas.ApplyConvolution3x3(FilterGaussian3x3);
    if Size = 3 then
      FImageCanvas.ApplyConvolution3x3(TConvolutionFilter3x3(Kernel^))
    else
      FImageCanvas.ApplyConvolution5x5(TConvolutionFilter5x5(Kernel^));

    MeasureTime('Transformation done in:', T);
    UpdateView;
  end;
end;

procedure TMainForm.ApplyPointTransform(Transform: TPointTransform);
var
  T: Int64;
begin
  if CheckCanvasFormat then
  begin
    FImageCanvas.CreateForImage(FImage);
    T := GetTimeMicroseconds;

    case Transform of
      ptInvert:         FImageCanvas.InvertColors;
      ptIncContrast:    FImageCanvas.ModifyContrastBrightness(20, 0);
      ptDecContrast:    FImageCanvas.ModifyContrastBrightness(-20, 0);
      ptIncBrightness:  FImageCanvas.ModifyContrastBrightness(0, 20);
      ptDecBrightness:  FImageCanvas.ModifyContrastBrightness(0, -20);
      ptIncGamma:       FImageCanvas.GammaCorection(1.2, 1.2, 1.2);
      ptDecGamma:       FImageCanvas.GammaCorection(0.8, 0.8, 0.8);
      ptThreshold:      FImageCanvas.Threshold(0.5, 0.5, 0.5);
      ptLevelsLow:      FImageCanvas.AdjustColorLevels(0.0, 0.5, 1.0);
      ptLevelsHigh:     FImageCanvas.AdjustColorLevels(0.35, 1.0, 0.9);
      ptAlphaPreMult:   FImageCanvas.PremultiplyAlpha;
      ptAlphaUnPreMult: FImageCanvas.UnPremultiplyAlpha;
    end;

    MeasureTime('Transformation done in:', T);
    UpdateView;
  end;
end;

procedure TMainForm.ApplyNonLinear(FilterType: TNonLinearFilter; FilterSize: Integer);
var
  T: Int64;
begin
  if CheckCanvasFormat then
  begin
    FImageCanvas.CreateForImage(FImage);
    T := GetTimeMicroseconds;

    case FilterType of
      nfMedian: FImageCanvas.ApplyMedianFilter(FilterSize);
      nfMin:    FImageCanvas.ApplyMinFilter(FilterSize);
      nfMax:    FImageCanvas.ApplyMaxFilter(FilterSize);
    end;

    MeasureTime('Converted In :', T);
    UpdateView;
  end;
end;

procedure TMainForm.ApplyMorphology(MorphOp: TMorphology);
var
  T: Int64;
  Strel: TStructElement;
begin
  T := GetTimeMicroseconds;
  OtsuThresholding(FImage.ImageDataPointer^);

  SetLength(Strel, 3, 3);
  Strel[0, 0] := 0;
  Strel[1, 0] := 1;
  Strel[2, 0] := 0;
  Strel[0, 1] := 1;
  Strel[1, 1] := 1;
  Strel[2, 1] := 1;
  Strel[0, 2] := 0;
  Strel[1, 2] := 1;
  Strel[2, 2] := 0;

  case MorphOp of
    mpErode:   Morphology(FImage.ImageDataPointer^, Strel, moErode);
    mpDilate:  Morphology(FImage.ImageDataPointer^, Strel, moDilate);
    mpOpen:
      begin
        Morphology(FImage.ImageDataPointer^, Strel, moErode);
        Morphology(FImage.ImageDataPointer^, Strel, moDilate);
      end;
    mpClose:
      begin
        Morphology(FImage.ImageDataPointer^, Strel, moDilate);
        Morphology(FImage.ImageDataPointer^, Strel, moErode);
      end;
  end;
  MeasureTime('Morphology operation applied in:', T);
  UpdateView;
end;

procedure TMainForm.ApplyManipulation(ManipType: TManipulationType);
var
  T: Int64;
begin
  T := GetTimeMicroseconds;
  case ManipType of
    mtFlip:             FImage.Flip;
    mtMirror:           FImage.Mirror;
    mtRotate90CW:       FImage.Rotate(-90);
    mtRotate90CCW:      FImage.Rotate(90);
    mtRotate180CW:      FImage.Rotate(-180);
    mtFreeRotate:       FImage.Rotate(FParam1);
    mtResize50:         FImage.Resize(FImage.Width div 2, FImage.Height div 2, TResizeFilter(FParam1));
    mtResize150:        FImage.Resize(FImage.Width div 2 * 3,FImage.Height div 2 * 3,TResizeFilter(FParam1));
    mtResize200:        FImage.Resize(FImage.Width * 2, FImage.Height * 2, TResizeFilter(FParam1));
    mtFreeResize:       FImage.Resize(FParam2, FParam3, TResizeFilter(FParam1));
    mtSwapRB:           FImage.SwapChannels(ChannelRed, ChannelBlue);
    mtSwapRG:           FImage.SwapChannels(ChannelRed, ChannelGreen);
    mtSwapGB:           FImage.SwapChannels(ChannelGreen, ChannelBlue);
    mtReduce1024:       ReduceColors(FImage.ImageDataPointer^, 1024);
    mtReduce256:        ReduceColors(FImage.ImageDataPointer^, 256);
    mtReduce64:         ReduceColors(FImage.ImageDataPointer^, 64);
    mtReduce16:         ReduceColors(FImage.ImageDataPointer^, 16);
    mtReduce2:          ReduceColors(FImage.ImageDataPointer^, 2);
  end;
  MeasureTime('Image manipulated in:', T);
  UpdateView;
end;

procedure TMainForm.SelectSubimage(Index: LongInt);
begin
  FImage.ActiveImage := Index;
  UpdateView;
end;

procedure TMainForm.UpdateView;
begin
  Image.Picture.Graphic.Assign(FImage);
end;
procedure TMainForm.UpdateViewOnOpen;
var
  FormHeight:Integer;
  FormWidth:Integer;
  ImageWidth:Integer;
  ImageHeight:Integer;

begin
  Image.Picture.Graphic.Assign(FImage);

  // get image dimension
  ImageWidth:=Image.Picture.Width;
  ImageHeight:=Image.Picture.Height;

  // get the form dimension
  FormWidth:=MainForm.ClientWidth;
  FormHeight:=MainForm.ClientHeight;

  // if the viewport is bigger than the image then put the image control in actual size of the image
  // or else use autofit
    if(FormWidth>ImageWidth) and (FormHeight>ImageHeight) then
    MenuActualSizeClick(self)
    else
    MenuFitToWindowClick(self);
end;

procedure TMainForm.FreeResizeInput;
begin
  if InputInteger('Free Resize', 'Enter width in pixels', FParam2) and
   InputInteger('Free Resize', 'Enter height in pixels', FParam3) then
  begin
    ApplyManipulation(mtFreeResize);
  end;
end;

procedure TMainForm.MeasureTime(const Msg: string; const OldTime: Int64);
begin
  StatusBar.SimpleText := Format('  %s %.0n ms', [Msg, (GetTimeMicroseconds - OldTime) / 1000.0]);
end;
end.

