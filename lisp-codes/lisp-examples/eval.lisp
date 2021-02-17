;Ejemplos sencillos para demostrar que hace

(eval '(+ 1 2))
(eval (+ 1 2))
(eval (cons '+ '(1 2)))
(eval 3)
(eval (cons 'a '(1 2 4)))

-------------------------------------------------------------

;Ejemplo sencillo pero se agrega un poco de dificultad

;Suma normal de una lista
(+ 1 2 3)
;Le asigno a una variable local 'suma' la función anterior con un quote
(setq suma '(+ 1 2 3))
;Si hago quote de la variable suma, muestra SUMA
'suma ---------> SUMA
;Si muestro suma, me muestra lo que contiene suma que es (+ 1 2 3)
suma ----------> (+ 1 2 3)
;Si uso el eval de suma, con el quote muestra (+ 1 2 3), en cambio sin el quote muestra el resultado de la suma que es 6
(eval 'suma)
(eval suma)

-------------------------------------------------------------

;Mismo ejemplo que el anterior pero en vez de hacer que suma tenga la función con quote, la tiene directo
(setq suma (+ 1 2 3))
;Si hago quote de la variable suma, muestra SUMA
'suma ---------> SUMA
;Si muestro suma, me muestra lo que contiene suma que es 6
suma ----------> 6
;Si uso el eval de suma, en los dos casos me va a mostrar 6 ya que es lo que contiene suma y lo que tiene si evaluo suma
(eval 'suma)
(eval suma)

-------------------------------------------------------------

;Ejemplo de como funciona en realidad

(setq PrimerVariable 'UnaVariable) --------> PrimerVariable = UnaVariable
(setq UnaVariable 'SoyOtraVariable) -------> UnaVariable = SoyOtraVariable

;En el siguiente caso recibe el argumento de la PrimerVariable
(eval 'PrimerVariable)
;Ahoa recibe a PrimerVariable, el cual es en realidad UnaVariable, el cual es a su vez SoyOtraVariable
(eval PrimerVariable)


-------------------------------------------------------------

;Ejemplo un poco mas complejo

(setq funcion '(1+ a)) ---------> funcion = 1 + a
(setq a 999) --------> a = 999 => funcion = 1 + 999 => funcion = 1000
;Usando el eval sin el quote, hace lo que la función debe y le asigna a 'a' el número 999
(eval funcion)
;Si usamos el quote, muestra literalmente lo que se encuentra en la varaible, en este caso la forma de la función
(eval 'funcion)


-------------------------------------------------------------

;Ejemplo complejo

;ACLARACION: El punto es una manera de generar una lista de una forma mas primitiva

(quote (a . b)) -----> (A . B)
'((quote (a . b)) c) --------> ('(A . B) C)
(car '((quote (a . b)) c)) ------------> '(A . B)
(list 'cdr (car '((quote (a . b)) c))) ----------> (CDR '(A . B))

;Si toda a esta construcción anterior le aplicamos el eval con el quote, nos dará el mismo resultado del final
(eval '(list 'cdr (car '((quote (a . b)) c)))) -----------> (CDR '(A . B))
;En cambio si usamos el eval sin el quote, evalua la expresión (cdr '(a . b)), por lo que devulve b
(eval (list 'cdr (car '((quote (a . b)) c)))) -------------> B