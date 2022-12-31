#!/bin/bash
mkdir -p /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
cp -i ./map/ptex-ms.map /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
mkdir -p /usr/local/texlive/texmf-local/fonts/truetype/ms
ln -s ./map/msmincho.ttc /usr/local/texlive/texmf-local/fonts/truetype/ms/msmincho.ttc
ln -s ./map/msgothic.ttc /usr/local/texlive/texmf-local/fonts/truetype/ms/msgothic.ttc
mktexlsr
updmap-sys --setoption kanjiEmbed ms
mktexlsr
kanji-config-updmap-sys ms