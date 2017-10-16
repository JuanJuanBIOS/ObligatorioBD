create database Alquileres_Vehiculos

go

use Alquileres_Vehiculos

-- ------------------------------------------------------------------------------------------------
-- CREACIÓN DE TABLAS 
-- ------------------------------------------------------------------------------------------------

-- Se crea la tabla de clientes
create table Clientes(
documento varchar(15) not null primary key,
tarjeta varchar(16) not null unique,
nombre varchar(30) not null,
calle varchar(30),
numerodepuerta int,
)

-- Se crea la tabla teléfonos
create table Telefonos(
idTel int identity(1,1) NOT NULL PRIMARY KEY,
documento varchar(15) not null foreign key references Clientes(documento),
telefono int,
)

-- Se crea la tabla vehículos
create table Vehiculos(
matricula varchar(7) not null primary key,
marca varchar(30),
modelo varchar(30),
anio int,
cant_puertas int,
costodiario float,
categoria varchar(10),
)

--Se crea la tabla Autos
create table Autos(
matricula varchar(7) not null foreign key references Vehiculos(matricula),
anclaje varchar(8),
vehiculosimilar varchar(7) foreign key references Vehiculos(matricula),
)

-- Se crea la tabla utilitarios
create table Utilitarios(
matricula varchar(7) not null foreign key references Vehiculos(matricula),
capacidad int,
tipo varchar(9),
vehiculosimilar varchar(7) foreign key references Vehiculos(matricula),
)

-- Se crea la tabla alquileres
create table Alquileres(
idAlquiler int identity(1,1) NOT NULL PRIMARY KEY,
vehiculo varchar(7) not null foreign key references Vehiculos(matricula),
cliente varchar(15) not null foreign key references Clientes(documento),
fechainicio datetime not null,
fechafin datetime not null,
costo float not null,
)

-- -----------------------------------------------------------------------------------------------
-- CARGA DE DATOS INICIALES PARA PRUEBAS
-- -----------------------------------------------------------------------------------------------

-- Se agregan datos a la tabla Clientes
INSERT INTO Clientes VALUES
('3155160','4967296361175687','Juan Perez','Avenida Italia',1548),
('4167344','3393430860568847','Maria Gonzalez','Garibaldi',2453),
('3809175','375659812386472','Santiago Rodriguez','Bvar Artigas',1483),
('4598108','6248315518673216','Nicolas Lopez','Rivera',5427),
('1914310','5019021263067369','Valeria Rodriguez','Sarandi',254),
('2548635','6372326355114261','Ana Martinez','18 de Julio',1236),
('1248963','6901506975192728','Pedro Artigas','Sarandi',126),
('2586951','5380502970150763','Julio Sanchez','8 de Octubre',5498)

-- Se agregan datos a la tabla Telefonos
INSERT INTO Telefonos VALUES
('3155160',45863458),
('3155160',098321548),
('4167344',26138597),
('3809175',091653287),
('3809175',53269874),
('4598108',098321589),
('1914310',52376981),
('2548635',24845698),
('1248963',095634888),
('2586951',096324657)

-- Se agregan datos a la tabla Vehículos
INSERT INTO Vehiculos VALUES
('AAA1111','Suzuki','Alto',2014,4,21.3,'Auto'),
('BBB2222','Chevrolet','Onix',2015,4,20,'Auto'),
('CCC3333','ByD','F0',2016,4,18.5,'Auto'),
('DDD4444','VW','Up',2014,4,21.3,'Auto'),
('EEE5555','VW','Up',2016,4,21.3,'Auto'),
('FFF6666','Ford','Fiesta',2014,4,21.3,'Auto'),
('GGG7777','Citroen','Berlingo',2009,5,25,'Utilitario'),
('HHH8888','Fiat','Fiorino',2010,5,23.2,'Utilitario'),
('III9999','Chevrolet','S10',2013,2,26.4,'Utilitario'),
('JJJ1010','Ford','Ranger',2014,4,27.8,'Utilitario'),
('KKK1111','Ford','Ranger',2016,2,27.8,'Utilitario'),
('LLL1212','Toyota','Hilux',2009,4,27.8,'Utilitario')

-- Se agregan datos a la tabla Autos
INSERT INTO Autos VALUES
('AAA1111','ISOFIX','CCC3333'),
('BBB2222','Cinturon','FFF6666'),
('CCC3333','ISOFIX','DDD4444'),
('DDD4444','Latch','EEE5555'),
('EEE5555','Latch','DDD4444'),
('FFF6666','ISOFIX','BBB2222')

-- Se agregan datos a la tabla Utilitarios
INSERT INTO Utilitarios VALUES
('GGG7777',500,'Furgoneta','HHH8888'),
('HHH8888',450,'Furgoneta','GGG7777'),
('III9999',1050,'Pickup','KKK1111'),
('JJJ1010',1200,'Pickup','LLL1212'),
('KKK1111',1100,'Pickup','III9999'),
('LLL1212',1250,'Pickup','JJJ1010')

-- Se agregan datos a la tabla Alquileres
INSERT INTO Alquileres VALUES
('CCC3333','3155160','12/01/2017','12/15/2017',380),
('AAA1111','4598108','10/02/2017','10/08/2017',150)

go

-- -----------------------------------------------------------------------------------------------
-- CREACIÓN DE STORED PROCEDURES
-- -----------------------------------------------------------------------------------------------

-- Se crea procedimiento para eliminar vehículo
create procedure Eliminar_Vehiculo
-- Se define la variable de entrada al proceso, la cual va a ser la matrícula del vehículo
@vehiculo varchar(7)
as
-- Se chequea que exista la matrícula en la base de datos, y si no existe se muestra el error
if not exists(select * from Vehiculos where matricula=@vehiculo)
	begin
	print 'El vehículo no existe en la base de datos'
	return -1
	end
-- Se chequea qeu el vehículo que se desea almacenar no posea ningún alquiler asociado, si lo posee se muestra el error
else if exists(select * from Alquileres where vehiculo=@vehiculo)
	begin
	print 'No se eliminó el vehículo ya que el mismo posee alquileres en la base de datos'
	return -2
	end
else
	begin
	begin transaction
		-- Se declara la variable auxiliar @tipo para definir si se quiere eliminar un Auto o un Utilitario
		declare @tipo varchar(10)
		-- Se busca si la matrícula ingresada corresponde a un Auto o a un Utilitario y se le asigna el valor a la variable auxiliar
		select @tipo = Vehiculos.categoria from Vehiculos where Vehiculos.matricula=@vehiculo
		-- Se declara una variable auxiliar que será usada más adelante
		declare @similarauxiliar varchar(7)
		-- Si se quiere eliminar un vehículo de tipo Auto se siguen los siguientes pasos
		if @tipo='Auto'
		begin
			-- Se le asigna a la variable auxiliar la primer matrícula que se encuentre, cuyo vehículo similar sea el que se desea eliminar
			select top 1 @similarauxiliar = Autos.matricula from Autos where vehiculosimilar=@vehiculo
			-- Se actualiza la tabla Autos para cambiar el vehículo similar para que luego se pueda eliminar el vehículo sin problemas
			update Autos set vehiculosimilar = @similarauxiliar where vehiculosimilar=@vehiculo
			-- Si se produce algún error al hacer lo anterior se hace el rollback
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			-- Se elimina el registro de la tabla Autos
			delete from Autos where Autos.matricula=@vehiculo
			-- Si se produce algún error al hacer lo anterior se hace el rollback
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			--Se elimina el registro de la tabla vehículos
			delete from Vehiculos where Vehiculos.matricula=@vehiculo
			-- Si se produce algún error al hacer lo anterior se hace el rollback
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
		end
		-- Si se quiere eliminar un vehículo de tipo Utilitario se siguen los siguientes pasos
		else if @tipo='Utilitario'
		begin
			-- Se le asigna a la variable auxiliar la primer matrícula que se encuentre, cuyo vehículo similar sea el que se desea eliminar
			select top 1 @similarauxiliar = Utilitarios.matricula from Utilitarios where vehiculosimilar=@vehiculo
			-- Se actualiza la tabla Utilitarios para cambiar el vehículo similar para que luego se pueda eliminar el vehículo sin problemas
			update Utilitarios set vehiculosimilar = @similarauxiliar where vehiculosimilar=@vehiculo
			-- Si se produce algún error al hacer lo anterior se hace el rollback
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			-- Se elimina el registro de la tabla Utilitarios
			delete from Utilitarios where Utilitarios.matricula=@vehiculo
			-- Si se produce algún error al hacer lo anterior se hace el rollback
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			--Se elimina el registro de la tabla vehículos
			delete from Vehiculos where Vehiculos.matricula=@vehiculo
			-- Si se produce algún error al hacer lo anterior se hace el rollback
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
		end
	-- Si no se produjo ningún error, se confirma el proceso y se muestra el mensaje correspondiente
	commit transaction
	print 'El vehículo se eliminó correctamente'
	return 1
	end;

go 

-- Se crea procedimiento para realizar un alquiler
create procedure Realizar_Alquiler
-- Se definen las variables de entrada al proceso
@vehiculo varchar(7),
@cliente varchar(15),
@fechainicio datetime,
@fechafin datetime
as
-- Se chequea que exista la matrícula en la base de datos, y si no existe se muestra el error
if not exists(select * from Vehiculos where matricula=@vehiculo)
	begin
	print 'El vehículo no existe en la base de datos'
	return -1
	end
-- Se chequea que exista el cliente en la base de datos, y si no existe se muestra el error
else if not exists(select * from Clientes where documento=@cliente)
	begin
	print 'El cliente no existe en la base de datos'
	return -2
	end
-- Se chequea que la fecha de inicio no sea anterior al dia de hoy
else if (@fechainicio<GETDATE())
	begin
	print 'La fecha de inicio no puede ser anterior al día de hoy'
	return -3
	end
-- Se chequea que la fecha de fin sea posterior a la fecha de inicio
else if (@fechainicio>=@fechafin)
	begin
	print 'La fecha de fin debe ser posterior a la fecha de inicio'
	return -4
	end
-- Se chequea que el vehículo que se desea alquilar no se encuentre alquilado en las fechas solicitadas
else if	(exists (select * from Alquileres where (Alquileres.vehiculo=@vehiculo and @fechafin<=Alquileres.fechafin and @fechafin>=Alquileres.fechainicio)) or
	exists (select * from Alquileres where (Alquileres.vehiculo=@vehiculo and @fechainicio<=Alquileres.fechafin and @fechainicio>=Alquileres.fechainicio)) or
	exists (select * from Alquileres where (Alquileres.vehiculo=@vehiculo and @fechainicio<=Alquileres.fechainicio and @fechafin>=Alquileres.fechafin)))
	begin
	-- Se declara la variable auxiliar @tipo y otra @similar para sugerir el vehículo similar que se podría alquilar
	declare @tipo varchar(10)
	declare @similar varchar(7)
	-- Se busca si la matrícula ingresada corresponde a un Auto o a un Utilitario y se le asigna el valor a la variable auxiliar
	select @tipo = Vehiculos.categoria from Vehiculos where Vehiculos.matricula=@vehiculo
	-- Si el vehículo que ya está alquilado es de tipo Auto se busca su similar
	if @tipo='Auto'
		begin
		-- Se le asigna el vehículo similar a la variable creada anteriormente
			select @similar = Autos.vehiculosimilar from Autos where Autos.matricula=@vehiculo
		end
	-- Si el vehículo que ya está alquilado es de tipo Utilitario se busca su similar
	if @tipo='Utilitario'
		begin
		-- Se le asigna el vehículo similar a la variable creada anteriormente
			select @similar = Utilitarios.vehiculosimilar from Utilitarios where Utilitarios.matricula=@vehiculo
		end
	print 'El vehículo se encuentra alquilado en el período seleccionado'
	print 'Intente con el vehículo similar ' + @similar
	return -5
	end
else
	begin
	begin transaction
	declare @costo float
	set @costo = DATEDIFF(day,@fechainicio,@fechafin) * (select Vehiculos.costodiario from Vehiculos where Vehiculos.matricula=@vehiculo)
	insert into Alquileres values (@vehiculo,@cliente,@fechainicio,@fechafin,@costo)
	if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo realizar el alquiler del vehículo'
				return -5
			end
	commit transaction
	print 'El alquiler se ingresó correctamente. El costo total del mismo es de $' + CONVERT(varchar(10),@costo)
	return 0
	end

go

-- Se crea procedimiento para obtener el total recaudado de un vehículo
create procedure Total_Vehiculo
-- Se define la variable de entrada al proceso, la cual va a ser la matrícula del vehículo
@vehiculo varchar(7)
as
-- Se chequea que exista la matrícula en la base de datos, y si no existe se muestra el error
if not exists(select * from Vehiculos where matricula=@vehiculo)
	begin
	print 'El vehículo no existe en la base de datos'
	return -1
	end
else
	begin
	begin transaction
	declare @marca varchar(30)
	declare @modelo varchar(30)
	declare @recaudado float
	select @marca = Vehiculos.marca from Vehiculos where Vehiculos.matricula=@vehiculo
	select @modelo = Vehiculos.modelo from Vehiculos where Vehiculos.matricula=@vehiculo
	select @recaudado = SUM(Alquileres.costo) from Alquileres where Alquileres.vehiculo=@vehiculo
	if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo realizar el alquiler del vehículo'
				return -2
			end
	commit transaction
	print 'El vehículo '+@marca+' '+@modelo+', matrícula '+@vehiculo+' ha recaudado un total de $'+CONVERT(varchar(10),@recaudado)
	return 1
	end;

go

-- Se crea procedimiento para ver vehículos disponibles por período
create procedure Disponibles_por_periodo
-- Se definen las variables de entrada al proceso
@fechainicio datetime,
@fechafin datetime
as
-- Se chequea que la fecha de fin sea posterior a la fecha de inicio
if (@fechainicio>=@fechafin)
	begin
	print 'La fecha de fin debe ser posterior a la fecha de inicio'
	return -1
	end
else
	begin
	-- Se copian en una tabla temporal aquellos vehículos que están alquilados dentro del período seleccionado
	-- y se seleccionan aquellos vehículos que no se encuentran en dicha tabla
	select Vehiculos.* into #TablaAux from Vehiculos where Vehiculos.matricula not in 
		(select Alquileres.vehiculo from Alquileres 
		where ((@fechainicio<=Alquileres.fechafin and @fechainicio>=Alquileres.fechainicio) or
				(@fechafin<=Alquileres.fechafin and @fechafin>=Alquileres.fechainicio) or
				(@fechainicio<=Alquileres.fechainicio and @fechafin>=Alquileres.fechafin)))
	-- Se traen los datos de las tablas Autos y Utilitarios para completar la consulta
	select TablaAux2.*, Utilitarios.tipo, Utilitarios.capacidad, Utilitarios.vehiculosimilar as utilitario_similar
	from (select #TablaAux.*, Autos.anclaje, Autos.vehiculosimilar as auto_similar from #TablaAux left join Autos on #TablaAux.matricula=Autos.matricula)
	as TablaAux2 left join Utilitarios on TablaAux2.matricula=Utilitarios.matricula
	end

go

create procedure Mas_Rentable
as
begin
select Vehiculos.matricula, Vehiculos.Marca, Vehiculos.modelo, Mayorreacudacion.total from Vehiculos 
inner join (select top 1 vehiculo as matricula, sum(costo) as total from Alquileres group by vehiculo order by sum(costo) desc) as Mayorreacudacion 
on Vehiculos.matricula = Mayorreacudacion.matricula
end