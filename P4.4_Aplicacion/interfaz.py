import tkinter as tk
from tkinter import ttk
from leche import obtener_tabla_reglas 

# 1. Crear la ventana principal
ventana = tk.Tk()
ventana.title("Reglas de Asociación - Lactoescan")
ventana.geometry("950x400")

# 2. Título de la interfaz
titulo = tk.Label(ventana, text="🥛Reglas de Asociación: FP-Growth", font=("Arial", 14, "bold"))
titulo.pack(pady=10)

# 3. Crear el contenedor de la tabla (Treeview)
columnas = ('antecedents', 'consequents', 'support', 'confidence', 'lift')
tabla = ttk.Treeview(ventana, columns=columnas, show='headings')

# Definir los encabezados de la tabla
tabla.heading('antecedents', text='Antecedente (Si ocurre...)')
tabla.heading('consequents', text='Consecuente (...es probable)')
tabla.heading('support', text='Soporte')
tabla.heading('confidence', text='Confianza')
tabla.heading('lift', text='Lift')

# Ajustar el ancho y alineación de las columnas
tabla.column('antecedents', width=220, anchor='w')
tabla.column('consequents', width=220, anchor='w')
tabla.column('support', width=100, anchor='center')
tabla.column('confidence', width=100, anchor='center')
tabla.column('lift', width=90, anchor='center')

# 4. Cargar los datos e insetarlos en la tabla
df_reglas = obtener_tabla_reglas()

for index, fila in df_reglas.iterrows():
    # Formateamos los decimales para que se vean más limpios (Confianza en porcentaje)
    soporte_fmt = f"{fila['support']:.3f}"
    confianza_fmt = f"{fila['confidence']*100:.1f}%"
    lift_fmt = f"{fila['lift']:.2f}"
    
    tabla.insert('', tk.END, values=(fila['antecedents'], fila['consequents'], soporte_fmt, confianza_fmt, lift_fmt))

tabla.pack(pady=10, fill=tk.BOTH, expand=True, padx=10)

# 5. Botón de Cerrar (Cierra la ventana al hacer clic)
boton_cerrar = tk.Button(ventana, text="Cerrar", command=ventana.destroy, bg="#ff4d4d", fg="white", font=("Arial", 10,"bold"), width=12)
boton_cerrar.pack(pady=15)

# Ejecutar la interfaz gráfica
ventana.mainloop()