; Agregar elementos al final de una lista.

(defvar lstA)

(setq lstA '(nil))

(push "casa" (cdr (last lstA)))
(push "perro" (cdr (last lstA)))
(push "gato" (cdr (last lstA)))

(write (nth 1 lstA))
(write (nth 2 lstA))
(write (nth 3 lstA))

