;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Bernardo Hummes"
      user-mail-address "hummes@ieee.org")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 14))
;;(setq doom-font (font-spec :family "Inconsolata" :size 14))
(setq doom-font (font-spec :family "Office Code Pro" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/mega/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(setq doom-modeline-icon nil)

(setq default-tab-width 4)

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "Today"
                                         :time-grid t
                                         :scheduled today)
                                  (:name "Due today"
                                         :deadline today)
                                  (:name "Important"
                                         ::priority: "A")
                                  (:name "Overdue"
                                         :deadline past)
                                  (:name "Due soon"
                                         :deadline future)
                                  (:name "Big Outcomes"
                                         :tag "bo")))
  :config
  (org-super-agenda-mode)
)

;; ROS related configutations
(add-to-list 'load-path "/opt/ros/melodic/share/emacs/site-lisp")
(require 'rosemacs-config)

;; run catkin_make
(defun ros-catkin-make (dir)
  "Run catkin_make command in DIR."
  (interactive (list (read-directory-name "Directory: ")))
  (let* ((default-directory dir)
         (compilation-buffer-name-function (lambda (major-mode-name) "*catkin_make*")))
    (compile "catkin_make"))
  )

;; generate compile_commands.json
(defun ros-catkin-make-json (dir)
  "Run catkin_make command in DIR."
  (interactive (list (read-directory-name "Directory: ")))
  (let* ((default-directory dir)
         (compilation-buffer-name-function (lambda (major-mode-name) "*catkin_make*")))
    (compile "catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ."))
  )

(defun ros-catkin-make-debug (dir)
  "Run catkin_make with Debug mode in DIR."
  (interactive (list (read-directory-name "Directory: ")))
  (let* ((default-directory dir)
         (compilation-buffer-name-function (lambda (major-mode-name) "*catkin_make*")))
    (compile "catkin_make -DCMAKE_BUILD_TYPE=Debug"))
  )

(global-set-key (kbd "C-x C-r M") 'ros-catkin-make)
(global-set-key (kbd "C-x C-r C-j") 'ros-catkin-make-json)


;; YAML mode
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded                                                IMPORTANTE para configurar pacotes do doom
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
