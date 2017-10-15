
use Alquileres_Vehiculos

-- -------------------------------------------------------------------------------------------------
-- PRUEBAS
-- -------------------------------------------------------------------------------------------------
-- Prueba de eliminaci�n de un veh�culo que no se encuentra en la base de datos
Eliminar_Vehiculo 'AAA1112'

-- Prueba de eliminaci�n de un veh�culo que posee un alquiler
Eliminar_Vehiculo 'AAA1111'

-- Prueba de eliminaci�n de un veh�culo que puede ser eliminado
Eliminar_Vehiculo 'BBB2222'

-- Prueba de realizaci�n de alquiler con un cliente que no existe
Realizar_Alquiler 'AAA1111', '1231231', '01/01/2018', '01/15/2018'

-- Prueba de realizaci�n de alquiler con veh�culo que no existe
Realizar_Alquiler 'AAA1112', '3155160', '01/01/2018', '01/15/2018'

-- Prueba de realizaci�n de alquiler con fecha de inicio menor a hoy
Realizar_Alquiler 'AAA1111', '3155160', '01/01/2017', '01/15/2017'

-- Prueba de realizaci�n de alquiler con fecha de fin menor a fecha de inicio
Realizar_Alquiler 'AAA1111', '3155160', '01/01/2018', '12/15/2017'

-- Prueba de realizaci�n de alquiler de un veh�culo que ya se encuentra alquilado
Realizar_Alquiler 'CCC3333', '3155160', '11/25/2017', '12/05/2017'
Realizar_Alquiler 'CCC3333', '3155160', '12/01/2017', '12/31/2017'
Realizar_Alquiler 'CCC3333', '3155160', '12/02/2017', '12/12/2017'

