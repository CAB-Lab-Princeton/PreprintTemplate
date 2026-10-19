% =============================================================================
%  cablab.cls -- preprint class of the CAB Lab, Princeton University
%
%  A single-column (optionally two-column) article class for arXiv preprints:
%  a boxed title panel in translucent Princeton orange with the lab logo,
%  sans-serif headings, styled captions, a running header and metadata links.
%
%  Builds with pdflatex (TeX Live 2022+) and is arXiv-safe: every font ships
%  with TeX Live, and no external tools or shell escape are needed.
%
%  Design adapted from the MIT-licensed fairmeta.cls (Meta Platforms, Inc.)
%  and arXivTeX (Hao Wang). See LICENSE.
% =============================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cablab}[2026/10/19 v1.0 CAB Lab preprint class]

% ----------------------------------------------------------------------------
%  Options
% ----------------------------------------------------------------------------
%   10pt | 11pt (default) | 12pt   body size
%   twocolumn                      two-column body, title panel spans both
%   nonatbib                       do not load natbib (e.g. to use cite.sty)
%   nologo                         hide the logo in the title panel
%   noheader                       no running header on pages 2+
%   preprint (default) | draft     draft adds line numbers via lineno
%   toc                            compact two-column contents under the panel
%   tocpage                        one-column contents under the panel, then
%                                  the body starts on a new page (long papers)
%   anything else                  passed to article (a4paper, ...)
\newcommand\cab@ptsize{11pt}
\newif\ifcab@natbib   \cab@natbibtrue
\newif\ifcab@logo     \cab@logotrue
\newif\ifcab@header   \cab@headertrue
\newif\ifcab@draft    \cab@draftfalse
\newif\ifcab@toc      \cab@tocfalse
\newif\ifcab@tocpage  \cab@tocpagefalse
\newcommand\cab@toccols{2}
\DeclareOption{10pt}{\renewcommand\cab@ptsize{10pt}}
\DeclareOption{11pt}{\renewcommand\cab@ptsize{11pt}}
\DeclareOption{12pt}{\renewcommand\cab@ptsize{12pt}}
\DeclareOption{nonatbib}{\cab@natbibfalse}
\DeclareOption{nologo}{\cab@logofalse}
\DeclareOption{noheader}{\cab@headerfalse}
\DeclareOption{draft}{\cab@drafttrue}
\DeclareOption{preprint}{\cab@draftfalse}
\DeclareOption{toc}{\cab@toctrue}
\DeclareOption{tocpage}{\cab@toctrue\cab@tocpagetrue\renewcommand\cab@toccols{1}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[\cab@ptsize,letterpaper]{article}

\pdfoutput=1

% ----------------------------------------------------------------------------
%  Page layout and typography
% ----------------------------------------------------------------------------
\RequirePackage[top=1in,bottom=1in,left=1in,right=1in,
                headsep=0.3in,footskip=0.4in,columnsep=0.25in]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{etoolbox}
\RequirePackage{xspace}

% Body: XCharter; maths: newtxmath in its Charter flavour; sans: Source Sans Pro;
% mono: Inconsolata. All four are in TeX Live and embed as Type 1.
\RequirePackage[osf=false]{XCharter}
\RequirePackage{amsmath,amssymb}
\RequirePackage[xcharter,vvarbb]{newtxmath}
\RequirePackage[scale=0.96]{sourcesanspro}
\RequirePackage[varqu,varl,scaled=0.95]{inconsolata}
\RequirePackage{microtype}
\RequirePackage{setspace}
\setstretch{1.05}
\setlength{\parskip}{0.35em plus 0.1em}
\setlength{\parindent}{1.2em}
\setlength{\emergencystretch}{1.5em}

% ----------------------------------------------------------------------------
%  Colours
% ----------------------------------------------------------------------------
\RequirePackage[dvipsnames,table]{xcolor}
\definecolor{cabOrange}{HTML}{E77500}      % Princeton orange
\definecolor{cabOrangeDark}{HTML}{B35A00}  % orange that reads on white
\definecolor{cabInk}{HTML}{1F1F1F}         % charcoal
\definecolor{cabGray}{HTML}{6B6B6B}
\colorlet{cabAccent}{cabOrangeDark}
% Translucent title panel: fill opacity and frame strength are tunable.
\newcommand\cab@panelopacity{0.10}
\newcommand\cab@frameopacity{0.55}
\newcommand\panelopacity[1]{\renewcommand\cab@panelopacity{#1}}

% ----------------------------------------------------------------------------
%  Floats, tables, lists, maths helpers
% ----------------------------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{makecell}
\RequirePackage{enumitem}
\RequirePackage{placeins}
\RequirePackage{environ}
\setlist[itemize]{leftmargin=1.4em,itemsep=0.15em,topsep=0.3em}
\setlist[enumerate]{leftmargin=1.6em,itemsep=0.15em,topsep=0.3em}
\setlength{\abovecaptionskip}{6pt}
\renewcommand{\arraystretch}{1.12}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcolumntype{C}{>{\centering\arraybackslash}X}

% Table helper: \tablestyle{<tabcolsep>}{<arraystretch>}
\newcommand{\tablestyle}[2]{\setlength{\tabcolsep}{#1}%
  \renewcommand{\arraystretch}{#2}\centering\small}

% ----------------------------------------------------------------------------
%  Captions:  "Figure 1 | Caption text"
% ----------------------------------------------------------------------------
\RequirePackage{caption}
\RequirePackage{subcaption}
\DeclareCaptionLabelSeparator{cabbar}{\enspace{\color{cabOrange}\textbar}\enspace}
\captionsetup{font={small},labelfont={sf,bf,color=cabAccent},
  labelsep=cabbar,justification=justified,singlelinecheck=true,skip=6pt}
\captionsetup[table]{position=top}
\captionsetup[sub]{labelfont={sf,bf},labelsep=space,font=small}

% ----------------------------------------------------------------------------
%  Headings
% ----------------------------------------------------------------------------
\RequirePackage{titlesec}
\titleformat{\section}
  {\sffamily\bfseries\Large\color{cabInk}}
  {\color{cabOrange}\thesection}{0.6em}{}
\titleformat{\subsection}
  {\sffamily\bfseries\large\color{cabInk}}
  {\color{cabAccent}\thesubsection}{0.5em}{}
\titleformat{\subsubsection}
  {\sffamily\bfseries\normalsize\color{cabInk}}
  {\color{cabAccent}\thesubsubsection}{0.5em}{}
\titleformat{\paragraph}[runin]
  {\sffamily\bfseries\normalsize\color{cabAccent}}{}{0pt}{}[.]
\titlespacing*{\section}{0pt}{2.2ex plus .6ex minus .2ex}{1.0ex plus .2ex}
\titlespacing*{\subsection}{0pt}{1.8ex plus .4ex minus .2ex}{0.7ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{1.4ex plus .3ex minus .1ex}{0.5ex}
\titlespacing*{\paragraph}{0pt}{0.9ex plus .3ex minus .1ex}{0.6em}

% Bold run-in paragraph head without numbering: \parahead{Title}
\newcommand{\parahead}[1]{\par\noindent{\sffamily\bfseries\color{cabAccent}#1.}\hspace{0.5em}\ignorespaces}

% ----------------------------------------------------------------------------
%  Running header / footer
% ----------------------------------------------------------------------------
\RequirePackage{fancyhdr}
\newcommand\cab@shorttitle{}
\newcommand\cab@headerright{CAB Lab \textperiodcentered\ Princeton University}
\newcommand\shorttitle[1]{\renewcommand\cab@shorttitle{#1}}
\newcommand\headerright[1]{\renewcommand\cab@headerright{#1}}
\fancypagestyle{cabplain}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \fancyfoot[C]{\sffamily\small\color{cabGray}\thepage}}
\fancypagestyle{cabmain}{%
  \fancyhf{}%
  \ifcab@header
    \fancyhead[L]{\sffamily\footnotesize\color{cabGray}\cab@shorttitle}%
    \fancyhead[R]{\sffamily\footnotesize\color{cabGray}\cab@headerright}%
    \renewcommand{\headrulewidth}{0.4pt}%
    \renewcommand{\headrule}{{\color{cabOrange!45}%
      \hrule height\headrulewidth width\headwidth\vskip-\headrulewidth}}%
  \else
    \renewcommand{\headrulewidth}{0pt}%
  \fi
  \fancyfoot[C]{\sffamily\small\color{cabGray}\thepage}}
\pagestyle{cabmain}

\ifcab@draft
  \RequirePackage[switch]{lineno}
  \renewcommand\linenumberfont{\normalfont\tiny\sffamily\color{cabGray}}
  \AtBeginDocument{\linenumbers}
\fi

% ----------------------------------------------------------------------------
%  Links, references, icons
% ----------------------------------------------------------------------------
\ifcab@natbib
  \RequirePackage[numbers,sort&compress]{natbib}
  \renewcommand{\bibfont}{\small}
  \setlength{\bibsep}{0.25em plus 0.1em}
\fi
\RequirePackage[hyphens]{url}
\RequirePackage[colorlinks,linkcolor=cabAccent,citecolor=cabAccent,
  urlcolor=cabAccent,breaklinks,pdfusetitle,bookmarksnumbered]{hyperref}
\RequirePackage[nameinlink,noabbrev,capitalise]{cleveref}
\RequirePackage{fontawesome5}

% ----------------------------------------------------------------------------
%  Table of contents
% ----------------------------------------------------------------------------
%   Turned on by the `toc` / `tocpage` class options, or placed by hand with
%   \tableofcontents. \toccolumns{1|2} (default 2; 1 with tocpage),
%   \setcounter{tocdepth}{n} (default 2), \tocnumwidths{<sec>}{<subsec>}.
\RequirePackage{multicol}
\RequirePackage{titletoc}
\setcounter{tocdepth}{2}
\newcommand\toccolumns[1]{\renewcommand\cab@toccols{#1}}
\newlength\cab@secnumwidth    \setlength\cab@secnumwidth{2.0em}
\newlength\cab@subsecnumwidth \setlength\cab@subsecnumwidth{2.6em}
\newcommand\tocnumwidths[2]{\setlength\cab@secnumwidth{#1}\setlength\cab@subsecnumwidth{#2}}
\titlecontents{section}[\cab@secnumwidth]
  {\addvspace{0.55em}\sffamily\bfseries\color{cabInk}}
  {\contentslabel[{\color{cabOrange}\thecontentslabel}]{\cab@secnumwidth}}
  {\hspace*{-\cab@secnumwidth}}
  {\hfill{\mdseries\color{cabGray}\contentspage}}
  [\addvspace{0.1em}]
\titlecontents{subsection}[\dimexpr\cab@secnumwidth+\cab@subsecnumwidth\relax]
  {\sffamily\small\color{cabInk!90}}
  {\contentslabel[{\color{cabAccent}\thecontentslabel}]{\cab@subsecnumwidth}}
  {\hspace*{-\cab@subsecnumwidth}}
  {\,{\color{cabOrange!45}\titlerule*[0.55em]{.}}\,{\color{cabGray}\contentspage}}
\titlecontents{subsubsection}[\dimexpr\cab@secnumwidth+\cab@subsecnumwidth+2.8em\relax]
  {\sffamily\footnotesize\color{cabInk!80}}
  {\contentslabel{2.8em}}{}
  {\,{\color{cabOrange!45}\titlerule*[0.55em]{.}}\,{\color{cabGray}\contentspage}}
% References get a contents entry too.
\AtBeginEnvironment{thebibliography}{%
  \ifnum\c@tocdepth>0\phantomsection\addcontentsline{toc}{section}{\refname}\fi}
\renewcommand\tableofcontents{%
  \begingroup
    \hypersetup{linkcolor=cabInk}%
    \setlength{\parskip}{0pt}%
    \noindent{\sffamily\bfseries\large\color{cabInk}\contentsname}\par
    \vskip 0.25em
    {\color{cabOrange!60}\hrule height 0.5pt}%
    \vskip 0.2em
    \ifnum\cab@toccols>1
      \setlength{\columnsep}{2.2em}%
      \setlength{\columnseprule}{0.4pt}%
      \renewcommand{\columnseprulecolor}{\color{cabOrange!30}}%
      \begin{multicols}{\cab@toccols}\@starttoc{toc}\end{multicols}%
    \else
      \@starttoc{toc}%
    \fi
    \vskip 0.2em
    {\color{cabOrange!60}\hrule height 0.5pt}%
  \endgroup
  \vskip 1.2em}

% ----------------------------------------------------------------------------
%  Title metadata
% ----------------------------------------------------------------------------
%   \title{...}                         \shorttitle{...} (running header)
%   \author[1,*]{Name}                  \affiliation[1]{Institution}
%   \contribution[*]{Equal contribution}
%   \begin{abstract} ... \end{abstract} (before \maketitle)
%   \keywords{a, b, c}
%   \date{...}  \code{url}  \project{url}  \data{url}  \arxiv{id}
%   \correspondence{\email{x@princeton.edu}}  \metadata[Label]{value}
%   \lablogo{path}  (default: assets/cablab-logo)
\newcommand\cab@title{}
\newcommand\cab@authors{}
\newcommand\cab@affils{}
\newcommand\cab@contribs{}
\newcommand\cab@abstract{}
\newcommand\cab@keywords{}
\newcommand\cab@meta{}
\newcommand\cab@logo{assets/cablab-logo}
\newcommand\cab@sup[1]{\ifblank{#1}{}{\textsuperscript{\ensuremath{#1}}}}

\renewcommand\title[1]{\renewcommand\cab@title{#1}}
\renewcommand\author[2][]{%
  \ifdefempty\cab@authors
    {\gappto\cab@authors{\mbox{#2\cab@sup{#1}}}}
    {\gappto\cab@authors{,\hspace{0.45em}\mbox{#2\cab@sup{#1}}}}}
\newcommand\affiliation[2][]{%
  \ifdefempty\cab@affils
    {\gappto\cab@affils{\mbox{\cab@sup{#1}#2}}}
    {\gappto\cab@affils{\hspace{0.6em}\textperiodcentered\hspace{0.6em}\mbox{\cab@sup{#1}#2}}}}
\newcommand\contribution[2][]{%
  \ifdefempty\cab@contribs
    {\gappto\cab@contribs{\cab@sup{#1}#2}}
    {\gappto\cab@contribs{,\hspace{0.6em}\cab@sup{#1}#2}}}
\let\abstract\relax\let\endabstract\relax
\NewEnviron{abstract}{\global\let\cab@abstract\BODY}
\newcommand\keywords[1]{\gdef\cab@keywords{#1}}
\newcommand\lablogo[1]{\renewcommand\cab@logo{#1}}

\newcommand\metadata[2][]{%
  \gappto\cab@meta{\cab@metaitem{#1}{#2}}}
\newcommand\cab@metaitem[2]{%
  \mbox{{\sffamily\bfseries\color{cabAccent}#1}\enspace#2}\hspace{1.4em}\allowbreak}
\newcommand\cab@link[1]{\href{#1}{\nolinkurl{#1}}}
\newcommand\email[1]{\href{mailto:#1}{\texttt{#1}}}
\renewcommand\date[1]{\metadata[\faCalendar*\ Date]{#1}}
\newcommand\code[1]{\metadata[\faGithub\ Code]{\cab@link{#1}}}
\newcommand\project[1]{\metadata[\faGlobe\ Project]{\cab@link{#1}}}
\newcommand\data[1]{\metadata[\faDatabase\ Data]{\cab@link{#1}}}
\newcommand\arxiv[1]{\metadata[{\faFile*[regular]\ arXiv}]{\href{https://arxiv.org/abs/#1}{\texttt{#1}}}}
\newcommand\correspondence[1]{\metadata[{\faEnvelope[regular]\ Contact}]{#1}}

% ----------------------------------------------------------------------------
%  Title panel
% ----------------------------------------------------------------------------
\RequirePackage[most]{tcolorbox}
\newlength\cab@logowidth   \setlength\cab@logowidth{3.6cm}
\newcommand\logowidth[1]{\setlength\cab@logowidth{#1}}
\newlength\cab@titlewidth

\newcommand\cab@panel{%
  \begin{tcolorbox}[enhanced,
      frame hidden,
      interior style={fill=cabOrange,fill opacity=\cab@panelopacity},
      borderline={0.6pt}{0pt}{cabOrange,opacity=\cab@frameopacity},
      arc=9pt, boxsep=0pt, left=0.75cm, right=0.75cm, top=0.6cm, bottom=0.55cm,
      before skip=0pt, after skip=0pt,
      overlay={\ifcab@logo\IfFileExists{\cab@logo.pdf}{\cab@placelogo}%
               {\IfFileExists{\cab@logo.png}{\cab@placelogo}{}}\fi}]
    \setlength{\parindent}{0pt}\setlength{\parskip}{0pt}%
    \raggedright\color{cabInk}%
    {\sffamily\bfseries\fontsize{21}{26}\selectfont
     \hyphenpenalty=10000\exhyphenpenalty=10000\cab@title\par}
    \vskip 0.45cm
    {\sffamily\large\cab@authors\par}%
    \ifdefempty\cab@affils{}{\vskip 0.2cm{\sffamily\small\color{cabInk!85}\cab@affils\par}}%
    \ifdefempty\cab@contribs{}{\vskip 0.12cm{\sffamily\footnotesize\color{cabGray}\cab@contribs\par}}%
    \ifdefempty\cab@abstract{}{%
      \vskip 0.3cm
      {\color{cabOrange!60}\rule{\linewidth}{0.5pt}}\par
      \vskip 0.28cm
      {\justifying@cab\small\setstretch{1.08}\cab@abstract\par}}%
    \ifdefempty\cab@keywords{}{%
      \vskip 0.25cm
      {\small{\sffamily\bfseries\color{cabAccent}Keywords}\enspace\cab@keywords\par}}%
    \ifcab@logo\setlength\cab@titlewidth{\dimexpr\linewidth-\cab@logowidth-0.6cm\relax}%
    \else\setlength\cab@titlewidth{\linewidth}\fi
    \vskip 0.3cm
    {\color{cabOrange!60}\rule{\linewidth}{0.5pt}}\par
    \vskip 0.22cm
    % metadata on the left; a strut reserves the logo's height on the right
    \begin{minipage}[b]{\cab@titlewidth}
      \small\raggedright\setstretch{1.25}%
      \ifdefempty\cab@meta{\strut}{\cab@meta}\par
    \end{minipage}%
    \ifcab@logo\hfill\rule{0pt}{0.23\cab@logowidth}\fi\par
  \end{tcolorbox}}
\newcommand\cab@placelogo{%
  \node[anchor=south east,inner sep=0pt] at
    ([xshift=-0.65cm,yshift=0.5cm]frame.south east)
    {\includegraphics[width=\cab@logowidth]{\cab@logo}};}
\newcommand\justifying@cab{\leftskip=0pt\rightskip=0pt\parfillskip=0pt plus 1fil\relax}

\pdfstringdefDisableCommands{\def\\{ }}
\renewcommand\maketitle{%
  \hypersetup{pdftitle={\cab@title}}%
  \thispagestyle{cabplain}%
  \if@twocolumn
    \twocolumn[{\cab@panel\vskip 0.6cm\ifcab@toc\tableofcontents\fi}]%
  \else
    \cab@panel\par\vskip 0.6cm
    \ifcab@toc\tableofcontents\fi
  \fi
  \ifcab@tocpage\clearpage\fi
  \FloatBarrier}

% ----------------------------------------------------------------------------
%  Misc
% ----------------------------------------------------------------------------
\newcommand{\beginappendix}{%
  \clearpage\appendix
  \phantomsection\addcontentsline{toc}{section}{Appendix}}
\newcommand{\cmark}{{\color{ForestGreen}\faCheck}}
\newcommand{\xmark}{{\color{BrickRed}\faTimes}}

\endinput
