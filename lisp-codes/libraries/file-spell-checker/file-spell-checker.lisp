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
          (numero_palabra 0))
        (dolist (wordcur words) 

            (setq numero_palabra (+ numero_palabra 1))

            (if (nth 0 index)
                (push (list numero_palabra wordcur (get-suggestions diccionario wordcur)) (cdr (last index)))
                (setq index (list (list numero_palabra wordcur (get-suggestions diccionario wordcur))))
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
        (format T "~%~D: ~S" (nth 0 node) (nth 1 node))))


(defun writeIndex (filePath index) 

    "Escribe el primer nivel del indice en un archivo de texto indicando el numero de linea."

    (with-open-file (str filePath
                        :direction :output
                        :if-exists :append
                        :if-does-not-exist :create)
        (dolist (el index)
        (format str "~%~D: ~S" (nth 0 el) (nth 1 el)))))