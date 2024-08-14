% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(andy, buzz, 8).
duenio(sam, jessie, 3).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial,[original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,
caraDePapa([ original(pieIzquierdo),
original(pieDerecho),
repuesto(nariz) ])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).
% Dice si una persona es coleccionista
esColeccionista(sam).

tematica(Juguete,Tematica):-
    juguete(Juguete,deTrapo(Tematica)).
tematica(Juguete,Tematica):-
    juguete(Juguete,deAccion(Tematica,_)).
tematica(Juguete,Tematica):-
    juguete(Juguete,miniFiguras(Tematica,_)).
tematica(Juguete,Tematica):-
    juguete(Juguete,caraDePapa(_)),
    Tematica = caraDePapa.
    
esDePlastico(Juguete):-
    juguete(Juguete,miniFiguras(_,_)).
esDePlastico(Juguete):-
    juguete(Juguete,caraDePapa(_)).

/*esDeColeccion/1:Tanto lo muñecos de acción como los cara de papa son de colección si
son raros, los de trapo siempre lo son, y las mini figuras, nunca.*/

esDeColeccion(Juguete):-
    juguete(Juguete,deTrapo(_)).
esDeColeccion(Juguete):-
    tematica(Juguete,caraDePapa),
    esRaro(Juguete).
esDeColeccion(Juguete):-
    juguete(Juguete,deAccion(_,_)),
    esRaro(Juguete).

/*
amigoFiel/2: Relaciona a un dueño con el nombre del juguete que no sea de plástico que tiene
hace más tiempo. Debe ser completamente inversible.
*/

amigoFiel(Duenio,Juguete):-
    duenio(Duenio,Juguete,_),
    not(esDePlastico(Juguete)),
    findall(OtroJuguete, (duenio(Duenio,OtroJuguete,Tiempo), not(esDePlastico(OtroJuguete)), Tiempo > 8), OtrosJuguetes),
    length(OtrosJuguetes, 0).

/*
3. superValioso/1: Genera los nombres de juguetes de colección que tengan todas sus piezas
originales, y que no estén en posesión de un coleccionista.
*/

superValioso(Juguete):-
    esDeColeccion(Juguete),
    juguete(Juguete,deAccion(_,Partes)),
    forall(member(Parte,Partes), esOriginal(Parte)),
    duenio(Duenio,Juguete,_),
    not(esColeccionista(Duenio)).

esOriginal(original(_)).

/*
4. dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le pertenezcan que
hagan buena pareja. Dos juguetes distintos hacen buena pareja si son de la misma temática.
Además woody y buzz hacen buena pareja. Debe ser complemenente inversible.
*/

duoDinamico(Duenio,Juguete1,Juguete2):-
    haceBuenaPareja(Juguete1,Juguete2),
    duenio(Duenio,Juguete1,_),
    duenio(Duenio,Juguete2,_),
    Juguete1 \= Juguete2.
duoDinamico(Duenio,Juguete2,Juguete1):-
    haceBuenaPareja(Juguete1,Juguete2),
    duenio(Duenio,Juguete2,_),
    duenio(Duenio,Juguete1,_),
    Juguete1 \= Juguete2.

haceBuenaPareja(Juguete1,Juguete2):-
    tematica(Juguete1,Tematica),
    tematica(Juguete2,Tematica).

haceBuenaPareja(woody,buzz).


/*
5. felicidad/2:Relaciona un dueño con la cantidad de felicidad que le otorgan todos sus
juguetes:
● las minifiguras le dan a cualquier dueño 20 * la cantidad de figuras del conjunto
● los cara de papas dan tanta felicidad según que piezas tenga: las originales dan 5, las de
repuesto,8.
● los de trapo, dan 100
● Los de accion, dan 120 si son de coleccion y el dueño es coleccionista. Si no dan lo mismo
que los de trapo.
Debe ser completamente inversible.
*/

felicidad(Duenio,Felicidad):-
    duenio(Duenio,_,_),
    findall(FelicidadJuguete,(duenio(Duenio,Juguete,_),daFelicidad(Duenio,Juguete,FelicidadJuguete)),Felicidades),
    sum_list(Felicidades,Felicidad).

daFelicidad(Duenio,Juguete,Felicidad):-
    juguete(Juguete,miniFiguras(_,Cantidad)),
    Felicidad is Cantidad * 20.

daFelicidad(Duenio,Juguete,Felicidad):-
    juguete(Juguete,caraDePapa(Partes)),
    daFelicidadcaraDePapa(Partes,Felicidad).

daFelicidad(Duenio,Juguete,Felicidad):-
    juguete(Juguete,deTrapo(_)),
    Felicidad is 100.

daFelicidad(Duenio,Juguete,Felicidad):-
    esColeccionista(Duenio),
    juguete(Juguete,deAccion(_,_)),
    esDeColeccion(Juguete),
    Felicidad is 120.

daFelicidad(Duenio,Juguete,Felicidad):-
    juguete(Juguete,deAccion(_,_)),
    Felicidad is 100.

daFelicidadcaraDePapa(Partes,Felicidad):-
    findall(Parte,(member(Parte,Partes),esOriginal(Parte)),PartesOriginales),
    length(PartesOriginales,Cantidad),
    Felicidad1 is Cantidad * 5,
    findall(Parte,(member(Parte,Partes),esRepuesto(Parte)),PartesRepuestos),
    length(PartesRepuestos,CantidadRepuestos),
    Felicidad2 is CantidadRepuestos * 8,
    Felicidad is Felicidad1 + Felicidad2.

esRepuesto(repuesto(_)).

