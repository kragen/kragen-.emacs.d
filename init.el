;; .emacs from kragen@thrifty, version 4

(require 'cl)

;; It's too bad there's no convenient way to set EMACSLOADPATH in my
;; environment.
(push "/usr/share/emacs/site-lisp" load-path)
(push "/usr/share/emacs/site-lisp/autoconf" load-path)
(push "/usr/share/emacs/site-lisp/bigloo-ude" load-path)
(push "/usr/share/emacs/site-lisp/dictionaries-common" load-path)
(push "/usr/share/emacs/site-lisp/emacs-goodies-el" load-path)
(push "/usr/share/emacs/site-lisp/erlang" load-path)
(push "/usr/share/emacs/site-lisp/ess" load-path)
(push "/usr/share/emacs/site-lisp/gambc" load-path)
(push "/usr/share/emacs/site-lisp/haskell-mode" load-path)
(push "/usr/share/emacs/site-lisp/mmm-mode" load-path)
(push "/usr/share/emacs/site-lisp/octave2.1-emacsen" load-path)
(push "/usr/share/emacs/site-lisp/php-elisp" load-path)
(push "/usr/share/emacs/site-lisp/pymacs" load-path)
(push "/usr/share/emacs/site-lisp/pymacs-elisp" load-path)
(push "/usr/share/emacs/site-lisp/python-mode" load-path)
(push "/usr/share/emacs/site-lisp/ruby1.8-elisp" load-path)
(push "/usr/share/emacs/site-lisp/tuareg-mode" load-path)
(push "~/.emacs.d" load-path)
(push "~/.emacs.d/yasnippet-0.5.6" load-path)

(setq-default filladapt-mode t)
(require 'filladapt)
(require 'compile)
(iswitchb-mode 1)
(tool-bar-mode 0)
(menu-bar-mode 0)
(fringe-mode '(0 . 4))                  ; half-width fringes on right side only
(server-start) (setenv "EDITOR" "emacsclient")
(setenv "PAGER" "cat")           ; prevent git from trying to use less

; 80 columns:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; (setenv "DATABASE_ENGINE" "sqlite") no longer!

(display-battery-mode 1)                ; an emacs22-ism?
(savehist-mode 1)                       ; definitely an emacs22-ism

(require 'paren)

(require 'htmlize)

(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet-0.5.6/snippets")

;; yuck, I can't just `require` js2-mode
;; because it doesn't `(provide 'js2)`
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;;; The python.el that ships with Emacs 22.2 is inferior.
(require 'python-mode)

;;; tuareg-mode doesn't get auto-loaded
(require 'tuareg)

(autoload 'forth-mode "gforth.el")
(defun auto-mode (expr mode)
  "Add a filename-pattern/mode association to auto-mode-alist.
  
  Why the FUCK is this not in the standard library?"
  (push (cons expr mode) auto-mode-alist))

(defun add-n-to-list (list-var elements &optional append compare-fn)
  "Add whichever ELEMENTS to the value of LIST-VAR that aren't there yet.

See the documentation for `add-to-list' for more details.

The return value is not useful.
"
  (when (not (null elements))
    (add-to-list list-var (car elements) append compare-fn)
    (add-n-to-list list-var (cdr elements) append compare-fn)))

;;; For screencasts: Michael Weber's log-commands
(require 'mwe-log-commands)
;;; Ignore some boring commands that org-mode uses
(add-n-to-list 'mwe:*log-command-exceptions* 
               '(org-self-insert-command org-delete-backward-char org-return
                 org-delete-char))

(auto-mode "\\.fs\\'" 'forth-mode)
(autoload 'forth-block-mode "gforth.el")
(auto-mode "\\.BLK\\'" 'forth-block-mode)
(auto-mode "\\.fb\\'" 'forth-block-mode)
;; default is perl-mode, which sucks
(auto-mode "\\.pl\\'" 'cperl-mode) (auto-mode "\\.pm\\'" 'cperl-mode)
(auto-mode "\\.s\\'" 'asm-mode)
(auto-mode "\\.scm\\'" 'scheme-mode) ; that's the default, but
				     ; bee-mode overrides it
(require 'ruby-mode)
(auto-mode "\\.rb\\'" 'ruby-mode)
(auto-mode "\\.m\\'" 'objc-mode)


(require 'inf-lisp) ; not using SLIME yet
(add-hook 'inferior-lisp-mode-hook 'turn-on-eldoc-mode)

(require 'org)
(global-set-key "\C-cl" 'org-store-link) ; as recommended in org-mode docs
(global-set-key "\C-ca" 'org-agenda)
(auto-mode "\\.org$" 'org-mode)
;; disabled because it breaks shift-space
;(add-hook 'python-mode-hook 'orgtbl-mode)

;; work around org-mode's breakage of shift-space
(global-set-key [(shift ? )] #'(lambda () (interactive) (insert " ")))

(fset 'insert-wikipedia-link
   [?[ ?[ ?\C-y ?] ?[ ?\C-y ?] ?\C-b ?\C-  ?\C-r ?/ ?\C-m ?\M-x ?r ?e ?p ?l ?a ?c ?e ?- ?s ?t tab return ?_ return ?  return ?\C-r ?/ ?\C-m ?\C-f ?\C-r ?[ ?\C-m ?\C-f ?\C-x ?\C-x ?\C-w ?\C-s ?] ?\C-m ?]])

(require 'php-mode)

(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'cperl-mode-hook 'flyspell-prog-mode)
(add-hook 'python-mode-hook 'flyspell-prog-mode)
(add-hook 'c-mode-hook 'flyspell-prog-mode)
(add-hook 'scheme-mode-hook 'flyspell-prog-mode)
(add-hook 'forth-mode-hook 'flyspell-prog-mode)
(add-hook 'js2-mode-hook 'flyspell-prog-mode)
(add-hook 'php-mode-hook 'flyspell-prog-mode)

(require 'shell)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(require 'saveplace)
(require 'gist)

(which-func-mode t)         ; I didn't know about this!  Thanks Glyph!

;;; still doesn't handle the formats 4154975513 and 415 4975513
(defun reformat-us-phone-number ()
   "Reformat a phone number in a US format into my normal phone number format."
  (interactive)
  (save-excursion
    ; XXX these regexen break at end of buffer
    (if (looking-at "[0-9]\\{3\\}[-. ][0-9]\\{3\\}[-. ][0-9]\\{4\\}[^0-9]")
	(progn
	  (insert "+1 ")
	  (forward-char 3)
	  (delete-char 1)
	  (insert " ")
	  (forward-char 3)
	  (delete-char 1)
	  (insert " ")
	  t)
      (if (looking-at
	   "([0-9]\\{3\\})[-. ]?[0-9]\\{3\\}[-. ][0-9]\\{4\\}[^0-9]")
	  (progn 
	    (insert "+1 ")
	    (delete-char 1)
	    (forward-char 3)
	    (delete-char 1)
	    (if (looking-at "[-. ]") (delete-char 1))
	    (insert " ")
	    (forward-char 3)
	    (delete-char 1)
	    (insert " ")
	    t)
	nil))))

(defun magic-reformat-us-phone-number ()
  "Reformat a US phone number somewhere in the vicinity."
  (interactive)
  (or (reformat-us-phone-number)
      (save-excursion (forward-char 1) (reformat-us-phone-number))
      (save-excursion (backward-char 1) (reformat-us-phone-number))
      (and (looking-at "1-[0-9]\\{3\\}")
	   (progn (delete-char 2) (reformat-us-phone-number)))
      (save-excursion (backward-char 12) (reformat-us-phone-number))
      (save-excursion (backward-char 13) (reformat-us-phone-number))
      (save-excursion (backward-char 14) (reformat-us-phone-number))))
(global-set-key [(control meta tab)] 'magic-reformat-us-phone-number)

(global-set-key [f5] 'recompile)
(global-set-key [f6] 'browse-url-at-point)

(defun underline-line-with (char)
  (save-excursion
    (let ((length (- (point-at-eol) (point-at-bol))))
      (end-of-line)
      (insert "\n")
      (insert (make-string length char)))))
(defun underline-line ()
  (interactive)
  (underline-line-with ?-))
(defun double-underline-line ()
  (interactive)
  (underline-line-with ?=))
(global-set-key [(control meta _)] 'underline-line)
(global-set-key [(control meta =)] 'double-underline-line)

(defun insert-em-dash ()
  "Insert a TeX-style em-dash '---' with appropriate spaces around it."
  (interactive)
  ;; ensure we have a space before the em dash
  (if (not (looking-back " "))
      (if (looking-at " ") (forward-char 1) (insert " ")))
  (insert "---")
  ;; ensure we have a space after the em dash
  (if (looking-at " ") (forward-char 1) (insert " ")))
(global-set-key [(meta _)] 'insert-em-dash)

;;; It's kind of sad this doesn't exist normally...
(defun indent-rigidly-n (n)
  "Indent the region, or otherwise the current line, by N spaces."
  (let* ((use-region (and transient-mark-mode mark-active))
         (rstart (if use-region (region-beginning) (point-at-bol)))
         (rend   (if use-region (region-end)       (point-at-eol)))
         (deactivate-mark "irrelevant")) ; avoid deactivating mark
    (indent-rigidly rstart rend n)))
(defun indent-rigidly-4 ()
  "Indent the region, or otherwise the current line, by 4 spaces."
  (interactive)
  (indent-rigidly-n 4))
(defun outdent-rigidly-4 ()
  "Indent the region, or otherwise the current line, by -4 spaces."
  (interactive)
  (indent-rigidly-n -4))
(global-set-key [(control >)] 'indent-rigidly-4)
(global-set-key [(control <)] 'outdent-rigidly-4)

;;; XXX has a bug --- won’t move “`” to after a newline.
(defun markdown-tt-word ()
  "Hit N times to enclose previous N chunks of nonwhitespace in `` (for Markdown)."
  (interactive)
  (if (looking-back "`")
      (save-excursion
        (backward-char)

        (search-backward "`")
        (delete-char 1)

;;         (backward-word) previously
        (search-backward-regexp "\\S-")
        (search-backward-regexp "\\s-")
        (forward-char)

        (insert "`"))
    (progn
      (insert "`")
      (save-excursion
        (backward-word)   ; should this use the same simpler approach?
        (insert "`")))))
(global-set-key [(meta ?`)] 'markdown-tt-word)

;; Thanks to bpt (Brian Templeton) and snogglethorpe (Miles Bader) for
;; help with this.
(defun momentary-highlight (beg end &optional delay face)
  "Momentarily display a highlight overlay until a delay, or there's input.

  Highlights the chars from BEG to END until the next event is
  input, or until DELAY seconds expire.  By default, uses the
  face \"highlight\", but you can override this with FACE.

  "
  (save-excursion
    (let ((overlay (make-overlay beg end)))
      (unwind-protect
          (progn
            (overlay-put overlay 'face (or face 'highlight))
            ;; code from momentary-string-display
            (if (<= (window-end nil t) end)
                (recenter (/ (window-height) 2)))
            (sit-for (or delay 1)))
        (delete-overlay overlay)))))

(defun smartquote ()
  "Turn the previous '\"' character into either '“' or '”', based on context.

  This highlights the area around the changed character so you
  can see if it screwed up.
  "
  (interactive)
  (save-excursion
    (search-backward "\"")
    (cond ((bobp) (replace-match "“"))
          ((looking-at ".\\s-")         ; before whitespace, close
           (delete-char 1) (insert "”")) 
          ((looking-back "\\s-")        ; after whitespace, open
           (delete-char 1) (insert "“"))
          ((looking-at ".\\sw")         ; before a word, open (e.g. '("hi")')
           (delete-char 1) (insert "“"))
          ((looking-back "\\sw")        ; after a word, close
           (delete-char 1) (insert "”"))
          ((looking-back "\\s(")        ; after an open paren, open quote
           (delete-char 1) (insert "“"))
          ((looking-at ".\\s)")         ; before a close paren, close quote
           (delete-char 1) (insert "”"))
          (t (delete-char 1) (insert "”"))) ; default: close
    ;; Without this momentary-highlight, sometimes this command
    ;; replaces "'s that are off the top of the screen, and even when
    ;; they're on the screen, it's easy to not notice which one they
    ;; are.
    (momentary-highlight (- (point) 2) (+ 1 (point)))))
(global-set-key [(meta ?\")] 'smartquote)

(defun smart-apostrophe ()
  "Replace ' with ’ or ‘, depending on context."
  (interactive)
  (save-excursion
    (search-backward "'")
    (if (looking-back "\\s-")           ; if after whitespace, ‘
        (progn
          (delete-char 1)
          (insert "‘"))
      (progn                            ; otherwise, ’
        (delete-char 1)
        (insert "’")))
    (momentary-highlight (- (point) 2) (+ 1 (point)))))
;; by default this key is set to abbrev-prefix-mark, which I never use
(global-set-key [(meta ?')] 'smart-apostrophe)      

;; sample code from 1979 Multics Emacs: http://www.multicians.org/mepap.html
;; The only thing that’s wrong with it is that it doesn’t have an (interactive)
;; declaration; otherwise it works!
(defun bracket-word ()
       (forward-word)
       (insert-string ">")
       (backward-word)
       (insert-string "<"))

;;; do a heavy-handed <pre>
(defun heavy-handed-pre (start end)
  (interactive "r")
  ; XXX "This function is usually the wrong thing to use in a Lisp program."
  (replace-string " " "&nbsp;" nil start end) ; nil for DELIMITED
  (replace-string "\n" "<br />\n" nil start end))

(defun sunlight ()
  (interactive)
  (custom-set-faces
   '(default ((t (:stipple nil :background "#ffffff" 
                           :foreground "#000000" 
                           :inverse-video nil :box nil
                           :strike-through nil :overline nil
                           :underline nil :slant normal
                           :weight bold :height 180
                           :width normal
                           :family "adobe-courier"))))))

;;; my todelicious file

(defun words-in-field ()
  (interactive)
  (condition-case err
      (save-excursion
        (forward-paragraph)
        (search-backward-regexp "^[^ \\t:][^:]*:")
        (forward-char)
        (let ((start (point)))
          (forward-paragraph)
          (shell-command-on-region start (point) "wc")))
    (error (message "could not find field beginning: %s" err))))

(defun words-in-field-newline ()
  (interactive)
  (words-in-field)
  (newline))

(defun words-in-field-fill-paragraph ()
  (interactive)
  (words-in-field)
  (fill-paragraph nil))

(global-set-key [(meta q)] 'words-in-field-fill-paragraph)

;; from replace-string docs:
;; This function is usually the wrong thing to use in a Lisp program.
;; What you probably want is a loop like this:
;;   (while (search-forward FROM-STRING nil t)
;;     (replace-match TO-STRING nil t))
;; which will run faster and will not set the mark or print anything.
;; (search-forward STRING &optional BOUND NOERROR COUNT)
;; optional second arugment bounds search
;; region-end region-beginning
;; exchange-point-and-mark
;; so we want something like
(defun replace-string-in-region (old new)
  (interactive "MOld: \nMNew: ")
  (let ((deactivate-mark "irrelevant")) ; avoid deactivating
    (save-excursion
      (exchange-point-and-mark)
      (let ((end (region-end)))
        (goto-char (region-beginning))
        (while (search-forward old end t)
          (replace-match new nil t))))))

;;; mmm-mode
;; doesn't work
;; (setq mmm-global-mode 'maybe)
;; (mmm-add-mode-ext-class 'html-mode "\\.php\\'" 'html-php)

(fset 'fix-nationaljournal-url
   "\344\C-d\C-dfile:///home/kragen/devel/watchdog-git/data/crawl/almanac\C-shtt\C-m\C-b\C-b\C-b")

;;; Binding from XEmacs.
(global-set-key [(meta g)] 'goto-line)

;;; Toggling of argument lists between horizontal and vertical.
;; For example, turn this: memset(bigstring, '\xe3', bigstringsize-1);
;; into this: memset(bigstring,
;;                   '\xe3',
;;                   bigstringsize-1);
;; or vice versa.

;; This was really useful at Airwave back in 2004, but I never
;; understood how it worked.  I miss it, so I reimplemented it, which
;; took me a couple of hours.  The idea is that when you're writing
;; out an argument list becomes too long to write on one line, you
;; have a single key to put each item on its own line; and that same
;; key does the inverse operation, if the argument list is already on
;; multiple lines.

;; Works on things other than argument lists, too, like {}-enclosed
;; blocks of statements, or list and dict displays in Python.

;; Bugs:
;; 
;; - doesn't escape from comments the way it escapes from strings
;; - doesn't drop the trailing separator when doing
;;   vertical-to-horizontal
;; - doesn't add a trailing separator when going
;;   horizontal-to-vertical
;; - removes trailing whitespace going horizontal-to-vertical, even
;;   before a close delimiter, even if there's leading whitespace
;;   after the open delimiter
;; - doesn't understand comments-to-the-end-of-the-line and how they
;;   screw up the transformation
;; - always puts the first argument on the same line as the open
;;   delimiter; it would be better to have a third format in which
;;   that first item indented on the next line instead.
;; - the functions should probably get a package prefix on their names

(defun inside-string-p ()
  "Returns true if we're inside a string."
  (cadddr (syntax-ppss)))

(defun backward-up-list-escaping-strings ()
  "Like backward-up-list, but works if we're inside a string."
  ;; probably should take comments into account too
  (while (inside-string-p) (backward-char))
  (backward-up-list))

(defun start-of-list ()
  "Go to inside the start of the currently enclosing list --- e.g. arg list."
  (interactive)
  (backward-up-list-escaping-strings)
  (down-list))


(defun end-of-list-p ()
  "Can we move no further forward without going up a list?"
  (looking-at "\\(\\s.\\|\n\\|\\s-\\)*\\s)"))

(defun horizontal-to-vertical-list ()
  "Turn a horizontal argument list into a vertical argument list.
This is written so that it only breaks at commas and semicolons; 
too bad for Lisps."
  (interactive)
  (save-excursion
    (start-of-list)
    (while (not (end-of-list-p))
      (while (not (or (end-of-list-p) (looking-at "\\s-*[;,]"))) ; skip over arg
        (forward-sexp))
      (while (looking-at "\\s-*[;,]") (forward-char)) ; skip over comma
      ;; now delete whitespace after comma
      (while (and (not (looking-at "\n")) (looking-at "\\s-")) (delete-char 1))
      (when (not (end-of-list-p)) ; insert newline if needed and indent
        (if (looking-at "\n") (forward-char) (insert "\n"))
        (indent-for-tab-command)))
    (if (current-list-horizontal-p) 
        (message "Couldn't find any commas or semicolons.  Are you editing Lisp?"))))

(defun vertical-to-horizontal-list ()
  (interactive)
  (save-excursion
    (backward-up-list-escaping-strings)
    (forward-list)
    (backward-char)
    (while (not (current-list-horizontal-p))
      (save-excursion (delete-indentation)))))

(defun current-list-horizontal-p ()
  "Returns nil unless the list around point is all on one line."
  (save-excursion
    (backward-up-list-escaping-strings)
    (let ((start (point)))
      (forward-list)
      (= 1 (count-lines start (point))))))


(defun toggle-list-orientation ()
  "Turn a horizontal list into a vertical one, or vice versa."
  (interactive)
  (if (current-list-horizontal-p)
      (horizontal-to-vertical-list)
    (vertical-to-horizontal-list)))

(global-set-key [f7] 'toggle-list-orientation)

(defun tablify ()
  "Reformat the region (or the current paragraph) using the tablify program."
  (interactive)
  (save-excursion
    (if (and transient-mark-mode (not mark-active))
        (mark-paragraph))
    (shell-command-on-region (region-beginning) (region-end)
                             "~/bin/tablify" nil ; nil OUTPUT-BUFFER
                             t)))                ; REPLACE

;;; bind F8 to open the filename that is the current line
;;; for use in ~/.emacs.d/auto-save-list/.saves-* files
(defun current-line-contents ()
  (save-excursion
    (move-beginning-of-line nil)
    (let ((start (point)))
      (move-end-of-line nil)
      (buffer-substring-no-properties start (point)))))
(defun find-file-named-on-current-line ()
  (interactive)
  (find-file (current-line-contents)))
(global-set-key [f8] 'find-file-named-on-current-line)

;;; I want a key to open the current buffer all over the screen.
(defun all-over-the-screen ()
  (interactive)
  (delete-other-windows)
  (split-window-horizontally)
  (split-window-horizontally)
  (balance-windows)
  (follow-mode t))

;;; for nighttime work
(defun red-on-black ()
  (interactive)
  (custom-set-faces
   '(default ((t (:stipple nil :background "black" :foreground "red" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
   '(mode-line ((((class color) (min-colors 88)) (:background "black" :foreground "#990000" :box (:line-width -1 :style released-button)))))))

;;; custom

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(asm-comment-char 35)
 '(column-number-mode t)
 '(compilation-scroll-output t)
 '(default-input-method "latin-1-prefix")
 '(erlang-electric-commands (quote (erlang-electric-comma erlang-electric-semicolon)) t)
 '(global-font-lock-mode t nil (font-lock))
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "sbcl")
 '(ispell-dictionary-alist (quote ((nil "[A-Za-z]" "[^A-Za-z]" "'\\|’" nil ("-B") nil iso-8859-1) ("american" "[A-Za-z]" "[^A-Za-z]" "'\\|’" nil ("-B") nil iso-8859-1) ("brasileiro" "[A-ZÁÉÍÓÚÀÈÌÒÙÃÕÇÜÂÊÔa-záéíóúàèìòùãõçüâêô]" "[^A-ZÁÉÍÓÚÀÈÌÒÙÃÕÇÜÂÊÔa-záéíóúàèìòùãõçüâêô]" "[']" nil nil nil iso-8859-1) ("british" "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B") nil iso-8859-1) ("castellano" "[A-ZÁÉÍÑÓÚÜa-záéíñóúü]" "[^A-ZÁÉÍÑÓÚÜa-záéíñóúü]" "[-]" nil ("-B") "~tex" iso-8859-1) ("castellano8" "[A-ZÁÉÍÑÓÚÜa-záéíñóúü]" "[^A-ZÁÉÍÑÓÚÜa-záéíñóúü]" "[-]" nil ("-B" "-d" "castellano") "~latin1" iso-8859-1) ("czech" "[A-Za-zÁÉÌÍÓÚÙÝ®©ÈØÏ«Òáéìíóúùý¾¹èøï»ò]" "[^A-Za-zÁÉÌÍÓÚÙÝ®©ÈØÏ«Òáéìíóúùý¾¹èøï»ò]" "" nil ("-B") nil iso-8859-2) ("dansk" "[A-ZÆØÅa-zæøå]" "[^A-ZÆØÅa-zæøå]" "[']" nil ("-C") nil iso-8859-1) ("deutsch" "[a-zA-Z\"]" "[^a-zA-Z\"]" "[']" t ("-C") "~tex" iso-8859-1) ("deutsch8" "[a-zA-ZÄÖÜäößü]" "[^a-zA-ZÄÖÜäößü]" "[']" t ("-C" "-d" "deutsch") "~latin1" iso-8859-1) ("english" "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B") nil iso-8859-1) ("esperanto" "[A-Za-z¦¬¶¼ÆØÝÞæøýþ]" "[^A-Za-z¦¬¶¼ÆØÝÞæøýþ]" "[-']" t ("-C") "~latin3" iso-8859-1) ("esperanto-tex" "[A-Za-z^\\]" "[^A-Za-z^\\]" "[-'`\"]" t ("-C" "-d" "esperanto") "~tex" iso-8859-1) ("francais7" "[A-Za-z]" "[^A-Za-z]" "[`'^---]" t nil nil iso-8859-1) ("francais" "[A-Za-zÀÂÆÇÈÉÊËÎÏÔÙÛÜàâçèéêëîïôùûü]" "[^A-Za-zÀÂÆÇÈÉÊËÎÏÔÙÛÜàâçèéêëîïôùûü]" "[-']" t nil "~list" iso-8859-1) ("francais-tex" "[A-Za-zÀÂÆÇÈÉÊËÎÏÔÙÛÜàâçèéêëîïôùûü\\]" "[^A-Za-zÀÂÆÇÈÉÊËÎÏÔÙÛÜàâçèéêëîïôùûü\\]" "[-'^`\"]" t nil "~tex" iso-8859-1) ("italiano" "[A-ZÀÁÈÉÌÍÒÓÙÚa-zàáèéìíóùú]" "[^A-ZÀÁÈÉÌÍÒÓÙÚa-zàáèéìíóùú]" "[-]" nil ("-B") "~tex" iso-8859-1) ("nederlands" "[A-Za-zÀ-ÅÇÈ-ÏÒ-ÖÙ-Üà-åçè-ïñò-öù-ü]" "[^A-Za-zÀ-ÅÇÈ-ÏÒ-ÖÙ-Üà-åçè-ïñò-öù-ü]" "[']" t ("-C") nil iso-8859-1) ("nederlands8" "[A-Za-zÀ-ÅÇÈ-ÏÒ-ÖÙ-Üà-åçè-ïñò-öù-ü]" "[^A-Za-zÀ-ÅÇÈ-ÏÒ-ÖÙ-Üà-åçè-ïñò-öù-ü]" "[']" t ("-C") nil iso-8859-1) ("norsk" "[A-Za-zÅÆÇÈÉÒÔØåæçèéòôø]" "[^A-Za-zÅÆÇÈÉÒÔØåæçèéòôø]" "[\"]" nil nil "~list" iso-8859-1) ("norsk7-tex" "[A-Za-z{}\\'^`]" "[^A-Za-z{}\\'^`]" "[\"]" nil ("-d" "norsk") "~plaintex" iso-8859-1) ("polish" "[A-Za-z¡£¦¬¯±³¶¼¿ÆÊÑÓæêñó]" "[^A-Za-z¡£¦¬¯±³¶¼¿ÆÊÑÓæêñó]" "" nil nil nil iso-8859-2) ("portugues" "[a-zA-ZÁÂÉÓàáâéêíóãú]" "[^a-zA-ZÁÂÉÓàáâéêíóãú]" "[']" t ("-C") "~latin1" iso-8859-1) ("russian" "[áâ÷çäå³öúéêëìíîïðòóôõæèãþûýøùÿüàñÁÂ×ÇÄÅ£ÖÚÉÊËÌÍÎÏÐÒÓÔÕÆÈÃÞÛÝØÙßÜÀÑ]" "[^áâ÷çäå³öúéêëìíîïðòóôõæèãþûýøùÿüàñÁÂ×ÇÄÅ£ÖÚÉÊËÌÍÎÏÐÒÓÔÕÆÈÃÞÛÝØÙßÜÀÑ]" "" nil nil nil koi8-r) ("slovak" "[A-Za-zÁÄÉÍÓÚÔÀÅ¥Ý®©ÈÏ«Òáäéíóúôàåµý¾¹èï»ò]" "[^A-Za-zÁÄÉÍÓÚÔÀÅ¥Ý®©ÈÏ«Òáäéíóúôàåµý¾¹èï»ò]" "" nil ("-B") nil iso-8859-2) ("svenska" "[A-Za-zåäöéàüèæøçÅÄÖÉÀÜÈÆØÇ]" "[^A-Za-zåäöéàüèæøçÅÄÖÉÀÜÈÆØÇ]" "[']" nil ("-C") "~list" iso-8859-1))) t)
 '(js2-cleanup-whitespace nil)
 '(js2-strict-missing-semi-warning nil)
 '(kept-new-versions 200)
 '(kept-old-versions 200)
 '(longlines-show-hard-newlines t)
 '(mark-ring-max 64)
 '(org-agenda-files (quote ("~/notes/notes.org")))
 '(org-insert-mode-line-in-empty-file t)
 '(org-startup-truncated nil)
 '(paren-mode (quote paren) nil (paren))
 '(parens-require-spaces nil)
 '(save-place t nil (saveplace))
 '(show-paren-delay 0)
 '(show-paren-mode (quote paren) nil (paren))
 '(split-height-threshold 5)
 '(transient-mark-mode t)
 '(truncate-partial-width-windows nil)
 '(vc-handled-backends nil)
 '(version-control t)
 '(visible-bell t)
 '(which-func-modes (quote (emacs-lisp-mode c-mode c++-mode perl-mode cperl-mode makefile-mode sh-mode fortran-mode f90-mode ada-mode python-mode))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#ffffff" :foreground "#000000" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 70 :width normal :foundry "unknown" :family "Monospace"))))
 '(paren-face-match ((((class color)) (:background "green"))))
 '(paren-face-mismatch ((((class color)) (:foreground "white" :background "red"))))
 '(paren-match ((t (:background "green"))))
 '(paren-mismatch ((t (:background "red"))))
 '(show-paren-match ((((class color)) (:background "green"))))
 '(show-paren-mismatch ((((class color)) (:background "blue")))))
