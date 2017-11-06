; latex-snippets.el
; -----------------
; Minor mode to insert useful snippets for plots and tables. This mode
; is intended to be used with a special LaTeX template which I created
; as well. This mode is still in development and many features such
; as proper error handling are not yet implemented. If you want to use
; this snippet without my template, you should adjust the relative paths
; used for file access such as:
;
; table[x=,y=,col sep=comma] {res/tables/%s.csv} ->
; table[x=,y=,col sep=comma] {YOURPATH/%s.csv}
;
; The key map can be changed at the bottom of the file, the default is:
;
; C-c p - Insert plot (from .csv)
; C-c t - Insert table (from .csv)
; C-c f - Insert figure (any supported filetype)
; C-c c - Insert circuit (expects a file containing circuitikz code)
;
; If you have any questions regarding the setup/usage of the snippets,
; refer to the tutorials on http://www.latex-tutorial.com in the
; advanced section, where similar code snippets are explained in detail.
;
; You can also obtain the full template from the download section on
; the same website. If the files are not available for some reason,
; send me an email and I will send you a copy as soon as possible.
;
; Installation
; ------------
; 1. Copy latex-snippets.el or latex-snippets.elc to ~/.emacs.d/
; 2. Add the following lines to your .emacs file:
;
;   (ido-mode t)
;   (add-to-list 'load-path "~/.emacs.d/")
;   (load "latex-snippets")
;
; 3. Profit
;
; License
; -------
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; Copyright (C) 2013  Claudio Vellage (vellage@ieee.org)

(require 'ido)

(defun latex-insert-csv-plot ()
  "This function prompts the user to select a file and inserts the code for plotting it
 using pgfplots"
  (interactive)
  (let ((filename (file-name-base (ido-read-file-name ".")))) (insert (format "
%%
%% Picture %s
%%
\\begin{figure}[H]
  \\begin{center}
    \\begin{tikzpicture}
      \\begin{axis}[
      width=\\textwidth,
      grid=major,
      grid style={dashed,gray!30},
      xlabel=,
      ylabel=,
      x unit=\\si{},
      y unit=\\si{},
      legend columns=2,
      legend style={at={(0.5,-0.20)},anchor=north},
      x tick label style={rotate=90,anchor=east}
      ]
        \\addplot 
        table[x=,y=,col sep=comma] {res/tables/%s.csv};
        \\addlegendentry{}
      \\end{axis}
    \\end{tikzpicture}
    \\caption{}
    \\label{fig:%s}
  \\end{center}
\\end{figure}
" filename filename filename))))

(defun latex-insert-csv-table ()
  "This function prompts the user to select a file and inserts the code for plotting a table
 using pgfplotstable"
  (interactive)
  (let ((filename (file-name-base (ido-read-file-name ".")))) (insert (format "
%%
%% Table %s
%%
\\begin{table}[H]
  \\begin{center}
    \\caption{}
    \\label{tab:%s}
    \\pgfplotstabletypeset[
      multicolumn names,
      col sep=comma,
      fixed zerofill,
      precision=1,
      display columns/0/.style={column name=$$,column type={S},string type},
      display columns/1/.style={column name=$$,column type={S},string type},
      every head row/.style={before row={\\toprule}, after row={\\si{} & \\si{} \\\\ \\midrule}},
      every last row/.style={after row=\\bottomrule},
    ]{res/tables/%s.csv}
  \\end{center}
\\end{table}
" filename filename filename))))

(defun latex-insert-picture ()
  "This function prompts the user to select a file and inserts the code to show a picture in a figure
environment"
  (interactive)
  (let ((filename (ido-read-file-name "."))) (let ((base (file-name-base filename)) (ext (file-name-extension filename))) (insert (format "
%%
%% Picture %s
%%
\\begin{figure}[H]
  \\begin{center}
    \\includegraphics[width=\\textwidth]{res/pictures/%s.%s}
    \\caption{}
    \\label{fig:%s}
  \\end{center}
\\end{figure}
" base base ext base)))))

(defun latex-insert-circuit ()
  "This function prompts the user to select a file, creates it and inserts
the code to embed a circuitikz circuit inside a figure environment."
  (interactive)
  (let ((filename (ido-read-file-name "."))) (progn
					       (with-temp-buffer
						 (insert "\\begin{circuitikz}\n\n\\end{circuitikz}\n") (when (file-writable-p filename)
												      (write-region (point-min) (point-max) filename)))
					       (let ((base (file-name-base filename)) (ext (file-name-extension filename))) (insert (format "
%%
%% Circuit %s
%%
\\begin{figure}[H]
  \\begin{center}
    \\input{res/tikz/%s.tex}
    \\caption{}
    \\label{fig:%s}
  \\end{center}
\\end{figure}
" base base base))))))

;
; Set key map here:
;

(define-minor-mode latex-snippets
  "Provides insertion of useful latex snippets in latex-mode"
  :lighter latex-snippets
  :keymap (let ((map (make-sparse-keymap)))
	    (define-key map (kbd "C-c p") 'latex-insert-csv-plot)
	    (define-key map (kbd "C-c t") 'latex-insert-csv-table)
	    (define-key map (kbd "C-c f") 'latex-insert-picture)
	    (define-key map (kbd "C-c c") 'latex-insert-circuit)
	    map))

(add-hook 'latex-mode-hook 'latex-snippets)
(add-hook 'latex-snippets-hook 'ido-mode)

(provide 'latex-snippets)
