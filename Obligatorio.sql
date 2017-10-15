create database Alquileres_Vehiculos

go

use Alquileres_Vehiculos

create table Clientes(
documento varchar(15) not null primary key,
tarjeta varchar(16) not null unique,
nombre varchar(30) not null,
calle varchar(30),
numerodepuerta int,
)

create table Telefonos(
idTel int identity(1,1) NOT NULL PRIMARY KEY,
documento varchar(15) not null foreign key references Clientes(documento),
telefono int,
)

create table Vehiculos(
matricula varchar(7) not null primary key,
marca varchar(30),
modelo varchar(30),
anio int,
cant_puertas int,
costodiario float,
categoria varchar(10),
)

create table Autos(
matricula varchar(7) not null foreign key references Vehiculos(matricula),
anclaje varchar(8),
vehiculosimilar varchar(7) foreign key references Vehiculos(matricula),
)

create table Utilitarios(
matricula varchar(7) not null foreign key references Vehiculos(matricula),
capacidad int,
tipo varchar(9),
vehiculosimilar varchar(7) foreign key references Vehiculos(matricula),
)

create table Alquileres(
idAlquiler int identity(1,1) NOT NULL PRIMARY KEY,
vehiculo varchar(7) not null foreign key references Vehiculos(matricula),
cliente varchar(15) not null foreign key references Clientes(documento),
fechainicio datetime not null,
fechafin datetime not null,
costo float not null,
)

INSERT INTO Clientes VALUES
('3155160','4967296361175687','Juan Perez','Avenida Italia',1548),
('4167344','3393430860568847','Maria Gonzalez','Garibaldi',2453),
('3809175','375659812386472','Santiago Rodriguez','Bvar Artigas',1483),
('4598108','6248315518673216','Nicolas Lopez','Rivera',5427),
('1914310','5019021263067369','Valeria Rodriguez','Sarandi',254)


INSERT INTO Telefonos VALUES
('3155160',45863458),
('3155160',098321548),
('4167344',26138597),
('3809175',091653287),
('3809175',53269874),
('4598108',098321589),
('1914310',52376981)

INSERT INTO Vehiculos VALUES
('AAB1254','Suzuki','Alto',2014,4,21.3,'Auto'),
('SDF4523','Chevrolet','Onix',2015,4,20,'Auto'),
('JGB5025','ByD','F0',2016,4,18.5,'Auto'),
('AAB5846','VW','Up',2014,4,21.3,'Auto'),
('LMN4523','Citroen','Berlingo',2009,5,25,'Utilitario'),
('IJE8756','Fiat','Fiorino',2010,5,23.2,'Utilitario'),
('SSV2431','Chevrolet','S10',2013,2,26.4,'Utilitario'),
('SRT4523','Ford','Ranger',2014,4,27.8,'Utilitario')

INSERT INTO Autos VALUES
('AAB1254','ISOFIX','JGB5025'),
('SDF4523','Cinturon','AAB5846'),
('JGB5025','ISOFIX','AAB1254'),
('AAB5846','Latch','SDF4523')

INSERT INTO Utilitarios VALUES
('LMN4523',500,'Furgoneta','IJE8756'),
('IJE8756',450,'Furgoneta','LMN4523'),
('SSV2431',1050,'Pickup','SRT4523'),
('SRT4523',1200,'Pickup','SSV2431')

INSERT INTO Alquileres VALUES
('AAB1254','4598108','10/02/2017','10/08/2017',150),
('SSV2431','4598108','09/10/2017','09/15/2017',180),
('SSV2431','3155160','09/16/2017','09/18/2017',52),
('JGB5025','4167344','03/15/2017','03/31/2017',300),
('AAB5846','1914310','02/19/2016','02/28/2016',180)


go

create procedure Eliminar_Vehiculo
@vehiculo varchar(7)
as
if not exists(select * from Vehiculos where matricula=@vehiculo)
	begin
	print 'El vehículo no existe en la base de datos'
	return -1
	end
else if exists(select * from Alquileres where vehiculo=@vehiculo)
	begin
	print 'No se eliminó el vehículo ya que el mismo posee alquileres en la base de datos'
	return -2
	end
else
	begin
	begin transaction
		declare @tipo varchar(10)
		select @tipo = Vehiculos.categoria from Vehiculos where Vehiculos.matricula=@vehiculo
		declare @similarauxiliar varchar(7)
		if @tipo='Auto'
		begin
			select top 1 @similarauxiliar = Autos.matricula from Autos where vehiculosimilar=@vehiculo
			update Autos set vehiculosimilar = @similarauxiliar where vehiculosimilar=@vehiculo
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			delete from Autos where Autos.matricula=@vehiculo
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			delete from Vehiculos where Vehiculos.matricula=@vehiculo
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
		end
		else if @tipo='Utilitario'
		begin
			select top 1 @similarauxiliar = Utilitarios.matricula from Utilitarios where vehiculosimilar=@vehiculo
			update Utilitarios set vehiculosimilar = @similarauxiliar where vehiculosimilar=@vehiculo
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			delete from Utilitarios where Utilitarios.matricula=@vehiculo
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
			delete from Vehiculos where Vehiculos.matricula=@vehiculo
			if @@ERROR<>0
			begin
				rollback transaction
				print 'No se pudo eliminar el vehículo'
				return 0
			end
		end	
	commit transaction
	print 'El vehículo se eliminó correctamente'
	return 1
	end