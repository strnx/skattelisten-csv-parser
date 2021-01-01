(defpackage skattelisten-csv-parser
  (:use
   :cl
   :str
   :unix-options)
  (:export
   :main))
(in-package :skattelisten-csv-parser)

(defstruct company
  cvr-num
  name
  se-num
  income-year
  company-type
  taxable
  taxable-income
  deficit
  corporate-tax)

(defun read-csv-file (fname thunk)
  (with-open-file (stream fname
                          :external-format :utf-8)
    (do ((line (read-line stream nil)
               (read-line stream nil)))
        ((null line))
      (funcall thunk line))))

(defun create-company (line)
  (let ((attr-list nil) (company nil))
    (setf attr-list (split "," line))
    (setq company (make-company
                   :cvr-num (nth 0 attr-list)
                   :name (nth 1 attr-list)
                   :se-num (nth 2 attr-list)
                   :income-year (nth 3 attr-list)
                   :company-type (nth 5 attr-list)
                   :taxable (nth 7 attr-list)
                   :taxable-income (nth 8 attr-list)
                   :deficit (nth 9 attr-list)
                   :corporate-tax (nth 10 attr-list)))
    company))

(defun run (fname)
  (read-csv-file fname #'create-company))

(defun main ()
  (with-cli-options (uiop:*command-line-arguments*)
                    (&parameters f)
    (format t "Starting import of ~S.~%" f)
    (run f)
    (format t "Finished import.~%")))
