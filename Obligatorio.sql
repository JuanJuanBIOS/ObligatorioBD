create database Alquileres_Vehiculos

use Alquileres_Vehiculos

create table Clientes(
documento varchar(15) not null primary key,
Marca varchar(30),
Modelo varchar(30),
Anio int,
Cant_Puertas int,
Costo_Diario double,
)


create table Vehiculos(
Matricula varchar(7) not null primary key,
Marca varchar(30),
Modelo varchar(30),
Anio int,
Cant_Puertas int,
Costo_Diario double,
Similar varchar(7),
Categoria varchar(10),
Anclaje varchar(8),
Capacidad int,
Tipo varchar(9),
)


