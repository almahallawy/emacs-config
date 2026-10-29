;;; .emacs --- Bootstrap for ~/src/emacs-config -*- lexical-binding: t -*-
;; Loaded from ~/.emacs with: (load "~/src/emacs-config/.emacs")
;; Hand-written, not tangled.

;; Load a newer .el over a stale .elc (e.g. my-gptel after tangling).
(setq load-prefer-newer t)
(defvar kia-emacs-directory "~/src/emacs-config")
(add-to-list 'load-path kia-emacs-directory)

;; Tangle each .org whose output .el is missing or older than the .org.
;; Covers a new machine, git pull, and edits without C-c C-v t.
(defun kia-tangle-if-stale (org el)
  "Tangle ORG if EL is missing or older (both relative to `kia-emacs-directory')."
  (let ((org (expand-file-name org kia-emacs-directory))
        (el  (expand-file-name el  kia-emacs-directory)))
    (when (and (file-exists-p org) (file-newer-than-file-p org el))
      (require 'ob-tangle)
      (message "Tangling %s..." (file-name-nondirectory org))
      (org-babel-tangle-file org)
      ;; Org skips writing an unchanged file; touch it so a prose-only edit
      ;; doesn't re-tangle on every start.
      (when (file-exists-p el)
        (set-file-times el)))))

(kia-tangle-if-stale "emacs.org"    "kia-config.el")
(kia-tangle-if-stale "my-gptel.org" "my-gptel.el")

(require 'kia-config)

;; Compile my-gptel*.el if the .elc is missing or older.  Done after
;; kia-config so ELPA packages and gptel are loaded.  This session already
;; loaded the .el (load-prefer-newer); the .elc is used from the next start.
(let ((warning-minimum-level :error))   ; no *Warnings* popup at startup
  (dolist (el (directory-files kia-emacs-directory t "\\`my-gptel.*\\.el\\'"))
    (byte-recompile-file el nil 0)))
