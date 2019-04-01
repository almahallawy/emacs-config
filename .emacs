(setq ring-bell-function 'ignore)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-x\m" 'execute-extended-command)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; map C-x b  to f1
;(global-set-key [f1] 'switch-to-buffer)
;; map C-x o to f2
(global-set-key [f2] 'other-window)
;; map C-x o to tab
(global-set-key [C-tab] 'other-window)

;; y or n is sufficient for yes or no questions
(defalias 'yes-or-no-p 'y-or-n-p)
;(fset 'yes-or-no-p 'y-or-n-p)

;; set background to black, easy on the eyes
(set-background-color "black")
;; set text (i.e., foreground) to white
(set-foreground-color "white")

;; Packages
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(setq inhibit-splash-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore)

;; Enable/Disable scroll bar
(toggle-scroll-bar 1)
;; Enable/Disable toolbars
(tool-bar-mode 0)
;; Enable/Disable menu bars
(menu-bar-mode 1) 
;; Enable line numbers
(global-linum-mode 1)
(setq line-number-mode t)
(setq column-number-mode t)

;; scrolling line by line
(setq scroll-step 1)

;; Toggle visualization of matching parens (Show Paren mode).
(show-paren-mode t)
(setq show-paren-style 'mixed)
(setq show-paren-delay 0)

;;;;org-mode configuration
;; Enable org-mode
(require 'org)
;; Make org-mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
;;(define-key global-map "\C-cl" 'org-store-link)
;;(define-key global-map "\C-ca" 'org-agenda)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-log-done t)

(setq org-agenda-files (list "~/gtd/study.org"))

;; Racket Mode
;;(setq racket-program "/path/to/racket/executable/racket")

;; Show the time
;; (display-time-mode 1)
(display-time)

(server-start)

;;word-wrapped all documents
(global-visual-line-mode t)


;; C mode, set tabs to 4
(setq-default c-basic-offset 4)

;;https://www.kernel.org/doc/html/v4.10/process/coding-style.html
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "~/")
                                       filename))
                (setq indent-tabs-mode t)
                (setq show-trailing-whitespace t)
                (c-set-style "linux-tabs-only")))))


;; Show system-name and the full path of the buffer your currently editing.
;; https://stackoverflow.com/questions/3669511/the-function-to-show-current-files-full-path-in-mini-buffer
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Display Visited File's Path in the Frame Title
;; http://emacsredux.com/blog/2013/04/07/display-visited-files-path-in-the-frame-title/
;(setq frame-title-format
;     '((:eval (if (buffer-file-name)
;		   (abbreviate-file-name (buffer-file-name)) 
;		 "%b"))))


;; cscope configuration file
(load "~/cscope.el")
