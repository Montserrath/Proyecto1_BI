# Proyecto BI - NovaRuta Logistics
Problema: El caso deja ver que la empresa sí genera bastante información por la operación diaria, pero eso no significa que la esté aprovechando bien, debido a que tener datos de envíos, entregas, rutas, centros de distribución, transportistas, incidencias o devoluciones no sirve de mucho si después esa información queda dispersa o no se puede analizar de manera clara. 
Aquí lo que realmente le está pasando a la empresa es que necesita entender mejor cómo se está comportando su operación, ya que no solo le interesa saber cuántos envíos realiza, sino cuáles rutas, centros de distribución y tipos de envío concentran más volumen y facturación. También necesita comparar el tiempo que promete con el tiempo que realmente tarda en entregar, porque ahí se refleja una parte muy importante de la calidad del servicio. Además, la empresa ocupa identificar en qué zonas se están dando más problemas, qué tipos de paquete presentan más incidencias o devoluciones y cuáles transportistas acumulan más retrasos, sumándole otra necesidad igual de importante, que es entender qué clientes o segmentos generan más ingresos, pero también más complejidad operativa, lo que es sumamente importante porque no siempre el cliente que más volumen mueve es el más fácil de atender. 
Entonces, el problema no está en que la empresa no tenga información, sino en que no cuenta con una forma clara de organizarla y analizarla para convertirla en apoyo real para la toma de decisiones, ya que mientras eso no se resuelva, se vuelve más difícil detectar dónde se concentran los principales problemas, qué parte de la operación está funcionando mejor y cuáles decisiones podrían ayudar a mejorar la trazabilidad, los tiempos de entrega y la calidad del servicio. 

## Arquitectura de la solución
La solución implementada sigue un enfoque de Business Intelligence basado en un modelo dimensional.

1. **Fuente de datos (OLTP):
   Se parte de una base de datos transaccional que contiene información de clientes, envíos, paquetes, incidencias y devoluciones.

2. Proceso ETL (KNIME):
   Se realiza la extracción, transformación y carga de los datos hacia un data warehouse, aplicando limpieza, integración y modelado dimensional.

3. Data Warehouse (PostgreSQL):
   Se construye un modelo en estrella con una tabla de hechos (fact_envio) y (fact_incidencia) y dimensiones como cliente, fecha, ruta, tipo de envío, transportista, entre otras.

4. **Análisis y visualización (KNIME)**:
   Se desarrollan dashboards que permiten analizar:
   - Ingresos y volumen de envíos
   - Cumplimiento de tiempos de entrega
   - Incidencias y devoluciones
   - Desempeño por cliente
  
##Integrantes del grupo:
-David Acuña Brenes
-Esteban Brenes Montoya
-Joseph Lugo Brown
-Monserrat Martinez González
  
Instrucciones de ejecución:
En este flujo lo que hacemos primero es extraer los datos desde el data warehouse, específicamente desde la tabla de hechos de envíos, junto con dimensiones como fecha, ruta y tipo de envío. Esto nos permite tener tanto la fecha prometida como la fecha real de entrega para cada envío.

Luego, utilizamos el nodo de diferencia de fechas para calcular una nueva variable llamada dias_diferencia, que mide cuántos días se adelantó o se retrasó cada envío. Este cálculo es clave porque transforma las fechas en una métrica cuantificable del desempeño.

Después, con el Rule Engine clasificamos cada envío en tres categorías: A tiempo, Retrasado o Adelantado, dependiendo del valor de esa diferencia. Esto nos permite pasar de un dato numérico a una interpretación clara del cumplimiento.

A partir de ahí, se generan varios análisis. Primero, se cuenta la cantidad de envíos por estado de entrega, lo que nos da una visión general del cumplimiento del servicio. Luego, se calcula el promedio de días de diferencia por estado, lo que permite entender qué tan grandes son los retrasos o adelantos. Finalmente, se analiza el promedio de días por tipo de envío, lo que permite identificar si ciertos servicios tienen más problemas que otros.

Además, se aplica un filtro para aislar únicamente los envíos retrasados, lo que permite enfocar el análisis en los casos críticos y entender mejor dónde se están generando los incumplimientos.

## Herramientas utilizadas
- PostgreSQL
- KNIME Analytics Platform
- GitHub

##Estructura del repositorio
/Documentación
│   ├── Proyecto BI (trabajo escrito)
│   ├── Presentación
/PostgreSQL
│   ├──01_modelo_transaccional_base.sql
│   ├──02_modelo_dimesional.sql 
│   ├──novaruta_inserts.sql 
/dashboards
│   ├──04_dashboard.knwf
/etl
│   ├──03_ETL_proyecto.knar.knwf

Link del github: https://github.com/Montserrath/Proyecto1_BI
