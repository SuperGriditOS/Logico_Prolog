persona(nina,joven,22,1.60).
persona(marcos,ninio,8,1.32).
persona(osvaldo,adolescente,13,1.29).

atraccion(trenFantasma).
atraccion(montaniaRusa).
atraccion(maquinaTiquetera).
atraccion(laOlaAzul).
atraccion(corrienteSerpenteante).
atraccion(maremoto).
atraccion(meHiceCaca).

puedeSubir(Persona,Atraccion):-
    atraccion(Atraccion),
    puedeSubirAtraccion(Persona,Atraccion).

puedeSubirAtraccion(Persona,trenFantasma):-
    persona(Persona,_,Edad,_),
    Edad >= 12.
puedeSubirAtraccion(Persona,montaniaRusa):-
    persona(Persona,_,_,Altura),
    Altura > 1.30.
puedeSubirAtraccion(Persona,maquinaTiquetera):-
    persona(Persona,_,_,_).
puedeSubirAtraccion(Persona,laOlaAzul):-
    persona(Persona,_,_,Altura),
    Altura >= 1.50.
puedeSubirAtraccion(Persona,corrienteSerpenteante):-
    persona(Persona,_,_,_).
puedeSubirAtraccion(Persona,maremoto):-
    persona(Persona,_,Edad,_),
    Edad >= 5.
puedeSubirAtraccion(Persona,meHiceCaca):-
    persona(Persona,_,Edad,_),
    Edad >= 80.

/*
esParaElle/2, relaciona un parque con una persona, si la persona puede subir a todos los juegos del parque.
*/

parque(parqueDeLaCostant,[trenFantasma,montaniaRusa,corrienteSerpenteante,maremoto,meHiceCaca]).
parque(disneynt,[trenFantasma,maquinaTiquetera]).
parque(euroDisneynt,[meHiceCaca]).


esParaElle(Parque,Persona):-
    persona(Persona,_,_,_),
    parque(Parque,Atracciones),
    forall(member(Atraccion,Atracciones),puedeSubirAtraccion(Persona,Atraccion)).

/*
malaIdea/2, relaciona un grupo etario (adolescente/niño/joven/adulto/etc) con un parque, y nos dice que "es mala idea" que las personas de ese grupo vayan juntas a ese parque, si es que no hay ningún juego al que puedan subir todos.
*/
 
malaIdea(GrupoEtario,Parque):-
    parque(Parque,Atracciones),
    member(Atraccion,Atracciones),
    atraccion(Atraccion),
    persona(_,GrupoEtario,_,_),
    forall(persona(Persona,GrupoEtario,_,_),not(puedeSubirAtraccion(Persona,Atraccion))).


programa([maremoto,corrienteSerpenteante,laOlaAzul]).
