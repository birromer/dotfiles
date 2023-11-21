(setq user-full-name "Bernardo Hummes"
        user-mail-address "hummes@ieee.org")
;;  (setq user-full-name "BHF")

;;  (setq doom-font (font-spec :family "Source Code Pro" :size 14))
;;  (setq doom-font (font-spec :family "Inconsolata" :size 14))
  (setq doom-font (font-spec :family "Mononoki" :size 14))
;;  (setq doom-unicode-font (font-spec :family "JuliaMono" :size 14))
  (setq doom-unicode-font (font-spec :family "XITS Math" :size 14))
  ; (add-to-list 'doom-symbol-fallback-font-families '("MesloLGS NF"))

;(use-package! unicode-fonts
;  :config
;  ;; Common math symbols
;  (dolist (unicode-block '("Mathematical Alphanumeric Symbols"))
;    (push "JuliaMono" (cadr (assoc unicode-block unicode-fonts-block-font-mapping)))))
;  (dolist (unicode-block '("Greek and Coptic"))
;    (push "Sarasa Mono CL" (cadr (assoc unicode-block unicode-fonts-block-font-mapping))))

(setq doom-theme 'doom-dracula)
;(setq doom-theme 'doom-laserwave)
;(setq doom-theme 'doom-acario-dark)

(setq doom-modeline-icon nil)

(setq default-tab-width 2)
(custom-set-variables '(tab-width 2))
(setq tab-width 2)

(setq undo-limit 80000000
      evil-want-fine-undo t)

(setq display-line-numbers-type 'relative)

(setq show-trailing-whitespace t)

(setq +latex-viewers '(zathura))

(setq bibtex-completion-bibliography
      '("~/mega/org/library.bib"
        ))

(setq bibtex-completion-pdf-field "File")

(map! :leader
    :prefix "o"
    :desc "helm-bibtex" "b" #'helm-bibtex)

(use-package ox-latex
  :after ox :after org
  :custom
  (org-latex-image-default-width "1\\linewidth")
  (org-latex-packages-alist
   `((,(concat "cache=false,outputdir=" org-export-default-output-folder)
      "minted") ("T1" "fontenc") ("" "placeins")))
  (org-latex-listings 'minted)
  (org-latex-minted-options '(("breaklines") ("breakafter" "d") ("linenos"
                                                                 "true") ("xleftmargin" "\\parindent")))
  (org-latex-pdf-process '("latexmk -pdflatex='lualatex -shell-escape' -pdf -bibtex -f %f"))

  :config
  (add-to-list
   'org-latex-classes
   '("iiufrgs" "\\documentclass{iiufrgs}" ("\\chapter{%s}" .
                                           "\\chapter*{%s}") ("\\section{%s}" . "\\section*{%s}") ("\\subsection{%s}" .
                                           "\\subsection*{%s}") ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                                           ("\\paragraph{%s}" . "\\paragraph*{%s}")))
  (add-to-list 'org-latex-classes
   '("newlfm" "\\documentclass{newlfm}" ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}") ("\\subsection{%s}" .
                                           "\\subsection*{%s}") ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (add-to-list 'org-latex-classes '("if-beamer" "\\documentclass{if-beamer}"
                                    ("\\chapter{%s}" . "\\chapter*{%s}") ("\\section{%s}" . "\\section*{%s}")
                                    ("\\subsection{%s}" . "\\subsection*{%s}") ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (add-to-list 'org-latex-classes
               '("mimosis"
                 "\\documentclass{mimosis}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  [EXTRA]
  \newcommand{\mboxparagraph}[1]{\paragraph{#1}\mbox{}\}
  \newcommand{\mboxsubparagraph}[1]{\subparagraph{#1}\mbox{}\}"
                 ("\\chapter{%s}" . "\\addchap{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes '("IEEEtran"
                                    "\\documentclass{IEEEtran}" ("\\section{%s}" . "\\section*{%s}")
                                    ("\\subsection{%s}" . "\\subsection*{%s}") ("\\subsubsection{%s}" . "\\subsubsection*{%s}") ("\\paragraph{%s}" . "\\paragraph*{%s}")
                                    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(map! :leader
      :prefix "c"
      :desc "org-latex-export-to-pdf" "p" #'org-latex-export-to-pdf)

(map! :leader
      :prefix "c"
      :desc "org-beamer-export-to-pdf" "b" #'org-beamer-export-to-pdf)

(map! :leader
      :prefix "c"
      :desc "org-hugo-export-to-md" "h" #'org-hugo-export-to-md)

(setq org-latex-create-formula-image-program 'dvipng)
(global-set-key (kbd "C-c C-g") 'org-toggle-latex-fragment)

(use-package! ox-extra
  :after org
  :config
  (ox-extras-activate '(ignore-headlines)))

(advice-add 'org-export-numbered-headline-p :around
            (lambda (orig headline info)
              (and (funcall orig headline info)
                   (not (org-element-property :UNNUMBERED headline)))))

(use-package ox-hugo
  :config
  (setq org-hugo-base-dir (file-truename "~/Sites/bernardo/"))
  (setq org-hugo-section "post"))

;;  (add-to-list 'load-path "/opt/ros/melodic/share/emacs/site-lisp")
;;  (require 'rosemacs-config)

;;  ;; run catkin_make
;;  (defun ros-catkin-make (dir)
;;    "Run catkin_make command in DIR."
;;    (interactive (list (read-directory-name "Directory: ")))
;;    (let* ((default-directory dir)
;;           (compilation-buffer-name-function (lambda (major-mode-name) "*catkin_make*")))
;;      (compile "catkin_make"))
;;    )

;;  ;; generate compile_commands.json
;;  (defun ros-catkin-make-json (dir)
;;    "Run catkin_make command in DIR."
;;    (interactive (list (read-directory-name "Directory: ")))
;;    (let* ((default-directory dir)
;;           (compilation-buffer-name-function (lambda (major-mode-name) "*catkin_make*")))
;;      (compile "catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ."))
;;    )

;;  (defun ros-catkin-make-debug (dir)
;;    "Run catkin_make with Debug mode in DIR."
;;    (interactive (list (read-directory-name "Directory: ")))
;;    (let* ((default-directory dir)
;;           (compilation-buffer-name-function (lambda (major-mode-name) "*catkin_make*")))
;;      (compile "catkin_make -DCMAKE_BUILD_TYPE=Debug"))
;;    )

;;(global-set-key (kbd "C-x C-r M") 'ros-catkin-make)
;;(global-set-key (kbd "C-x C-r C-j") 'ros-catkin-make-json)

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

; (use-package spell-fu
;   :config
;   (add-hook 'spell-fu-mode-hook
;     (lambda ()
;      (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "en"))
;      (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "fr"))
;      (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "pt"))))

(map! :leader
    :prefix "m"
    :desc "writeroom" "w" #'+zen/toggle-fullscreen)

(use-package writeroom-mode
  :config
  (add-to-list 'org-structure-template-alist '("th" . "theorem"))
  (add-to-list 'org-structure-template-alist '("eq" . "equation"))
  (add-to-list 'org-structure-template-alist '("ex" . "example"))
  (add-to-list 'org-structure-template-alist '("de" . "definition"))
  (add-to-list 'org-structure-template-alist '("re" . "remark"))
  (add-to-list 'org-structure-template-alist '("pr" . "proof"))
  (add-to-list 'org-structure-template-alist '("le" . "lemma"))
  (add-to-list 'org-structure-template-alist '("pro" . "proposition"))
)

(setq org-directory "~/mega/org/")

(setq org-startup-folded t)
(setq org-startup-indented t)
(setq org-fontify-done-headline t)
(setq org-fontify-todo-headline t)
(setq org-src-fontify-natively t)

(use-package org-tempo
  :config
  (add-to-list 'org-structure-template-alist '("th" . "theorem"))
  (add-to-list 'org-structure-template-alist '("eq" . "equation"))
  (add-to-list 'org-structure-template-alist '("ex" . "example"))
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
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
  )

(use-package org-fancy-priorities
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("+" "+" "+")))

;(setq org-capture-templates
;      '(("n" "Notes" entry
;         (file "~/mega/org/notes/inbox.org") "* %^{Description} %^g\n Added: %U\n%?")
;        ))

(use-package org-fancy-priorities
    :config
  (defun org-hugo-new-subtree-post-capture-template ()
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
;                 (file+olp "all-posts.org" "Capture")
                 (file "~/mega/org/roam/content-org/all-posts.org")
                 (function org-hugo-new-subtree-post-capture-template))))

(after! org
    (setq org-todo-keywords '((sequence "TODO(t)" "OPEN(o)" "STARTED(s)" "WAIT(w)" "IDEA(i)" "|" "DONE(d)" "CLOSED(c)" "KILLED(k)")
                              (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[x](D)"))
  ))

(setq org-todo-keyword-faces
    (quote (("TODO" :foreground "red" :weight bold)
            ("OPEN" :foreground "sky blue" :weight bold)
            ("STARTED" :foreground "light blue" :weight bold)
            ("WAIT" :foreground "orange" :weight bold)
            ("IDEA" :foreground "orange" :weight bold)
            ("DONE" :foreground "forest green" :weight bold)
            ("CLOSED" :foreground "forest green" :weight bold)
            ("KILLED" :foreground "forest green" :weight bold))))

;;(setq-default org-export-with-todo-keywords nil)

(setq org-log-done t)
(setq org-agenda-file '("~/mega/org/todo.org"))
;; "~/mega/org/notes.org"

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
(setq org-agenda-files "~/mega/org/todo.org")
;;                       "~/mega/org/roam/")
;;                       "~/mega/org/")
;(setq org-agenda-custom-commands
;      '(("o" "Overview"
;         ((agenda "" ((org-agenda-span 'day)
;                      (org-super-agenda-groups
;                       '((:name "Today"
;                          :time-grid t
;                          :date today
;                          :todo "TODAY"
;                          :scheduled today
;                          :order 1)))))
;          (alltodo "" ((org-agenda-overriding-header "")
;                       (org-super-agenda-groups
;                        '((:name "Next to do"
;                           :todo "NEXT"
;                           :order 1)
;                          (:name "Important"
;                           :tag "Important"
;                           :priority "A"
;                           :order 1)
;                          (:name "Due Today"
;                           :deadline today
;                           :order 2)
;                          (:name "Due Soon"
;                           :deadline future
;                           :order 8)
;                          (:name "Overdue"
;                           :deadline past
;                           :face error
;                           :order 7)
;                          (:name "Work"
;                           :tag  "Work"
;                           :order 3)
;                          (:name "Dissertation"
;                           :tag "Dissertation"
;                           :order 7)
;                          (:name "Emacs"
;                           :tag "Emacs"
;                           :order 13)
;                          (:name "Projects"
;                           :tag "Project"
;                           :order 14)
;                          (:name "Essay 1"
;                           :tag "Essay1"
;                           :order 2)
;                          (:name "Reading List"
;                           :tag "Read"
;                           :order 8)
;                          (:name "Work In Progress"
;                           :tag "WIP"
;                           :order 5)
;                          (:name "Blog"
;                           :tag "Blog"
;                           :order 12)
;                          (:name "Essay 2"
;                           :tag "Essay2"
;                           :order 3)
;                          (:name "Trivial"
;                           :priority<= "E"
;                           :tag ("Trivial" "Unimportant")
;                           :todo ("SOMEDAY" )
;                           :order 90)
;                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

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
  :ensure t
  :preface
  (defconst birromer/user-org-ref-path
    (expand-file-name "~/mega/org/"))
  :init
  (with-eval-after-load 'ox
    (defun my/org-ref-process-buffer--html (backend)
      (when (org-export-derived-backend-p backend 'html)
        (org-ref-process-buffer 'html)))
    (add-to-list 'org-export-before-parsing-hook #'my/org-ref-process-buffer--html))

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

;;(use-package! ob-sagemath
;;  :after org
;;  :custom
;;  ;; Ob-sagemath supports only evaluating with a session.
;;  (setq org-babel-default-header-args:sage '((:session . t)
;;                                             (:results . "output")))
;;
;;  ;; C-c c for asynchronous evaluating (only for SageMath code blocks).
;;  (with-eval-after-load "org"
;;    (define-key org-mode-map (kbd "C-c c") 'ob-sagemath-execute-async))
;;
;;  ;; Do not confirm before evaluation
;;  (setq org-confirm-babel-evaluate nil)
;;
;;  ;; Do not evaluate code blocks when exporting.
;;  (setq org-export-babel-evaluate nil)
;;
;;  ;; Show images when opening a file.
;;  (setq org-startup-with-inline-images t)
;;
;;  ;; Show images after evaluating code blocks.
;;  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

(setq org-roam-directory "~/mega/org/roam/")
  (setq org-roam-completion-everywhere t)
;  (setq find-file-visit-truename t)

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
      (setq org-roam-list-files-commands '(find fd fdfind rg))
      (setq org-roam-mode-sections
       (list #'org-roam-backlinks-section
             #'org-roam-reflinks-section
             #'org-roam-unlinked-references-section
            ))
      (setq org-roam-capture-templates
      '(("a" "(add) personal note" plain
         "%?"
         :if-new (file+head "main/${slug}.org"
                            "#+title: ${title}\n
* COMMENT Metadata
- date created :: %t
- tags ::
- related :: \n
* Setup :ignore:
#+startup: nofold
#+latex_class: article
#+LATEX_CLASS_OPTIONS: [a4paper, 12pt, english, leqno, hidelinks]
#+setupfile: ../org.setup
#+options: broken-links:auto
#+hugo_base_dir: ../
#+hugo_section: note
#+hugo_auto_set_lastmod: t
#+hugo_custom_front_matter: :link-citations true
#+print_bibliography: keyword\n
* COMMENT TODO\n\n
* Notes :ignore:\n\n
* Bibliography :ignore:
\\printbibliography")
         :immediate-finish t
         :unnarrowed t)
        ("n" "phd note" plain
         "%?"
         :if-new (file+head "notes/${slug}.org"
                            "#+title: ${title}\n
* COMMENT Metadata
- date created :: %t
- tags ::
- related :: \n
* Setup :ignore:
#+startup: nofold
#+latex_class: article
#+LATEX_CLASS_OPTIONS: [a4paper, 12pt, english, leqno, hidelinks]
#+setupfile: ../org.setup
#+options: broken-links:auto
#+hugo_base_dir: ../
#+hugo_section: note
#+hugo_auto_set_lastmod: t
#+hugo_custom_front_matter: :link-citations true
#+print_bibliography: keyword\n
* COMMENT TODO\n\n
* Notes :ignore: \n\n
* Bibliography :ignore:
\\printbibliography")
         :immediate-finish t
         :unnarrowed t)
        ("h" "human" plain "%?"
         :if-new
         (file+head "main/${title}.org"
                    "#+title: ${title}\n#+startup: nofold\n\n* metadata :ignore:\n- date created :: %t\n- tags :: [[id:32ac744b-c312-435e-9406-55fb38aa9085][person]]\n\n* Information\nPhone:\nEmail:\nAddress:\nOccupation:\nBirthday:\nHow did we meet: \n\n* Notes ")
         :immediate-finish t
         :unnarrowed t)
        ("m" "meeting" plain "%?"
         :if-new
         (file+head "notes/meeting_%<%Y_%m_%d>_with_${slug}.org"
                    "
#+filetags: meeting\n
#+title:Meeting %<%A, %d %B %Y> with ${title}
#+topic: \n
#+startup: nofold\n#+date: %t\n\n* metadata :ignore:\n- tags :: [[id:26b5de5d-2806-4b7d-b7d3-b785c231f137][meeting]] \n- attendees :: \n\n* Agenda \n 1. \n\n* Notes\n")
         :immediate-finish t
         :unnarrowed t)
        ("r" "recipe" plain
         "%?"
         :if-new (file+head "recipes/${slug}.org"
                            "#+title: ${title}\n
* COMMENT Metadata
- date created :: %t
- tags :: [[id:0a0955ea-16a0-4014-be78-6c77a7956c58][recipe]]
- ingredients ::
#+filetags: recipe\n
* Setup :ignore:
#+startup: nofold
#+options: toc:nil H:2 tags:nil broken-links:auto title:nil
#+latex_class: book
#+latex_class_options: [twosides, 12pt]
#+latex_header: \\usepackage[utf8]{inputenc}
#+latex_header: \\usepackage[T1]{fontenc}
#+latex_header: \\usepackage[]{../files/tex/cuisine}\n
* Contents :ignore:
** Overview :ignore:\n
\\recette{${title}}
\\preptime{20 min}
\\cooktime{20 min}
\\baketime{210\\textdegree C, 45 min}
\\cooltime{ 20 min}
\\people{6}
\\robot{}\n
** Ingredients :ignore:\n
#+latex: \\begin{recipe}{
#+begin_src latex
\\unit[1.5]{kg} & ingredient 1 \\\\
\\unit[1]{l}    & ingredient 2
#+end_src\n
** Instructions :ignore:\n
#+latex: }{
#+begin_src latex
\\item step 1
\\item step 2
#+end_src
#+latex: }\\end{recipe}\n
** Extra :ignore:\n
\\info{information about the recipe, something to take care of.}
\\photo{~/mega/org/roam/files/img/poset_cat_ex.jpg}")
         :immediate-finish t
         :unnarrowed t)
        ("t" "tree note" plain
         "%?"
         :if-new (file+head "../../forest/trees/${slug}.org"
                            "\\title{${title}}
\\date{%<%Y-%m-%d>}
\\author{bernardohummes}
\\taxon{}
\\meta{}
\\import{}
\\export{}\n
\\p{}")
         :immediate-finish t
         :unnarrowed t)
        ("p" "hugo post" plain "%?"
         :if-new
         (file+head "post/${title}.org" "#+title: ${title}\n#+filetags: :article:\n")
         :immediate-finish t
         :unnarrowed t)))
      )

(setq org-roam-dailies-directory "~/mega/org/roam/daily/")

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
  (deft-directory "~/mega/org/roam/"))

(use-package! org-roam-bibtex
  :load-path "~/mega/org/roam/library.bib"
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
         (("C-c n a" . orb-note-actions))))
(setq orb-templates
      '(("r" "ref" plain (function org-roam-capture--get-point) ""
         :file-name "${citekey}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n"
         :unnarrowed t)))
(setq orb-preformat-keywords '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))

(setq orb-templates
      '(("n" "ref+noter" plain (function org-roam-capture--get-point)
         ""
         :file-name "reference/${slug}"
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

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam
    :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start nil))

(use-package! org-transclusion
  :after org
  :init
  (map!
    :map global-map "<f12>" #'org-transclusion-add
    :leader
    :prefix "n"
    :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

(setq +latex-viewers '(zathura))

;(map! :map cdlatex-mode-map :i "TAB" #'cdlatex-tab)

(use-package! reftex
  :config
  (setq reftex-default-bibliography "/Users/bernardo/mega/phd/library.bib"))
