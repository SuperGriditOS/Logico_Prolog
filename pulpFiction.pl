personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).


esPeligroso(Personaje):-
    realizaActividadPeligrosa(Personaje).
esPeligroso(Personaje):-
    tieneEmpleadosPeligrosos(Personaje).

realizaActividadPeligrosa(Personaje):-
    personaje(Personaje, mafioso(maton)).
realizaActividadPeligrosa(Personaje):-
    personaje(Personaje, ladron(Lugares)),
    member(licorerias, Lugares).


tieneEmpleadosPeligrosos(Personaje):-
    trabajaPara(Personaje, Empleado),
    realizaActividadPeligrosa(Empleado).


amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

duoTerrible(Personaje1,Personaje2):-
    sonPareja(Personaje1,Personaje2),
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    Personaje1 \= Personaje2.
duoTerrible(Personaje2,Personaje1):-
    sonPareja(Personaje1,Personaje2),
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    Personaje1 \= Personaje2.
duoTerrible(Personaje2,Personaje1):-
    sonAmigos(Personaje1,Personaje2),
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    Personaje1 \= Personaje2.
duoTerrible(Personaje1,Personaje2):-
    sonAmigos(Personaje1,Personaje2),
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    Personaje1 \= Personaje2.


sonPareja(Personaje1,Personaje2):-
    pareja(Personaje1,Personaje2).

sonAmigos(Personaje1,Personaje2):-
    amigo(Personaje1,Personaje2).


%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).


estaEnProblemas(_):-
    personaje(butch,_).
estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    encargo(Jefe, Personaje, cuidar(_)).
estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(_, _)).

/*
4.  sanCayetano/1:  es quien a todos los que tiene cerca les da trabajo (algún encargo). 
Alguien tiene cerca a otro personaje si es su amigo o empleado. 
*/

sanCayetano(Personaje) :-
    personaje(Personaje, _),
    findall(Cercano, personajeCercano(Personaje, Cercano), Cercanos),
    Cercanos \= [], 
    forall(member(Cercano, Cercanos), encargo(Personaje, Cercano, _)).

personajeCercano(Personaje, Cercano) :-
    trabajaPara(Personaje, Cercano).
personajeCercano(Personaje, Cercano) :-
    amigo(Personaje, Cercano).

/*
5. masAtareado/1. Es el más atareado aquel que tenga más encargos que cualquier otro personaje.
*/

cantidadEncargos(Personaje, Cantidad):-
    personaje(Personaje, _),
    findall(Encargo, encargo(_, Personaje, Encargo), Encargos),
    length(Encargos, Cantidad).

masAtareado(Personaje):-
    personaje(Personaje, _),
    cantidadEncargos(Personaje, Cantidad),
    forall((cantidadEncargos(OtroPersonaje,OtraCantidad),Personaje \= OtroPersonaje),Cantidad >= OtraCantidad).

