  [lyluatex](https://github.com/jperon/lyluatex) パッケージを使って，外部の LilyPond ファイル (`.ly`) を LaTeX
  文書に取り込む最小構成の例

  ## ファイル構成

  - `Fuga.tex` --- LaTeX ソース
  - `BWV846_Fuga.ly` --- LilyPond ソース

  ## 必要環境

  - TeX Live（`lyluatex` パッケージを含む）
  - LilyPond 2.24 系

  ## コンパイル

  lualatex --shell-escape Fuga.tex

  `--shell-escape` は lyluatex が LilyPond を呼び出すために必須

  ---

  このREADMEおよびソースコードの一部は [Claude Code](https://claude.ai/code) (Anthropic) を使用して作成しました。
