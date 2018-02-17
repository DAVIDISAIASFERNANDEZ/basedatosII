--2.REPORTE DE ARTICULOS

 select * from Productos
 select * from SalidaDetalle
 select * from Marca

 use ComputerDB
select 
	id codigo,
	nombre,
	p.precio,
	costo,
	existencia,
	m.nombreMarca, 
	count(sd.cantidad) as [recuento de ventas] 
from  
	productos p, marca m, SalidaDetalle sd
where p.idMarca in (select idMarca from Marca where p.idMarca=m.idMarca) and
	sd.idProducto in (select idProducto from SalidaDetalle where p.id=sd.idProducto)
group by id, nombre,costo, existencia, p.precio, m.nombreMarca
order by nombre, nombreMarca asc