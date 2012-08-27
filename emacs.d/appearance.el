;;;; set frame transparency
(set-frame-parameter (selected-frame) 'alpha '(90 70))
(add-to-list 'default-frame-alist '(alpha 90 70))

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
(set-frame-size)

;;;; inhibit at startup
(setq fancy-splash-image nil)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message "")

;;;; toolbar
(if window-system
    (progn
      (tool-bar-mode -1)
      (menu-bar-mode -1)
      (toggle-scroll-bar -1)))

;;;; colors
(if window-system
    (setq default-frame-alist
	  (append default-frame-alist
		  '((foreground-color . "GhostWhite")
		    (background-color . "Black")
		    (cursor-color . "GhostWhite")))))