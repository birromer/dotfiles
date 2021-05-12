(setq user-full-name "Bernardo Hummes"
      user-mail-address "hummes@ieee.org")

(setq doom-font (font-spec :family "Office Code Pro" :size 14))

(setq doom-theme 'doom-dracula)

(setq doom-modeline-icon nil)

(setq default-tab-width 2)

(setq undo-limit 80000000
      evil-want-fine-undo t)

(setq display-line-numbers-type 'relative)

(setq show-trailing-whitespace t)

(setq bibtex-completion-bibliography
      '("~/mega/org/library.bib"
        ))

(setq ivy-use-virtual-buffers t)

(after! ivy-bibtex
    (map! :leader
        :prefix "i"
        :desc "ivy-bibtex" "l" #'ivy-bibtex))

(setq org-directory "~/mega/org/")
(setq org-roam-directory "~/mega/org/roam/")

(setq org-startup-folded t)
(setq org-startup-idented t)
(setq org-fontify-done-headline t)
(setq org-fontify-todo-headline t)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-superstar  ;; improved bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(setq org-log-done t)
(setq org-agenda-file '("~/mega/org/notes.org"
                        "~/mega/org/todo.org"))

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
(setq org-agenda-files "~/mega/org/daily/")
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

(use-package! org-ref
    :after org
    :preface
    (defconst birromer/user-org-ref-path
      (expand-file-name "~/mega/org/"))
    :custom
    (org-ref-bibliography-notes (expand-file-name "notes.org" birromer/user-org-ref-path))
    (org-ref-default-bibliography `(,(expand-file-name "library.bib" birromer/user-org-ref-path)))
    (reftex-default-bibliography `(,(expand-file-name "library.bib" birromer/user-org-ref-path)))
;;    (org-ref-pdf-directory birromer/user-org-ref-path)
    (org-ref-completion-library 'org-ref-ivy-cite)
    (org-ref-insert-cite-function 'org-ref-ivy-insert-cite-link)
    (org-ref-insert-label-function 'org-ref-ivy-insert-label-link)
    (org-ref-insert-ref-function 'org-ref-ivy-insert-ref-link)
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

(use-package! toc-org
  :defer t
  :hook
  (org-mode-hook . toc-org-mode))

(after! org-roam
      (map! :leader
          :prefix "n"
          :desc "org-roam" "l" #'org-roam
          :desc "org-roam-insert" "i" #'org-roam-insert
          :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
          :desc "org-roam-find-file" "f" #'org-roam-find-file
          :desc "org-roam-show-graph" "g" #'org-roam-show-graph
          :desc "org-roam-insert" "i" #'org-roam-insert
          :desc "org-roam-capture" "c" #'org-roam-capture))

(after! org-roam
      (setq org-roam-ref-capture-templates
            '(("r" "ref" plain (function org-roam-capture--get-point)
               "%?"
               :file-name "websites/${slug}"
               :head "#+TITLE: ${title}
    #+ROAM_KEY: ${ref}
    - source :: ${ref}"
               :unnarrowed t))))

(require 'company-org-roam)
(use-package company-org-roam
  :when (featurep! :completion company)
  :after org-roam
  :config
  (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-dir "~/mega/org/roam")
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %m %Y"))
(setq org-journal-enable-agenda-integration t)

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
