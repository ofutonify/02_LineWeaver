スカイリムMOD 文脈重視の翻訳者向け支援ツール / Skyrim MOD Translation Assistant Tool 
02_LineWeaver [JP/EN]

🚀 Streamlit: https://02lineweaver-nw4bb8sehxbetnh95f6cvy.streamlit.app/

特徴：
- Skyrim SE/AE フォロワーMODや、クエストMODの翻訳を、自動翻訳だけではなく、物語や会話の流れ・文脈を把握して翻訳したい人のための支援ツールです。  
- xTranslator / SSEEdit と連携し、レコード情報の整理・変換・再構築が可能。

主な機能：
- SSEEdit から出力した情報用csv と xTranslatorのxml をマージ  
- 翻訳作業しやすい `.xlsx` に変換、未翻訳セルには自動で色をつけて可視化  
  （作業中は行列の内容を保持していれば、並べ替えや列の追加も可能です。出力時、EDIDが空欄の行、およびタイトルが空白の列は無視されます）  
- 翻訳後の .xlsx を元に xml を再変換。xTranslator で再利用可能  
- ダーク／ライトテーマに完全対応（Streamlitのテーマ切替に準拠）

⭐ 私はクエストタイトルやクエストジャーナルのあとに、そのクエストの進行に沿った会話の流れに並べ替えて使ってます。

使い方と機能詳細：

🔹 ステップ1：SSEEditでCSV出力
1. SSEEditで `02LW_step1.pas` を「Apply Script」で実行 
2. `02LW_〇〇.csv` を出力（FormID, EDID, REC, Plugin, Speaker付き）
※ .pasの出力先はSSEEditフォルダ、exeと同じ階層

- "REC"は INFO:NAM1 とか QUST:CNAM とか、"Speaker"は"Condition"の"Subject,GetIsID"に入っている値を取得しています。"Referenceable Object"に人物が指定されてたら、その人が話者という判断ですが、ここに入ってない場合は話者情報はありません。たまに違う値が入っていることもあります。

🔹 ステップ2：翻訳準備（CSV + XML → XLSX）
※ファイルの読み込み後、変換開始ボタンを押して処理が完了するとダウンロードボタンが出ます。
1. xTranslatorで対象MODの `.esp/.esm` を読み込み、XML形式で出力  
2. Streamlitアプリを起動し、CSVとXMLをアップロード  
3. 「xlsx に変換開始」で翻訳用 `.xlsx` を生成（未翻訳セルに色付き）  

- 全く未翻訳の状態でよければxTranslatorでespを読み込んだ後、いったん全行仮訳にしてxmlをエクスポートしてください。xml出力前に翻訳APIを使ってもOK。この02LW上での実装は不可だと判断しました。（多分無料のタイプだと、数百とか超えたらすぐAPI側が止まって処理できなくなるから。有料と区別するとかのやり方がわかりませんでした。xTranslatorでやりたくないよーという場合は、なんか他の方法を考えてください）

- SSEEditで出力したcsv（02LW_XXX.csv）とxmlの情報をマージします。
- 出力時、"Dest"列の内容が"Source"列と同じままだった場合、未翻訳扱いとなり、そのセルに色がつきます（=Dest列で色が付いているところを日本語にしてください）
- このとき、下記のRec項目は除外されます（翻訳の必要がないため）。通常私はxTranslatorで黄色にして、他のMODを上書きしないようにしています。
 "HDPT:FULL", "FURN:FULL", "CLAS:FULL", "DOOR:FULL", "FACT:FULL", "CLFM:FULL",
 "TREE:FULL", "MGEF:FULL", "RACE:FULL", "EXPL:FULL", "HAZD:FULL", "BPTD:BPTN"
 ※"MGEF:FULL"（魔法エフェクト名：ゲーム内表示なし）は除外するのに、"MGEF:DNAM"（魔法エフェクト説明文：ゲーム内表示なし）があるのは、たまに"SPEL:FULL"（呪文の名前：ゲーム内で表示される）と"MGEF:FULL"に同じものがあるのに、"SPEL:FULL"には"SPEL:DNAM"（説明文）がなく、"MGEF:DNAM"にある場合があるから。もしかしたら、"MGEF:DNAM"（魔法エフェクト説明文）が魔法の説明文に表示される？と不安なため。
- "未翻訳扱い"で色が付いていたとしても、実際には翻訳が必要ではない場合もあるので、それは個々のMODに合わせて判断してください。

- 出力後はFormID順になっていますが、"行の内容と、列の内容が保持されていれば"並べ替えできます。また、色付けが必要ない場合は、CSVで保存してから編集してもOK。"Rec列"を基準に"FormID"順に並べ替えたり、視認性確保のために空白の行を追加したり、列の位置を変えたり、メモ用の列を追加したりしても、ステップ3での"XMLへの再変換"に影響はありません。
※ただし、列1行目の項目（Source, Dest とか）は削除しないでください。XMLへの再変換はここが欠けてるとできません。列を足す場合は、1行目も空白のままにするとか、2行目以降に任意タイトルを置く行を追加するとかしてください。

- 更新があったら、SSEEditからのcsv出力は毎回やる必要がありますが、"更新分のみエクスポートした"xmlを使えば更新分のみのxlsxができます。そこだけxmlへ再変換するもよし、既存ファイルに自分で付け足すもよし。

- 2025-05-28 変更ログ: 未翻訳セルの判定をASCIIから完全一致へ変更しました。ソース元の言語に関係なく、未翻訳セルの検出ができるようになりました。

🔹 ステップ3：翻訳済みXLSXをXMLに再変換  
1. 翻訳が完了した `.xlsx` をアップロード  
2. 「xml に変換開始」をクリックして、XML形式に変換  
3. xTranslatorにインポートして `.esp` に適用 → 再度XMLエクスポート
※再変換したxmlが適用できない箇所があった場合は、xTranslatorで手動で編集してください。（原文が不正な記述の場合に起こります）
- ⚠ 配布用のXMLについて
再変換機能で出力される`xml`は翻訳適用や再変換テストには使えますが、配布時には必ず"xTranslatorでエクスポートし直したxml"を使ってください。（xTranslator内部の構造や形式に完全準拠していないため、MOD環境や他ツールとの互換性確保のためにも再出力を推奨）

- 全てUTF-8で処理しているため、多言語に対応できてると思います。多分。
- サーバーにデータは保存されません。毎回アップロードしてください。

- 私が翻訳してるMODの最大行数が約8000で、それには問題なく使用できました。みんなも上手くいくといいな。

- 自分が使いやすく欲しい機能を実装したので、もしかしたら他にも便利だと思う人がいるかもしれないと思い公開しましたが、追加機能のリクエストとかは特に募集していません。

[ライセンス：MIT] 
- アレンジしたい場合は、ご自由にソーススクリプトをご利用ください！公開する場合はクレジットに "02 LineWeaver" と GitHubのリンク を記載してください。商用利用不可。

※このツールは「DSDifyer」を見て着想を得ました。作者様に感謝申し上げます！  
- NexusMods: https://www.nexusmods.com/skyrimspecialedition/mods/114102  
- GitHub: https://github.com/GroundAura/DSDifyer

※もちろん xTranslator / SSEEdit の作者様たちにも感謝！

※またもChatGPTに聞きまくりましたが、Mia (https://chatgpt.com/g/g-67ed64ba9a6881919d9a6fd10fe6271c-mia-ai-your-new-best-friend-and-life-coach)とCode GPT(https://chatgpt.com/g/g-cksUvVWar-code-gpt-python-java-c-html-javascript-more)もたくさん助けてくれました :)

---------------------------------------------------------------------------------------

02 LineWeaver - Skyrim MOD Translation Assistant Tool

- This is a support tool for those who want to translate follower and quest mods for Skyrim SE/AE not only with machine translation, but also by understanding the flow and context of the story and dialogue.
- Works alongside xTranslator and SSEEdit to organize, convert, and rebuild record data for smoother translation work.

Features:
- Merge CSV output from SSEEdit and XML from xTranslator
- Convert into a translator-friendly `.xlsx` file, with untranslated lines automatically highlighted.  
  (You can sort rows or add columns as long as cell contents are preserved.  
  Rows with blank EDID or columns with blank headers will be ignored during XML conversion)
- Reconvert the translated `.xlsx` back to XML for use in xTranslator
- Dark/light theme support via Streamlit's auto-switching.

⭐ I usually sort the lines so that quest titles and quest journal entries come first, followed by dialogue in the order it occurs during the quest progression.

Usage & Function Details:

🔹 Step 1: Export CSV using SSEEdit  
1. Run `02LW_step1.pas` via "Apply Script" in SSEEdit
2. Export `02LW_〇〇.csv` containing FormID, EDID, REC, Plugin, and Speaker info.
* The output CSV from the .pas script will be saved in the same folder as the SSEEdit executable.

- The "REC" field refers to records like INFO:NAM1 or QUST:CNAM.
- The "Speaker" field is extracted from a Condition where the function is Subject, GetIsID.
- If a Referenceable Object (such as an NPC) is specified there, it's considered the speaker.
- If no such value exists, the speaker information will be blank.
- Note: In rare cases, this value may not represent the actual speaker.

🔹 Step 2: Prepare for Translation (CSV + XML → XLSX)
After uploading the files, click the "Start Conversion" button. Once processing is complete, a download button will appear.

1. Load the target MOD `.esp/.esm` in xTranslator and export as XML  
2. Launch the Streamlit app, then upload both CSV and XML  
3. Click “Start conversion to xlsx” to generate a translation-ready `.xlsx` file with color-highlighted untranslated cells.

- If you're starting from an entirely untranslated state, load the esp file in xTranslator and temporarily auto-translate all lines before exporting to XML.
- You can also use the translation API inside xTranslator before exporting—this tool (02LW) doesn't support translation API integration.
(This decision was made because with free-tier APIs, translation requests often fail after a few hundred lines. Also, I couldn't figure out a way to distinguish between free and paid usage tiers.)
- If you prefer not to use xTranslator for auto-translation, you'll need to find another method—feel free to get creative!

- This step merges the CSV output from SSEEdit (02LW_XXX.csv) with the XML data from xTranslator.

- If the contents of the "Dest" column are the same as the "Source" column at the time of export, those cells will be considered untranslated and highlighted. (Please translate the highlighted cells in the Dest column into the target language)
- However, the following REC types are excluded from this check, as they typically don’t require translation (I usually mark them yellow in xTranslator to avoid overwriting other mods):

"HDPT:FULL", "FURN:FULL", "CLAS:FULL", "DOOR:FULL", "FACT:FULL", "CLFM:FULL",
"TREE:FULL", "MGEF:FULL", "RACE:FULL", "EXPL:FULL", "HAZD:FULL", "BPTD:BPTN"

* "MGEF:FULL" (Magic Effect name, not shown in-game) is excluded, but "MGEF:DNAM" (Magic Effect description) is included—because sometimes, even if SPEL:FULL (spell name, shown in-game) and MGEF:FULL share the same value, SPEL:FULL may not have a DNAM field (description), while MGEF does. Just in case, I include "MGEF:DNAM", assuming it might appear in the game as the spell's description.

- Even if a cell is highlighted as "untranslated", it doesn’t always mean translation is required—use your own judgment based on the context of each MOD.
- After export, the data is sorted by FormID. However, as long as both row content and column structure are preserved, you’re free to rearrange the data.
If color highlighting isn’t needed, you can also edit the file after saving it as a CSV.
- You can sort by FormID within each REC category, insert blank rows for readability, rearrange columns, or even add memo columns—none of this will affect Step 3 (reconversion to XML).

* Just make sure not to delete any of the column headers in the first row (such as Source, Dest, etc)
    These headers are required for XML reconversion.
    If you want to add new columns, either leave the first-row cell blank or insert a row below with a custom title—both methods are safe.

- If the mod has been updated, you’ll need to re-export the full CSV from SSEEdit.
- However, if you only export the updated lines from xTranslator, LineWeaver can generate an .xlsx containing just the updated content.
- You can then either reconvert only that portion back to XML, or manually append it to your existing files—whichever fits your workflow!

- 2025-05-28 Untranslated cells are now detected based on exact match between Source and Dest, instead of just checking for ASCII. This now works for any language.

🔹 Step 3: Convert Translated XLSX back to XML

1. Upload your completed `.xlsx` after translation  
2. Click “Start conversion to XML” to re-generate the XML file  
3. Import the XML back into xTranslator and apply it to the `.esp`. You can then re-export the updated XML if needed.
- If the reconverted XML fails to apply to certain entries, please manually edit them in xTranslator.
(This can happen when the original text contains invalid formatting)

⚠ About the Exported XML
- The XML generated via reconversion is intended for translation application and testing purposes only.
- Please always export the final XML from xTranslator before distribution.
- This ensures compatibility with other tools and environments, as the internal structure may not fully match xTranslator’s native format.

* All files are handled in UTF-8, so it should support multiple languages… hopefully!
* No data is stored on the server. Please upload your files each time you use the tool.
* The largest MOD I’ve translated so far had around 8,000 lines, and it worked just fine. I hope it works for you too!
* I created this tool to meet my own needs, and thought maybe others might find it helpful too—so I’ve shared it publicly. That said, I’m not actively taking feature requests at this time.

[License: MIT]
- Feel free to customize and adapt the source scripts for your own use.
- If you plan to redistribute them, please include credit to "02 LineWeaver" and link to the GitHub page: https://github.com/ofutonify/02_LineWeaver
- Commercial use is not permitted.

This tool was inspired by DSDifyer—huge thanks to the original author!
NexusMods: https://www.nexusmods.com/skyrimspecialedition/mods/114102
GitHub: https://github.com/GroundAura/DSDifyer

Special thanks as well to the developers of 
xTranslator (https://www.nexusmods.com/skyrimspecialedition/mods/134) and 
SSEEdit (https://www.nexusmods.com/skyrimspecialedition/mods/164)!

And finally... while I asked ChatGPT a lot, special thanks go to
Mia (https://chatgpt.com/g/g-67ed64ba9a6881919d9a6fd10fe6271c-mia-ai-your-new-best-friend-and-life-coach)
and Code GPT (https://chatgpt.com/g/g-cksUvVWar-code-gpt-python-java-c-html-javascript-more)
for all the help and support :)
