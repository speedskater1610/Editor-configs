;; Terminal thingy
(add-to-list 'load-path "~/emacs/emacs-libvterm")
(require 'vterm)

;; GDB!!!!
(setq gdb-many-windows t)
(setq gdb-show-main t)

;; Startup screen
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; 4 space tabbing and use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(defun my-insert-4-spaces ()
  (interactive)
  (insert "    "))

(electric-indent-mode -1)
(electric-pair-mode -1)

(global-set-key (kbd "TAB") 'my-insert-4-spaces)

(defun my-newline-preserve-indent ()
  (interactive)
  (newline)
  (indent-to (current-indentation)))

(global-set-key (kbd "RET") 'my-newline-preserve-indent)

;; Load straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(require 'use-package)
(setq straight-use-package-by-default t)

;; Set the yank stuff to system clipboard
(setq
 select-enable-clipboard             t
 select-enable-primary               nil
 save-interprogram-paste-before-kill t)

(when (and (eq system-type 'gnu/linux)
           (not (display-graphic-p)))
  (use-package xclip
    :config (xclip-mode 1)))

;; Stop fucking blinking
(blink-cursor-mode -1)

;; Line numbers only in prog environments
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(set-face-attribute 'line-number-current-line nil
  :foreground "black"
  :background "red"
  :weight 'bold)

;; What would I do without git
(use-package magit
  :bind ("C-x g" . magit-status))
(use-package diff-hl
  :hook ((prog-mode          . diff-hl-mode)
         (magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

;; --- Autocomplete ---
(use-package company
  :hook (prog-mode . company-mode)
  :config

  ;; Show popup immediately (no delay)
  (setq company-idle-delay 0.2)

  ;; Start completing after 2 characters
  (setq company-minimum-prefix-length 2)

  ;; Wrap around the candidate list
  (setq company-selection-wrap-around t)

  ;; Show numbers next to candidates
  (setq company-show-quick-access t)

  ;; Don't downcase completions
  (setq company-dabbrev-downcase nil)

  ;; Keep case as typed
  (setq company-dabbrev-ignore-case nil)

  :bind
  (:map company-mode-map
   ;; S-down opens/enters the completion popup
   ("S-<down>" . company-complete)
   :map company-active-map

   ;; Navigate within the popup with S-up/S-down
   ("S-<down>" . company-select-next)
   ("S-<up>"   . company-select-previous)

   ;; Enter confirms the selection
   ("<return>" . company-complete-selection)
   ("RET"      . company-complete-selection)

   ;; Left or right arrow dismisses the popup
   ("<left>"   . company-abort)
   ("<right>"  . company-abort)
   
   ;; Also block normal up/down from leaking out of popup
   ("<down>"   . company-select-next)
   ("<up>"     . company-select-previous)))

;; Optional: nicer-looking completion box
(use-package company-box
  :hook (company-mode . company-box-mode))

;; ---  DONT FUCKING TOUCH ---
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
