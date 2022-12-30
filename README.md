# Codespace LaTeX for Japanese

## 概要
Forked from [sanjib-sen/WebLaTeX](https://github.com/sanjib-sen/WebLaTex).

This is a LaTeX template for Codaspace that generates Japanese PDFs.

これは卒業論文を書くためのCodaspace用LaTeXです。

[sanjib-sen](https://github.com/sanjib-sen)さんの[WebLaTeX](https://github.com/sanjib-sen/WebLaTex)より派生しています。

日本語のPDFを作成できるように，`latexmkrc`の設定や，[LaTeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop)の設定をいれています。

## 使い方
1. リポジトリの右上の`Use this template`で，
   
   `Create a new repository`または`Open in a codespace`を選択します。
2. 任意のリポジトリ名を入力し，**Create Fork / Create repository from template**をクリックします。
3. **<> Code** > **CodeSpaces** > **Create Codespace on Main**を選択し，インストールは始めます。
   
   初回起動は時間がかかりますが，2回目以降は早くなります。
4. LaTeX WorkshopのデフォルトBuildは日本語pdfの出力が何故かできません。
   
   レシピの`latexmkrc`をクリックして，`./OUT`のディレクトリにPDFは出力されます。
   
   好みの設定を入れたい場合は，`./.latexmkrc`を編集してください。

![latexmkrc](/images/latex.gif)

## Grammarlyを使用しない場合
は`./.devcontainer/devcontainer.json`に
  ```json
   "extensions": [
        "...",
        //"znck.grammarly",
        "..."
        ]
  ```
  とコメントアウトしてください。
## MS明朝, MSゴシックを使用したい場合
### 1. フォントファイルの準備
フォントのttcファイルを`./map`に配置してください。

マイクロソフトのフォントはライセンスの関係で，このリポジトリには含まれていません。

Windowsユーザーは，`C:\Windows\Fonts`からコピーしてください。

WordとかOffice系のアプリをお持ちのMACユーザーは，bashコマンドで
```bash
$ open /Applications/Microsoft\ Word.app/Contents/Resources/Fonts
```
Wordのフォントフォルダを開き，ttcファイルコピーしてください。

### 2. フォントのインストール
ここからCodespaceのターミナルを使用します。

まずは必要最低限のマップを作成します。

(すでに作成してあるので, ディレクトリを作成してマップファイルをコピーします。)
```terminal
$ mkdir /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
$ cp -i /workspaces/{レポジトリ名}/map/ptex-ms.map /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
```
マップファイルが正常に設置しているかをcatで確認します。
```
$ cat /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms/ptex-ms.map
```
`texmf-local`にディレクトリを作成してフォントファイルをリンクします。
```
$ ln -s /workspaces/{レポジトリ名}/map/msmincho.ttc /usr/local/texlive/texmf-local/fonts/truetype/ms/msmincho.ttc
$ ln -s /workspaces/{レポジトリ名}/map/msgothic.ttc /usr/local/texlive/texmf-local/fonts/truetype/ms/msgothic.ttc
```
dvipdfmxで先程設置したマップファイルptex-ms.mapを使えるように設定します。
```
$ mktexlsr
$ updmap-sys --setoption kanjiEmbed ms
$ mktexlsr
```
これでupdmap系のコマンドでptex-ms.mapを認識できる様になりました。

一応，確認のために
```
$ kanji-config-updmap-sys ms
$ kanji-config-updmap-sys status
```
でCURRENT family for ja: msになっているか確認してください。

### 3. フォントの使用
mainとなるtexファイル(サンプルではpaper.tex)に適宜に
```
\AtBeginDvi{\special{pdf:mapfile map/{好みのマップファイル}.map}}
```
を追加してください。
## Credits
- [sanjib-sen](https://github.com/sanjib-sen)'s [WebLaTex](https://github.com/sanjib-sen/WebLaTex)
- @James-Yu's [LaTeX-Workshop](https://github.com/James-Yu/LaTeX-Workshop) 
- [danteev/texlive](https://github.com/dante-ev/docker-texlive)
- @znck's [Grammarly](https://github.com/znck/grammarly)
- 優曇華院's [MS明朝でLaTeXする話](https://omedstu.jimdofree.com/2019/05/29/ms%E6%98%8E%E6%9C%9D%E3%81%A7latex%E3%81%99%E3%82%8B%E8%A9%B1-mac%E7%B7%A8/)