;;; macdict.el --- Dictinary.app from Emacs

;; Copyright (C) 2013 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: http://github.com/syohex/emacs-macdict
;; Version: 0.01

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

; Emacs Port of macdict.vim

;;; Code:

(eval-when-compile
  (require 'cl))

(require 'thingatpt)

(defgroup macdict nil
  "macdict for Emacs"
  :group 'dictionary)

(defcustom macdict-default-lang 'japanese-english
  "Default language"
  :type 'symbol
  :group 'macdict)

(defcustom macdict-program "dict"
  "Dictionary command name"
  :type 'string
  :group 'macdict)

(defvar macdict--buffer-name "*macdict*")

(defun macdict--lang-option (lang)
  (case lang
    (japanese-english " ")
    (japanese "-j")
    (english "-e")
    (thesaurus "-t")
    (french "-f")
    (apple "-a")
    (wikipedia "-w")
    (otherwise (error "Invalid lang: '%s'" lang))))

(defvar macdict--searched-word-history '())

(defun macdict--common (lang)
  (let* ((cursor-word (thing-at-point 'word))
         (cursor-word-no-prop (and cursor-word
                                   (substring-no-properties cursor-word)))
         (lang-option (macdict--lang-option lang))
         (searched-word (read-string "Search word: "
                                     cursor-word-no-prop
                                     'macdict--searched-word-history))
         (cmd (format "%s %s '%s'" macdict-program lang-option searched-word)))
    (with-current-buffer (get-buffer-create macdict--buffer-name)
      (setq buffer-read-only nil)
      (erase-buffer)
      (unless (zerop (call-process-shell-command cmd nil t))
        (error "Failed: '%s'" cmd))
      (goto-char (point-min))
      (highlight-phrase (format "\\<%s\\>" (regexp-quote searched-word)))
      (pop-to-buffer (current-buffer))
      (setq buffer-read-only t))))

;;;###autoload
(defun macdict ()
  (interactive)
  (macdict--common macdict-default-lang))

;;;###autoload
(defun macdict-japanese ()
  (interactive)
  (macdict--common 'japanese))

;;;###autoload
(defun macdict-english ()
  (interactive)
  (macdict--common 'english))

;;;###autoload
(defun macdict-thesaurus ()
  (interactive)
  (macdict--common 'thesaurus))

;;;###autoload
(defun macdict-german ()
  (interactive)
  (macdict--common 'german))

;;;###autoload
(defun macdict-french ()
  (interactive)
  (macdict--common 'french))

;;;###autoload
(defun macdict-apple ()
  (interactive)
  (macdict--common 'french))

;;;###autoload
(defun macdict-wikipedia ()
  (interactive)
  (macdict--common 'wikipedia))

(provide 'macdict)

;;; macdict.el ends here
