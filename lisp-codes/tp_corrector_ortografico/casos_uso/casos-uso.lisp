;;;; corrector-ortografico.lisp

;;Cargar File Spell Checker
(ql:quickload "file-spell-checker") ;Cargar File Spell Checker

;; Inicializar el diccionario
(defvar diccionario)
(setq diccionario (init-dictionary "abcdefghijklmnñopqrstuvwxyz" "corrector-ortografico/archivo_grande.txt"))

;; Inicializo el índice de correcciones.
(defvar indice-correccion)
(setq indice-correccion (index-file diccionario "corrector-ortografico/archivo_entrada.txt"))

;; Se crea el archivo de sugerencias.
(createSuggestionsFile "corrector-ortografico/sugerencias.txt" indice-correccion)

;; Se crea el archivo de resumen.
(createResultFile "corrector-ortografico/corregido.txt" indice-correccion)