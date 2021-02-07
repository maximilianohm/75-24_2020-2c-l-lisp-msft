; the function AreaOfCircle
; calculates area of a circle
; when the radius is input from keyboard

(defpackage :input-stdin
  (:use :cl))
(in-package :input-stdin)
(ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(defun AreaOfCircle() "Reads from keyboard the radius and calculates the Area of the Circle."
    (terpri)
    (princ "Enter Radius: ")
    (setq radius (read))
    (setq area (* 3.1416 radius radius))
    (terpri)
    (princ "Area: ")
    (write area))