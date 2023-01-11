#!/bin/bash
mkdir -p /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
cp -i ./map/ptex-ms.map /usr/local/texlive/texmf-local/fonts/map/dvipdfmx/ms
mkdir -p /usr/local/texlive/texmf-local/fonts/truetype/local/ms
cp ./map/msmincho.ttc /usr/local/texlive/texmf-local/fonts/truetype/local/ms/msmincho.ttc
cp ./map/msgothic.ttc /usr/local/texlive/texmf-local/fonts/truetype/local/ms/msgothic.ttc
chmod 755 /usr/local/texlive/texmf-local/fonts/truetype/local/ms/msmincho.ttc
chmod 755 /usr/local/texlive/texmf-local/fonts/truetype/local/ms/msgothic.ttc
mktexlsr
updmap-sys --setoption jaEmbed ms
mktexlsr
kanji-config-updmap-sys ms
