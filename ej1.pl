canilla(roja,triangular,4).
canilla(azul,redonda,3).
canjson(amarillo,redonda,2).

codo(rojo)
codo(azul)
codo(amarillo)

caño(rojo,4).
caño(azul,3).
caño(amarillo,2).

/*
Definir un predicado que relacione una cañería con su precio. Una cañería es una lista de piezas. Los precios son:
codos: $5.
caños: $3 el metro.
canillas: las triangulares $20, del resto $12 hasta 5 cm de ancho, $15 si son de más de 5 cm.

*/

precio([Pieza|Resto],Precio):-
    precioPieza(Pieza,PrecioPieza),
    precio(Resto,PrecioResto),
    Precio is PrecioPieza + PrecioResto.

precioPieza(codo(_),5).

precioPieza(caño(_,Longitud),Precio):-
    Precio is Longitud * 3.

precioPieza(canilla(amarillo,redonda,Ancho),Precio):-
    Ancho =< 5,
    Precio is 12.

precioPieza(canilla(amarillo,redonda,Ancho),Precio):-
    Ancho > 5,
    Precio is 15.

precioPieza(canilla(_,triangular,_),20).



precio([],0).
