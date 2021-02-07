;;;; spell-checker.asd

(asdf:defsystem #:spell-checker
  :description "Implementa un corrector ortografico en castellano."
  :author "msft-tp"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-ppcre
               #:alexandria)
  :components ((:file "package")
               (:file "spell-checker")))
