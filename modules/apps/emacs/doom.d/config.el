(setq user-full-name "Bernardo Hummes Flores"
        user-mail-address "hummes@ieee.org")
;;  (setq user-full-name "BHF")

(setq doom-font (font-spec :family "Source Code Pro" :size 14))
;;  (setq doom-font (font-spec :family "Inconsolata" :size 16))

;(setq doom-theme 'doom-dracula)
;(setq doom-theme 'doom-laserwave)
(setq doom-theme 'doom-acario-dark)

(setq doom-modeline-icon nil)

(setq default-tab-width 2)
(custom-set-variables '(tab-width 2))

(setq undo-limit 80000000
      evil-want-fine-undo t)

(setq display-line-numbers-type 'relative)

(setq show-trailing-whitespace t)

(setq +latex-viewers '(zathura))

;;(use-package company
;;  :config
;;  (define-key company-active-map (kbd "<return>") nil)
;;  (define-key company-active-map (kbd "RET") nil)
;;  (define-key company-active-map (kbd "C-SPC") #'company-complete-selection))

;;(use-package helm
;;    :config
;;    (setq helm-M-x-fuzzy-match t
;;          helm-apropos-fuzzy-match t
;;          helm-buffers-fuzzy-matching t
;;          helm-semantic-fuzzy-matching t
;;          helm-sessions-fuzzy-matching t
;;          helm-locate-fuzzy-matching t
;;          helm-imenu-fuzzy-match t
;;          helm-recentf-fuzzy-match t))

(setq bibtex-completion-bibliography
      '("~/mega/org/library.bib"
        ))

(setq bibtex-completion-pdf-field "File")

(map! :leader
    :prefix "o"
    :desc "helm-bibtex" "b" #'helm-bibtex)

;;  (setq ivy-use-virtual-buffers t)

;;  (after! ivy-bibtex
;;      (map! :leader
;;          :prefix "i"
;;          :desc "ivy-bibtex" "l" #'ivy-bibtex))

(setq org-jekyll-project-root "~/Documents/birromer.github.io/")

(use-package ox-latex
  :after ox
  :after org
  :custom
  (org-latex-image-default-width "1\\linewidth")
  (org-latex-packages-alist
   `((,(concat "cache=false,outputdir=" org-export-default-output-folder) "minted")
     ("T1" "fontenc")
     ("" "placeins")))
  (org-latex-listings 'minted)
  (org-latex-minted-options
   '(("breaklines")
     ("breakafter" "d")
     ("linenos" "true")
     ("xleftmargin" "\\parindent")))
  (org-latex-pdf-process
   '("latexmk -pdfxelatex='xelatex -shell-escape -interaction=nonstopmode' -f -xelatex -outdir=%o %f"
     "latexmk -pdfxelatex='xelatex -shell-escape -interaction=nonstopmode' -f -xelatex -outdir=%o %f"
     "latexmk -pdfxelatex='xelatex -shell-escape -interaction=nonstopmode' -f -xelatex -outdir=%o %f"))
  :config
  (add-to-list 'org-latex-classes
           '("iiufrgs"
         "\\documentclass{iiufrgs}"
         ("\\chapter{%s}"       . "\\chapter*{%s}")
         ("\\section{%s}"       . "\\section*{%s}")
         ("\\subsection{%s}"    . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
         ("\\paragraph{%s}"     . "\\paragraph*{%s}")))
  (add-to-list 'org-latex-classes
           '("newlfm"
         "\\documentclass{newlfm}"
         ("\\chapter{%s}"       . "\\chapter*{%s}")
         ("\\section{%s}"       . "\\section*{%s}")
         ("\\subsection{%s}"    . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (add-to-list 'org-latex-classes
           '("if-beamer"
         "\\documentclass{if-beamer}"
         ("\\chapter{%s}"       . "\\chapter*{%s}")
         ("\\section{%s}"       . "\\section*{%s}")
         ("\\subsection{%s}"    . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (add-to-list 'org-latex-classes
           '("IEEEtran"
         "\\documentclass{IEEEtran}"
         ("\\section{%s}"       . "\\section*{%s}")
         ("\\subsection{%s}"    . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
         ("\\paragraph{%s}"     . "\\paragraph*{%s}")
         ("\\subparagraph{%s}"  . "\\subparagraph*{%s}"))))
  ;(add-to-list 'org-structure-template-alist
  ;             '(,"B"
  ;"#+TITLE:
  ;,#+AUTHOR:
  ;,#+EMAIL:
  ;,#+DATE:   \\today
  ;,#+DESCRIPTION:
  ;,#+KEYWORDS:
  ;,#+LANGUAGE: en
  ;,#+LaTeX_HEADER: \\institute[short]{long}

  ;,#+STARTUP: beamer
  ;,#+STARTUP: oddeven
  ;,#+STARTUP: latexpreview

  ;,#+LaTeX_CLASS: beamer
  ;,#+LaTeX_CLASS_OPTIONS: [bigger]
  ;,#+latex_class_options: [9pt]

  ;,#+BEAMER_THEME: Frankfurt

  ;,#+OPTIONS:   H:2 toc:t

  ;,#+SELECT_TAGS: export
  ;,#+EXCLUDE_TAGS: noexport

  ;,#+latex_header: \\usepackage{amsmath}
  ;,#+latex_header: \\usepackage{amsfonts}
  ;,#+latex_header: \\usepackage{amssymb}

  ;,#+latex_header: \\useinnertheme[shadow=false]{rounded}
  ;,#+latex_header: \\usecolortheme{orchid}
  ;,#+begin_src latex
  ;,\\setbeamertemplate{footline}
  ;,{
  ;,    \\leavevmode%
  ;,    \\hbox{%
  ;,        \\begin{beamercolorbox}[wd=.333333\\paperwidth,ht=1.55ex,dp=1ex,center]{author in head/foot}%
  ;,            \\usebeamerfont{author in head/foot}\\insertshortauthor
  ;,        \\end{beamercolorbox}%
  ;,        \\begin{beamercolorbox}[wd=.333333\\paperwidth,ht=1.55ex,dp=1ex,center]{title in head/foot}%
  ;,            \\usebeamerfont{title in head/foot}\\insertshorttitle
  ;,        \\end{beamercolorbox}%
  ;,        \\begin{beamercolorbox}[wd=.333333\\paperwidth,ht=1.55ex,dp=1ex,right]{date in head/foot}%
  ;,            \\usebeamerfont{institute in head/foot}\\insertshortinstitute{}\\hspace*{2em}
  ;,            \\insertframenumber{} / \\inserttotalframenumber\\hspace*{2ex}
  ;,        \\end{beamercolorbox}}%
  ;,        \\vskip0pt%
  ;,}
  ;,,#+end_src


  ;,,* Emacs setup :noexport:
  ;,# Local Variables:
  ;,# eval: (add-to-list 'load-path ".")
  ;,# eval: (indent-tabs-mode nil)
  ;,# eval: (tab-width 4)
  ;,# eval: (fill-column 70)
  ;,# eval: (sentence-end-double-space t)
  ;,# eval: (org-edit-src-content-indentation 0)
  ;,# eval: (org-adapt-indentation nil)
  ;,# eval: (org-list-two-spaces-after-bullet-regexp nil)
  ;,# eval: (org-list-description-max-indent 5)
  ;,# eval: (org-blank-before-new-entry '((heading . auto) (plain-list-item . auto)))
  ;,# eval: (set-input-method 'TeX)
  ;,# eval: (org-pretty-entities t)
  ;,# End:\n\n? "))

(map! :leader
      :prefix "c"
      :desc "org-latex-export-to-pdf" "p" #'org-latex-export-to-pdf)

(map! :leader
      :prefix "c"
      :desc "org-beamer-export-to-pdf" "b" #'org-beamer-export-to-pdf)

(global-set-key (kbd "C-c C-g") 'org-preview-latex-fragment)

(advice-add 'org-export-numbered-headline-p :around
            (lambda (orig headline info)
              (and (funcall orig headline info)
                   (not (org-element-property :UNNUMBERED headline)))))



(setq hypothesis-username "birromer")
(setq hypothesis-token "6879-kTl5hR8KRzyVYL5u78DzJdD0Rt0wx0EIpcPHQdmW2y0")

(setq hypothesis-archive "~/mega/org/roam/20211109230343-hypothesis_archive.org")

;;  (use-package esup
;;    ;; To use MELPA Stable use ":pin melpa-stable",
;;    :pin melpa)

;;  (use-package benchmark-init
;;    :config
;;    ;; To disable collection of benchmark data after init is done.
;;    (add-hook 'after-init-hook 'benchmark-init/deactivate))

(setq org-directory "~/mega/org/")

(setq org-startup-folded t)
(setq org-startup-indented t)
(setq org-fontify-done-headline t)
(setq org-fontify-todo-headline t)
(setq org-src-fontify-natively t)

(use-package org-tempo
  :config
  (add-to-list 'org-structure-template-alist '("th" . "theorem"))
  (add-to-list 'org-structure-template-alist '("de" . "definition"))
  (add-to-list 'org-structure-template-alist '("re" . "remark"))
  (add-to-list 'org-structure-template-alist '("pr" . "proof"))
  (add-to-list 'org-structure-template-alist '("le" . "lemma"))
  (add-to-list 'org-structure-template-alist '("pro" . "proposition"))
)

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-superstar  ;; improved bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(use-package org-fancy-priorities
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("+" "+" "+")))

(setq org-log-done t)
(setq org-agenda-file '("~/mega/org/notes.org"
                        "~/mega/org/todo.org"))

(after! org
    (setq org-todo-keywords '((sequence "TODO(t)" "LOOP(r)" "START(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)" "KILLED(k)")
                              (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[x](D)")
                              (sequence "OKAY(o)" "YES(y)" "|" "NO(n)" ))
  ))

(after! org
  (setq org-priority-faces '((65 :foreground "#e45649")
                             (66 :foreground "#da8548")
                             (67 :foreground "#0098dd"))))

(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)
(setq org-agenda-files "~/mega/org/roam/daily/")
;;                       "~/mega/org/roam/"
;;                       "~/mega/org/")
(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 1)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Work"
                           :tag  "Work"
                           :order 3)
                          (:name "Dissertation"
                           :tag "Dissertation"
                           :order 7)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Essay 1"
                           :tag "Essay1"
                           :order 2)
                          (:name "Reading List"
                           :tag "Read"
                           :order 8)
                          (:name "Work In Progress"
                           :tag "WIP"
                           :order 5)
                          (:name "Blog"
                           :tag "Blog"
                           :order 12)
                          (:name "Essay 2"
                           :tag "Essay2"
                           :order 3)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-dir "~/mega/org/roam/daily/")
  (org-journal-time-prefix "* ")
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %m %Y"))
(setq org-journal-enable-agenda-integration t)

(use-package! org-ref
    :after org
    :preface
    (defconst birromer/user-org-ref-path
      (expand-file-name "~/mega/org/"))
    :custom
    (org-ref-bibliography-notes "~/mega/org/notes.org")
    (org-ref-default-bibliography '("~/mega/org/library.bib"))
    (reftex-default-bibliography '("~/mega/org/library.bib"))
    (org-ref-completion-library 'org-ref-cite-insert-helm)
    (org-ref-insert-cite-function 'org-ref-cite-insert-helm)
    (org-ref-insert-label-function 'org-ref-cite-insert-helm)
    (org-ref-insert-ref-function 'org-ref-cite-insert-helm)
    (org-ref-show-broken-links nil)
    (org-ref-notes-directory birromer/user-org-ref-path)

    :init
    :general
    (:states '(normal visual)
     :keymaps 'org-mode-map
     :prefix "m"
     "m c" 'org-ref-cite-hydra/body)
    :config
    (require 'doi-utils)
    )

  (map! :leader
        :prefix "i"
        :desc "insert citation link" "l" #'org-ref-insert-link)

(setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
       org-ref-insert-cite-function 'org-ref-cite-insert-helm
       org-ref-insert-label-function 'org-ref-insert-label-link
       org-ref-insert-ref-function 'org-ref-insert-ref-link
       org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))

 (setq org-src-fontify-natively t
       org-confirm-babel-evaluate nil
       org-src-preserve-identation t)


 (setq bibtex-completion-bibliography '("~/mega/org/library.bib")
;       bibtex-completion-library-path '("~/Dropbox/emacs/bibliography/bibtex-pdfs/")
       bibtex-completion-pdf-field "File"
       bibtex-completion-notes-path "~/mega/org/notes.org"
       bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"

       bibtex-completion-additional-search-fields '(keywords)
       bibtex-completion-display-formats
         '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
           (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
           (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
           (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
           (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
      bibtex-completion-pdf-open-function
      (lambda (fpath)
        (call-process "open" nil 0 nil fpath)))

(use-package! toc-org
  :defer t
  :hook
  (org-mode-hook . toc-org-mode))

(setq org-roam-directory "~/mega/org/roam/")

(after! org-roam
      (map! :leader
          :prefix "n"
          :desc "org-roam" "l" #'org-roam
          :desc "org-roam-node-insert" "i" #'org-roam-node-insert
          :desc "org-roam-node-find" "f" #'org-roam-node-find
          :desc "org-roam-buffer-toggle" "b" #'org-roam-buffer-toggle
          :desc "org-roam-graph" "g" #'org-roam-graph
          :desc "org-roam-capture-today" "N" #'org-roam-dailies-capture-today
          :desc "org-roam-capture" "c" #'org-roam-capture)
      (setq org-roam-ref-capture-templates
            '(("r" "ref" plain (function org-roam-capture--get-point)
               "%?"
               :file-name "websites/${slug}"
               :head "#+TITLE: ${title}\n,#+ROAM_KEY: ${ref}\n- source :: ${ref}"
               :unnarrowed t)
              ("t" "text" plain (function org-roam-capture--get-point)
               "%?"
               :file-name "${slug}"
               :head "#+TITLE: ${title}
#+LANGUAGE: en
#+OPTIONS: broken-links:t toc:nil
#+STARTUP: overview indent
#+TAGS: noexport(n) deprecated(d) ignore(i)
#+EXPORT_SELECT_TAGS: export
#+EXPORT_EXCLUDE_TAGS: noexport
#+LATEX_CLASS: article
#+LATEX_CLASS_OPTIONS: [a4paper, 11pt, english]
#+Latex_HEADER: \\usepackage[utf8]{inputenc}

* metadata :noexport:
  - tags :: [[id:61e0b309-641e-47b7-b6b6-d966b65e9900][no_tag]]"
               :unnarrowed t))))

(require 'company-org-roam)
(use-package company-org-roam
  :when (featurep! :completion company)
  :after org-roam :config
  (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/mega/org/roam/"
    "~/mega/org/roam/daily/"))

(use-package! org-roam-bibtex
  :load-path "~/mega/org/library.bib"
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
         (("C-c n a" . orb-note-actions))))
(setq orb-templates
      '(("r" "ref" plain (function org-roam-capture--get-point) ""
         :file-name "${citekey}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n" ; <--
         :unnarrowed t)))
(setq orb-preformat-keywords '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))

(setq orb-templates
      '(("n" "ref+noter" plain (function org-roam-capture--get-point)
         ""
         :file-name "${slug}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n#+ROAM_TAGS:

- tags ::
- keywords :: ${keywords}
\* ${title}
:PROPERTIES:
:Custom_ID: ${citekey}
:URL: ${url}
:AUTHOR: ${author-or-editor}
:NOTER_DOCUMENT: %(orb-process-file-field \"${citekey}\")
:NOTER_PAGE:
:END:")))

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

(setq-default flycheck-disable-checkers '(python-pylint))