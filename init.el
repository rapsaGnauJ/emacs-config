;; Toda la mierda va a ir aquí, maldita configuración custom :(
(setq custom-file "~/.emacs.d/.emacs-custom.el")
;; Comprobación de paquetes lo primero. Nos conectamos tanto a melpa como a melpa-stable
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/"))
  (package-initialize))
;; Ahora el use-package que agilizará la instalación de nuestros paquetes
(unless (featurep 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

; ----- Fuente. -----
(add-to-list 'default-frame-alist '(font . "FiraCode-14"))
(set-face-attribute 'default nil :family "FiraCode-14")
(set-default-font "FiraCode-14")

; Usar fira-code-mode para ligaduras.
(defun fira-code-mode--make-alist (list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ #Xe100 idx))
          (width (string-width s))
          (prefix ())
          (suffix '(?\s (Br . Br)))
          (n 1))
     (while (< n width)
       (setq prefix (append prefix '(?\s (Br . Bl))))
       (setq n (1+ n)))
     (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst fira-code-mode--ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
    "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
    "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
    "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
    "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
    "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
    "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
    "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
    "x" ":" "+" "+" "*"))

(defvar fira-code-mode--old-prettify-alist)

(defun fira-code-mode--enable ()
  "Enable Fira Code ligatures in current buffer."
  (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist (append (fira-code-mode--make-alist fira-code-mode--ligatures) fira-code-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun fira-code-mode--disable ()
  "Disable Fira Code ligatures in current buffer."
  (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode fira-code-mode
  "Fira Code ligatures minor mode"
  :lighter " Fira Code"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if fira-code-mode
      (fira-code-mode--enable)
    (fira-code-mode--disable)))

(defun fira-code-mode--setup ()
  "Setup Fira Code Symbols"
  (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))

(provide 'fira-code-mode)


;;(set-face-attribute 'default nil :height 168)
(tooltip-mode -1)
(tool-bar-mode -1)
(set-window-fringes nil 0 0)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; (toggle-frame-fullscreen)
(setq inhibit-startup-screen t)
(display-time-mode 1)
(setq ring-bell-function 'ignore)
;;(shell-command-to-string "echo -n $(date +%k:%M--%m-%d)")
(display-battery-mode 1)
(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode 1))
(use-package telephone-line
  :ensure t) ;; Bueno, esto necesita un repaso gordo. Espero que mole mucho.
(setq telephone-line-subseparator-faces '())
(setq telephone-line-height 24
      telephone-line-evil-use-short-tag t)
(telephone-line-mode t)

;----- Tema y apariencia. -----
(use-package nyx-theme
  :ensure t
  :init (load-theme 'nyx t))

; --- Cursor. ---
(setq-default cursor-type 'bar)
(require 'frame)

; --- Fondo. ---
;(set-background-color "#101010")


; Unas cuantas utilidades para mejorar nuestra experiencia
(use-package windmove
  :ensure t
  :bind (("M-<up>" . windmove-up)
	 ("M-<down>" . windmove-down)
	 ("M-<right>" . windmove-right)
	 ("M-<left>" . windmove-left)))
(use-package ido
  :init (ido-mode))
(use-package neotree
  :ensure t
  :bind (("C-x n" . neotree-toggle)))

(use-package helm
  :init (helm-mode 1)
  :config (require 'helm-config)
  :bind (("C-x C-f" . helm-find-files)
	 ("M-x" . helm-M-x)))
(use-package ac-helm
  :ensure t)
;;(use-package auto-complete
;;  :ensure t
;;  :config (ac-config-default))

(use-package company
  :ensure t
  :init
  :config (add-hook 'after-init-hook 'global-company-mode))

;; Varios Básicos
(electric-pair-mode 1)
(show-paren-mode 1)
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

;; Juegos :D
(use-package tetris
  :ensure t
  :bind ("C-S-t" . tetris))
(use-package typing
  :ensure t )
(use-package poker
  :ensure t )
;; Accesorios varios
;;(use-package zone-rainbow
;;  :ensure t
;;  :bind ("C-z" . zone-rainbow))
(use-package golden-ratio
  :ensure t
  :config (golden-ratio-mode t))
(use-package rainbow-mode
  :ensure t
  :config (rainbow-mode t))
;; Modos para programar (Aunque no hay nada de programación aquí xD) y demás
(use-package markdown-mode+
  :ensure t)
(use-package flymd
  :ensure t)
(use-package magit
  :ensure t)
;; Terminal mejorada
(use-package multi-term
  :ensure t
  :bind (("C-t" . multi-term-dedicated-toggle)))
;; Muchos cursores
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)))
;;(use-package auctex
;;  :ensure t)
;;  :config ((setq TeX-auto-save t)
;;	   (setq TeX-parse-self t)))
(put 'upcase-region 'disabled nil)

;; Algunos modos para algunas extensiones.
(add-to-list 'auto-mode-alist '("\\.ens\\'" . asm-mode))

;; Algunos bindings personlizados.
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-x C-k") 'kill-buffer)
(global-set-key (kbd "C-x k") 'kill-buffer-and-window)
(global-set-key (kbd "C-<backspace>") 'kill-whole-line)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-S-e") 'move-beginning-of-line)
(global-set-key (kbd "C-;") 'comment-line)
;(global-set-key (kbd "RET") 'indent-new-comment-line)
