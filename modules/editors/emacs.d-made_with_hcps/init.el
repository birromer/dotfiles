;; Configure package.el to include MELPA.
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;; Ensure that use-package is installed.
;;
;; If use-package isn't already installed, it's extremely likely that this is a
;; fresh installation! So we'll want to update the package repository and
;; install use-package before loading the literate configuration.
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(org-babel-load-file "~/.emacs.d/config.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "47ec21abaa6642fefec1b7ace282221574c2dd7ef7715c099af5629926eb4fd7" "f11e219c9d043cbd5f4b2e01713c2c24a948a98bed48828dc670bd64ae771aa1" "4bdc0dfc53ae06323e031baf691f414babf13c9c9c35014dd07bb42c4db27c24" "c7aa6fcf85e6fe4ea381733d9166d982bbc423af4a55c26f55f5d0cfb0ce1835" "947190b4f17f78c39b0ab1ea95b1e6097cc9202d55c73a702395fc817f899393" "cdb4ffdecc682978da78700a461cdc77456c3a6df1c1803ae2dd55c59fa703e3" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" "2540689fd0bc5d74c4682764ff6c94057ba8061a98be5dd21116bf7bf301acfb" "8f97d5ec8a774485296e366fdde6ff5589cf9e319a584b845b6f7fa788c9fa9a" default)))
 '(org-edit-source-content-indentation 0 t)
 '(org-hide-leading-starts t t)
 '(org-modules
   (quote
    (org-w3m org-bbdb org-bibtex org-docview org-gnus org-info org-irc org-mhe org-rmail org-tempo ox-extra)))
 '(package-selected-packages
   (quote
    (smart-mode-line gruber-darker-theme clues-theme magit poet-theme dracula-theme zenburn-theme gruvbox-theme evil-org evil-surround evil-collection evil auto-compile use-package)))
 '(sml/no-confirm-load-theme t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
