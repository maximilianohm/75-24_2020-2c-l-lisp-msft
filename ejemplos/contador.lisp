(defun caracter (line)
  (with-input-from-string (stream line)
    (loop while (peek-char stream nil nil)
      collect (read stream))))

(defun copiar ()
  (setq contador 1)
  (with-open-file (source "Prueba.txt" :direction :input)
    (with-open-file (dest "Copia.txt" :direction :output :if-exists :rename-and-delete)
    (loop for line = (read-line source nil)
          while line
          do
          (caracter line)
          (setq contador (1+ contador))))))
