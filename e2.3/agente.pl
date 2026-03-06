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


% 2. COMPROBAR


% 3. CONCATENAR


% 4. AGREGARp


% 5. ELIMINAR


% 6. LONGITUD
ejecutar(6) :-
    % Obtener y mostrar nombres de las listas existentes
    write('-----------------------------------------------'), nl,
    write('Idiomas disponibles en la base de datos:'), nl,
    findall(Nombre, idioma(Nombre, _), ListaNombres),
    listas(ListaNombres),

    % Solicitar el idioma
    nl, write('Cual idioma desea saber la longitud?:'), 
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


% 8. Salir
ejecutar(8) :- write('Gracias...'), nl.
