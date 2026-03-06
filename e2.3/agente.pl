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
    write('Cambios guardados en base.pl.'), nl.

% Menú 
menu :-
    repeat,
    nl, write('--- MENU ---'), nl,
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


% 4. AGREGAR


% 5. ELIMINAR


% 6. LONGITUD


% 7. ORDENAMIENTO
