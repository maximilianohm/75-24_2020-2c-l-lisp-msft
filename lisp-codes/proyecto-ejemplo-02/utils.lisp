(in-package #:proyecto-ejemplo-02)

(defun Greeting (name) 
    "Imprime un saludo"
    (let ((saludo nil)) 
        (setq saludo (format nil  "~%~%¡¡¡Hola ~S!!!" name))
        (return-from Greeting saludo)
    )
)

(defun excepcion_ignorada ()
    "Ejemplo donde se ignora la excepcion."

    ;; Ignora los errores
    (ignore-errors
        (/ 3 0))

    (format t "~%~%Se ignora la excepcion de division por cero.~%~%")
)

(defun excepcion_atrapada () 
    "Ejemplo del manejo de una excepcion"

    (handler-case (/ 3 0)
    (error (c)
        (format t "~%~%¡¡Tratas de dividir por cero!!~&~%~%")
        (values 0 c)))  
)