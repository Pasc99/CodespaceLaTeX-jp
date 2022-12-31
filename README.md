# Codespace LaTeX for Japanese
- [Codespace LaTeX for Japanese](#codespace-latex-for-japanese)
  - [概要](#概要)
  - [使い方](#使い方)
    - [Troubleshooting](#troubleshooting)
  - [Grammarlyを使用しない場合](#grammarlyを使用しない場合)
  - [MS明朝，MSゴシックを使用したい場合](#ms明朝msゴシックを使用したい場合)
    - [1. フォントファイルの準備](#1-フォントファイルの準備)
    - [2. フォントのインストール](#2-フォントのインストール)
    - [3. フォントの使用](#3-フォントの使用)
  - [Credits](#credits)

## 概要
- Forked from [sanjib-sen/WebLaTeX](https://github.com/sanjib-sen/WebLaTex).

- This is a LaTeX template for Codaspace that generates Japanese PDFs.

- これは卒業論文を書くためのCodaspace用LaTeXです。

- [sanjib-sen](https://github.com/sanjib-sen)さんの[WebLaTeX](https://github.com/sanjib-sen/WebLaTex)より派生しています。

- 日本語のPDFを作成できるように，`latexmkrc`の設定や，[LaTeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop)の設定をいれています。

## 使い方
1. リポジトリの右上の`Use this template`で，
   
   `Create a new repository`または`Open in a codespace`を選択します。
2. 任意のリポジトリ名を入力し，**Create Fork / Create repository from template**をクリックします。
3. **<> Code** > **CodeSpaces** > **Create Codespace on Main**を選択し，インストールは始めます。
   
   初回起動は時間がかかりますが，2回目以降は早くなります。
4. latexindentを導入されています。texファイルをセーブする時点で自動でインデントが整えられます。好みの設定を入れたい場合は，`./latexindent.yaml`を編集してください。
5. デフォルトのビルドで`.latexmkrc`は自動的に読み込まれていますので，設定を変更したい場合は直接に`./.latexmkrc`を編集してください。PDFファイルは`./OUT`のディレクトリに出力されます。
   ### Troubleshooting
   - デフォルトのビルドが上手くいかない場合，下記のようにレシピの`latexmkrc`をクリックしてビルドしてください。
   　 ![latexmkrc](/images/latex.gif)
   -  ローカルのVisual Studio CodeでCodespaceを使うとき, LaTeX Workshopのレシピツールが設定されていないことでレシピが実行されないことがあります。その場合は，VS Codeの`settings.json`に下記を追加してください。
      ```json
         "latex-workshop.latex.tools": [
            {
               "name": "latexmk_rconly",
               "command": "latexmk",
               "args": [
                  "%DOC%"
               ],
               "env": {}
            }
         ]
      ```
6. texファイルの先頭にマジックコメントを入れることはできますが，デフォルトのレシピを無視して優先的に実行されるので，やっていることがわからない方にはおすすめしません。参照:[マジックコメント](https://texwiki.texjp.org/?Visual%20Studio%20Code%2FLaTeX#b7b858ba)。

## Grammarlyを使用しない場合
- `./.devcontainer/devcontainer.json`に
  ```json
   "extensions": [
        "...",
        //"znck.grammarly",
        "..."
        ]
  ```
  とコメントアウトしてください。
## MS明朝，MSゴシックを使用したい場合
### 1. フォントファイルの準備
- フォントのttcファイルを`./map`に配置してください。

- マイクロソフトのフォントはライセンスの関係で，このリポジトリには含まれていません。
  - Windowsユーザーは，`C:\Windows\Fonts`からコピーしてください。
  - WordとかOffice系のアプリをお持ちのMACユーザーは，bashコマンドで
      ```bash
      $ open /Applications/Microsoft\ Word.app/Contents/Resources/Fonts
      ```
      Wordのフォントフォルダを開き，ttcファイルをコピーしてください。

### 2. フォントのインストール
ここからはCodespaceのターミナルを使用します。

- #### シェルスクリプトを使用する場合
  - デフォルトディレクトリ`/workspaces/{レポジトリ名}#`になっていることを確認してください。
      
      - なっていない場合は，
         ```bash
         $ cd /workspaces/{レポジトリ名}
         ```
         で移動してください。
  - 下記のコマンドで`./msfont.sh`を実行してください。
      ```bash
      $ sh msfont.sh
      ```
      これでdvipdfmxのデフォルトフォントはMS系フォントになります。
  - 確認のために
      ```bash
      $ kanji-config-updmap-sys status
      ```
      で`CURRENT family for ja: ms`になっているか確認してください。
- #### Bashコマンドを使用する場合
  - まずは必要最低限のマップを作成します。

     (すでに作成してあるので，ディレクトリを作成してマップファイルをコピーします。)
     ```bash
     $ mkdir -p /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
     $ cp -i /workspaces/{レポジトリ名}/map/ptex-ms.map /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
     ```
  - ここで，マップファイルが正常に設置しているかをcatで確認します。
     ```bash
     $ cat /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms/ptex-ms.map
     ```
  - そして，`texmf-local`にディレクトリを作成してフォントファイルをリンクします。
     ```bash
     $ mkdir -p /usr/local/texlive/texmf-local/fonts/truetype/ms
     $ ln -s /workspaces/{レポジトリ名}/map/msmincho.ttc /usr/local/texlive/texmf-local/fonts/truetype/ms/msmincho.ttc
     $ ln -s /workspaces/{レポジトリ名}/map/msgothic.ttc /usr/local/texlive/texmf-local/fonts/truetype/ms/msgothic.ttc
     ```
  - 次にdvipdfmxで先ほど設置したマップファイルptex-ms.mapを使えるように設定します。
     ```bash
     $ mktexlsr
     $ updmap-sys --setoption kanjiEmbed ms
     $ mktexlsr
     ```
  - これでupdmap系のコマンドでptex-ms.mapを認識できるようになりました。

     一応，確認のために
     ```bash
     $ kanji-config-updmap-sys ms
     $ kanji-config-updmap-sys status
     ```
     でCURRENT family for ja: msになっているか確認してください。

  ### 3. フォントの使用
  - ここまでできたら，デフォルトフォントはMS系フォントになります。
  - 他のフォント(例えばIPAex)を指定したい場合はmainとなるtexファイルにおいて適宜に
     ```LaTeX
     \usepackage[ipaex]{pxchfon}
     ```
      を追加してください。
## Credits
- [sanjib-sen](https://github.com/sanjib-sen)'s [WebLaTex](https://github.com/sanjib-sen/WebLaTex)
- @James-Yu's [LaTeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop) 
- [danteev/texlive](https://github.com/dante-ev/docker-texlive)
- @znck's [Grammarly](https://github.com/znck/grammarly)
- 優曇華院's [MS明朝でLaTeXする話](https://omedstu.jimdofree.com/2019/05/29/ms%E6%98%8E%E6%9C%9D%E3%81%A7latex%E3%81%99%E3%82%8B%E8%A9%B1-mac%E7%B7%A8/)