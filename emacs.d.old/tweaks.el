;;;; Backup Files
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))
(setq kept-new-versions 6)
(setq kept-old-versions 2)

;;;; Save M-x customize in its own file
(setq custom-file "~/.emacs.d/emacs_custom.el")
(load custom-file 'noerror)

;;;; ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-create-new-buffer 'always)
(ido-mode 1)

;;;; replace yes-no
(fset 'yes-or-no-p 'y-or-n-p)

;;;; line numbering
(line-number-mode 1)
(column-number-mode 1)

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

;;;; map caps lock to control
(defun map-caps-lock-to-control ()
  (interactive)
  (shell-command "/usr/bin/xmodmap -e 'keycode 66 = Control_L' -e 'clear Lock' -e 'add Control = Control_L'"))
;(if (eq window-system 'x)
;(map-caps-lock-to-control)

;;;; un-map caps lock from control
(defun unmap-caps-lock-from-control ()
  (interactive)
  (shell-command "/usr/bin/xmodmap -e 'clear Lock' -e 'keycode 66 = Caps_Lock' -e 'add Lock = Caps_Lock'"))

;;;; intelligent close
(defun intelligent-close ()
  (interactive)
  ;(unmap-caps-lock-from-control)
  (if (eq (car (visible-frame-list)) (selected-frame)) 
      (if (eq (car (visible-frame-list)) 1)
	  (delete-frame (selected-frame))
	(save-buffers-kill-emacs))
    (delete-frame(selected-frame))))
;(global-set-key (kbd "C-x C-c") 'intelligent-close)
