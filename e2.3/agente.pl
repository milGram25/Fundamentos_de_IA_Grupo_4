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
    write('Presione enter para ver el siguiente...'),
    read(_),
    listar_uno_a_uno(T).

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

% 8. Salir
ejecutar(8) :- write('Gracias...'), nl.
