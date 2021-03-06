/*
1.	Scenario: Reporte de clientes
Given: El dueño del negocio requiere conocer a sus clientes
When: requiera la información
Then: un reporte debería mostrar el nombre, dirección, teléfono y nit
And: debe estar ordenado por nombre 
And: debe estar filtrado por las ventas del primer semestre de cada año.
And: debe estar filtrado por el día lunes de las ventas.
*/

select nombreCliente nombre, direccion,telefono,nit,
s.fecha,datename(dw,s.fecha) nombreDia,day(s.fecha) dia, 
datepart(qq,s.fecha) trimestre, datename(mm,s.fecha) nombreMes
from Clientes c
inner join Salida s on s.idCliente=c.idCliente
--where month(s.fecha) in (1,2,3,4,5,6) 
where datepart(qq,s.fecha) in (1,2)
and datename(dw,s.fecha)='Lunes'
order by nombreCliente

/*
2.	Scenario: Reporte de artículos
Given: El dueño del negocio requiere un listado de productos
When: requiera la información
Then: debería mostrar el código, nombre, precio, costo, existencia, marca, total en ventas, total en costos y total en utilidad 
And: debe estar ordenado por marca y nombre de artículo
*/

select  codigo,nombre,d.precio,d.cantidad, d.costoTotal costo, existencia, m.nombreMarca marca,
d.cantidad*d.precio totalVenta, d.costoTotal*d.cantidad totalCosto,
(d.precio-d.costoTotal)*d.cantidad totalUtilidad
from Productos p
inner join marca m on p.idmarca=m.idmarca
inner join SalidaDetalle d on p.id=d.idproducto
order by m.nombreMarca,p.nombre

select p.codigo,p.nombre,p.descripcion,
avg(d.cantidad) cantidadPromedio,
sum(d.cantidad) cantidadSuma,
min(d.cantidad) cantidadMinima,
max(d.cantidad) cantidadMaximo,
sum(d.cantidad*d.precio) totalVenta, sum(d.costoTotal*d.cantidad) totalCosto,
sum((d.precio-d.costoTotal)*d.cantidad) totalUtilidad
from Productos p
inner join SalidaDetalle d on p.id=d.idproducto
group by  p.codigo,p.nombre,p.descripcion

update SalidaDetalle set costoTotal=(precio*0.6)


select p.codigo,p.nombre,s.fecha,
sum((d.precio-d.costoTotal)*d.cantidad) totalUtilidad
from Productos p
inner join SalidaDetalle d on p.id=d.idproducto
inner join Salida as s on d.idsalida=s.idsalida
where s.fecha between dateadd(MONTH,-7,getdate()) and GETDATE()
group by  p.codigo,p.nombre,s.fecha
order by p.nombre


select fecha from salida
order by fecha desc




/*
9.  Scenario: Reporte de utilidad bruta (Daniel Estupe)
Given: el dueño de un negocio requiere información de las ventas
When: requiera la información
Then: debería mostrar el año, mes, ingresos, egresos y utilidad bruta 
And: debe estar ordenado por año y mes
And: debe ser posible filtrar por ninguno o varios años y por ninguno o varios meses
*/

declare @consulta varchar(max)
declare @anhos varchar(50)
declare @meses varchar(50)

select @anhos = '2016'
select @meses = '2'

set @consulta = 'select year(fecha) as Año,
					   datename(month, fecha) as Mes,
					   sum(sd.costoTotal) as Ingresos,
					   sum(sd.cantidad * p.costo) as Egresos,
					   sum(costoTotal - cantidad * p.costo) as Utilidad_Bruta
				from Salida s
				inner join SalidaDetalle sd on sd.idSalida = s.idSalida
				inner join Productos p on p.id = sd.idProducto
				where (len('+ @anhos + ') > 0) 
				and (len(' + @meses + ') > 0)
				and (year(fecha) in (' + @anhos + ')) 
				and month(fecha) in (' + @meses + ')
				group by year(fecha), datename(month, fecha), month(fecha)
				order by Año desc, month(fecha) asc'
exec(@consulta)

--2.REPORTE DE ARTICULOS EJERCICIO 2 
--- por la forma de in para subconsulta
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
