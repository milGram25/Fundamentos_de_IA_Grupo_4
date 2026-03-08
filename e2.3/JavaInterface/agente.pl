%  Integrantes:
% - Sergio Camarena Carbajal
% - Milton García Romo
% - Juan Carlos Gutiérrez Herández
% - Irene Pérez Navarro

:- consult('conocimiento.pl').

% Guarda el estado actual de todas las listas en el archivo conocimiento.pl
guardar_en_archivo :-
    tell('conocimiento.pl'),
    listing(idioma/2),
    told,
    write('Cambios guardados en conocimiento.pl.'), nl.

% Menú 
menu :-
    repeat,
    nl, write('------------------- MENU ----------------------'), nl,
    write('1. Buscar palabra'), nl,
    write('2. Comprobar/Listar elementos'), nl,
    write('3. Concatenar listas'), nl,
    write('4. Agregar palabra'), nl,
    write('5. Eliminar palabra'), nl,
    write('6. Ver longitud de una lista'), nl,
    write('7. Ordenar lista'), nl,
    write('8. Salir'), nl,
    write('Seleccione una opcion: '), read(Op),
    ejecutar(Op),
    Op == 8, !.


% 1. BUSCAR
ejecutar(1) :-
    nl, write('---Buscar palabra---'), nl,
    write('Idiomas disponibles: espanol, ingles, italiano, portugues, frances'), nl,
    write('Ingrese el idioma: '), read(Idioma),
    (idioma(Idioma, Lista) ->
        write('Ingrese la palabra a buscar: '), read(Palabra),
        (member(Palabra, Lista) ->
            format('La palabra "~w" SÍ se encuentra en la lista de ~w.~n', [Palabra, Idioma])
        ;
            format('La palabra "~w" NO se encuentra en la lista de ~w.~n', [Palabra, Idioma]),
            write('¿Desea agregarla? (si/no): '), read(Resp),
            (Resp == si ->
                append(Lista, [Palabra], NuevaLista),
                retract(idioma(Idioma, _)),
                assert(idioma(Idioma, NuevaLista)),
                guardar_en_archivo,
                write('Palabra agregada y guardada.'), nl
            ;
                write('No se agregó la palabra.'), nl
            )
        )
    ;
        write('Idioma no encontrado.'), nl
    ).

buscar(Id, P) :-
    idioma(Id, Lt),
    member(P, Lt).

% 2. COMPROBAR
ejecutar(2) :-
    nl, write('---Listar elementos---'), nl,
    write('Idiomas disponibles: espanol, ingles, italiano, portugues, frances'), nl,
    write('Ingrese el idioma: '), read(Idioma),
    (idioma(Idioma, Lista) ->
        write('Elementos de la lista:'), nl,
        listar_uno_a_uno(Lista)
    ;
        write('Idioma no encontrado.'), nl
    ).

listar_uno_a_uno([]) :- write('Fin de la lista.'), nl.
listar_uno_a_uno([H|T]) :-
    write(H), nl,
    listar_uno_a_uno(T).

comprobar(Id, Lt) :-
    idioma(Id, Lt).

% 3. CONCATENAR
ejecutar(3) :-
    nl, write('---concatenar lista---'),nl,
    write('Idiomas disponibles: espanol, ingles, italiano, portuges, frances'), nl,
    nl,
    write('Ingrese idioma: '), read(Idioma1),
    write('Ingrese idioma: '), read(Idioma2),
        (idioma(Idioma1, Lista1),
         idioma(Idioma2, Lista2) ->
         append(Lista1, Lista2, Lista_concat),
         nl,
         write('Lista cocatenada: '), nl,
         write(Lista_concat),
         length(Lista_concat, Largo),
         format('~nTotal de palbras: ~w~n', [Largo]);
         write('Error: uno de los cambios de idioma no existen'), nl
        ).

concatenar_idiomas(Id1, Id2, Result) :-
    idioma(Id1, Lt1),
    idioma(Id2, Lt2),
    append(Lt1, Lt2, Result).

% 4. AGREGAR
ejecutar(4) :-
    nl,write('---Agregar palabra---'), nl,
    write('Idiomas disponibles: espanol, ingles, italiano, portugues, frances'),  nl,
    nl,
    write('Ingrese el idioma que desea agregar: '), read(Idioma),
    (   idioma(Idioma, ListaActual)
    ->  format('Lista actual de ~w: ~w~n', [Idioma, ListaActual]),
        nl,
        write('Ingrese la palabra a agregar: '), read(PalabraRaw),
        % Convertir a string/atom limpio
        term_to_atom(PalabraRaw, Palabra),
        (   member(Palabra, ListaActual)
        ->  format('La palabra "~w" ya existe en la lista de ~w.~n', [Palabra, Idioma])
        ;   append(ListaActual, [Palabra], NuevaLista),
            % Actualizar en memoria
            retract(idioma(Idioma, _)),
            assert(idioma(Idioma, NuevaLista)),
            format('Palabra "~w" agregada exitosamente.~n', [Palabra]),
            nl,
            format('Lista actualizada de ~w: ~w~n', [Idioma, NuevaLista]),
            length(NuevaLista, Largo),
            format('Total de palabras: ~w~n', [Largo]),
            % Persistir cambios
            guardar_en_archivo
        )
    ;   write('Error: El idioma ingresado no existe.'), nl
    ).


agregar(Id, P) :-
    idioma(Id, Lt),
    (   member(P, Lt)
    ->  fail
    ;   append(Lt, [P], Nlt),
        retract(idioma(Id, _)),
        assert(idioma(Id, Nlt)),
        guardar_en_archivo % Persists changes to conocimiento.pl
    ).

% 5. ELIMINAR
ejecutar(5) :-
    % Eliminar nombres de las listas existentes
    write('-----------------------------------------------'), nl,
    write('Idimomas disponibles en la Base de Datos'), nl,
    findall(Nombre, idioma(Nombre, _), ListaNombres),
    listas(ListaNombres),

    % Solicitar a que idoma le va a Eliminar
    nl, write('A que idioma desea eliminar alguna palabra?'), nl,
    read(Id),

    % Eliminar palabra
    (idioma(Id, Lt) ->
        write(Lt),
        nl, write('Que palabra desea borrar?'), nl,
        read(P),
            (member(P,Lt)->
            delete(Lt,P,Nlt),
            retract(idioma(Id,Lt)),
            assert(idioma(Id,Nlt)),
            nl, write('Palabra Eliminada'),
            guardar_en_archivo;
            write('Palabra no encontrada')
        )
        ;
        write('Idioma no encontrado')
    ).
    
eliminar(Id,P) :-
    idioma(Id, Lt),
    (   member(P, Lt)
    ->  delete(Lt, P, Nlt),
        retract(idioma(Id, _)),
        assert(idioma(Id, Nlt)),
        guardar_en_archivo
    ;   fail
    ).

% 6. LONGITUD
ejecutar(6) :-
    % Obtener y mostrar nombres de las listas existentes
    write('-----------------------------------------------'), nl,
    write('Idiomas disponibles en la base de datos:'), nl,
    findall(Nombre, idioma(Nombre, _), ListaNombres),
    listas(ListaNombres),

    % Solicitar el idioma
    nl, write('¿Cual idioma desea saber la longitud?:'), 
    read(Id),
    
    % Validar y mostrar longitud
    (idioma(Id, Lt) ->
        length(Lt, N), 
        format('El idioma tiene ~d palabras registradas.', [N])
    ;   write('Error: El idioma no existe en la base de datos.')
    ).

longitud(Id, N) :-
    idioma(Id, Lt),
    length(Lt, N).

% Mostrar listas
listas([]).
listas([H|T]) :-
    format('- ~w~n', [H]),
    listas(T).

% 7. ORDENAMIENTO
ejecutar(7) :-
    nl, write('---Ordenar lista---'), nl,
    write('Idiomas disponibles: espanol, ingles, italiano, portugues, frances'), nl,
    write('Ingrese el idioma: '), read(Idioma),
    (idioma(Idioma, Lista) ->
        sort(Lista, ListaOrd),
        write('Lista ordenada:'), nl,
        write(ListaOrd), nl,
        retract(idioma(Idioma, _)),
        assert(idioma(Idioma, ListaOrd)),
        guardar_en_archivo
    ;
        write('Idioma no encontrado.'), nl
    ).

ordenar_idioma(Id, Nlt) :-
    idioma(Id, Lt),
    sort(Lt, Nlt),
    retract(idioma(Id, _)),
    assert(idioma(Id, Nlt)),
    guardar_en_archivo.

% 8. Salir
ejecutar(8) :- write('Gracias...'), nl.


% Aprender

% Cuenta cuántas palabras de una lista pertenecen a un idioma
rating(Id, Palabras, Count) :-
    idioma(Id, Lt),
    include(flip_member(Lt), Palabras, Coincidencias),
    length(Coincidencias, Count).

% Predicado auxiliar para usar con include/3
flip_member(Lista, Elemento) :- member(Elemento, Lista).

aprender(Frase, IdGanador) :-
    % 1. Convertimos el string en una lista de átomos
    atomic_list_concat(ListaPalabras, ' ', Frase),
    
    % 2. Buscamos todos los idiomas y sus ratings
    findall(C-Id, rating(Id, ListaPalabras, C), Ratings),
    
    % 3. Obtenemos el idioma con el rating mas alto
    keysort(Ratings, Sorted),
    reverse(Sorted, [MaxCount-IdGanador|_]),
    
    % Solo aprendemos si hubo al menos una coincidencia previa
    MaxCount > 0, 
    
    % 4. Identificamos qué palabras NO están en el idioma ganador y las agregamos
    idioma(IdGanador, ListaActual),
    exclude(flip_member(ListaActual), ListaPalabras, PalabrasNuevas),
    (   PalabrasNuevas \= []
    ->  append(ListaActual, PalabrasNuevas, Nlt),
        retract(idioma(IdGanador, _)),
        assert(idioma(IdGanador, Nlt)),
        guardar_en_archivo
    ;   true % No hay nada nuevo que aprender
    ).