;; TODO: download 1.1

(load-file "~/.emacs.d/vendor/cedet-1.0/common/cedet.el")
(global-ede-mode 1) ; proj mgmt system
(semantic-load-enable-code-helpers) ; prototype help, smart completion
(global-srecode-minor-mode 1) ; template insertion menu
;(require 'semantic-ia) ; name completion and display of tags
;(require 'semantic-gcc) ; auto-locate system include files
;(require 'semantic-db)
;(global-semanticdb-minor-mode 1)
;(when window-system (speedbar t))