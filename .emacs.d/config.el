(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))

  (setq load-prefer-newer t)

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

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq indent-tabs-mode nil
      tab-width 4)

(setq inhibit-startup-screen t
      initial-scratch-message ""
      initial-major-mode 'org-mode)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package afternoon-theme
  :demand
  :config
  ;;(load-theme 'gruvbox-dark-soft t))
  (load-theme 'aftenoon t))

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

(use-package org
  :hook
  ((org-mode . turn-on-auto-fill) ;; auto break line
   (org-mode . org-indent-mode)) 
  :custom
  (org-hide-leading-starts t)
  (org-modules (append org-modules '(org-tempo ox-extra)))
  (org-edit-source-content-indentation 0)
  )

(defun c-mode-defauults ()
  (setq c-defaults-style "linux"
        c-basic-offset 4)
  (c-set-offset 'substatement-open 0))

(add-hook 'c-mode-common-hook (lambda () (run-hooks 'c-mode-defaults-hook)))
