unit userscript;

var
  sl: TStringList;
  firstPluginName: string;

function Initialize: integer;
begin
  sl := TStringList.Create;
  sl.Add('FormID,EDID,REC,Plugin,Speaker');
  firstPluginName := '';
end;

function GetSpeakerEditorID(e: IInterface): string;
var
  conds, cond, param1Field, param1Rec: IInterface;
  i: integer;
  funcName: string;
begin
  Result := '';
  conds := ElementByPath(e, 'Conditions');
  if not Assigned(conds) then Exit;

  for i := 0 to ElementCount(conds) - 1 do begin
    cond := ElementByIndex(conds, i);
    funcName := GetEditValue(ElementByPath(cond, 'CTDA - CTDA\Function'));
    if funcName = 'GetIsID' then begin
      param1Field := ElementByPath(cond, 'CTDA - CTDA\Parameter #1');
      if Assigned(param1Field) then begin
        param1Rec := LinksTo(param1Field);
        if Assigned(param1Rec) then begin
          Result := GetEditValue(ElementBySignature(param1Rec, 'EDID'));
          Exit;
        end;
      end;
    end;
  end;
end;

function GetEDIDSafe(e: IInterface): string;
var
  edidElem: IInterface;
begin
  Result := '';
  edidElem := ElementBySignature(e, 'EDID');
  if Assigned(edidElem) then
    Result := GetEditValue(edidElem);
end;

function Process(e: IInterface): integer;
var
  formID, edid, recType, pluginName, speaker: string;
begin
  recType := Signature(e);
  edid := GetEDIDSafe(e); // 空欄でも処理する

  formID := IntToHex(FixedFormID(e), 8);
  pluginName := GetFileName(GetFile(e));
  speaker := GetSpeakerEditorID(e);

  if firstPluginName = '' then
    firstPluginName := ChangeFileExt(pluginName, '');

  sl.Add(Format('%s,%s,%s,%s,%s', [formID, edid, recType, pluginName, speaker]));
end;

function Finalize: integer;
var
  outFile: string;
begin
  if firstPluginName <> '' then
    outFile := ProgramPath + '02LW_' + firstPluginName + '.csv'
  else
    outFile := ProgramPath + '02LW_ID.csv';

  sl.SaveToFile(outFile);
  sl.Free;
end;

end.
