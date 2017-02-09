(setq files-to-load
      '(
	appearance
	tweaks
	;autocomplete
	;yasnippet
	;;cedet
	;;ecb
	;;evil
	))

(defun load-config (f)
  (load (concat "~/.emacs.d/"
		(symbol-name f)
		".el")))

(mapcar 'load-config files-to-load)
