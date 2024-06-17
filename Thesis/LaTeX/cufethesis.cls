%%
%% This is file `cufethesis.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% cufethesis.dtx  (with options: `class')
%%
%% Copyright(C) 2014 by Mohsen Muhammad Mahroos, PhD
%%
%% Assistant Professor
%% Electronics and Electrical Communications Engineering Department
%% Faculty of Engineering
%% Cairo University
%% Giza, EGYPT 12613
%% Phone: +202 3567-8888
%% E-mail: mmahroos@eece.cu.edu.eg
%%
%% This is a free file may be distributed and/or modified under the
%% conditions of the latest version of the LaTeX Project Public License
%% available in:
%%
%%           http://www.latex-project.org/lppl.txt
%%
%% which is part of all distributions of LaTeX on June 17, 2014.
%%
%% This is a generated file designed to implement LaTeX Document Class for
%% typesetting MSc and PhD Theses prepared in all Departments in the Faculty
%% of Engineering at Cairo University according to the Graduate Studies
%% Administration Guidelines released in January 2013.
%%
%%
%% This project was modified by Mohamed Badr Mahmoud in June, 2019.
%%
%% Teaching Assistant
%% Electronics and Electrical Communications Engineering Department
%% Faculty of Engineering
%% Cairo University
%% Giza, EGYPT 12613
%% E-mail: m.badr@eng.cu.edu.eg
%% 
%% These Modifications was based on the latest thesis template
%% provided by the post graduate office at CUFE in June, 2109.
%%
%%
\NeedsTeXFormat{LaTeX2e}[2011/06/27]
\ProvidesClass{cufethesis}
  [2014/06/17 v1.2 A LaTeX Document Class for Typesetting Graduate Theses ]
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\def\@MSc{Bachelor of Science}
\DeclareOption{msc}{\def\@Degree{\@MSc}}
\def\@PhD{Doctor of Philosophy}
\DeclareOption{phd}{\def\@Degree{\@PhD}}
\def\@Degree{\@MSc}
\DeclareOption{emp}{
    \def\@Specialization{Engineering Mathematics and Physics}
}
\DeclareOption{arch}{
    \def\@Specialization{Architectural Engineering}
}
\DeclareOption{civil}{
    \def\@Specialization{Civil Engineering}
}
\DeclareOption{mech}{
    \def\@Specialization{Mechanical Engineering}
}
\DeclareOption{aero}{
    \def\@Specialization{Aeronautical and Aerospace Engineering}
}
\DeclareOption{eece}{
    \def\@Specialization{Electronics and Communications}
}
\DeclareOption{epm}{
    \def\@Specialization{Electrical Power and Machines}
}
\DeclareOption{chem}{
    \def\@Specialization{Chemical Engineering}
}
\DeclareOption{mpm}{
    \def\@Specialization{Mining, Petroleum and Metallurgical}
}
\DeclareOption{bio}{
    \def\@Specialization{Biomedical Engineering and Systems}
}
\DeclareOption{comp}{
    \def\@Specialization{Computer Engineering}
}
\def\@Specialization{Electronics and Communications Engineering}
\newif\if@praise
\DeclareOption{nopraise}{\@praisefalse}
\DeclareOption{Logos/praise}{\@praisetrue}
\newif\if@phero
\DeclareOption{nophero}{\@pherofalse}
\DeclareOption{Logos/phero}{\@pherotrue}
\newif\if@longtitle
\DeclareOption{nolongtitle}{\@longtitlefalse}
\DeclareOption{longtitle}{\@longtitletrue}
\newif\if@infopage
\DeclareOption{noinfopage}{\@infopagefalse}
\DeclareOption{infopage}{\@infopagetrue}
\newif\if@listoftables
\DeclareOption{nolistoftables}{\@listoftablesfalse}
\DeclareOption{listoftables}{\@listoftablestrue}
\newif\if@listoffigures
\DeclareOption{nolistoffigures}{\@listoffiguresfalse}
\DeclareOption{listoffigures}{\@listoffigurestrue}
%\newif\if@listofalgorithms
%\DeclareOption{nolistofalgorithms}{\@listofalgorithmsfalse}
%\DeclareOption{listofalgorithms}{\@listofalgorithmstrue}
\ExecuteOptions{praise,nophero,nolongtitle,infopage}
\ExecuteOptions{listoftables,listoffigures}
\ProcessOptions
\LoadClass[12pt,a4paper,twoside,openright]{report}%
%\setlength\oddsidemargin{10mm}
%\setlength\evensidemargin{0mm}
\setlength\topmargin{0mm}
\setlength\headheight{0mm}
\setlength\textheight{246.2mm}
\setlength\textwidth{149.2mm}
\setcounter{tocdepth}{4}
\setcounter{secnumdepth}{4}
\lefthyphenmin 62
\righthyphenmin 62
\usepackage{alltt}
%\usepackage[titlenotnumbered,boxruled]{algorithm2e}
\usepackage[centertags]{amsmath}
\usepackage{amsfonts}
\usepackage{amssymb}
\usepackage{amsthm}
\usepackage[toc,page]{appendix}
\usepackage[english]{babel}
\usepackage{calc}
\usepackage{epsfig}
\usepackage[hidelinks]{hyperref}
\usepackage[all]{hypcap}
\usepackage{ifthen}
\usepackage{pdflscape}
\usepackage{mathptmx}
\usepackage{microtype}
\usepackage{multicol}
\usepackage{multirow}
\usepackage{newlfont}
\usepackage{nomencl}
\usepackage[overload]{textcase}
\usepackage{tocloft}
\usepackage{txfonts}
\usepackage[nottoc]{tocbibind}
\usepackage{xstring}
\usepackage{stringstrings}
\usepackage[inner=35.4mm,outer=25.4mm,top=25.4mm,bottom=25.4mm,asymmetric]{geometry}

\def\specialization{Electronics}
\def\department{Electronics and Communications Engineering}
\def\faculty{Faculty of Engineering }
\def\university{Tanta University}
\def\city{Tanta}
\def\country{Egypt}
\newcommand\MainSupervisor[2]
{
    \def\@MainSupervisor{#1}
    \def\@MainSupervisorPosition{#2}
}
\newcounter{@NumberOfCoSupervisors}

\newcommand{\CoSupervisor}[4]{
    \addtocounter{@NumberOfCoSupervisors}{1}
    \ifcase\the@NumberOfCoSupervisors\relax
    % Do nothing if no Co-Supervisors
    \or \def\@FirstCoSupervisor{#1}
        \def\@FirstCoSupervisorPosition{#2}
        \def\@FirstCoSupervisorDepartment{#3}
        \def\@FirstCoSupervisorAffiliation{#4}
    \or \def\@SecondCoSupervisor{#1}
        \def\@SecondCoSupervisorPosition{#2}
        \def\@SecondCoSupervisorDepartment{#3}
        \def\@SecondCoSupervisorAffiliation{#4}
    \or \def\@ThirdCoSupervisor{#1}
        \def\@ThirdCoSupervisorPosition{#2}
        \def\@ThirdCoSupervisorDepartment{#3}
        \def\@ThirdCoSupervisorAffiliation{#4}
    \fi
}
\newcommand{\ExternalExaminer}[4]{
    \def\@ExternalExaminer{#1}
    \def\@ExternalExaminerPosition{#2}
    \def\@ExternalExaminerSchool{#3}
    \def\@ExternalExaminerUniv{#4}
}
\newcommand\InternalExaminer[1]{\def\@InternalExaminer{#1}}
\newcounter{@NumberOfMemberExaminers}

\newcommand\MemberExaminer[1]{
    \addtocounter{@NumberOfMemberExaminers}{1}
    \ifcase\the@NumberOfMemberExaminers\relax
    % Do nothing if no Member Examiners
    \or \def\@FirstMemberExaminer{#1}
    \or \def\@SecondMemberExaminer{#1}
    \fi
}
\newcommand{\RegistrationDate}[3]{\def\@RegistrationDate{#1/#2/#3}}
\newcommand{\SubmissionDate}[2]{
    \def\@SMonth{#1}
    \def\@SYear{2023}
}
\newcommand{\AwardingDate}[3]{\def\@AwardingDate{#1/#2/#3}}
\def\@AwardingDate{}
\newcommand{\EngineerName}[1]{\def\@EngineerName{#1}}
\newcommand{\BirthDate}[3]{\def\@BirthDate{#1/#2/#3}}
\newcommand{\Nationality}[1]{\def\@Nationality{#1}}
\newcommand{\EMail}[1]{\def\@EMail{#1}}
\newcommand{\Phone}[1]{\def\@Phone{#1}}
\newcommand{\Address}[1]{\def\@Address{#1}}
\newcommand{\shoshop}[1]{\def\@shoshop{#1}}
\newcommand{\brishap}[1]{\def\@brishap{#1}}
\newcommand{\emanp}[1]{\def\@emanp{#1}}
\newcommand{\hatemp}[1]{\def\@hatemp{#1}}
\newcommand{\hossamp}[1]{\def\@hossamp{#1}}
\newcommand{\husseinp}[1]{\def\@husseinp{#1}}
\newcommand{\helalp}[1]{\def\@helalp{#1}}
\newcommand{\shabanp}[1]{\def\@shabanp{#1}}
\newcommand{\shalabyp}[1]{\def\@shalabyp{#1}}
\newcommand{\ThesisTitle}[1]{\def\@ThesisTitle{#1}}
\newcommand{\ThesisKeywords}[1]{\def\@ThesisKeywords{#1}}
\newcommand{\ThesisSummary}[1]{\def\@ThesisSummary{#1}}

\newcommand{\Preamble}[2]{
    \@NNChapter{#1}
    \input{#2.tex}
    \newpage
}
\newif\if@firstchapter\@firstchaptertrue

\newcommand{\Chapter}[2]{ %
    \gchapter{\caseupper{#1}}
    \chapter{#1}
    \label{Chapter:#2}
    \if@firstchapter
        \@firstchapterfalse
        \pagestyle{plain}
        \pagenumbering{arabic}
    \fi
    \input{#2.tex}
    \newpage
}
\newcommand{\Appendix}[2]{
    \gchapter{\caseupper{#1}}
    \chapter{#1}
    \label{Appendix:#2}
    \input{#2.tex}
    \newpage
}

\renewcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
                    \thispagestyle{plain}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{\chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \if@twocolumn
                      \@topnewpage[\@makechapterhead{#2}]%
                    \else
                      \@makechapterhead{#2}%
                      \@afterheading
                    \fi}

\newcommand{\seclbl}[1]{\label{Section:#1}}

\newcommand{\chref}[1]{Chapter~\ref{Chapter:#1}}
\newcommand{\appref}[1]{Appendix~\ref{Appendix:#1}}

\newcommand{\secref}[1]{Section~\ref{Section:#1}}
\newcommand{\eqnlbl}[1]{\label{Equation:#1}}
\newcommand{\eqnref}[1]{Equation~\ref{Equation:#1}}
\newcommand{\tabref}[1]{Table~\ref{Table:#1}}
\newcommand{\figref}[1]{Figure~\ref{Figure:#1}}
%\newcommand{\algref}[1]{Algorithm~\ref{Algorithm:#1}}

\newcommand{\gtable}[4]{
    \begin{hctable}{#1}{#2}
        \includegraphics[#3]{#4}
    \end{hctable}
}
\newcommand{\gfigure}[4]
{
    \begin{hcfigure}
        \includegraphics[#3]{#4}
        \caption{#1}
        \label{Figure:#2}
    \end{hcfigure}
}
%\newenvironment{Algorithm}[2]{
%    \begin{algorithm}[H]
%        \caption{#1}
%        \label{Algorithm:#2}
%}
%{
%    \end{algorithm}
%}
\newcommand{\newnom}[2]{
    \nomenclature{#2}{#1}#1~(#2)
}
\renewcommand\tocbibname{References}
%\bibliographystyle{unsrtnat}
%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{changemargintop}[1]{%
\begin{list}{}{%
%\setlength{\topsep}{0pt}%
\setlength{\topmargin}{#1}%
\setlength{\rightmargin}{0mm}%
\setlength{\leftmargin}{0mm}%
%\setlength{\itemindent}{\parindent}%
%\setlength{\parsep}{\parskip}%
}%
\item[]}{\end{list}}
%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{changemarginleft}[1]{%
\begin{list}{}{%
%\setlength{\topsep}{0pt}%
\setlength{\topmargin}{-1cm}%
\setlength{\rightmargin}{0mm}%
\setlength{\leftmargin}{#1}%
%\setlength{\itemindent}{\parindent}%
%\setlength{\parsep}{\parskip}%
}%
\item[]}{\end{list}}
%%%%%%%%%%%%%%%%%
\newenvironment{@thesistitlepage}{
    \thispagestyle{empty}%
    \begin{center}
    \if@longtitle
      \large
    \else
      \Large
    \fi
    \textbf{\MakeTextUppercase{\textbf{\@ThesisTitle}}}\\[3pt]
    \Large
    \textrm{By}\\[3pt]
    \textrm{\textbf{{Al-Shaimaa Yusuf Diab}}}\\
    \textrm{\textbf{{Abdallah Nagy Brisha}}}\\
    \textrm{\textbf{{Eman Ahmed Zyada}}}\\
    \textrm{\textbf{{Hatem Medhat Elshorbagy}}}\\
    \textrm{\textbf{{Hossam Hassanin Abdelhay}}}\\
    \textrm{\textbf{{Hussein Sobhy El-Shamy}}}\\
    \textrm{\textbf{{Mohamed Saeed Helal}}}\\
    \textrm{\textbf{{Mohamed Shaban Abdelhadi}}}\\
    \textrm{\textbf{{Mohammed Mahmoud Shalaby}}}\\[3pt]
    \large A Thesis Submitted to the\\
        \faculty  at \university\\
        in Partial Fulfillment of the Requirements for the Degree of\\
        \MakeTextUppercase{\textbf{\@Degree}}\\
        in \\ \textbf{\@Specialization} \\[3pt]
         Under the Supervision of\\[3pt]
                \textbf{\@MainSupervisor}\\
                \small Assistant Professor\\
                \small\department\\
                \small\faculty, \university\\[3pt]
                \textrm{\large Technically Sponsored By}\\[3pt]
                \textrm{\textbf{\normalsize Valeo}}\\[3pt]
}
{   \vfill\large
   \MakeTextUppercase{\faculty},\MakeTextUppercase{\university}\\
    \MakeTextUppercase{\city},\MakeTextUppercase{\country}\\
    \MakeTextUppercase{\@SYear}
    \normalsize
    \end{center}
    \newpage
}


%% Hussein

\newenvironment{@thesistitlepagebreif}{
    \thispagestyle{empty}%
    \begin{center}
    \if@longtitle
      \large
    \else
      \Large
    \fi
    \textbf{\MakeTextUppercase{\textbf{\@ThesisTitle}}}\\[3pt]
    \Large
    \textrm{By}\\[3pt]
    \textrm{\textbf{{Al-Shaimaa Yusuf Diab}}}\\
    \textrm{\textbf{{Abdallah Nagy Brisha}}}\\
    \textrm{\textbf{{Eman Ahmed Zyada}}}\\
    \textrm{\textbf{{Hatem Medhat Elshorbagy}}}\\
    \textrm{\textbf{{Hossam Hassanin Abdelhay}}}\\
    \textrm{\textbf{{Hussein Sobhy El-Shamy}}}\\
    \textrm{\textbf{{Mohamed Saeed Helal}}}\\
    \textrm{\textbf{{Mohamed Shaban Abdelhadi}}}\\
    \textrm{\textbf{{Mohammed Mahmoud Shalaby}}}\\[3pt]
    \large A Thesis Submitted to the\\
        \faculty  at \university\\
        in Partial Fulfillment of the Requirements for the Degree of\\
        \MakeTextUppercase{\textbf{\@Degree}}\\
        in \\ \textbf{\@Specialization} \\[3pt]

      
}

%%

\newcommand{\@MakeEnglishCoverPage}{
    \begin{changemargintop}{-1cm}
    \if@praise
        \centerline{\includegraphics{Praise}}
    \fi
    \includegraphics{Logos/FoE.jpg} \hfill
    \if@phero
        \includegraphics{Logos/CU-Phero}
    \else
        \includegraphics{Logos/CU-Logo}
    \fi
    %%\vspace*{0.5in}
    \begin{@thesistitlepage}
    \end{@thesistitlepage}
    \end{changemargintop}
}

\newcommand{\@MakeEnglishCoverPageSponser}{
    \begin{changemargintop}{-1cm}
    \if@praise
        \centerline{\includegraphics{Praise}}
    \fi
    \includegraphics{Logos/FoE.jpg} \hfill
    \if@phero
        \includegraphics{Logos/Valeo.png}
    \else
        \includegraphics{Logos/Valeo.png}
    \fi
    %%\vspace*{0.5in}
    \begin{@thesistitlepage}
    \end{@thesistitlepage}
    \end{changemargintop}
}


\newcommand{\@MakeEnglishSupervisionCommitteePage}{
  %%  \begin{changemarginleft}{20mm}
    %\addtolength{\topmargin}{0.1in}
    \begin{@thesistitlepage}
        Under the Supervision of\\[14pt]
        \ifcase\the@NumberOfCoSupervisors
            % No Co-Supervisors
            \begin{tabular}{c}
                \textbf{\@MainSupervisor}\\
                \small\@MainSupervisorPosition\\
                \small\department\\
                \small\faculty, \university\\
            \end{tabular}
        \or % One Co-Supervisor
            \begin{tabular}{cc}
                \textbf{\@MainSupervisor} &
                \textbf{\@FirstCoSupervisor} \\
                \footnotesize\@MainSupervisorPosition &
                \footnotesize\@FirstCoSupervisorPosition\\
                \footnotesize\department&
                \footnotesize\@FirstCoSupervisorDepartment \\
                \footnotesize\faculty, \university &
                \footnotesize\@FirstCoSupervisorAffiliation\\
            \end{tabular}
        \or % Two Co-Supervisors
            \begin{tabular}{c} 
                \textbf{\@MainSupervisor}\\
                \footnotesize\@MainSupervisorPosition\\
                \footnotesize\department\\
                \footnotesize\faculty, \university
            \end{tabular}
            \begin{tabular}{cc}\\
                \textbf{\@FirstCoSupervisor} &
                \textbf{\@SecondCoSupervisor}\\
                \footnotesize\@FirstCoSupervisorPosition &
                \footnotesize\@SecondCoSupervisorPosition\\
                \footnotesize\@FirstCoSupervisorDepartment&
                \footnotesize\@SecondCoSupervisorDepartment\\
                \footnotesize\@FirstCoSupervisorAffiliation&
                \footnotesize\@SecondCoSupervisorAffiliation\\
            \end{tabular}
        \or % Three Co-Supervisors
            \begin{tabular}{cc}
                \textbf{\@MainSupervisor} &
                \textbf{\@FirstCoSupervisor}\\
                \footnotesize\@MainSupervisorPosition &
                \footnotesize\@FirstCoSupervisorPosition\\
                \footnotesize\department&
                \footnotesize\@FirstCoSupervisorDepartment\\
                \footnotesize\faculty, \university &
                \footnotesize\@FirstCoSupervisorAffiliation\\
            \end{tabular}
            \begin{tabular}{cc} \\
                \textbf{\@SecondCoSupervisor} &
                \textbf{\@ThirdCoSupervisor}\\
                \footnotesize\@SecondCoSupervisorPosition&
                \footnotesize\@ThirdCoSupervisorPosition\\
                \footnotesize\@SecondCoSupervisorDepartment&
                \footnotesize\@ThirdCoSupervisorDepartment\\
                \footnotesize\@SecondCoSupervisorAffiliation&
                \footnotesize\@ThirdCoSupervisorAffiliation
            \end{tabular}
        \fi
    \end{@thesistitlepage}
    %%\end{changemarginleft}
}
\newcommand{\@MakeEnglishExaminingCommitteePage}{
    \begin{@thesistitlepagebreif}
    %%    \begin{quote}
            \begin{tabular}{p{3.5in} 1}
            \\\multicolumn{2}{l}{Approved by the Examining Committee:} \\[3pt]
                \hline
                \textbf{\@MainSupervisor},&Thesis Main Advisor \\[3pt]
                \hline 
                \textbf{\@InternalExaminer},& 1st Examiner \\[3pt]
                \hline   
                \textbf{\@ExternalExaminer},& 2nd Examiner \\[3pt]
                \hline
                 \textbf{\@ExternalExaminer},& 3rd Examiner \\[3pt]
                \hline
            \end{tabular}
%%        \end{quote}

   \vfill\large
   \MakeTextUppercase{\faculty},\MakeTextUppercase{\university}\\
    \MakeTextUppercase{\city},\MakeTextUppercase{\country}\\
    \MakeTextUppercase{\@SYear}
        
    \end{@thesistitlepagebreif}
}
\newcommand{\@MakeEnglishInformationPage}{
 \begin{changemarginleft}{-30mm}
    \thispagestyle{empty}
    \begin{quote}
    \begin{tabular}{lll}
        % Personal Information [1]
        \textbf{Student's Name:}  &Al-Shaimaa Yusuf Teleb Diab&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@shoshop}\\
        \textbf{Date of Birth:}     &01/04/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            &elshaimaa30981255@f-eng.tanta.edu.eg
&\\
        \textbf{Phone:}             &01126045918&\\
        \textbf{Address:}           &Zefta, Gharbia Governorate, 31641&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
                % Personal Information [2]
        \textbf{Student's Name:}  & Abdallah Nagy Mohamed Brisha 
&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@brishap}\\
        \textbf{Date of Birth:}     & 10/12/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            & abdallah30981622@f-eng.tanta.edu.eg
&\\
        \textbf{Phone:}             & 01063735748
&\\
        \textbf{Address:}           &Tanta, Gharbia Governorate, 31733
&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & July 2024&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
                % Personal Information [3]
        \textbf{Student's Name:}  &Eman Ahmed Zyada Al-sherbiny&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@emanp}\\
        \textbf{Date of Birth:}     & 14/09/2001&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            & eman30981302@f-eng.tanta.edu eg
&\\
        \textbf{Phone:}             & 01068737955&\\
        \textbf{Address:}           &El-Santa, Gharbia Governorate, 31631&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
                % Personal Information [4]
        \textbf{Student's Name:}  & Hatem Medhat Mohamed Elshorbagy 
&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@hatemp}\\
        \textbf{Date of Birth:}     & 20/09/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            & hatem30981565@f-eng.tanta.edu.eg
&\\
        \textbf{Phone:}             & 01558090667&\\
        \textbf{Address:}           & El-Santa, Gharbia Governorate, 31667&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
        
\end{tabular}
    
    
    \begin{tabular}{lll}
  % Personal Information [5]
        \textbf{Student's Name:}  &Hossam Hassanin Abdelshahid Abdelhay&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@hossamp}\\
        \textbf{Date of Birth:}     & 22/05/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            & hossam30998689@f-eng.tanta.edu.eg
&\\
        \textbf{Phone:}             & 01554574031&\\
        \textbf{Address:}           & Kafr Elzayat, Gharbia Governorate, 31611&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
                % Personal Information [6]
        \textbf{Student's Name:}  & Hussein Sobhy Sobhy El-Sebaey Hassanin El-Shamy&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@husseinp}\\
        \textbf{Date of Birth:}     & 05/12/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            & hussein30981883@f-eng.tanta.edu.eg&\\
        \textbf{Phone:}             & 01064490820&\\
        \textbf{Address:}           & Basioun, Gharbia Governorate, 31714&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
                % Personal Information [7]
        \textbf{Student's Name:}  & Mohamed Saeed Abdsalam Helal
&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@helalp}\\
        \textbf{Date of Birth:}     & 16/09/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            & mohammed30982076@f-eng.tanta.edu.eg&\\
        \textbf{Phone:}             & 01003670535&\\
        \textbf{Address:}           & Basioun, Gharbia Governorate, 31778&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
                % Personal Information [8]
        \textbf{Student's Name:}  & Mohamed Shaaban Ahmed Abdelhady&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@shabanp}\\
        \textbf{Date of Birth:}     & \@20/08/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}            & mohammed31038894@f-eng.tanta.edu.eg&\\
        \textbf{Phone:}             & 01117508013&\\
        \textbf{Address:}           & Ihnasia, Benisuef Governorate, 62631&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
\end{tabular}

    \begin{tabular}{lll}
                    % Personal Information [9]
        \textbf{Student's Name:}  &Mohammed Mahmoud Mohammed El-Tohamy&
        \multirow{8}{*}{\!\!\!\!\!\!\!\!\!\@shalabyp}\\
        \textbf{Date of Birth:}     &08/03/2000&\\
        \textbf{Nationality:}       & Egyptian&\\
        \textbf{E-mail:}        &mohammed30981976@feng.tanta.edu.eg&\\
        \textbf{Phone:}             &01128088651&\\
        \textbf{Address:}           &El-Santa, Gharbia Governorate, 31631&\\
        \textbf{Registration Date:} & September 2018 &\\
        \textbf{Awarding Date:}     & September 2023&\\
        \textbf{Degree:}            & Bachelor of Science&\\
        \textbf{Department:}        & Electronics and Communications Engineering&\\ & & \\ [3pt]
        \hline \\[3pt]
\end{tabular}

\begin{tabular}{lll}
        \textbf{Supervisor:}       & &\\
                                    & \textbf{\@MainSupervisor}&\\
        & &\\
        \textbf{Examiners:}
            & &\\
            & \textbf{\@MainSupervisor}  &(Thesis Main Advisor)\\
            & \textbf{\@InternalExaminer} &(Internal Examiner) \\
            & \textbf{\@ExternalExaminer} &(External Examiner)\\
    \end{tabular}\\
    \textbf{Title of Thesis:}
        \begin{center}
            \textbf{\@ThesisTitle}
        \end{center}

    \textbf{Key Words:}\\ \@ThesisKeywords


    \textbf{Summary:}\\ \@ThesisSummary
    \end{quote}
 
    \newpage
      \end{changemarginleft}
}
\newcommand{\@SMonthText}{
\ifcase\@SMonth\relax
\or January
\or February
\or March
\or April
\or May
\or June
\or July
\or August
\or September
\or October
\or November
\or December
\fi
}
\newcommand{\@NNChapter}[1]{
    \newpage
    \@NNChapterTitle{#1}
    \addcontentsline{toc}{chapter}{#1}
}
\newcommand{\@NNChapterTitle}[1]{
    \centerline{\textbf{\Huge #1}}
     \vspace*{24pt}
}

\def\@makechapterhead#1{
  {
  \huge\bfseries
  \settowidth{\@chapterheadwidth}{\@chapapp~\thechapter:~#1}
  \ifnum \@chapterheadwidth < \textwidth
    \begin{center} % The required centering of one-line chapter headers
        \@chapapp~\thechapter:~#1
    \end{center}
  \else % Flush-left multi-line chapter header
    \begin{flushleft}
        \@chapapp~\thechapter: #1
    \end{flushleft}
  \fi
  }
  \vspace*{4pt}
}
\newlength{\@chapterheadwidth}
\newenvironment{hcfigure}
{
     \begin{hfigure}
        \begin{center}
}
{
        \end{center}
     \end{hfigure}
}
\newenvironment{hfigure}{\def\@captype{figure}}{}
\newenvironment{hctable}[2]
{
    \begin{htable}
        \caption{#1}
        \label{Table:#2}
        \begin{center}
            \begin{tabular}{c}
}
{           \end{tabular}
        \end{center}
    \end{htable}
}
\newenvironment{htable}{\def\@captype{table}}{}
\newlength{\nomenclaturelabelwidth}
\setlength{\nomenclaturelabelwidth}{1.0in}
\makenomenclature \makeindex
\def\thenomenclature{%
    \@NNChapter{List of Symbols and Abbreviations}
    \nompreamble
    \list{}{%
        \labelwidth\nom@tempdim
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \itemsep\nomitemsep
        \let\makelabel\nomlabel
    }
}

\newcommand{\gchapter}[1]{
  \ifnum \c@secnumdepth >\m@ne
    \refstepcounter{chapter}
    \typeout{\@chapapp\space\thechapter.}
    \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}
  \else
    \addcontentsline{toc}{chapter}{#1}
  \fi
}

\appendixtitletocon\appendixpageoff\appendixtocoff
\numberwithin{equation}{chapter}
\renewcommand{\theequation}{\thechapter.\arabic{equation}}
\RequirePackage{color}

\newcommand{\TableOfContents}{
    \@NNChapter{Table of Contents}
    \@starttoc{toc}
}
\newcommand{\ListOfTables}{
    \if@listoftables
        \@NNChapter{List of Tables}
        \@starttoc{lot}
    \fi
}
\newcommand{\ListOfFigures}{
    \if@listoffigures
        \@NNChapter{List of Figures}
        \@starttoc{lof}
    \fi
}
\newcommand{\ListOfAlgorithms}{
    \if@listofalgorithms
        \@NNChapter{List of Algorithms}
        \@starttoc{loa}
    \fi
}
\newcommand{\Nomenclature}{
    \printnomenclature[\nomenclaturelabelwidth]
}



\AtBeginDocument{
    \@MakeEnglishCoverPage
    \@MakeEnglishCoverPageSponser
    %%\@MakeEnglishSupervisionCommitteePage
    \@MakeEnglishExaminingCommitteePage
    \@MakeEnglishInformationPage
    \pagenumbering{roman}
    \pagestyle{plain}
    \setcounter{page}{1}

}

\endinput
%%
%% End of file `cufethesis.cls'.
