-- Autora: Antonella Alares
use evaluacion_continua; 

-- Tareas a Realizar:

-- PREGUNTA 1. Total de Ventas por Producto: Calcula el total de ventas para cada producto, ordenado de mayor a menor.
	-- SOLUCIÓN 1 ( Se ha dado por sentado en esta solución que todos los pedidos incluyen los que también tienen estado como cancelado)
SELECT productos.id_producto, nombre, SUM(Detalles_Pedidos.cantidad) AS total_cantidad_vendida, SUM(Detalles_Pedidos.cantidad * precio) AS total_ventas 
FROM Detalles_Pedidos
INNER JOIN Productos 
ON productos.id_producto = Detalles_Pedidos.id_producto
GROUP BY Detalles_Pedidos.id_producto
ORDER BY total_ventas DESC;
	--  al agrupar por id_producto (GROUP BY), sería la lógica así: que de cada id_producto (ej: id=1), con SUM(Detalles_Pedidos.cantidad * precio) sería ((1 * 1200) + (1*1200)), y de esta forma te da el total de precio que se ha vendido de ese producto con id = 1.
	-- cuidado! lo que pongas en GROUP BY debe estar seleccionado en el SELECT, además si hay otras columnas en el SEELCT deben estar como agregados (SUM(), COUNT(), AVG()...) o deben ser incluidas en el GROUP BY

-- SOLUCIÓN 2 ( Se ha dado por sentado en esta otra solución que todos los pedidos NO incluyen los que tienen estado como cancelado, por tanto, hay que hacer una segunda join con la tabla Pedidos)
SELECT productos.id_producto, nombre, SUM(Detalles_Pedidos.cantidad) AS total_cantidad_vendida, SUM(Detalles_Pedidos.cantidad * precio) AS total_ventas 
FROM Detalles_Pedidos
INNER JOIN Productos 
ON productos.id_producto = Detalles_Pedidos.id_producto
INNER JOIN Pedidos
ON  Detalles_Pedidos.id_pedido = pedidos.id_pedido
WHERE estado not in ('Cancelado')
GROUP BY Detalles_Pedidos.id_producto
ORDER BY total_ventas DESC;


-- PREGUNTA 2. Último Pedido de Cada Cliente: Identifica el último pedido realizado por cada cliente.
	-- SOLUCIÓN 1 ( Se ha dado por sentado en esta solución que todos los pedidos incluyen los que también tienen estado como cancelado)
SELECT pedidos.id_cliente, nombre, fecha_pedido
FROM Pedidos
INNER JOIN Clientes 
ON pedidos.id_cliente = clientes.id_cliente
WHERE pedidos.fecha_pedido = (
    SELECT MAX(pedidos.fecha_pedido) -- esto podría ser más simple, e ir en el primer SELECT
    FROM Pedidos
    WHERE pedidos.id_cliente = clientes.id_cliente
);

-- SOLUCIÓN 2 ( Se ha dado por sentado en esta solución que todos los pedidos NO incluyen los que tienen estado como cancelado)
SELECT pedidos.id_cliente, nombre, fecha_pedido
FROM Pedidos
INNER JOIN Clientes 
ON pedidos.id_cliente = clientes.id_cliente
WHERE pedidos.fecha_pedido = (
    SELECT MAX(pedidos.fecha_pedido)
    FROM Pedidos
    WHERE pedidos.id_cliente = clientes.id_cliente
) AND estado not in ('Cancelado');

-- PREGUNTA 3. Número de Pedidos por Ciudad: Determina el número total de pedidos realizados por clientes en cada ciudad.
	-- SOLUCIÓN 1( Se ha dado por sentado en esta solución que todos los pedidos incluyen los que también tienen estado como cancelado)
SELECT ciudad, COUNT(id_pedido) AS numero_de_pedidos_por_ciudad
FROM Pedidos
INNER JOIN Clientes 
ON pedidos.id_cliente = clientes.id_cliente
GROUP BY ciudad
ORDER BY numero_de_pedidos_por_ciudad DESC;

-- SOLUCIÓN 2( Se ha dado por sentado en esta solución que todos los pedidos NO incluyen los que tienen estado como cancelado)
SELECT ciudad, COUNT(id_pedido) AS numero_de_pedidos_por_ciudad
FROM Pedidos
INNER JOIN Clientes 
ON pedidos.id_cliente = clientes.id_cliente
WHERE estado not in ('Cancelado')
GROUP BY ciudad
ORDER BY numero_de_pedidos_por_ciudad DESC;

-- PREGUNTA 4. Productos que Nunca se Han Vendido: Lista todos los productos que nunca han sido parte de un pedido. 
	-- SOLUCIÓN 1 (Se ha dado por sentado en esta solución que todos los pedidos incluyen los que también tienen estado como cancelado)

SELECT productos.id_producto, nombre, precio, categoría
FROM Productos
LEFT JOIN Detalles_Pedidos
ON productos.id_producto = Detalles_Pedidos.id_producto
WHERE detalles_pedidos.id_producto IS NULL;

-- SOLUCIÓN 2 ( Se ha dado por sentado en esta solución que todos los pedidos NO incluyen los que tienen estado como cancelado) 
SELECT *
FROM Productos
LEFT JOIN Detalles_Pedidos
ON productos.id_producto = Detalles_Pedidos.id_producto
LEFT JOIN Pedidos
ON  Detalles_Pedidos.id_pedido = pedidos.id_pedido
WHERE detalles_pedidos.id_producto IS NULL OR estado LIKE 'Cancelado';  -- upper(estado) LIKE 'CANCELADO'

-- PREGUNTA 5. Productos Más Vendidos por Cantidad: Encuentra los productos más vendidos en términos de cantidad total vendida.
	-- SOLUCIÓN 1( Se ha dado por sentado en esta solución que todos los pedidos incluyen los que también tienen estado como cancelado)
    
SELECT productos.id_producto, nombre, SUM(Detalles_Pedidos.cantidad) AS total_cantidad_vendida
FROM Detalles_Pedidos
INNER JOIN Productos 
ON productos.id_producto = Detalles_Pedidos.id_producto
GROUP BY Detalles_Pedidos.id_producto
ORDER BY total_cantidad_vendida DESC;

-- SOLUCIÓN 2( Se ha dado por sentado en esta solución que todos los pedidos NO incluyen los que tienen estado como cancelado) 
    
SELECT productos.id_producto, nombre, SUM(Detalles_Pedidos.cantidad) AS total_cantidad_vendida
FROM Detalles_Pedidos
INNER JOIN Productos 
ON productos.id_producto = Detalles_Pedidos.id_producto
INNER JOIN Pedidos
ON  Detalles_Pedidos.id_pedido = pedidos.id_pedido
WHERE estado not in ('Cancelado')
GROUP BY Detalles_Pedidos.id_producto
ORDER BY total_cantidad_vendida DESC;


-- PREGUNTA 6. Clientes con Compras en Múltiples Categorías: Identifica a los clientes que han realizado compras en más de una categoría de producto.

/*SELECT id_cliente, Detalles_Pedidos.id_pedido, COUNT(categoría) as numero_de_categorias_por_cliente
FROM Detalles_Pedidos
INNER JOIN Productos 
ON productos.id_producto = Detalles_Pedidos.id_producto
INNER JOIN Pedidos
ON  Detalles_Pedidos.id_pedido = pedidos.id_pedido
INNER JOIN Clientes
ON  pedidos.id_cliente = clientes.id_cliente
WHERE numero_de_categorias_por_cliente > 1
GROUP BY id_cliente, Detalles_Pedidos.id_pedido;*/ /*El error se debe a que no puedes utilizar el alias numero_de_categorias_por_cliente en la cláusula WHERE. 
Los alias definidos en la cláusula SELECT no se pueden utilizar directamente en la cláusula WHERE porque la cláusula WHERE se evalúa antes de que se compute la columna numero_de_categorias_por_cliente. 
Para filtrar los resultados utilizando el resultado de una función de agregación como COUNT(), debes usar la cláusula HAVING después de la cláusula GROUP BY.*/

SELECT pedidos.id_cliente, clientes.nombre, Detalles_Pedidos.id_pedido, COUNT(categoría) as numero_de_categorias_por_cliente
FROM Detalles_Pedidos
INNER JOIN Productos 
ON productos.id_producto = Detalles_Pedidos.id_producto
INNER JOIN Pedidos
ON  Detalles_Pedidos.id_pedido = pedidos.id_pedido
INNER JOIN Clientes
ON  pedidos.id_cliente = clientes.id_cliente
GROUP BY id_cliente, Detalles_Pedidos.id_pedido
HAVING numero_de_categorias_por_cliente > 1;

-- PREGUNTA 7. Ventas Totales por Mes: Muestra las ventas totales agrupadas por mes y año.
SELECT YEAR(fecha_pedido) AS año, MONTH(fecha_pedido) AS mes, DATE_FORMAT(fecha_pedido, '%M') as nombre_mes, SUM(precio * cantidad) AS ventas_totales -- nota mental: cuidado! no poner fecha_pedido en el SELECT y GROUP BY - no agrupa como queremos, es mejor agrupar por año (siempre empezar por el atributo que engloba al resto)!
FROM Pedidos 
INNER JOIN Detalles_Pedidos  
ON pedidos.id_pedido = Detalles_Pedidos.id_pedido
INNER JOIN Productos 
ON Detalles_Pedidos.id_producto = productos.id_producto
GROUP BY YEAR(fecha_pedido), mes, nombre_mes
ORDER BY año, mes DESC;

-- PREGUNTA 8. Promedio de Productos por Pedido: Calcula la cantidad promedio de productos por pedido.

SELECT AVG(cantidad_productos_por_pedido) AS media_productos FROM  (
SELECT Detalles_Pedidos.id_pedido, SUM(cantidad) AS cantidad_productos_por_pedido
FROM  Detalles_Pedidos
GROUP BY Detalles_Pedidos.id_pedido) AS tabla1;

-- Esta sería otra opción como la anterior, pero con el WITH:
WITH tabla1 AS (SELECT Detalles_Pedidos.id_pedido, SUM(cantidad) AS cantidad_productos_por_pedido
FROM  Detalles_Pedidos
GROUP BY Detalles_Pedidos.id_pedido)
SELECT AVG(cantidad_productos_por_pedido) AS media_productos FROM  tabla1;

-- PREGUNTA 9. Tasa de Retención de Clientes: Determina cuántos clientes han realizado pedidos en más de una ocasión. 

WITH tabla1 AS (SELECT pedidos.id_cliente, COUNT(pedidos.id_pedido) AS numero_de_compras
FROM Clientes
INNER JOIN Pedidos
ON Clientes.id_cliente = pedidos.id_cliente
GROUP BY pedidos.id_cliente
HAVING numero_de_compras > 1) 
SELECT COUNT(*) AS numero_clientes_con_más_de_1_pedido FROM tabla1;

-- PREGUNTA 10. Tiempo Promedio entre Pedidos: Calcula el tiempo promedio que pasa entre pedidos para cada cliente.

SELECT id_cliente, AVG(diferencia_dias) AS promedio_dias_entre_pedidos_por_cliente
FROM ( SELECT p.id_cliente, DATEDIFF(p.fecha_pedido, LAG(p.fecha_pedido) OVER (PARTITION BY p.id_cliente ORDER BY p.fecha_pedido ASC)) AS diferencia_dias
    FROM Pedidos p
) AS subconsulta
GROUP BY id_cliente
HAVING promedio_dias_entre_pedidos_por_cliente IS NOT NULL;

-- DATEDIFF() : estamos calculando la diferencia en días entre la fecha del pedido actual (p.fecha_pedido) y la fecha del pedido anterior (LAG(p.fecha_pedido) OVER...) para el mismo cliente. 
-- LAG(): nos permite acceder a la fecha del pedido anterior dentro de la misma partición de cliente (definida por PARTITION BY p.id_cliente)
-- ORDER BY: se ordena por fecha_pedido en orden ASC, ya que de lo contrario la resta saldría negativa


commit;
