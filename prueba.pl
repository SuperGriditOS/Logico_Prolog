cancion(queen, bohemian_rhapsody, rock, 1975).
cancion(queen, we_will_rock_you, rock, 1977).
cancion(queen, we_are_the_champions, rock, 1977).
cancion(queen, another_one_bites_the_dust, rock, 1980).
cancion(queen, radio_ga_ga, rock, 1984).
cancion(queen, i_want_to_break_free, rock, 1984).
cancion(queen, a_kind_of_magic, rock, 1986).
cancion(queen, the_show_must_go_on, rock, 1991).

cantidadCanciones(N):-
    findall(Cancion, cancion(_, Cancion, _, _), Canciones),
    length(Canciones, N).

