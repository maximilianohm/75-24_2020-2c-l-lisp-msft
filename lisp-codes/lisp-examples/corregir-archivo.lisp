(ql:quickload "cl-ppcre")

#||(defun palabras (string)
  (cl-ppcre:all-matches-as-strings "[a-z]+" string))||#

(defun es-correcta (palabra)
    t)

(defun corregir (palabra)
    nil)

(defun es-palabra (palabra)
	if (= palabra "([a-zA-ZÁáÉéÍíÓóÚúÜüÑñ])")
		do t
		else do nil
)

(defun spell-check (archivo-origen archivo-destino archivo-corecciones)
    (let (lista-completa '()) ;crea lista vacia

    (with-open-file (input-stream archivo-origen 
    	:direction :input)
	(with-open-file (output-corregido-stream archivo-destino ;poner un header al archivo tipo: nro-linea | nro-palabra | palabra | correcciones
		:direction :output
		:if-exists :supersede
		:if-does-not-exist :create)
    (with-open-file (output-correciones-stream archivo-correcciones 
    	:direction :output 
		:if-exists :supersede
		:if-does-not-exist :create)
        
        (loop for linea = (read-line stream nil)
        	for contador-linea from 1

            do ( (setq linea '(cl-ppcre:split "\\b" linea :with-registers-p t))

            	(loop for palabra in linea
            		for contador-palabra from 1

            		do (if (and (es-palabra 'palabra) (not (es-correcta 'palabra)) );si es alfabetica y es incorrecta escribe sus correcciones

            			do ((format output-correciones-stream "~F, ~F, ~A , ~S" contador-linea contador-palabra palabra (corregir 'palabra)) ;asumo que corregir palabra devuelve una lista con las posibles correcciones
            				(format output-corregido-stream "~A~S" palabra (corregir 'palabra))
            			)

            			else do (format output-correciones-stream "~A" palabra)
            			
            		)
            	)
            )
        ) 
    )))
    )
)


#||(defun crear-lista-de-lineas (archivo-origen archio-destino)
    (let (lista-completa '()) ;crea lista vacia

    (with-open-file (stream archivo-origen :direction :input)
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
)||#

