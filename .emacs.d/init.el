;; Machine-dependent configuration - adapt as required for your computer!

;; There are two kinds of settings that might have to be adapted to the
;; specific environment of a computer:
;; 1. Telling Emacs which executables to use for Python and R
;; 2. Telling Emacs to use a Web proxy

;;
;; 1. Telling Emacs which executables to use for Python and R
;;
;; Default setting: Use "python3" under Linux and macOS, but "Python" under Windows.
;; The default for R is "R" for all platforms (predefined by Emacs).
(setq org-babel-python-command
      (if (memq system-type '(windows-nt ms-dos))
          "Python"
        "python3 -q"))

;; If the Python and R executables are on your system's search path,
;; you should not have to modify anything here. If Emacs does not find
;; Python or R, or if it uses a different version of Python or R than you
;; expect, you can uncomment these two lines (one for Python, one for R)
;; and modify them to point to the executables.

;; Python
;; Be careful if the path to your Python installation contains spaces. The path
;; must then be surrounded by backslash-escaped quotation marks, as in
;; (setq org-babel-python-command "\"C:/Program Files/Python/Python37/python.exe\"")

;; R
;; (setq inferior-R-program-name "C:/Program Files/R/R-3.5.1/bin/x64/Rterm.exe")

;;
;; 2. Telling Emacs to use a Web proxy
;;
;; If your local network imposes the use of a Web proxy, you must uncomment and adapt
;; the following lines. Emacs does NOT use system-wide proxy settings. In most
;; cases, only the first two lines (proxy-name and proxy-port) need to be changed,
;; but sometimes the fifth line (no_proxy) also requires modifications. If you are
;; unsure what the right settings are, ask your local network administrator for help.

;; (let* ((proxy-name "proxy.mynetwork.org")
;;        (proxy-port "8080")
;;        (proxy-name-port (concat proxy-name ":" proxy-port))
;;        (proxy-url (concat "http://" proxy-name-port "/")))
;;   (setq url-proxy-services (list (cons "no_proxy" "127.0.0.1")
;;                                  (cons "http"  proxy-name-port)
;;                                  (cons "https"  proxy-name-port)))
;;   (setenv "http_proxy"  proxy-url)
;;   (setenv "https_proxy" proxy-url)
;;   (setenv "JVM_OPTS" (concat "-Dhttp.proxyHost=" proxy-name
;;                              " -Dhttp.proxyPort=" proxy-port)))

(package-initialize)
(add-to-list 'package-archives
		 '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives
		 '("melpa" . "http://melpa.org/packages/"))
(package-refresh-contents)
(setq package-archive-priorities '(("gnu" . 100)
                                   ("melpa-stable" . 10)))

(dolist (pkg '(ess
               auctex
               htmlize
               exec-path-from-shell))
  (when (not (package-installed-p pkg))
    (package-install pkg)))

(exec-path-from-shell-initialize)
(exec-path-from-shell-copy-env "PYTHONPATH")

(require 'org)

(require 'ess-site)

(setq inhibit-splash-screen t)

(setq frame-title-format
  '("Emacs - " (buffer-file-name "%f"
    (dired-directory dired-directory "%b"))))

  (global-font-lock-mode t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flyspell-incorrect ((t (:inverse-video t)))))

(line-number-mode 1)
(column-number-mode 1)

(load-library "paren")
(show-paren-mode 1)
(transient-mark-mode t)
(require 'paren)

(defalias 'yes-or-no-p 'y-or-n-p)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

    (setq
     ns-command-modifier 'meta         ; Apple/Command key is Meta
	 ns-alternate-modifier nil         ; Option is the Mac Option key
	 ns-use-mac-modifier-symbols  nil  ; display standard Emacs (and not standard Mac) modifier symbols
	 )

(cua-mode t)

(global-set-key "\M-g" 'goto-line)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
;; C-x C-0 restores the default font size

;; Inspired from http://tex.stackexchange.com/questions/166681/changing-language-of-flyspell-emacs-with-a-shortcut
;; (defun spell (choice)
;;    "Switch between language dictionaries."
;;    (interactive "cChoose:  (a) American | (f) Francais")
;;     (cond ((eq choice ?1)
;;            (setq flyspell-default-dictionary "american")
;;            (setq ispell-dictionary "american")
;;            (ispell-kill-ispell))
;;           ((eq choice ?2)
;;            (setq flyspell-default-dictionary "francais")
;;            (setq ispell-dictionary "francais")
;;            (ispell-kill-ispell))
;;           (t (message "No changes have been made."))) )

(define-key global-map (kbd "C-c s a") (lambda () (interactive) (ispell-change-dictionary "american")))
(define-key global-map (kbd "C-c s f") (lambda () (interactive) (ispell-change-dictionary "francais")))
(define-key global-map (kbd "C-c s r") 'flyspell-region)
(define-key global-map (kbd "C-c s b") 'flyspell-buffer)
(define-key global-map (kbd "C-c s s") 'flyspell-mode)

(global-set-key [f5] '(lambda () (interactive) (revert-buffer nil t nil)))

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
;; (global-magit-file-mode 1)

(defun auto-fill-mode-on () (TeX-PDF-mode 1))
(add-hook 'tex-mode-hook 'TeX-PDF-mode-on)
(add-hook 'latex-mode-hook 'TeX-PDF-mode-on)
(setq TeX-PDF-mode t)

(defun auto-fill-mode-on () (auto-fill-mode 1))
(add-hook 'text-mode-hook 'auto-fill-mode-on)
(add-hook 'emacs-lisp-mode 'auto-fill-mode-on)
(add-hook 'tex-mode-hook 'auto-fill-mode-on)
(add-hook 'latex-mode-hook 'auto-fill-mode-on)

(setq org-directory "~/Documents/org/")

(setq org-hide-leading-stars t)
(setq org-alphabetical-lists t)
(setq org-src-fontify-natively t)  ;; you want this to activate coloring in blocks
(setq org-src-tab-acts-natively t) ;; you want this to have completion in blocks
(setq org-hide-emphasis-markers t) ;; to hide the *,=, or / markers
(setq org-pretty-entities t)       ;; to have \alpha, \to and others display as utf8 http://orgmode.org/manual/Special-symbols.html

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-default-notes-file "~/org/notes.org")
     (define-key global-map "\C-cd" 'org-capture)
(setq org-capture-templates (quote (("t" "Todo" entry (file+headline "~/org/liste.org" "Tasks") "* TODO %?
  %i
  %a" :prepend t) ("j" "Journal" entry (file+datetree "~/org/journal.org") "* %?
Entered on %U
  %i
  %a"))))

(setq org-agenda-include-all-todo t)
(setq org-agenda-include-diary t)

(global-set-key (kbd "C-c d") 'insert-date)
(defun insert-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
                   ((not prefix) "** %Y-%m-%d")
                   ((equal prefix '(4)) "[%Y-%m-%d]"))))
      (insert (format-time-string format))))

(global-set-key (kbd "C-c t") 'insert-time-date)
(defun insert-time-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
                   ((not prefix) "[%H:%M:%S; %d.%m.%Y]")
                   ((equal prefix '(4)) "[%H:%M:%S; %Y-%m-%d]"))))
      (insert (format-time-string format))))

(global-set-key (kbd "C-c l") 'org-store-link)

(global-set-key (kbd "C-c <up>") 'outline-up-heading)
(global-set-key (kbd "C-c <left>") 'outline-previous-visible-heading)
(global-set-key (kbd "C-c <right>") 'outline-next-visible-heading)

;; In org-mode 9 you need to have #+PROPERTY: header-args :eval never-export
;; in the beginning or your document to tell org-mode not to evaluate every
;; code block every time you export.
(setq org-confirm-babel-evaluate nil) ;; Do not ask for confirmation all the time!!

  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (shell . t)
     (python . t)
     (R . t)
     (ruby . t)
     (ocaml . t)
     (ditaa . t)
     (dot . t)
     (octave . t)
     (sqlite . t)
     (perl . t)
     (screen . t)
     (plantuml . t)
     (lilypond . t)
     (org . t)
     (makefile . t)
     ))
  (setq org-src-preserve-indentation t)

(require 'org-tempo nil t)

(add-to-list 'org-structure-template-alist
        '("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("m" "#+begin_src emacs-lisp :tangle init.el\n\n#+end_src" "<src lang=\"emacs-lisp\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("r" "#+begin_src R :results output :session *R* :exports both\n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("R" "#+begin_src R :results output graphics :file (org-babel-temp-file \"figure\" \".png\") :exports both :width 600 :height 400 :session *R* \n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("RR" "#+begin_src R :results output graphics :file  (org-babel-temp-file (concat (file-name-directory (or load-file-name buffer-file-name)) \"figure-\") \".png\") :exports both :width 600 :height 400 :session *R* \n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("p" "#+begin_src python :results output :exports both\n\n#+end_src" "<src lang=\"python\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("P" "#+begin_src python :results output :session :exports both\n\n#+end_src" "<src lang=\"python\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("PP" "#+begin_src python :results file :session :var matplot_lib_filename=(org-babel-temp-file \"figure\" \".png\") :exports both\nimport matplotlib.pyplot as plt\n\nimport numpy\nx=numpy.linspace(-15,15)\nplt.figure(figsize=(10,5))\nplt.plot(x,numpy.cos(x)/x)\nplt.tight_layout()\n\nplt.savefig(matplot_lib_filename)\nmatplot_lib_filename\n#+end_src" "<src lang=\"python\">\n\n</src>"))

(if (memq system-type '(windows-nt ms-dos))
    ;; Non-session shell execution does not seem to work under Windows, so we use
    ;; a named session just like for B.
    (add-to-list 'org-structure-template-alist
                 '("b" "#+begin_src shell :session session :results output :exports both\n\n#+end_src" "<src lang=\"sh\">\n\n</src>"))
  (add-to-list 'org-structure-template-alist
               '("b" "#+begin_src shell :results output :exports both\n\n#+end_src" "<src lang=\"sh\">\n\n</src>")))

(add-to-list 'org-structure-template-alist
        '("B" "#+begin_src shell :session *shell* :results output :exports both \n\n#+end_src" "<src lang=\"sh\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("g" "#+begin_src dot :results output graphics :file \"/tmp/graph.pdf\" :exports both
   digraph G {
      node [color=black,fillcolor=white,shape=rectangle,style=filled,fontname=\"Helvetica\"];
      A[label=\"A\"]
      B[label=\"B\"]
      A->B
   }\n#+end_src" "<src lang=\"dot\">\n\n</src>"))

(global-set-key (kbd "C-c S-t") 'org-babel-execute-subtree)

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-babel-result-hide-all)

(setq python-shell-completion-native-enable nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
	("2540689fd0bc5d74c4682764ff6c94057ba8061a98be5dd21116bf7bf301acfb" "725a0ac226fc6a7372074c8924c18394448bb011916c05a87518ad4563738668" "eb7be1648009af366d83f855191057bdc09348a2d9353db31da03b1cdec50cc5" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" "bc75dfb513af404a26260b3420d1f3e4131df752c19ab2984a7c85def9a2917e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "f8fb7488faa7a70aee20b63560c36b3773bd0e4c56230a97297ad54ff8263930" "f8067b7d0dbffb29a79e0843797efabdf5e1cf326639874d8b407e9b034136a4" "97965ccdac20cae22c5658c282544892959dc541af3e9ef8857dbf22eb70e82b" "9129c2759b8ba8e8396fe92535449de3e7ba61fd34569a488dd64e80f5041c9f" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" default)))
 '(package-selected-packages
   (quote
	(haskell-emacs org-ref org-category-capture counsel-org-capture-string org-capture-pop-frame helm-bibtex smooth-scrolling afternoon-theme interleave pdf-tools helm zotxt zones gotham-theme jazz-theme abyss-theme smooth-scroll haskell-mode evil-nerd-commenter highlight-parentheses latex-preview-pane smart-mode-line highlight-indent-guides poet-theme dracula-theme magit exec-path-from-shell htmlize ess auctex))))

(load-theme 'afternoon t)

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(add-to-list 'load-path "~/cic/personal/neotree")
(require 'neotree)
(global-set-key [f3] 'neotree-toggle)

(add-hook 'prog-mode-hook 'linum-mode)

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)

(sml/setup)
(setq sml/theme 'atom-one-dark)

;; (latex-preview-pane-enable)

;; (add-hook 'prog-mode-hook 'highlight-parenteses-mode)

;; (evilnc-default-hotkeys)

(add-to-list 'load-path "~/.emacs.d/evil")
(setq evil-shift-width 4)
(require 'evil)
(evil-mode 1)

;;(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
;;(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;;(setq scroll-step 1) ;; keyboard scroll one line at a time

(require 'smooth-scrolling)
(smooth-scrolling-mode 1)
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

;; Activate org-zotxt-mode in org-mode buffers
(add-hook 'org-mode-hook (lambda () (org-zotxt-mode 1)))
(defun my-interleave-hook ()
  (with-current-buffer interleave-org-buffer
    (org-zotxt-mode 1)))
(add-hook 'interleave-mode-hook #'my-interleave-hook)

(ivy-mode 1)

(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

(add-hook 'doc-view-mode-hook 'pdf-tools-install)

(setq org-ref-notes-directory "~/Documents/org/references/notes"
      org-ref-bibliography-notes "~/Documents/org/references/articles.org"
      org-ref-default-bibliography '("~/Documents/org/references/references.bib")
      org-ref-pdf-directory "~/Documents/org/references/pdfs/")

(setq helm-bibtex-bibliography "~/Documents/org/references/references.bib"
      helm-bibtex-library-path "~/Documents/org/references/pdfs"
      helm-bibtex-notes-path "~/Documents/org/references/articles.org"
      bibtex-completion-notes-path "~/Documents/org/references/articles.org"
      bibtex-completion-bibliography "~/Documents/org/references/references.bib"
      bibtex-completion-library-path '("~/Documents/org/references/pdfs"))

(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))

(add-hook 'bibtex-mode-hook (lambda () (local-set-key (kbd "C-c b") 'helm-bibtex)))
(add-hook 'bibtex-mode-hook (lambda () (local-set-key (kbd "C-c n") 'org-ref-open-bibtex-notes)))
(add-hook 'org-mode-hook (lambda () (local-set-key (kbd "C-c i") 'interleave-mode)))
(add-hook 'pdf-view-mode-hook (lambda () (linum-mode -1)))

(scroll-bar-mode -1)

(setq-default tab-width 4)