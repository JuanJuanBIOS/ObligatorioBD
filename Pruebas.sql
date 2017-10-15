
use Alquileres_Vehiculos

-- -------------------------------------------------------------------------------------------------
-- PRUEBAS
-- -------------------------------------------------------------------------------------------------
-- Prueba de eliminación de un vehículo que no se encuentra en la base de datos
Eliminar_Vehiculo 'AAA1112'

-- Prueba de eliminación de un vehículo que posee un alquiler
Eliminar_Vehiculo 'AAA1111'

-- Prueba de eliminación de un vehículo que puede ser eliminado
Eliminar_Vehiculo 'BBB2222'

-- Prueba de realización de alquiler con un cliente que no existe
Realizar_Alquiler 'AAA1111', '1231231', '01/01/2018', '01/15/2018'

-- Prueba de realización de alquiler con vehículo que no existe
Realizar_Alquiler 'AAA1112', '3155160', '01/01/2018', '01/15/2018'

-- Prueba de realización de alquiler con fecha de inicio menor a hoy
Realizar_Alquiler 'AAA1111', '3155160', '01/01/2017', '01/15/2017'

-- Prueba de realización de alquiler con fecha de fin menor a fecha de inicio
Realizar_Alquiler 'AAA1111', '3155160', '01/01/2018', '12/15/2017'

-- Prueba de realización de alquiler de un vehículo que ya se encuentra alquilado
Realizar_Alquiler 'CCC3333', '3155160', '11/25/2017', '12/05/2017'
Realizar_Alquiler 'CCC3333', '3155160', '12/01/2017', '12/31/2017'
Realizar_Alquiler 'CCC3333', '3155160', '12/02/2017', '12/12/2017'

-- Prueba de realización de alquiler correctamente
Realizar_Alquiler 'DDD4444', '1914310', '11/25/2017', '12/05/2017'
Realizar_Alquiler 'JJJ1010', '2548635', '02/01/2018', '02/04/2018'
Realizar_Alquiler 'JJJ1010', '3155160', '03/01/2018', '03/15/2018'
Realizar_Alquiler 'JJJ1010', '1914310', '12/15/2017', '01/15/2018'

-- Prueba total recaudado de un vehículo que no existe
Total_Vehiculo 'JJJ2020'

-- Prueba total recaudado de un vehículo con un solo alquiler
Total_Vehiculo 'DDD4444'

-- Prueba total recaudado de un vehículo con más de un alquiler
Total_Vehiculo 'JJJ1010'

