(defun abrir ()
  (with-open-file (stream "Prueba.txt" :direction :input)
    (loop for line = (read-line stream nil)
          while line do (format t "~A~%" line))))
