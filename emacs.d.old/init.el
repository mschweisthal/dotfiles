;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    material-theme
    evil))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

;;;; inhibit at startup
;(setq fancy-splash-image nil)
;(setq inhibit-splash-screen t)
;(setq inhibit-startup-message t)
;(setq inhibit-startup-echo-area-message t)
;(setq initial-scratch-message "")
(setq inhibit-startup-message t) ;; hide the startup message

(load-theme 'material t) ;; load material theme

;;;; ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-create-new-buffer 'always)
(ido-mode 1)

;(require `evil)
(evil-mode 1)

;;;; set frame transparency
;(set-frame-parameter (selected-frame) 'alpha '(90 70))
;(add-to-list 'default-frame-alist '(alpha 90 70))

;;;; set frame size dynamically
;(if (window-system)
;    (set-frame-size (selected-frame) 180 60))
(defun set-frame-size ()
  (interactive)
  (if window-system
  (progn
    (if (> (x-display-pixel-width) 1280)
    (add-to-list 'default-frame-alist (cons 'width 140))
        (add-to-list 'default-frame-alist (cons 'width 80)))
    (add-to-list 'default-frame-alist
    (cons 'height (/ (- (x-display-pixel-height) 200)
             (frame-char-height)))))))
;(set-frame-size)

;;;; toolbar
(if window-system
    (progn
      (tool-bar-mode -1)
      (menu-bar-mode -1)
      (toggle-scroll-bar -1)))

;;;; Backup Files
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))
(setq kept-new-versions 6)
(setq kept-old-versions 2)


;;;; replace yes-no
(fset 'yes-or-no-p 'y-or-n-p)

;;;; line numbering
(global-linum-mode t) ;; enable line numbers globally
;(line-number-mode 1)
;(column-number-mode 1)

;;;; start new buffers in text mode
(setq default-major-mode 'text-mode)

;;;; enable auto fill mode (in all major modes)
(setq auto-fill-mode t)

;;;; tabs and spacing
(setq indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-indent 2)

;;;; buffer titles
(setq frame-title-format "%b")
