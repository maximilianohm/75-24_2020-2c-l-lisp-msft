;;;; file-spell-checker.lisp

;(in-package #:file-spell-checker)   ; Esto lo agrego quicklisp.  hay que ver por que sacandolo funciona cuando invocas la funcion en sbcl.

(defun get-words (string)
    "Dado un string, devuelve una lista de palabras."
    (cl-ppcre:all-matches-as-strings "[A-Za-zÄÖÜäöüáéíóú]+" string))

(defun get-suggestions (diccionario word)

    "Dado un diccionario, busca las sugerencias de correccion de <word>. Si no hay sugerencias retorna una lista vacia.  Caso contrario, retorna la lista de sugerencias."

    (let ((sugerencias (correct-ii diccionario word))) 
        
        ; Si no hay sugerencias, o la unica sugerencia es la palabra misma, significa que no hay correcciones.
        ; Luego, se retorna la lista vacia.
        (if (and (= 1 (length sugerencias)) (string= (nth 0 sugerencias) word))
            (setq sugerencias '(nil))
        )

        (return-from get-suggestions sugerencias)
    )
); get-suggestions

(defun index-words (diccionario line) 

    "Dado un diccionario, indexa las palabras de una linea indicando cuales poseen correcciones sugeridas."
    
    (let ((words (get-words line ))
          (index '(nil))
          (numero_palabra 0)
          (suggestions '(nil)))
        (dolist (wordcur words) 

            (setq numero_palabra (+ numero_palabra 1))
            (setq suggestions (get-suggestions diccionario (string-downcase wordcur)))
            ;(setq suggestions (get-suggestions diccionario wordcur)) ----> Acá es cuando pasa la palabra con mayúsculas
            
            (if (nth 0 suggestions)
                (if (nth 0 index)
                    (push (list numero_palabra wordcur suggestions) (cdr (last index)))
                    (setq index (list (list numero_palabra wordcur suggestions)))
                )
            )
        )

        (return-from index-words index)
    )
); index-words
    

(defun index-file (diccionario file-path) 
  
    "Crea un indice del archivo de texto <file-path> indexando por lineas que poseen palabras a corregir."

    (let ((index '(nil)) 
          (lines '(nil))
          (numeroLinea 0)
          (linea nil))
    
      (setq lines (uiop:read-file-lines file-path))

      (dolist (linea lines) 

        (setq numeroLinea (+ numeroLinea 1))
      
        (if (nth 0 index)
          (push (list numeroLinea linea (index-words diccionario linea)) (cdr (last index)))
          (setq index (list(list numeroLinea linea (index-words diccionario linea)))))      
      )

      (return-from index-file index)
    ))

(defun writeIndexToSTDOut (index) 

    "Imprime las lineas del indice junto con su numero de line a stdout."
         
    (dolist (node index) 
        (format T "~%~D: ~S" (nth 0 node) (nth 1 node)))
)


(defun createSuggestion(palabra)

	"Crea la estructura de la palabra a cambiar, quedando del estilo: <palabra-erronea | (sugerencia1, sugerencia2 ........)>"

	(setq numeroSugerencia 1)
	(setq correccion (concatenate 'string "<" (nth 1 palabra) " | ("))
    (setq todasSugerencias "")
    (setq tamaño (length(nth 2 palabra)))
    (dolist (sugerencia (nth 2 palabra))
    	;Verifica si la sugerencia es la última sugerencia disponible, esto es para cortar la impresión de la coma y quede todo mas prolijo
    	(if(equal tamaño numeroSugerencia)
			(setq todasSugerencias (concatenate 'string todasSugerencias sugerencia))
			(setq todasSugerencias (concatenate 'string todasSugerencias sugerencia ", "))
		)
		(setq numeroSugerencia (+ numeroSugerencia 1))
    )
    (setq correccion (concatenate 'string correccion todasSugerencias ")>"))
)


(defun wrongLineCreation (str lineaArchivo listadoPalabras)

	"Crea la linea en donde se reemplaza la palabra incorrecta por las sugerencias"

	(setq linea lineaArchivo)
   	(dolist (palabra listadoPalabras)
   		;Reemplaza la palabra incorrecta en la línea por el tercer parámetro que tiene la pinta <palabra-erronea|(sugerencias)>
    	(setq linea (cl-ppcre:regex-replace-all (nth 1 palabra) linea (createSuggestion palabra)))
    )
    (format str "~S~%" linea)
)

(defun createResultFile (filePath index) 

    "Crea un archivo en el que se tiene el texto original con las palabras erroneas seguidas por su sugerencia"

    (with-open-file (str filePath
                        :direction :output
                        :if-exists :rename-and-delete
                        :if-does-not-exist :create)
   		(dolist (elemento index)
   			;Verifica si hay palabas erroneas
    		(if(not(null(car(nth 2 elemento))))
    			;Si hay palabras incorrectas, crea la linea que se va a imprimir en el archivo
    	  		(wrongLineCreation str (nth 1 elemento) (nth 2 elemento))
    	  		;En caso de que no haya, directamente imprime la linea en el archivo
    	  		(format str "~S~%" (nth 1 elemento))
    		)
    	)
    )
         
)


(defun createSuggestionsFile (filePath index) 

    "Crea un archivo con las palabras erroneas y sus sugerencias de correcion, indexadas por nro de linea y palabra"
    

    (with-open-file (str filePath
                        :direction :output
                        :if-exists :rename-and-delete
                        :if-does-not-exist :create)
        (format str "----- Sugerencias de correción -----~%")
        (format str "~%")
        (format str "Formato: \"N°linea:N°palabra <palabra-erronea | (sugerencia1, sugerencia2 ... )>\"~%")
        (format str "~%")
        (mapcar #'(lambda (linea)
                (if (not (null (car (nth 2 linea))))
                    (mapcar #'(lambda (palabra)
                    	(format str "~D:~D " (nth 0 linea) (nth 0 palabra))
                    	(format str "~S~%" (createSuggestion palabra ))
                        ) (nth 2 linea)
                    )
                )
                
            ) index
        )
    
    )
        
)


(defun writeIndex (filePath index) 

    "Escribe el primer nivel del indice en un archivo de texto indicando el numero de linea."

    (with-open-file (str filePath
                        :direction :output
                        :if-exists :append
                        :if-does-not-exist :create)
        (dolist (el index)
        (format str "~%~D: ~S" (nth 0 el) (nth 1 el)))))
