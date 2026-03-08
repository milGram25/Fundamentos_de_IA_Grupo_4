/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.javainterface;


import java.io.*;
import org.jpl7.*;
import java.util.Map;
import java.util.Scanner;
import java.util.Scanner;
/**
 *
 * @author mil_g
 */
public class JavaInterface {
    
    static void menu(){
        while (true) {
            System.out.println("""
                -------Menu de Aprendizaje-------
                1. Buscar una palabra
                2. Comprobar diccionario
                3. Concatenar diccionarios
                4. Agregar palabra a diccionario
                5. Eliminar palabra de diccionario
                6. Longitud de diccionario
                7. Ordenar diccionario
                8. Aprender
                9. Salir

                Seleccione una opción:
                """);
            Scanner sc = new Scanner(System.in);
            int opcion = sc.nextInt();
            switch (opcion) {
                case 1:
                    buscarPalabra();
                    break;
                case 2:
                    comprobarDiccionario();
                    break;
                case 3:
                    concatenarDiccionarios();
                    break;
                case 4:
                    agregarPalabra();
                    break;
                case 5:
                    eliminarPalabra();
                    break;
                case 6:
                    longitudDiccionario();
                    break;
                case 7:
                    ordenarDiccionario();
                    break;
                case 8:
                    aprender();
                    break;
                case 9:
                    System.out.println("Saliendo del programa...");
                    return;
                default:
                    System.out.println("Opción no válida. Por favor, seleccione una opción del menú.");
                    break;
            }
        }
    }

    static void buscarPalabra(){
        Scanner sc = new Scanner(System.in);
        System.out.println("--- Buscar Palabra en el Diccionario ---");
        System.out.println("En que idioma desea buscar la palabra?");
        String idioma = sc.nextLine().trim().toLowerCase();
        System.out.println("Ingrese la palabra a buscar:");
        String palabra = sc.nextLine().trim().toLowerCase();
        String queryStr = String.format("buscar('%s', '%s')", idioma, palabra);
        Query consulta = new Query(queryStr);
        if (consulta.hasSolution()) {
            System.out.println("La palabra '" + palabra + "' se encuentra en el diccionario.");
        } else {
            System.out.println("La palabra '" + palabra + "' no se encuentra en el diccionario.");
        }
    }

    static void comprobarDiccionario(){
        Scanner sc = new Scanner(System.in);
    
        System.out.println("--- Comprobar Existencia de Diccionario ---");
        System.out.println("Ingrese el nombre del idioma:");
        String id = sc.nextLine().trim().toLowerCase();

        // Query: comprobar_idioma('espanol')
        String queryStr = String.format("comprobar('%s', Lt)", id);
        Query consulta = new Query(queryStr);

        try {
            if (consulta.hasSolution()) {
                System.out.println("Confirmado: El idioma '" + id + "' tiene un listado registrado.");
                Map<String, Term> solution = consulta.oneSolution();
                Term wordList = solution.get("Lt");
                System.out.println("Palabras en el diccionario '" + id + "': " + wordList);
            } else {
                System.out.println("Resultado: No existe ningún listado para el idioma '" + id + "'.");
            }
        } catch (org.jpl7.PrologException e) {
            System.err.println("Error de Prolog: " + e.getMessage());
        }
    }

    static void concatenarDiccionarios(){
        Scanner sc = new Scanner(System.in);
    
        System.out.println("Ingrese el primer idioma:");
        String id1 = sc.nextLine().trim().toLowerCase();
        
        System.out.println("Ingrese el segundo idioma:");
        String id2 = sc.nextLine().trim().toLowerCase();

        String queryStr = String.format("concatenar_idiomas('%s', '%s', Result)", id1, id2);
        Query consulta = new Query(queryStr);

        try {
            if (consulta.hasSolution()) {
                Map<String, Term> solution = consulta.oneSolution();
                Term mergedList = solution.get("Result"); 

                System.out.println("Diccionario combinado (" + id1 + " + " + id2 + "):");
                System.out.println(mergedList);
            } else {
                System.out.println("Error: Uno o ambos idiomas no existen en el sistema.");
            }
        } catch (org.jpl7.PrologException e) {
            System.err.println("Error de Prolog: " + e.getMessage());
        }
    }

    static void agregarPalabra(){
        Scanner sc = new Scanner(System.in);
        
        System.out.println("En que idioma desea agregar la palabra?");
        String id = sc.nextLine().trim().toLowerCase();
        
        System.out.println("Ingrese la palabra a agregar:");
        String p = sc.nextLine().trim();

        String queryStr = String.format("agregar('%s', '%s')", id, p);
        Query consulta = new Query(queryStr);

        try {
            if (consulta.hasSolution()) {
                System.out.println("Exito: '" + p + "' agregada a " + id + ".");
            } else {
                System.out.println("Error: El idioma no existe o la palabra ya esta en la lista.");
            }
        } catch (org.jpl7.PrologException e) {
            System.err.println("Error de Prolog: " + e.getMessage());
        }
    }

    static void eliminarPalabra(){
    Scanner sc = new Scanner(System.in);
    System.out.println("En que idioma desea eliminar la palabra?");
    String idioma = sc.nextLine().trim();

    Query diccionario = new Query(String.format("idioma('%s', Lt)", idioma));
    
    if (diccionario.hasSolution()) {
        Map<String, Term> solution = diccionario.oneSolution();
        System.out.println("Palabras en el diccionario " + idioma + ": " + solution.get("Lt"));
        
        System.out.println("Ingrese la palabra a eliminar:");
        String palabra = sc.nextLine().trim();

        Query eliminar = new Query(String.format("eliminar('%s', '%s')", idioma, palabra));
        
        if (eliminar.hasSolution()) {
            System.out.println("La palabra '" + palabra + "' ha sido eliminada del diccionario " + idioma + ".");
        } else {
            System.out.println("No se encontró la palabra '" + palabra + "' en el diccionario.");
        }
    } else {
        System.out.println("No se encontró el idioma: " + idioma);
    }
}

    static void longitudDiccionario(){
        Scanner sc = new Scanner(System.in);
        System.out.println("Ingrese el idioma del diccionario:");
        String idioma = sc.nextLine();
        Query consulta = new Query("longitud(" + idioma + ", N)");
        if(consulta.hasSolution()) {
            Map<String, Term> solution = consulta.nextSolution();
            System.out.println("La longitud del diccionario en " + idioma + " es: " + solution.get("N"));
        } else {
            System.out.println("No se pudo obtener la longitud del diccionario para el idioma: " + idioma);
        }
    }

    static void ordenarDiccionario(){
        Scanner sc = new Scanner(System.in);
    
        System.out.println("--- Ordenar Diccionario Alfabéticamente ---");
        System.out.println("Ingrese el idioma que desea ordenar:");
        String id = sc.nextLine().trim().toLowerCase();

        // Query: ordenar_idioma('espanol', SortedLt)
        String queryStr = String.format("ordenar_idioma('%s', SortedLt)", id);
        Query consulta = new Query(queryStr);

        try {
            if (consulta.hasSolution()) {
                Map<String, Term> solution = consulta.oneSolution();
                // This MUST match the 'SortedLt' in the query string above
                Term listadoOrdenado = solution.get("SortedLt");

                System.out.println("¡Diccionario de '" + id + "' ordenado exitosamente!");
                System.out.println("Lista alfabética: " + listadoOrdenado);
            } else {
                System.out.println("Error: No se encontró el idioma '" + id + "'.");
            }
        } catch (org.jpl7.PrologException e) {
            System.err.println("Error de Prolog: " + e.getMessage());
        }
    }

    static void aprender(){
        Scanner sc = new Scanner(System.in);
        
        System.out.println("--- Función Aprender ---");
        System.out.println("Ingrese una frase o texto para analizar:");
        String frase = sc.nextLine().trim().toLowerCase();

        String queryStr = String.format("aprender('%s', IdGanador)", frase);
        Query consulta = new Query(queryStr);

        try {
            if (consulta.hasSolution()) {
                Map<String, Term> solution = consulta.oneSolution();
                String idGanador = solution.get("IdGanador").toString();

                System.out.println("¡Aprendizaje completado!");
                System.out.println("El sistema identificó el idioma: " + idGanador);
                System.out.println("Las palabras desconocidas han sido agregadas a ese diccionario.");
            } else {
                System.out.println("No se pudo aprender. La frase no contiene palabras conocidas en ningún idioma.");
            }
        } catch (org.jpl7.PrologException e) {
            System.err.println("Error de Prolog: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        Query consulta = new Query("consult('agente.pl')");
        if (!consulta.hasSolution()) {
            System.err.println("Could not load agente.pl");
            return;
        }
        
        Query listado = new Query("idioma(espanol,Lt)");
        if (listado.hasSolution()) {
            Map<String, Term> solution = listado.nextSolution();
            System.out.println("Palabras en el diccionario espanol: " + solution.get("Lt"));
        } else {
            System.out.println("No se pudo obtener el listado de palabras para el idioma español.");
        }
        
        menu();
        
    }
}
