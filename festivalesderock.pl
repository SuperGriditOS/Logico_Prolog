oActual(2015).
%festival(nombre, lugar, bandas, precioBase).

%lugar(nombre, capacidad).
festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).


%banda(nombre, año, nacionalidad, popularidad).
banda(paulMasCarne,1960, uk, 70).
banda(muse,1994, uk, 45).
banda(kiss,1973, us, 63).
banda(erucaSativa,2007, ar, 60).
banda(judasPriest,1969, uk, 91).
banda(tanBionica,2012, ar, 71).
banda(miranda,2001, ar, 38).
banda(laRenga,1988, ar, 70).
banda(blackSabbath,1968, uk, 96).
banda(pharrellWilliams,2014, us, 85).


%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).
% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).
entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).
entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).

% … y asi para todas las filas
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).

estaDeModa(Banda):-
    esPopular(Banda),
    surgioHacePoco(Banda).

esPopular(Banda):-
    banda(Banda, _, _, Popularidad),
    Popularidad > 70.

surgioHacePoco(Banda):-
    banda(Banda, Anio, _, _),
    anioActual(AnioActual),
    Anio > AnioActual - 5.

esCareta(Festival):-
    participanDosBandasDeModa(Festival).
esCareta(Festival):-
    entradasRazonables(Festival,Entrada).
esCareta(Festival):-
    tocaMiranda(Festival).

participanDosBandasDeModa(Festival):-
    estaDeModa(Banda1),
    estaDeModa(Banda2),
    Banda1 \= Banda2,
    festival(Festival, _, Bandas, _),
    member(Banda1, Bandas),
    member(Banda2, Bandas).

tocaMiranda(Festival):-
    festival(Festival, _, Bandas, _),
    member(miranda, Bandas).

entradasRazonables(Festival,Entrada):-
    esRazonablePlateaGeneral(Festival,Entrada).
entradasRazonables(Festival,Entrada):-
    esRazonableCampo(Festival,Entrada).
%entradasRazonables(Festival,Entrada):-
 %   esRazonablePlateaNumerada(Festival,Entrada).

esRazonablePlateaGeneral(Festival,plateaGeneral(Zona)):-
    festival(Festival, lugar(Lugar,_), _, PrecioBase),
    plusZona(Lugar, Zona, Plus),
    Precio is PrecioBase + Plus,
    Plus < Precio * 0.1.

esRazonableCampo(Festival,campo):-
    festival(Festival, _, Bandas, PrecioBase),
    sumaDePopularidades(Bandas, PopularidadTotal),
    PrecioBase < PopularidadTotal.

sumaDePopularidades(Festival, PopularidadTotal):-
    festival(Festival, _, Bandas, _),
    findall(Popularidad, (member(Banda, Bandas), banda(Banda, _, _, Popularidad)), Popularidades),
    sumlist(Popularidades, PopularidadTotal).

/*esRazonablePlateaNumerada(Festival,plateaNumerada(Fila)):-
    festival(Festival, lugar(_,Capacidad), Bandas, PrecioBase),
    forall(not(estaDeModa(Bandas))),
    precioPlateaNumerada(Festival, Fila, Precio),
    sumaDePopularidades(Bandas, PopularidadTotal).
    Precio < Capacidad/PopularidadTotal.
esRazonablePlateaNumerada(Festival,plateaNumerada(Fila)):-
    precioPlateaNumerada(Festival, Fila, Precio),
    Precio < 750.


precioPlateaNumerada(Festival, Fila, Precio):-
    festival(Festival, lugar(_,Capacidad), _, PrecioBase),
    Precio is (PrecioBase + 200)/Fila.

*/