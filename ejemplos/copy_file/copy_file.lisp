(defpackage :file-utils
  (:use :cl))
(in-package :file-utils)
(ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(defun copy-file (input-path output-path) 

    "Copy the file specified by input-path to the file specified by output-path"
    
    (let ((in (open input-path  :if-does-not-exist nil))
          (out(open output-path :direction :output
                                :if-exists :append
                                :if-does-not-exist :create)))
        (when in
            (loop for line = (read-line in nil)
                while line do (write-line  line out))
            (close in)
            (close out))))

