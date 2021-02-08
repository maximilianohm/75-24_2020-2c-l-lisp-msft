;;;; file-spell-checker.asd

(asdf:defsystem #:file-spell-checker
  :description "Describe file-spell-checker here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:spell-checker)
  :components ((:file "package")
               (:file "file-spell-checker")))
