program LimitIDF;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  uTSingleESRIgrid,
  AVGRIDIO,
  math,
  SysUtils,
  uLimitIDF in 'uLimitIDF.pas' {MainForm};

var
  iResult, i, j: Integer;
  aValue, MinValue, MaxValue, MultFact: Single;

{$R *.res}

Procedure ShowArgumentsAndTerminate;
begin
  ShowMessage('LimitIDF IDFin min max [MultFact] IDFout');
  Application.Terminate;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);

  if not((ParamCount() = 4) or (ParamCount() = 5)) then
    ShowArgumentsAndTerminate;

  MinValue := 0;
  MaxValue := 0;
  MultFact := 1;
  Try
    MinValue := StrToFloat(ParamStr(2));
    MaxValue := StrToFloat(ParamStr(3));
    if ParamCount() = 5 then
      MultFact := StrToFloat(ParamStr(4));
  Except
    ShowArgumentsAndTerminate;
  End;

  if MinValue > MaxValue then
    ShowArgumentsAndTerminate;

  MainForm.IDFin := TSingleESRIgrid.InitialiseFromIDFfile(ParamStr(1), iResult,
    MainForm);

  with MainForm.IDFin do
  begin
    for i := 1 to NRows do
    begin
      for j := 1 to NCols do
      begin
        aValue := GetValue(i, j);
        if (aValue <> MissingSingle) then
        begin
          aValue := aValue * MultFact;
          MainForm.IDFin[i, j] := min(max(aValue, MinValue), MaxValue);
        end; { -if }
      end; { -for j }
    end; { -for i }
    if ParamCount() = 4 then
      ExportToIDFfile(ParamStr(4))
    else
      ExportToIDFfile(ParamStr(5))
  end;
  //ShowMessageFmt('IDF written to file [%s].', [ExpandFileName(ParamStr(4))]);

  // Application.Run;


end.
