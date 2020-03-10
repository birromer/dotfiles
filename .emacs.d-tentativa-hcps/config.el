(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))

  (setq load-prefer-newer t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq indent-tabs-mode nil
      tab-width 4)

(setq inhibit-startup-screen t
      initial-scratch-message ""
      initial-major-mode 'org-mode)

(fset 'yes-or-no-p 'y-or-n-p)

;; (use-package manoj-dark 
;;   :demand
;;   :config
;;   ;;(load-theme 'gruvbox-dark-soft t))
;;   )
  (load-theme 'manoj-dark t)

(setq-default display-line-numbers-type 'relative
              display-line-numbers-width-start 4)

(global-display-line-numbers-mode)

(setq auto-window-vscroll nil
      scroll-step 1
      scroll-conservatively most-positive-fixnum
      scroll-margin 10)

(global-hl-line-mode 1)

(setq-default display-time-format "%H:%M "
              display-time-default-load-average nil)

(display-time-mode 1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(use-package general
  :demand
  :preface
  (defconst leader-key "SPC"
    "Leader key for some special commands.")
  :config
  (general-def
   :states '(normal visual)
   :prefix leader-key
   "" nil))

(setq evil-want-abbrev-expand-on-insert-exit nil)

(use-package evil
  :demand
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil)

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package smart-mode-line
  :demand
  :custom
  (sml/no-confirm-load-theme t)
  :config
  (sml/setup))

(use-package ivy
  :demand
  :custom
  (ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-initial-inputs-alist nil)
  :config
  (ivy-mode 1))

(use-package counsel
  :demand
  :ensure smex
  :after ivy
  :preface
  (defun override-yank-pop (&optional arg)
    "Delete the region before inserting popped string."
    (when (and evil-mode (eq 'visual evil-state))
      (kill-region (region-beginning) (region-end))))
  :init
  (advice-add 'counsel-yank-pop :before #'override-yank-pop)
  :general
  (:states '(normal visual)
   :prefix leader-key
   "f f" 'counsel-find-file
   "b" 'counsel-switch-buffer
   "r" 'counsel-recentf
   "y" 'counsel-yank-pop
   "m p" 'counsel-package
   "m b" 'counsel-bookmark)
  ("M-x" 'counsel-M-x))

(use-package org
  :hook
  ((org-mode . turn-on-auto-fill) ;; auto break line
   (org-mode . org-indent-mode)) 
  :custom
  (org-hide-leading-starts t)
  (org-modules (append org-modules '(org-tempo ox-extra)))
  (org-edit-src-content-indentation 0)
  )

(defun c-mode-defauults ()
  (setq c-defaults-style "linux"
        c-basic-offset 4)
  (c-set-offset 'substatement-open 0))

(add-hook 'c-mode-common-hook (lambda () (run-hooks 'c-mode-defaults-hook)))
