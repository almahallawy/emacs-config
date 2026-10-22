;; Load a newer .el over a stale .elc (e.g. my-gptel after tangling).
(setq load-prefer-newer t)
(defvar kia-emacs-directory "~/src/emacs-config")
(add-to-list 'load-path kia-emacs-directory)
(require 'kia-config)
