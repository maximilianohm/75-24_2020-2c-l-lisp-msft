(defun factorial (n)
  (loop for i from 1 to n
        for y = 1 then (* i y)
        finally (return y)))
 
(defun factorial-main ()
  (format t "~d" (factorial (read))))
 
 
(factorial-main)