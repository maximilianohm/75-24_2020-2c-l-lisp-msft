(defun escribir (dest line)
  (format dest "~A~%" line))

(defun copiar ()
  (with-open-file (source "Prueba.txt" :direction :input)
    (with-open-file (dest "Copia.txt" :direction :output :if-exists :rename-and-delete)
    (loop for line = (read-line source nil)
          while line do (escribir dest line)
          ))))
