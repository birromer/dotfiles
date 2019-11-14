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

(setq auto-window-vscroll nil
      scroll-step 1
      scroll-conservatively most-positive-fixnum
      scroll-margin 10)

(use-package afternoon-theme
  :demand
  :config
  (load-theme 'aftenoon t))

(use-package org
  :hook
  ((org-mode . turn-on-auto-fill) ;; auto break line
   (org-mode . org-indent-mode)) 
  :custom
  (org-hide-leading-starts t)
  (org-modules (append org-modules '(org-tempo ox-extra)))
  (org-edit-source-content-indentation 0)
  )
