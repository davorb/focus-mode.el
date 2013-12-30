;;; focus-mode.el --- iA Writer-like mode for emacs

;; Copyright (c) 2013 Davor Babic <davor@davor.se>

;; Author: Davor Babic
;; Version: 0.0.2
;; Created: 2013-12-29
;; URL: https://github.com/davorb/focus-mode.el
;; Keywords: editing, focus, margin

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restrictnion, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

;;; Code:

(defvar focus-mode-hook nil)

(defun set-buffer-margins ()
  (let* ((margins (if (not (window-margins))
                      (window-margins) '(0 0)))
         (full-width (+ (first margins)
                        (second margins)
                        (window-width)))
         (target-width (if (>= 80 full-width)
                           80 80)) ;full-width 80))
         (move-left 3)
         (margin (/ (- full-width target-width) 2)))
    (if (and focus-mode (not (car (window-margins))))
        (set-window-margins (car (get-buffer-window-list (current-buffer)))
                            (- margin move-left) (+ margin move-left)))))

(defun on-focus-mode-disable ()
  (set-window-margins (car (get-buffer-window-list (current-buffer))) 0 0)
  (remove-hook 'focus-mode-off-hook 'on-focus-mode-disable)
  (remove-hook 'window-configuration-change-hook 'set-buffer-margins))

(define-minor-mode focus-mode
  "iA Writer-like mode for Emacs"
  nil " Focus" nil
  (set-buffer-margins)
  (add-hook 'focus-mode-off-hook 'on-focus-mode-disable)
  (add-hook 'window-configuration-change-hook 'set-buffer-margins))

;;; focus-mode.el ends here
