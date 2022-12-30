% This is test.bst created by cbst program 
%         2006/10/30 
% jBibTeX `jbase' is derived from 'jplain.bst'
% version 0.30 for JBibTeX versions 0.30 or later, LaTeX version 2.09.
% Copyright (C) 1990, all rights reserved.
% Copyright (C) 1985, all rights reserved.
% Copying of this file is authorized only if either
% (1) you make absolutely no changes to your copy, including name, or
% (2) if you do make changes, you name it something other than
% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
% This restriction helps ensure that all standard styles are identical.
% The file btxbst.doc has the documentation for this style.
%
% 松井 正一  (財) 電力中央研究所　情報システム部
%
% This file is a part of jcbst and is modified from plain.bst 
%   by Level3 
%     hagihira@anes.med.osaka-u.ac.jp / pgb00174@nifty.ne.jp
%   Department of Anesthesiology,
%   Osaka Prefectural Habikino Hospital,
%   3-7-1, Habikino, Habikino, Osaka 583-8588, Japan.
%
% for customizing bst files
%    1997.11.24  Ver 0.81
%    1997.11.28  Ver 0.82  added bold
%    1999.02.02  Ver 0.83  added pinit, remove output2

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    yomi
  }
  {is.kanji.entry}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

% added by Level3
% for working
STRINGS { separator pre pre2 post post2 str }
 
FUNCTION {pinit}
{
  ", " 'separator :=
  "" 'pre :=
  "" 'post :=
  "" 'pre2 :=
  "" 'post2 :=
  "" 'str :=
}

% This needs "separator"
FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { separator * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  pinit
  s
}


% This needs 'separator'
FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
  pinit
}

FUNCTION {output.pre}
{ duplicate$ empty$
    { pop$ pop$ }
    { * output.nonnull }
  if$
  pinit
}

FUNCTION {output.post}
{ duplicate$ empty$
    { pop$ pop$ }
    { swap$ * output.nonnull }
  if$
  pinit
}

FUNCTION {output.pre.post}
{ duplicate$ empty$
    { pop$ pop$ pop$ }
    { swap$ * * output.nonnull }
  if$
  pinit
}

% This needs 'separator'
FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
  pinit
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ %add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}


FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}


FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {bold}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }
% This needs 'str'
%  in plain.bst
%  str := " and "
FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff}{ll}" format.name$ is.kanji.str$
	{s nameptr "{ff~}{ll}" format.name$ 't :=}
 	{s nameptr "{f.~}{v~}{ll}{, jj}" format.name$ 't :=}
      if$
      nameptr #1 >
	{ namesleft #1 >
	    {", " * t * }
	    { t "others" =
 		{ s is.kanji.str$
 			{"ほか" * }
 			{", et~al." * }
 		  if$
 		}
 		{ s is.kanji.str$
 		    {", " * t * }
 		    {str * t * }
 		   if$
 		}
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

% This needs 'str' for last separator of authors
FUNCTION {format.authors2}
{ 'str :=
  author empty$
    { "" }
    { author format.names }
  if$
}

% This needs 'pre', 'pre2', 'post', 'post2' and 'str'
%  In plain.bst 
%   pre  := "" post  := ", editor"
%   pre2 := "" post2 := ", editors"
%   str := " and "
FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
	{ editor is.kanji.str$
           { "（編）" * }
           { pre2 swap$ * post2 * }
          if$
        }
        { editor is.kanji.str$
           { "（編）" * }
      	   { pre swap$ * post * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    {"``" title "t" change.case$ * "''" *}
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	  month
	}
      if$
    }
    { month empty$
	'year
	{ month " " * year * }
      if$
    }
  if$
}

% added by Level3
FUNCTION {format.str2}
{ 'str :=
  str empty$
  { "no" 'str * "item in " * cite$ * warning$
    ""
  }
  { pre str * post * }
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

%  This needs pre
%  in plain.bst
%  pre := "volume"
FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { volume is.kanji.str$
        { volume }
        { is.kanji.entry
	    { "第" volume * "巻" *}
	    { pre volume tie.or.space.connect }
          if$
        }
      if$
      series empty$
	'skip$
	{ " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

%  in plain.bst
%  pre  := "number"
%  pre2 := "Number"
FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ number is.kanji.str$
            { number }
            { output.state mid.sentence =
	        { pre }
	        { pre2 }
              if$
            }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " in " * series * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

% This needs 'pre' and 'post'
%  in plain.bst
%   pre := ""
%   post := " edition"
FUNCTION {format.edition2}
{ 'post :=
  edition empty$
    { "" }
    { edition is.kanji.str$
        { "第" edition * "版" * }
        { output.state mid.sentence =
	    { edition "l" change.case$ pre swap$ * post * }
	    { edition "t" change.case$ pre swap$ * post * }
          if$
        }
     if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

% This needs 'pre', 'pre2', 'post' and 'post2'
% in plain.bst
%  pre  := "page"  post  := ""
%  pre2 := "pages" post2 := ""
FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { pre2 pages n.dashify tie.or.space.connect post2 *}
        { pre pages tie.or.space.connect post * }
      if$
    }
  if$
}

FUNCTION {format.pages.pre.pre2}
{ 'pre2 :=
  'pre :=
  pages empty$
    { "" }
    { pages multi.page.check
	{ pre2 pages n.dashify tie.or.space.connect post2 *}
	{ pre pages tie.or.space.connect post * }
      if$
    }
  if$
}

% This needs 'pre' and 'post'
% in plain.bst
%  pre  := "page"  post  := ""
FUNCTION {format.pages2}
{ pages empty$
    'skip$
    { duplicate$ empty$
	{ "" }
	{ pages n.dashify pre swap$ * post * }
      if$
    }
  if$
}

% This needs 'str'
% in plain.bst
%  str := ":"
%  pre := "("
%  post := ")"
FUNCTION {format.vol.num.pages2}
{ 'str :=
  volume empty$
     {""}
     { volume is.kanji.str$
        { volume  ", " * }
        { volume }
       if$
     }
  if$
  number empty$
    'skip$
    { number is.kanji.str$
        { number * }
        { pre * number * post *}
      if$
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
%	{ number empty$
% 	    { format.pages * }
 	    { format.pages str swap$ * * }
%	  if$
%	}
      if$
    }
  if$
}

% This needs 'pre', 'pre2' in calling format.pages and 'str'
% in plain.bst 
%  str := "chapter"

FUNCTION {format.chapter.pages2}
{ 'str := 
  chapter empty$
    'format.pages
    { type empty$
	{ is.kanji.entry
            { "章" }
            { str }
          if$
        }
	{ type "l" change.case$ }
      if$
      chapter is.kanji.str$ not is.kanji.entry and
        {"第" chapter * swap$ *}
        { chapter is.kanji.str$
	    { chapter * }
	    { chapter tie.or.space.connect }
	  if$
	}
      if$
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

% This needs 'pre'
% in plain.bst
%  separator := ", "
FUNCTION {format.in.ed.booktitle2}
{ 'str :=
  's :=
  booktitle empty$
    { title empty$
       { "" }
       { editor empty$
           { title is.kanji.str$
             { " " title emphasize * }
             { s title emphasize * }
           if$
           }
           { title is.kanji.str$
             { " " format.editors * separator * title * }
             { s format.editors * separator * booktitle emphasize * }
           if$
           }
       if$
       }
    if$ 
    }
    { editor empty$
 	{ booktitle is.kanji.str$
 	    { " " booktitle emphasize * }
 	    { s booktitle emphasize * }
 	  if$
 	}
 	{ booktitle is.kanji.str$
 	    { " " format.editors * separator * booktitle * }
 	    { s format.editors * separator * booktitle emphasize * }
 	  if$
 	}
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

% This needs 'str'
%  in plain.bst
%  str := "Technical Report"
FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "In {\em " journal * "\/}" * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor is.kanji.str$
     {editor #1 "{ff}" format.name$ duplicate$
      empty$
 	{pop$ editor #1 "{ll}" format.name$}
 	'skip$
      if$
      }
      {editor #1 "{vv~}{ll}" format.name$}
  if$
  editor num.names$ duplicate$
  #2 >
    { editor is.kanji.str$
	  {pop$ "ほか" *} {pop$ ", et~al." * } if$
    }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
 	    { editor is.kanji.str$
 		{"ほか" *} {", et~al." * } if$
 	    }
 	    { editor is.kanji.str$
 		{
		  ", " *
 		   editor #2 "{ff}" format.name$ duplicate$
 		   empty$
 			{pop$ editor #2 "{ll}" format.name$}
 			'skip$
 		   if$
 		 *
 		}
 		{" and " * editor #2 "{vv~}{ll}" format.name$ * }
 	      if$
 	    }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
       title is.kanji.str$
 	{"  "} {"In "} if$
    }
    { volume is.kanji.str$
	{ volume }
	{ is.kanji.entry
	    {"第" volume * "巻" *}
	    {"Vol." volume tie.or.space.connect " of " *  }
	  if$
	}
      if$
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { series is.kanji.str$
		{ series ", " * swap$ * }
	        { "{\em " * series * "\/}" * }
	      if$
	    }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
 	    { booktitle is.kanji.str$
 		{ booktitle }
 		{"In {\em " booktitle * "\/}" * }
 	       if$
 	    }
	  if$
	}
	{ "In " key * }
      if$
    }
    { title is.kanji.str$
 	{" " format.crossref.editor * }
 	{"In " format.crossref.editor * }
      if$
    }
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {article}
{ output.bibitem
  ", " format.authors2 "author" output.check
  ": " 'separator :=
  "``" title * "''" * format.str2 "title" output.check
  journal emphasize format.str2 "journal" output.check
  "Vol. " volume  output.pre
  "No." number  output.pre
  "pp." 'pre :=
  format.pages2 output
  " " 'separator :=
  "(" year * ")" * format.str2 "year" output.check
  new.block
  fin.entry
}
FUNCTION {inproceedings}
{ output.bibitem
  ", " format.authors2 "author" output.check
  ": " 'separator :=
  "``" title * "''" * format.str2 "title" output.check
  booktitle emphasize format.str2 "booktitle" output.check
  "pp." 'pre :=
  format.pages2 output
  " " 'separator :=
  "(" year * ")" * format.str2 "year" output.check
  new.block
  fin.entry
}
FUNCTION {book}
{ output.bibitem
  ", " format.authors2 "author" output.check
  ": " 'separator :=
  "``" title * "''" * format.str2 "title" output.check
  publisher emphasize format.str2 "publisher" output.check
  address format.str2 "address" output.check
  " " 'separator :=
  "(" year * ")" * format.str2 "year" output.check
  new.block
  fin.entry
}
FUNCTION {inbook}
{ output.bibitem
  ", " format.authors2 "author" output.check
  ": " 'separator :=
  "``" title * "''" * format.str2 "title" output.check
  "{\em in }" 'pre :=
  series emphasize format.str2 "series" output.check
  publisher format.str2 "publisher" output.check
  address format.str2 "address" output.check
  "pp." 'pre :=
  format.pages2 output
  " " 'separator :=
  "(" year * ")" * format.str2 "year" output.check
  new.block
  fin.entry
}
FUNCTION {booklet}
{ output.bibitem
	", " format.authors2 "author" output.check
	": " 'separator :=
	"``" title * "''" * format.str2 "title" output.check
	publisher emphasize format.str2 "publisher" output.check
	address format.str2 "address" output.check
	" " 'separator :=
	"(" year * ")" * format.str2 "year" output.check
	new.block
	fin.entry
}

FUNCTION {misc}
{ output.bibitem
	note output
	new.block
	fin.entry
}

% -------------------------

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

MACRO {tieice} {"電子情報通信学会論文誌"}

MACRO {tipsj}  {"情報処理学会論文誌"}

MACRO {jipsj}  {"Journal of Informatin Processing Society of Japan"}

MACRO {jorsj}  {"Journal of the Operations Research Society of Japan"}

READ

FUNCTION {set.is.kanji.entry}
{
  author    field.or.null is.kanji.str$
  title     field.or.null is.kanji.str$ or
  editor    field.or.null is.kanji.str$ or
  journal   field.or.null is.kanji.str$ or
  booktitle field.or.null is.kanji.str$ or
  series    field.or.null is.kanji.str$ or
  'is.kanji.entry :=
}

ITERATE {set.is.kanji.entry}
STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
% ------------ end of test.bst -------------- 
