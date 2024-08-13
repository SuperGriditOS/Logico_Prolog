gusta(juan,maria).
gusta(pedro,ana).
gusta(pedro,nora).
gusta(pedro,luisa).

gustaZulema(Alguien,zulema):-
    gusta(Alguien,nora).

gustaLaura(Alguien,laura):-
    gusta(Alguien,ana),
    gusta(Alguien,luisa).

progenitor(homero, bart).
progenitor(homero, lisa).
progenitor(homero, maggie).
progenitor(abe, homero).
progenitor(abe, jose).
progenitor(jose, pepe).
progenitor(mona, homero).
progenitor(jacqueline, marge).
progenitor(marge, bart).
progenitor(marge, lisa).
progenitor(marge, maggie).

hermano(Hermano1,Hermano2):-
    progenitor(Padre,Hermano1),
    progenitor(Padre,Hermano2),
    Hermano1 \= Hermano2.

tio(Tio,Sobrino):-
    hermano(Tio,Padre),
    progenitor(Padre,Sobrino).
tio(Sobrino,Tio):-
    progenitor(Padre,Sobrino),
    hermano(Tio,Padre).

abuelo(Abuelo,Nieto):-
    progenitor(Abuelo,Padre),
    progenitor(Padre,Nieto).

primo(Primo1,Primo2):-
    progenitor(Padre1,Primo1),
    progenitor(Padre2,Primo2),
    hermano(Padre1,Padre2).