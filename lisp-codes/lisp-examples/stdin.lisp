(defun factorial (n)
  (loop for i from 1 to n
        for y = 1 then (* i y)
        finally (return y)))

(defun factorial-main ()
  (defvar numero)
  (princ "Ingresa un numero: ")
  (setq numero (read))
  (print "Factorial: ")
  (write (factorial numero)))
