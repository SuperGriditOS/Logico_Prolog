personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
actividadPeligrosa(mafioso(maton)).
actividadPeligrosa(ladron(Lista)):- member(licorerias, Lista).

empleadoPeligroso(Personaje,Empleado):-
    trabajaPara(Personaje,Empleado),
    personaje(Empleado,Actividad),
    actividadPeligrosa(Actividad).

esPeligroso(Personaje):-
    personaje(Personaje,Actividad),
    actividadPeligrosa(Actividad),
    empleadoPeligroso(Personaje,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

parejaOamigos(Personaje1,Personaje2):- amigo(Personaje1,Personaje2).
parejaOamigos(Personaje1,Personaje2):- pareja(Personaje1,Personaje2).
parejaOamigos(Personaje1,Personaje2):- pareja(Personaje2,Personaje1).
parejaOamigos(Personaje1,Personaje2):- amigo(Personaje2,Personaje1).

duoTemible(Personaje1,Personaje2):-
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    parejaOamigos(Personaje1,Personaje2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, jules, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

estaEnProblemas(Personaje):-
    trabajaPara(Jefe,Personaje),
    esPeligroso(Jefe),
    pareja(Jefe,Pareja),
    encargo(Jefe,Personaje,cuidar(Pareja)).

estaEnProblemas(Personaje):-
    trabajaPara(Jefe,Personaje),
    esPeligroso(Jefe),
    encargo(Jefe,Personaje,buscar(Boxeador,_)),
    personaje(Boxeador,boxeador).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sanCayetano(Personaje) :-
    personaje(Personaje, _),
    findall(Cercano, personajeCercano(Personaje, Cercano), Cercanos),
    Cercanos \= [], 
    forall(member(Cercano, Cercanos), encargo(Personaje, Cercano, _)).

personajeCercano(Personaje, Cercano) :-
    trabajaPara(Personaje, Cercano).
personajeCercano(Personaje, Cercano) :-
    amigo(Personaje, Cercano).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cantidadEncargos(Personaje,Cantidad):-
    personaje(Personaje, _),
    findall(Encargo,encargo(_,Personaje,Encargo),Encargos),
    length(Encargos,Cantidad).

masAtareado(Personaje):-
    personaje(Personaje, _),
    cantidadEncargos(Personaje,Cantidad),
    forall((cantidadEncargos(OtroPersonaje,OtraCantidad),Personaje \= OtroPersonaje),Cantidad >= OtraCantidad).

personajesRespetables(Personajes):-
    findall(Personaje,(personaje(Personaje,_),esRespetable(Personaje)),Personajes).


nivelRespeto(actriz(Peliculas),Nivel):-
    length(Peliculas,Cantidad),
    Nivel is Cantidad / 10.
nivelRespeto(mafioso(capo),Nivel):- Nivel is 20.
nivelRespeto(mafioso(resuelveProblemas),Nivel):- Nivel is 10.
nivelRespeto(mafioso(maton),Nivel):- Nivel is 1.

esRespetable(Personaje):-
    personaje(Personaje,Actividad),
    nivelRespeto(Actividad,Nivel),
    Nivel > 9.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hartoDe(Personaje, Otro) :-
    personaje(Personaje, _),
    personaje(Otro, _),
    findall(Tarea, encargo(_, Personaje, Tarea), Tareas),
    Tareas \= [],
    forall(member(Tarea, Tareas), interactuaCon(Tarea, Otro)).

interactuaCon(cuidar(Persona), Otro) :- interaccionDirectaOIndirecta(Persona, Otro).
interactuaCon(buscar(Persona, _), Otro) :- interaccionDirectaOIndirecta(Persona, Otro).
interactuaCon(ayudar(Persona), Otro) :- interaccionDirectaOIndirecta(Persona, Otro).

interaccionDirectaOIndirecta(Persona, Otro) :- Persona = Otro.
interaccionDirectaOIndirecta(Persona, Otro) :- amigo(Persona, Otro).
interaccionDirectaOIndirecta(Persona, Otro) :- amigo(Otro, Persona).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

caracteristicas(vincent, [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules, [muchoPelo, tieneCabeza]).
caracteristicas(marvin, [negro]).

duoDiferenciable(Personaje1,Personaje2):-
    parejaOamigos(Personaje1,Personaje2),
    caracteristicas(Personaje1,Lista1),
    caracteristicas(Personaje2,Lista2),
    tieneDiferencia(Lista1,Lista2).


tieneDiferencia(Lista1,Lista2) :-
    member(Caracteristica,Lista1),
    not(member(Caracteristica,Lista2)).