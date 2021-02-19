;;;; ejemplo-proyecto-01.asd

(asdf:defsystem #:ejemplo-proyecto-01
  :description "Ejemplo-Proyecto-01 es un ejemplo de creación de proyeco en LISP."
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "utils")
               (:file "ejemplo-proyecto-01")))
