(defpackage :file-index
  (:use :cl))
(in-package :file-index)
(ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(defun appendLineToIndex (index line lineNumber)
  
  "Agrega la linea al indice."

  (let ((indexAux index))

      (push (list lineNumber line '(nil)) (cdr (last indexAux)))
      (return-from appendLineToIndex indexAux)))
  


(defun indexFile (filePath) 
  
    "Crea el indice del archivo de texto indexando por palabra con correccion."
  
    (let ((in (open filePath  :if-does-not-exist nil))
          (index '(nil))
          (lineNumber 0))
        (when in
            (loop for line = (read-line in nil)
                while line do (setq index (appendLineToIndex index line (setq lineNumber (+ lineNumber 1)))))
            (close in)
          (return-from indexFile index))))

(defun writeIndex (index) 
  "Imprime las lineas del indice junto con su numero de line a stdout."
  (dolist (node index) (format T "~% Line#: ~d Line: ~s" (nth 0 node) (nth 1 node))))

;(defvar miIndice)
;(setq miIndice (indexFile "/home/teoprog/msft-tp/ejemplos/indice/Prueba.txt"))
;(writeIndex miIndice)

; (in-package file-index)
; (defvar laux)
; (setq laux (list (list 1 "mi mama me mima" '(nil))))
; (writeIndex laux)

; (push (list 2 "Pablito clavo un clavito" '(nil)) (cdr (last laux)))

; (setq laux (appendLineToIndex laux "Luna de papel." 4))

; (defvar fileIndex)
; (setq fileIndex (indexFile "/home/teoprog/msft-tp/ejemplos/indice/Prueba.txt"))
; (writeIndex fileIndex)