(ql:quickload "cl-ppcre")

#||(defun palabras (string)
  (cl-ppcre:all-matches-as-strings "[a-z]+" string))||#

(defun es-correcta (palabra)
    t)

(defun corregir (palabra)
    nil)

#||(defun corregir (archivo)
    (with-open-file (stream archivo :direction :input)
  	    (setq contador-linea 0)
        (loop for linea = (read-line stream nil)

            do (setq contador-palabra 0)
                (setq contador-linea (+ contador-linea 1))
                (loop for palabra in (palabras linea)

        	do (setq contador-palabra 0)
        	   (setq contador-palabra (+ contador-palabra 1))
        	   (evaluar palabra)
        	)
        )
    )
)||#

(defun crear-lista-de-lineas (archivo)
    (let (lista-completa '()) ;crea lista vacia

    (with-open-file (stream archivo :direction :input)
        (loop for linea = (read-line stream nil)
            do (append lista-completa (list linea)) ;queda en doble lista de forma ((linea) (linea) ...)
        )
    ))

    (lista-completa)
)

(defun evaluar-lineas (lista)

    (loop for linea in lista
        do ((setq linea '(cl-ppcre:split "\\b" (car 'linea) :with-registers-p t))

            (loop for palabra in 'linea
            do ((if (not (es-correcta 'palabra)) 
                then (append 'linea '((corregir 'palabra)) )
                ))
            )
        )
    )
)

