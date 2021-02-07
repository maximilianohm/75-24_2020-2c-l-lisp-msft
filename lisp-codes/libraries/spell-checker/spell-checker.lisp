

;;;; Literal translation of Peter Norvig's spell corrector (http://norvig.com/spell-correct.html)
;;;; by Mikael Jansson <mikael@lisp.se>
;;;;
;;;; At some time, for some test case, on some version of SBCL, I find this to be 1e6 times faster than the Python version on a Quad Xeon 2,6 GHz.
;;;; I can no longer (2015) verify that claim, nor do I remember how I tested it, so the speedup is most likely invalid.

;(defpackage #:spell-checker
;  (:use :cl))

;(in-package :spell-checker)

(defun words (string)
    "Dado un string retorna una lista de palabras."
  (cl-ppcre:all-matches-as-strings "[A-Za-zÄÖÜäöüáéíóú]+" string))

(defun train (words)
    "Retorna la frecuencia con que aparece cada palabra en el listado de palabras dado."
  (let ((frequency (make-hash-table :test 'equal)))
    (dolist (word words)
      ;; default 1 to make unknown words OK
      (setf (gethash word frequency) (1+ (gethash word frequency 1))))
    frequency))

;(defvar *freq* (train (words (nstring-downcase (alexandria:read-file-into-string #P"archivo_grande.txt")))))
;(defvar *alphabet* "abcdefghijklmnñopqrstuvwxyz")


;;; Edits of one character
(defun edits-1 (diccionario word)
    "Uses the <diccionario> to analyze the <word> and returns a list of words that are to one-edit-step of the given word."
    (let* ((alphabet (nth 0 diccionario))
            (splits     (loop for i from 0 upto (length word)
                            collecting (cons (subseq word 0 i) (subseq word i))))
            (deletes    (loop for (a . b) in splits
                            when (not (zerop (length b)))
                            collect (concatenate 'string a (subseq b 1))))
            (transposes (loop for (a . b) in splits
                            when (> (length b) 1)
                            collect (concatenate 'string a (subseq b 1 2) (subseq b 0 1) (subseq b 2))))
            (replaces   (loop for (a . b) in splits
                            nconcing (loop for c across alphabet
                                            when (not (zerop (length b)))
                                            collect (concatenate 'string a (string c) (subseq b 1)))))
            (inserts    (loop for (a . b) in splits
                            nconcing (loop for c across alphabet
                                            collect (concatenate 'string a (string c) b)))))
        (nconc deletes transposes replaces inserts)))     

(defun known-edits-2 (diccionario word)
    "Uses the <diccionario> to analyze the <word> and returns a list of words that are to two-edit-step of the given word."
    (loop for e1 in (edits-1 diccionario word) nconcing
            (loop for e2 in (edits-1 diccionario e1)
                when (multiple-value-bind (value pp) (gethash e2 (nth 1 diccionario) 1) pp)
                collect e2)))

(defun known (diccionario words)
    "Uses the <diccionario> for returning a list with known words."
    (loop for word in words
            when (multiple-value-bind (value pp) (gethash word (nth 1 diccionario) 1) pp)
            collect word))

(defun init-dictionary (alphabet probability_file_path) 
    "Inicializa el diccionario utlizando el alfabeto y el archivo de probabilidades especificado."
    (
        return-from init-dictionary (list alphabet (train (words (nstring-downcase (alexandria:read-file-into-string probability_file_path)))))
    ))

(defun correct (diccionario word)
    "Uses the <diccionario> for evaluating the <word> and return a list with suggestions."
    (loop for wordc in 
        (or 
            (known diccionario (list word)) 
            (known diccionario (edits-1 diccionario word)) 
            (known-edits-2 diccionario word)
            (list word))
        maximizing (gethash wordc (nth 1 diccionario) 1 )
        finally (return wordc)))

(defun correct-ii (diccionario word)
    "Uses the <diccionario> for evaluating the <word> and return a list with suggestions."
    (loop for wordc in 
        (or 
            (known diccionario (list word)) 
            (known diccionario (edits-1 diccionario word)) 
            (known-edits-2 diccionario word)
            (list word))
        when (> (gethash wordc (nth 1 diccionario) 1) 3) ; 3 es la cantidad minima de veces que la palabra aparece en el archivo de probabilidad.
            collect wordc))
