seVa(dodain,pehuenia).
seVa(dodain,sanMartin).
seVa(dodain,esquel).
seVa(dodain,sarmiento).
seVa(dodain,camarones).
seVa(dodain,playasDoradas).
seVa(alf,bariloche).
seVa(alf,sanMartin).
seVa(alf,elBolson).
seVa(nico,mardel).
seVa(vale,rosario).
seVa(vale,calafate).
seVa(vale,elBolson).
seVa(guido,esquel).

seVa(martu,Ciudad):-
    seVa(alf,Ciudad),
    seVa(nico,Ciudad).

/*
atraccion(parqueNacional(nombre)).
atraccion(cerro(nombre,altura)).
atraccion(cuerpoAgua(nombre,puedePescar,temperaturaPromedio)).
atraccion(playa(nombre,promedio)).
atraccion(excursion(nombre)).
*/

atraccion(esquel,parqueNacional(losAlerces)).
atraccion(esquel,excursion(trochita)).
atraccion(esquel,excursion(trevelin)).

atraccion(villaPehuenia,cerro(bateaMahuida,2000)).
atraccion(villaPehuenia,cuerpoAgua(moquehue,si,14)).
atraccion(villaPehuenia,cuerpoAgua(alumine,si,19)).

cerroCopado(Ciudad):-
    atraccion(Ciudad,cerro(_,Altura)),
    Altura > 2000.

cuerpoAguaCopado(Ciudad):-
    atraccion(Ciudad,cuerpoAgua(_,si,Temperatura)),
    Temperatura > 20.

playaCopada(Ciudad):-
    atraccion(Ciudad,playa(_,Promedio,_)),
    Promedio < 5.

excursionCopada(Atraccion):-
    atraccion(_,excursion(Atraccion,_)),
    length(Atraccion,CantidadDeLetras),
    CantidadDeLetras > 7.

parqueNacionalCopado(Ciudad):-
    atraccion(Ciudad,parqueNacional(_)).

existeAtraccionCopada(Ciudad):-
    cerroCopado(Ciudad).
existeAtraccionCopada(Ciudad):-
    parqueNacionalCopado(Ciudad).
existeAtraccionCopada(Ciudad):-
    cuerpoAguaCopado(Ciudad).
existeAtraccionCopada(Ciudad):-
    playaCopada(Ciudad).
existeAtraccionCopada(Ciudad):-
    excursionCopada(Ciudad).

/*
Queremos saber qué vacaciones fueron copadas para una persona. Esto ocurre cuando todos los lugares a visitar tienen por lo menos una atracción copada. 
*/

vacacionesCopadas(Persona):-
    seVa(Persona, _),
    findall(Ciudad, seVa(Persona, Ciudad), Ciudades),
    forall(member(Ciudad, Ciudades), existeAtraccionCopada(Ciudad)).

/*
Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que no se cruzaron. Por ejemplo, Dodain no se cruzó con Nico ni con Vale (sí con Alf en San Martín de los Andes). Vale no se cruzó con Dodain ni con Nico (sí con Alf en El Bolsón). El predicado debe ser completamente inversible.
*/

seCruzaron(Persona1, Persona2):-
    seVa(Persona1, Ciudad),
    seVa(Persona2, Ciudad),
    Persona1 \= Persona2.

noSeCruzaron(Persona1, Persona2):-
    not(seCruzaron(Persona1, Persona2)),
    Persona1 \= Persona2.
noSeCruzaron(Persona1, Persona2):-
    not(seCruzaron(Persona2, Persona1)),
    Persona1 \= Persona2.