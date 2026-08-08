--Consultas SQL de negocio--

--Consulta 1: Resumen ejecutivo mensual--

SELECT 
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

--Consulta 2: Ranking de productos--

SELECT TOP 5
id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

--Consulta 3: Clientes recurrentes--

SELECT 
id_cliente,
COUNT(*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

--Consulta 4: Meses por encima/por debajo del promedio--

WITH resumen_mensual AS (
SELECT 
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY MONTH(fecha_venta)
)

SELECT 
mes,
total_facturado,
CASE 
WHEN total_facturado > (SELECT AVG(total_facturado) FROM resumen_mensual)
THEN 'Por encima'
ELSE 'Por debajo'
END AS comparacion_promedio
FROM resumen_mensual
ORDER BY mes;


--BLOQUE DE CIERRE--

--HALLAZGO 1: El producto 1 fué el que más rentabilidad generó, aunque no fué  el más vendido--
--HALLAZGO 2: Aunque todos los clientes realizaron la misma cantidad de pedidos, el cliente 1 fué quien más gastó en sus pedidos--
--HALLAZGO 3: El més 3 concentra la totalidad de las ventas registradas, por lo tanto el análisis de comparación con el promedio mensual no aplica.-- 


