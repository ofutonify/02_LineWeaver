unit userscript;

var
  sl: TStringList;
  firstPluginName: string;
  currentDialFormID: string;
  currentDialEDID: string;
  espOrder: integer;

function Initialize: integer;
begin
  sl := TStringList.Create;
  sl.Add('ESP_Order,FormID,EDID,REC,Plugin,Speaker,ParentDIAL,ParentDIAL_EDID');
  firstPluginName := '';
  currentDialFormID := '';
  currentDialEDID := '';
  espOrder := 0;
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
  parentDial, parentDialEDID: string;
begin
  recType := Signature(e);
  edid := GetEDIDSafe(e);

  formID := IntToHex(FixedFormID(e), 8);
  pluginName := GetFileName(GetFile(e));
  speaker := GetSpeakerEditorID(e);

  espOrder := espOrder + 1;

  parentDial := '';
  parentDialEDID := '';

  // DIALレコードを見たら覚えておく。次に来るINFOはこのDIALの子。
  if recType = 'DIAL' then begin
    currentDialFormID := formID;
    currentDialEDID := edid;
  end
  else if recType = 'INFO' then begin
    parentDial := currentDialFormID;
    parentDialEDID := currentDialEDID;
  end;

  if firstPluginName = '' then
    firstPluginName := ChangeFileExt(pluginName, '');

  sl.Add(Format('%d,%s,%s,%s,%s,%s,%s,%s', [espOrder, formID, edid, recType, pluginName, speaker, parentDial, parentDialEDID]));
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
