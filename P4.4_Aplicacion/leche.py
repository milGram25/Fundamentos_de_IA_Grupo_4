import pandas as pd
import os
from mlxtend.frequent_patterns import fpgrowth, association_rules
from mlxtend.preprocessing import TransactionEncoder

# Required dependencies: pandas, openpyxl, mlxtend
# Install with: pip install pandas openpyxl mlxtend

# 1. CARGA DEL DATASET
# Obtiene la carpeta donde está el algoritmo para tener una ruta absoluta, para que pueda encontrar el dataset siempre
ruta_carpeta = os.path.dirname(os.path.abspath(__file__))
ruta_archivo = os.path.join(ruta_carpeta, 'CALIDAD DE LECHE LACTOESCAN.xlsx')

df_leche = pd.read_excel(ruta_archivo)

# 2. PRE-PROCESAMIENTO: DISCRETIZACIÓN
# Definimos funciones para categorizar según estándares técnicos lácteos (ya que el algoritmo trabaja mejor con categorías que con números)
def categorizar_leche(row):
    items = []
    
    # Categorización de Grasa (Valores típicos: < 3.2% es bajo)
    if row['GRASA'] < 3.2: items.append('Grasa_Baja')
    elif row['GRASA'] > 4.5: items.append('Grasa_Alta')
    else: items.append('Grasa_Normal')
    
    # Categorización de Proteína (Valores típicos: < 3.0% es bajo)
    if row['PROTEINA'] < 3.0: items.append('Proteina_Baja')
    elif row['PROTEINA'] > 3.5: items.append('Proteina_Alta')
    else: items.append('Proteina_Normal')
    
    # Categorización de Lactosa
    if row['LACTOSA'] < 4.5: items.append('Lactosa_Baja')
    elif row['LACTOSA'] > 5.0: items.append('Lactosa_Alta')
    else: items.append('Lactosa_Normal')
    
    return items

# Aplicamos la categorización a cada fila
transacciones = df_leche.apply(categorizar_leche, axis=1).tolist()

# 3. TRANSFORMACIÓN A MATRIZ BINARIA (One-Hot Encoding)
te = TransactionEncoder()
te_ary = te.fit(transacciones).transform(transacciones)
df_binario = pd.DataFrame(te_ary, columns=te.columns_)

# 4. EJECUCIÓN DE FP-GROWTH
# Buscamos patrones que aparezcan en al menos el 20% de las muestras
frequent_itemsets = fpgrowth(df_binario, min_support=0.2, use_colnames=True)

# 5. GENERACIÓN DE REGLAS DE ASOCIACIÓN
# Buscamos reglas con una confianza del 60% para ver tendencias
reglas = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.6)

# 6. VISUALIZACIÓN DE RESULTADOS
# Ordenamos por 'lift' para encontrar las relaciones más fuertes
resultado = reglas.sort_values(by='lift', ascending=False)

# Función para la interfaz
def obtener_tabla_reglas():
    df_tabla = resultado[['antecedents', 'consequents', 'support', 'confidence', 'lift']].head(10).copy()
    # Limpiamos los frozensets para que se vea texto normal
    df_tabla['antecedents'] = df_tabla['antecedents'].apply(lambda x: ", ".join(list(x)))
    df_tabla['consequents'] = df_tabla['consequents'].apply(lambda x: ", ".join(list(x)))
    return df_tabla

print("--- REGLAS DE ASOCIACIÓN DETECTADAS ---")
print(resultado[['antecedents', 'consequents', 'support', 'confidence', 'lift']].head(10))