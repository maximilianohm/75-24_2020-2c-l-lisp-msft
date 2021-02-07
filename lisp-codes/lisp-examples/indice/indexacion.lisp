(defpackage :file-index
  (:use :cl))
(in-package :file-index)
(ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(defun appendLineToIndex (index line lineNumber)
  
  "Agrega la linea al indice."

  (let ((indexAux index))
    
    (if index
      (push (list lineNumber line '(nil)) (cdr (last indexAux)))
      (setq indexAux (list lineNumber line '(nil)))
    )
      
    (return-from appendLineToIndex indexAux)
  )
)
  
(defun load-file (filename)
(let ((in (open filename :if-does-not-exist nil))
      (lines '(nil)))
  (when in
    (loop for line = (read-line in nil)
        while line do (princ line))
    (close in)
    )))

(defun get-file (filename)
  (with-open-file (stream filename :if-does-not-exist nil
                      :external-format '(:utf-8 :replacement "?"))
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun indexFile (filePath) 
  
    "Crea el indice del archivo de texto indexando por palabra con correccion."

    (let ((index '(nil)) 
          (lines '(nil))
          (numeroLinea 0)
          (linea nil))
    
      (setq lines (uiop:read-file-lines "/home/teoprog/msft-tp/ejemplos/indice/Prueba.txt"))
      (dolist (linea lines) 
        (setq numeroLinea (+ numeroLinea 1))
        (if (nth 0 index)
          (push (list numeroLinea linea '(nil)) (cdr (last index)))
          (setq index (list(list numeroLinea linea '(nil)))))
      )
      (return-from indexFile index)
    ))

(defun writeIndexToSTDOut (index) 
  "Imprime las lineas del indice junto con su numero de line a stdout."
  (dolist (node index) (format T "~% Line#: ~d Line: ~s" (nth 0 node) (nth 1 node))))


(defun writeIndex (filePath index) 

    "Escribe el primer nivel del indice en un archivo de texto indicando el numero de linea."

  (with-open-file (str filePath
                       :direction :output
                       :if-exists :append
                       :if-does-not-exist :create)
    (dolist (el index)
      (format str "~D: ~S" (nth 0 el) (nth 1 el)))))

;(defvar miIndice)
;(setq miIndice (indexFile "/home/teoprog/msft-tp/ejemplos/indice/Prueba.txt"))
;(writeIndex miIndice)

; (in-package file-index)
; (defvar laux)
; (setq laux (list (list 1 "mi mama me mima" '(nil))))
; (writeIndex laux)

; (push (list 2 "Pablito clavo un clavito" '(nil)) (cdr (last laux)))

; (setq laux (appendLineToIndex laux "Luna de papel." 4))

;(defvar fileIndex)
;(setq fileIndex (indexFile "/home/teoprog/msft-tp/ejemplos/indice/Prueba.txt"))
;(writeIndexToSTDOut fileIndex)
;(writeIndex "/home/teoprog/msft-tp/ejemplos/indice/PruebaIndexed.txt" fileIndex)
