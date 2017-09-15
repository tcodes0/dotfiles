
;;======================================== KEYS ========================================

;; quick movement
(global-set-key	(kbd "ESC <up>") 'backward-list)
(global-set-key	(kbd "ESC <down>") 'forward-list)
;;(global-set-key	(kbd "<up>") 'previous-line)
;;(global-set-key	(kbd "<down>") 'next-line)

;; (global-set-key	(kbd "C-f") 'forward-char)
;; (global-set-key	(kbd "C-b") 'backward-char)
;; (global-set-key	(kbd "M-f") 'forward-word) ;;also ESC <right>
;; (global-set-key	(kbd "M-b") 'backward-word) ;;also ESC <left>
(global-set-key	(kbd "<right>") 'right-char)
(global-set-key	(kbd "<left>") 'left-char)

;; (global-set-key      (kbd "C-f") 'forward-char)                   
;; (global-set-key      (kbd "C-b") 'backward-char)                  
;; (global-set-key      (kbd "M-f") 'forward-word) ;;also ESC <right>
;; (global-set-key      (kbd "M-b") 'backward-word) ;;also ESC <left>
;; (global-set-key      (kbd "<right>") 'forward-word)                 
;; (global-set-key      (kbd "<left>") 'backward-word)                   

;; for xterm-mouse-mode
(global-set-key (kbd "<mouse-4>") 'previous-line)
(global-set-key (kbd "<mouse-5>") 'next-line)
(global-set-key (kbd "<mouse-2>") 'yank)
(global-set-key (kbd "<mouse-3>") 'kill-region) ;;default (mouse-save-then-kill)
(global-set-key (kbd "<M-mouse-2>") 'kill-ring-save)

;; saving
(global-set-key (kbd "<f5>") 'save-buffer)

;;===================================== PACKAGES =====================================

;; this function is missing and must be defined here
(defun plist-to-alist (the-plist)
  (defun get-tuple-from-plist (the-plist)
    (when the-plist
      (cons
       (car the-plist)
       (cadr the-plist))))

  (let ((alist '()))
    (while the-plist
      (add-to-list 'alist (get-tuple-from-plist the-plist))
      (setq the-plist (cddr the-plist)))
    alist))

;; load path
(add-to-list 'load-path "~/.emacs.d/color-theme-660/")

;; requires
(require 'color-theme)
(color-theme-gray30)	;; current theme
;;(color-theme-charcoal-black)
;;(color-theme-jsc-dark)
(require 'package)

;; sources
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Added by Package.el.
(package-initialize)
;;(package-refresh-contents)

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/local/bin/sbcl") ;;ccl64, sbcl
(setq slime-contribs '(slime-fancy))

;;======================================== MODES & VARS ================================

(transient-mark-mode    	1) 
(show-paren-mode        	1)
(electric-pair-mode     	1)
;;(hs-minor-mode          	1)
(follow-mode            	1)
(save-place-mode        	1)
(xterm-mouse-mode       	1)
(delete-selection-mode  	1)
(global-visual-line-mode	1)
(column-number-mode		1)

;;======================================== MISC =======================================

;; disabled command enable
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; indentation
(setq tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;; autosave
(setq auto-save-visited-file-name t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (Vamac-theme rainbow-mode save-visited-files real-auto-save folding doremi-mac slime ##)))
 '(show-paren-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
