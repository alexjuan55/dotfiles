;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; linux pc configs

(setq shell-file-name (executable-find "bash"))

(setq-default vterm-shell "/bin/fish")
(setq-default explicit-shell-file-name "/bin/fish")

(setq user-full-name "alexjuan"
       user-mail-address "alexjuan@asterr.top")


;; theme and background alpha
(setq doom-theme 'doom-dracula)

(add-to-list 'default-frame-alist '(alpha-background . 80))
(set-frame-parameter nil 'alpha-background 80)

(setq display-line-numbers-type t)

;; org directories

(setq org-directory "~/notes/")
(setq org-roam-directory (file-truename "~/notes/"))
;;(setq org-agenda-files (list "todo.org" "journal.org"))

(setq org-roam-file-extensions '("org"))

;; setting for time in english
(setq current-language-environment "english")
(setenv "LANG" "en_PH.UTF+8")
(setenv "LC_TIME" "en_PH.UTF+8")
(setq system-time-locale "en_PH.UTF+8")

;; org-roam stuff
;; org-roam-ui
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :hook (org-roam-mode . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;(org-roam-ui-mode)

;; org-download
(require 'org-download)
(add-hook 'dired-mode-hook 'org-download-enable)

;; org-node
(use-package org-mem
  :defer
  :config
  (setq org-mem-do-sync-with-org-id t)
  (setq org-mem-watch-dirs
        (list "~/notes/"))
  (org-mem-updater-mode))

(use-package org-node
  :init
  (keymap-global-set "M-o n" org-node-global-prefix-map)
  (with-eval-after-load 'org
    (keymap-set org-mode-map "M-o n" org-node-org-prefix-map))
  :config
  (org-node-cache-mode)
  (org-node-roam-accelerator-mode)
  (setq org-node-creation-fn #'org-node-new-via-roam-capture)
  (setq org-node-file-slug-fn #'org-node-slugify-like-roam-default)
  (setq org-node-file-timestamp-format "%Y%m%d%H%M%S-"))

(setq org-node-backlink-do-drawers t)
(org-node-backlink-mode)

(org-node-complete-at-point-mode)
(setq org-roam-completion-everywhere nil)

;;shift selecting
(setq org-support-shift-select t)

;; capture templates and todo

(setq org-capture-templates
  `(("j" "Journal" entry (file+olp+datetree "~/notes/journal.org")
     "* %?\n"
     :before-finalize (lambda ()
             (save-excursion
               (while (org-up-heading-safe)
               (org-id-get-create)))))
    ("t" "Todo" entry  (file+olp+datetree "~/notes/journal.org")
        ,(concat "* TODO %?\n"
                 "SCHEDULED: %t")
             :before-finalize (lambda ()
             (save-excursion
               (while (org-up-heading-safe)
               (org-id-get-create)))))
    ("e" "Capture entry into ID node"
     entry (function org-node-capture-target) "* %?")
    ("p" "Capture plain text into ID node"
     plain (function org-node-capture-target) nil
     :empty-lines-after 1)
    ("f" "Find and jump to ID node"
     plain (function org-node-capture-target) nil
     :prepend t
     :immediate-finish t
     :jump-to-captured t)
    ("s" "Make quick stub ID node"
     plain (function org-node-capture-target) nil
     :immediate-finish t)))

;; colors for todo list

(setq org-todo-keywords `((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
      org-todo-keyword-faces
;      `(("TODO" :foreground "#7c7c75" :weight bold :underline t)
        `(("WAITING" :foreground "#9f7efe" :weight bold)
;        ("DONE" :foreground "#0098dd" :weight bold :underline t)
        ("CANCELLED" :foreground "#ff6480" :weight bold)))

(define-key global-map (kbd "C-c c") 'org-capture)

;(setq org-agenda-custom-commands
;      '(("g" "Get Things Done (GTD)"
;         ((agenda ""
;                  ((org-agenda-skip-function
;                    '(org-agenda-skip-entry-if 'deadline))
;                   (org-deadline-warning-days 0)))
;          (todo "NEXT"
;                ((org-agenda-skip-function
;                  '(org-agenda-skip-entry-if 'deadline))
;                 (org-agenda-prefix-format "  %i %-12:c [%e] ")
;                 (org-agenda-overriding-header "\nTasks\n")))
;          (agenda nil
;                  ((org-agenda-entry-types '(:deadline))
;                   (org-agenda-format-date "")
;                   (org-deadline-warning-days 7)
;                   (org-agenda-skip-function
;                    '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
;                   (org-agenda-overriding-header "\nDeadlines")))
;          (tags-todo "inbox"
;                     ((org-agenda-prefix-format "  %?-12t% s")
;                      (org-agenda-overriding-header "\nInbox\n")))
;          (tags "CLOSED>=\"<today>\""
;                ((org-agenda-overriding-header "\nCompleted today\n")))))))
