(in-package #:ejemplo-proyecto-01)

(defun Greeting (name) 
    "Imprime un saludo"
    (let ((saludo nil)) 
        (setq saludo (format nil  "~%~%¡¡¡Hola ~S!!!" name))
        (return-from Greeting saludo)
    )
)
