-- ----------------------------------------------------------------------------------------------
-- Tema 4. Ejercicios de Programando con SQL. Enunciados
-- ----------------------------------------------------------------------------------------------
/*
Bases de Datos
Tema 4. Ejercicios de Programando con SQL
Realiza las siguientes consultas SQL
Nombre: Sandra Cremades Marín
Grupo: 1ºDAM (indicar el grupo)

Deberás entregar el resultado en un documento .sql siguiendo el formato indicado en la plantilla.
Procura que en tu código no haya tabuladores, sólo espacios en blanco. Puedes ejecutar:
Menú > Editar > Operciones de limpieza > TAB a espacio antes de entregar los ejercicios.
Se valorará además de que las solución de los ejercicios sea correcta, la correcta indentación,
los comentarios en el código, nombres de columna correctos y la claridad del código en general.
Recuerda que no se puede copiar y pegar de ningún compañero. Ni si quiera un trozo pequeño.
El tratamiento de nulos y consultas vacías será el mismo que hemos hecho en clase.
*/

/*
NOTA:
En todos los procedimientos y funciones, incluye un ejemplo completo de llamada al procedimiento. Un "ejemplo completo" quiere decir que incluya todas las órdenes necesarias para llamar a este procedimiento, por ejemplo: SET @a=1; CALL MiProcedimiento(10,@a,@b); SELECT @a AS "Valor de a:"; SELECT @b AS "Valor de b:";
Nota: en los procedimientos y funciones no hay que chequear posibles errores, por ejemplo, comprobar que el país que se le pasa como parámetro existe, a no ser que se diga lo contrario.
*/

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 0. Dadas la tabla Nombres, que contiene los 200 nombres (100 masculinos y 100 femeninos) más comunes en España, la tabla apellidos con los 200 apellidos más comunes y la tabla Personas que está inicialmente vacía y que tiene los campos: id de la persona, su nombre completo y su fecha de nacimiento.

-- Se proporciona también la función: GeneraFechaNacimientoAleatoria, que genera una fecha de nacimiento aleatoria para que una persona tenga, a día de hoy, una edad aleatoria comprendida entre los dos valores que se le pasan como parámetro.

-- Crea la función GeneraNombreCompletoAleatorio que elige de manera aleatoria uno de los nombres y dos apellidos. Para seleccionar un registro  de manera aleatoria, guarda en una variable un número aleatorio comprendido entre 1 y el número de registros de la tabla y haz una consulta que seleccione el registro cuyo Id conincide con el valor de esa variable. Al añadir los Id con un ALTER TABLE tras meter los nombres nos aseguramos que los Id son consecutivos.

-- Crea el procedimiento InsertarPersonasAleatorias al que pasamos como parámetro el número de registros que tiene que insertar y que inserta el número de registros indicado en la tabla Personas haciendo uso de las funciones: GeneraNombreCompletoAleatorio y GeneraFechaNacimientoAleatoria.

-- Por último, inserta 10000 registros en la tabla personas y comprueba la tabla con las consultas indicadas al final para ver las repeticiones en los nombres y las fechas de nacimiento y para ver la distribución aleatoria de las fechas de nacimiento.

DROP DATABASE IF EXISTS Ejercicios;
CREATE DATABASE IF NOT EXISTS Ejercicios;
USE Ejercicios;

-- Datos de nombres y apellidos más comunes en España obtenidos del INE
-- https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177009&menu=resultados&idp=1254734710990

-- Tabla con los 200 nombres más comunes en España. Fíjate que el Id será un número comprendido entre el 1 y el 200
DROP TABLE IF EXISTS Nombres;
CREATE TABLE Nombres (
    Nombre CHAR(30) NOT NULL DEFAULT ''
) ENGINE = MEMORY;
INSERT INTO Nombres VALUES ('Antonio'), ('Manuel'), ('Jose'), ('Francisco'), ('David'), ('Juan'), ('Javier'), ('Jose Antonio'), ('Daniel'), ('Francisco Javier'), ('Jose Luis'), ('Carlos'), ('Jesus'), ('Alejandro'), ('Miguel'), ('Jose Manuel'), ('Rafael'), ('Miguel Angel'), ('Pablo'), ('Pedro'), ('Angel'), ('Sergio'), ('Jose Maria'), ('Fernando'), ('Jorge'), ('Luis'), ('Alberto'), ('Álvaro'), ('Juan Carlos'), ('Adrián'), ('Diego'), ('Juan Jose'), ('Raúl'), ('Iván'), ('Juan Antonio'), ('Ruben'), ('Enrique'), ('Oscar'), ('Ramón'), ('Andrés'), ('Juan Manuel'), ('Vicente'), ('Santiago'), ('Joaquín'), ('Mario'), ('Victor'), ('Eduardo'), ('Roberto'), ('Jaime'), ('Francisco Jose'), ('Marcos'), ('Hugo'), ('Ignacio'), ('Jordi'), ('Alfonso'), ('Ricardo'), ('Salvador'), ('Guillermo'), ('Marc'), ('Gabriel'), ('Mohamed'), ('Emilio'), ('Gonzalo'), ('Martín'), ('Jose Miguel'), ('Julio'), ('Julián'), ('Tomas'), ('Nicolas'), ('Agustín'), ('Jose Ramón'), ('Samuel'), ('Ismael'), ('Cristian'), ('Lucas'), ('Joan'), ('Félix'), ('Aitor'), ('Héctor'), ('Iker'), ('Alex'), ('Juan Francisco'), ('Jose Carlos'), ('Josep'), ('Sebastian'), ('Cesar'), ('Mariano'), ('Alfredo'), ('Domingo'), ('Mateo'), ('Jose Angel'), ('Rodrigo'), ('Victor Manuel'), ('Felipe'), ('Jose Ignacio'), ('Luis Miguel'), ('Jose Francisco'), ('Xavier'), ('Juan Luis'), ('Albert'), ('Maria Carmen'), ('Maria'), ('Carmen'), ('Ana Maria'), ('Maria Pilar'), ('Laura'), ('Josefa'), ('Isabel'), ('Maria Dolores'), ('Maria Teresa'), ('Ana'), ('Marta'), ('Cristina'), ('Maria Angeles'), ('Lucia'), ('Maria Isabel'), ('Maria Jose'), ('Francisca'), ('Antonia'), ('Dolores'), ('Sara'), ('Paula'), ('Elena'), ('Maria Luisa'), ('Raquel'), ('Rosa Maria'), ('Manuela'), ('Pilar'), ('Concepcion'), ('Maria Jesus'), ('Mercedes'), ('Julia'), ('Beatriz'), ('Alba'), ('Silvia'), ('Nuria'), ('Irene'), ('Rosario'), ('Patricia'), ('Juana'), ('Teresa'), ('Encarnación'), ('Andrea'), ('Rocio'), ('Montserrat'), ('Mónica'), ('Alicia'), ('Maria Mar'), ('Sandra'), ('Sonia'), ('Marina'), ('Rosa'), ('Angela'), ('Susana'), ('Natalia'), ('Yolanda'), ('Margarita'), ('Sofía'), ('Claudia'), ('Maria Josefa'), ('Eva'), ('Carla'), ('Maria Rosario'), ('Inmaculada'), ('Maria Mercedes'), ('Ana Isabel'), ('Noelia'), ('Esther'), ('Verónica'), ('Nerea'), ('Carolina'), ('Daniela'), ('Inés'), ('Eva Maria'), ('Maria Victoria'), ('Angeles'), ('Miriam'), ('Lorena'), ('Maria Rosa'), ('Ana Belén'), ('Maria Elena'), ('Martina'), ('Victoria'), ('Maria Concepcion'), ('Amparo'), ('Alejandra'), ('Maria Antonia'), ('Lidia'), ('Celia'), ('Catalina'), ('Maria Nieves'), ('Fátima'), ('Ainhoa'), ('Olga'), ('Consuelo'), ('Clara'), ('Gloria'), ('Maria Cristina'), ('Maria Soledad'), ('Adriana');
ALTER TABLE Nombres ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
SELECT * FROM Nombres;

-- Tabla con los 200 apellidos más comunes en España. Fíjate que el Id será un número comprendido entre el 1 y el 200
DROP TABLE IF EXISTS Apellidos;
CREATE TABLE Apellidos (
    Apellido CHAR(30) NOT NULL DEFAULT ''
) ENGINE = MEMORY;
INSERT INTO Apellidos VALUES ('García'), ('Rodríguez'), ('González'), ('Fernández'), ('López'), ('Martínez'), ('Sánchez'), ('Pérez'), ('Gómez'), ('Martín'), ('Jimenez'), ('Hernández'), ('Ruiz'), ('Diaz'), ('Moreno'), ('Muñoz'), ('Alvarez'), ('Romero'), ('Gutiérrez'), ('Alonso'), ('Navarro'), ('Torres'), ('Domínguez'), ('Ramos'), ('Vásquez'), ('Ramírez'), ('Gil'), ('Serrano'), ('Morales'), ('Molina'), ('Blanco'), ('Suárez'), ('Castro'), ('Ortega'), ('Delgado'), ('Ortiz'), ('Marín'), ('Rubio'), ('Núñez'), ('Sanz'), ('Medina'), ('Iglesias'), ('Castillo'), ('Cortes'), ('Garrido'), ('Santos'), ('Guerrero'), ('Lozano'), ('Cano'), ('Mendez'), ('Cruz'), ('Prieto'), ('Flores'), ('Herrera'), ('Peña'), ('León'), ('Marquez'), ('Cabrera'), ('Gallego'), ('Calvo'), ('Vidal'), ('Campos'), ('Reyes'), ('Vega'), ('Fuentes'), ('Carrasco'), ('Diez'), ('Aguilar'), ('Caballero'), ('Nieto'), ('Santana'), ('Pascual'), ('Herrero'), ('Vargas'), ('Giménez'), ('Montero'), ('Hidalgo'), ('Lorenzo'), ('Santiago'), ('Ibáñez'), ('Duran'), ('Benítez'), ('Ferrer'), ('Arias'), ('Mora'), ('Carmona'), ('Vicente'), ('Rojas'), ('Soto'), ('Crespo'), ('Román'), ('Pastor'), ('Velasco'), ('Parra'), ('Sáez'), ('Moya'), ('Bravo'), ('Soler'), ('Gallardo'), ('Rivera'), ('Esteban'), ('Pardo'), ('Silva'), ('Franco'), ('Rivas'), ('Lara'), ('Merino'), ('Espinosa'), ('Camacho'), ('Mendoza'), ('Vera'), ('Izquierdo'), ('Rios'), ('Arroyo'), ('Casado'), ('Sierra'), ('Redondo'), ('Luque'), ('Montes'), ('Rey'), ('Galán'), ('Carrillo'), ('Otero'), ('Segura'), ('Heredia'), ('Marcos'), ('Bernal'), ('Soriano'), ('Robles'), ('Martí'), ('Palacios'), ('Valero'), ('Contreras'), ('Vila'), ('Macias'), ('Guerra'), ('Varela'), ('Pereira'), ('Expósito'), ('Miranda'), ('Roldan'), ('Benito'), ('Mateo'), ('Bueno'), ('Andrés'), ('Guillen'), ('Villar'), ('Aguilera'), ('Escudero'), ('Salazar'), ('Mateos'), ('Acosta'), ('Padilla'), ('Calderón'), ('Rivero'), ('Casas'), ('Aparicio'), ('Guzmán'), ('Beltrán'), ('Estévez'), ('Salas'), ('Gálvez'), ('Bermúdez'), ('Menéndez'), ('Rico'), ('Jurado'), ('Conde'), ('Quintana'), ('Aranda'), ('Plaza'), ('Abad'), ('Gracia'), ('Avila'), ('Hurtado'), ('Trujillo'), ('Blazquez'), ('Escobar'), ('Pacheco'), ('Manzano'), ('Santamaría'), ('Villanueva'), ('Costa'), ('Roca'), ('Rueda'), ('Serra'), ('Cuesta'), ('Miguel'), ('Mesa'), ('Tomas'), ('Luna'), ('De la fuente'), ('Simon'), ('Castaño'), ('Alarcón'), ('Del rio'), ('Zamora'), ('Maldonado'), ('Millán'), ('Lazaro'), ('Pons');
ALTER TABLE Apellidos ADD COLUMN Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
SELECT * FROM Apellidos;

-- Tabla de personas
DROP TABLE IF EXISTS Personas;
CREATE TABLE Personas (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    NombreCompleto CHAR(90) NOT NULL DEFAULT '',
    FechaNacimiento DATE DEFAULT NULL
) ENGINE = MEMORY;
SELECT * FROM Personas;

-- Genera una fecha de nacimiento aleatoria de manera que la persona, a día de hoy,
-- tenga la edad indicada entre los parámetros: edadMinima y edadMaxima
-- puede que la edad no sea exacta por algunos días
DROP FUNCTION IF EXISTS GeneraFechaNacimientoAleatoria;
DELIMITER //
CREATE FUNCTION GeneraFechaNacimientoAleatoria(edadMinima INT, edadMaxima INT)
    RETURNS DATE
BEGIN 
    RETURN (SELECT DATE_SUB(CURDATE(), INTERVAL (TRUNCATE(RAND() * (edadMaxima  * 365 + 1 - edadMinima * 365), 0) + edadMinima * 365) DAY));
END// 
DELIMITER ;
SELECT GeneraFechaNacimientoAleatoria(18, 90);

-- Para entender la función anterior:
-- Genera un número aleatorio entre 2 y 5:
SELECT TRUNCATE(RAND() * (5 + 1 - 2), 0) + 2;
-- Genera una edad aleatoria entre 18 y 90 años:
SELECT TRUNCATE(RAND() * (90 + 1 - 18), 0) + 18;
-- Genera el número de días vividos (con un posible pequeño exceso de unos días por los años bisiestos) por una persona con una edad aleatoria entre 18 y 90 años:
SELECT (TRUNCATE(RAND() * (90  * 365 + 1 - 18 * 365), 0) + 18 * 365);
-- Genera la fecha de nacimiento de esa persona:
SELECT DATE_SUB(CURDATE(), INTERVAL (TRUNCATE(RAND() * (90  * 365 + 1 - 18 * 365), 0) + 18 * 365) DAY);

-- Consultas de comprobación:
-- Listado con los nombres completos repetidos y el número de repeticiones de cada una:
SELECT NombreCompleto, COUNT(*)  AS `Número de repeticiones`
FROM   Personas
GROUP BY NombreCompleto
HAVING `Número de repeticiones` > 1;

-- Listado con el número de nombres distintos repetidos y el número total de personas con nombre repetidos
SELECT COUNT(*) AS 'Número de nombres distintos repetidos', SUM(`Número de repeticiones`) AS 'Número total de personas con nombre repetidos'
FROM 
   (SELECT NombreCompleto, COUNT(*)  AS `Número de repeticiones`
    FROM   Personas
    GROUP BY NombreCompleto
    HAVING `Número de repeticiones` > 1) AS Repeticiones;

-- Listado con las fechas de nacimiento repetidas y el número de repeticiones de cada una
SELECT FechaNacimiento, COUNT(*)  AS `Número de repeticiones`
FROM   Personas
GROUP BY FechaNacimiento
HAVING `Número de repeticiones` > 1;

-- Listado con el número de fechas distintas repetidas y el número total de personas con fechas repetidas
SELECT COUNT(*) AS 'Número de fechas distintas repetidas', SUM(`Número de repeticiones`) AS 'Número total de personas con fechas repetidas'
FROM 
   (SELECT FechaNacimiento, COUNT(*)  AS `Número de repeticiones`
    FROM   Personas
    GROUP BY FechaNacimiento
    HAVING `Número de repeticiones` > 1) AS Repeticiones;

-- Número de personas nacidas en cada año
SELECT YEAR(FechaNacimiento), COUNT(*)
FROM   Personas
GROUP BY YEAR(FechaNacimiento)
ORDER BY 1;

-- Número de personas nacidas en cada mes del año
SELECT MONTH(FechaNacimiento), COUNT(*)
FROM   Personas
GROUP BY MONTH(FechaNacimiento)
ORDER BY 1;

-- Número de personas nacidas en cada día del mes
SELECT DAY(FechaNacimiento), COUNT(*)
FROM   Personas
GROUP BY DAY(FechaNacimiento)
ORDER BY 1;

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 1. Crea un procedimiento que guarde en una tabla los números 0, 10, 20, 30 ,..., 980, 990, 1000. usa un blucle y el código que se indica a continuación:
DROP TABLE IF EXISTS `Numeros`;
CREATE TABLE `Numeros` (
    `Numero` INTEGER NOT NULL
) ENGINE=MEMORY;

DROP PROCEDURE IF EXISTS ejercicio1;
DELIMITER //
CREATE PROCEDURE ejercicio1()
BEGIN
		SET @Contador = 0;
	REPEAT
		INSERT INTO Numeros VALUES(@Contador);
		SET @Contador = @Contador + 10;
	UNTIL @Contador > 1000 END REPEAT;
END//
DELIMITER ;
CALL ejercicio1();
SELECT *
FROM Numeros;

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 2. Crea un procedimiento al que le pasamos un número como parámetro (por ejemplo, 65) y que guarda en una tabla de números el número que ocupa la posición central (en nuestro ejemplo, el 32 o el 33, da igual) y, a continuación, nos guarda la siguiente (33), el anterior del inicial (32), el siguiente del siguiente (34) y el anterior de la anterior de (31), y así con todos los números desde el 1 al número que le pasamos como parámetro (65). Usa un bucle LOOP.
DROP TABLE IF EXISTS `Numeros`;
CREATE TABLE `Numeros` (
    `Numero` INTEGER NOT NULL
) ENGINE=MEMORY;

TRUNCATE TABLE Numeros;

DROP PROCEDURE IF EXISTS ejercicio2;
DELIMITER //
CREATE PROCEDURE ejercicio2(IN Numero INT)
BEGIN
		SET @Mitad = ROUND(Numero/2);
        INSERT INTO Numeros VALUES(@Mitad);
        SET @Contador = 1;
	Bucle: LOOP
		IF @Contador = @Mitad + 1 THEN LEAVE Bucle; END IF;
        IF @Contador - @Mitad <> 0 THEN 
			INSERT INTO Numeros VALUES(@Mitad - @Contador); 
        END IF;
        INSERT INTO Numeros VALUES(@Mitad + @Contador);
        SET @Contador = @Contador + 1;
        
	END LOOP Bucle;
END//
DELIMITER ;
CALL ejercicio2(10);

SELECT *
FROM Numeros;
-- ----------------------------------------------------------------------------------------------
-- Ejercicio 3. Realiza la consulta anterior usando un bucle WHILE. 
TRUNCATE TABLE Numeros;

DROP PROCEDURE IF EXISTS ejercicio3;
DELIMITER //
CREATE PROCEDURE ejercicio3(IN Numero INT)
BEGIN
    SET @Mitad = ROUND(Numero/2);
	INSERT INTO Numeros VALUES(@Mitad);
    SET @Contador = 1;
WHILE @Contador <> @Mitad + 1 DO
    IF @Contador - @Mitad <> 0 THEN 
		INSERT INTO Numeros VALUES(@Mitad - @Contador); 
        END IF;
        INSERT INTO Numeros VALUES(@Mitad + @Contador);
        SET @Contador = @Contador + 1;
END WHILE;
END//
DELIMITER ;
CALL ejercicio3(10);

SELECT *
FROM Numeros;
-- ----------------------------------------------------------------------------------------------
-- Ejercicio 4. Realiza la consulta anterior usando un bucle REPEAT...UNTIL. 
TRUNCATE TABLE Numeros;

DROP PROCEDURE IF EXISTS ejercicio4;
DELIMITER //
CREATE PROCEDURE ejercicio4(IN Numero INT)
BEGIN
	SET @Mitad = ROUND(Numero/2);
	INSERT INTO Numeros VALUES(@Mitad);
    SET @Contador = 1;
REPEAT
    IF @Contador - @Mitad <> 0 THEN 
		INSERT INTO Numeros VALUES(@Mitad - @Contador); 
	END IF;
        INSERT INTO Numeros VALUES(@Mitad + @Contador);
        SET @Contador = @Contador + 1;
UNTIL @Contador = @Mitad + 1 END REPEAT;
END//
DELIMITER ;
CALL ejercicio4(10);

SELECT *
FROM Numeros;
-- ----------------------------------------------------------------------------------------------
-- Ejercicio 5. En el Tema 3 realizamos la siguiente consulta: 2. Nombre de los países que tienen dos o más ciudades con dos millones de habitantes como mínimo. Parametriza la consulta para que podamos cambiar tanto el número de ciudades como el número de habitantes. Chequea errores en los parámetros y muestra mensajes descritivos. 

DROP PROCEDURE IF EXISTS ejercicio5;
DELIMITER //
CREATE PROCEDURE ejercicio5(IN PoblacionMin INT, IN NumCiudades INT)
BEGIN

	SELECT Pais.Nombre
	FROM Pais JOIN Ciudad
	ON Pais.Codigo=Ciudad.CodigoPais
	WHERE Ciudad.Poblacion >= PoblacionMin
	GROUP BY 1
	HAVING COUNT(1)>=NumCiudades;
    
END//
DELIMITER ;
CALL ejercicio5(2000000,2);

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 6. Crea una función que nos indique el número de palabras de una cadena. Para ello recorreremos la cadena de entrada. Entendemos como palabra cualquier secuencia segida de letras, letras acentuadas y dígitos; cualquier otra secuencia de uno o más carácteres es un separador: espacio, coma, punto, etc.
DROP PROCEDURE IF EXISTS ejercicio6;
DELIMITER //
CREATE PROCEDURE ejercicio6(IN Cadena CHAR(140))
BEGIN
	DECLARE Contador INT DEFAULT 1;
    DECLARE Longitud INT DEFAULT char_length(Cadena);
    DECLARE ContadorPalabras INT DEFAULT 0;
    DECLARE Posicion CHAR;
    DECLARE EraLetra BOOLEAN DEFAULT false;
REPEAT
    SET Posicion = SUBSTRING(Cadena, Contador, 1);
    IF Posicion BETWEEN 'A' AND 'Z' OR Posicion BETWEEN 'a' AND 'z' OR Posicion BETWEEN '0' AND '9' THEN 
		IF !EraLetra THEN
			SET ContadorPalabras = ContadorPalabras + 1;
		END IF;
        SET EraLetra = true;
    ELSE
		SET EraLetra = false;
    END IF;
    SET Contador = Contador + 1;
UNTIL Contador > Longitud  END REPEAT; 
SELECT ContadorPalabras AS 'Palabras contadas';
END//
DELIMITER ;
CALL ejercicio6("Hola");
CALL ejercicio6("Hola buenos dias");
CALL ejercicio6("Hola, que tal... yo bien");
-- ----------------------------------------------------------------------------------------------
-- Ejercicio 7. Crea una función que nos indique si la cadena introducida es palíndromo. Entendemos como palíndromos:  radar, reconocer, rotor, salas, seres, etc.
DROP FUNCTION IF EXISTS ejercicio7;
DELIMITER //
CREATE FUNCTION ejercicio7(Cadena CHAR(140)) RETURNS VARCHAR(140)
BEGIN
	SET @CadenaDerecha = right(Cadena, char_length(cadena)/2);
    SET @CadenaIzq = left(Cadena, char_length(Cadena)/2);
    IF REVERSE(@CadenaDerecha) = @CadenaIzq THEN
		RETURN "Es palindromo";
	ELSE
		RETURN "No es palindromo";
	END IF;
END//
DELIMITER ;
SELECT ejercicio7("Reconocer");
-- ----------------------------------------------------------------------------------------------
-- Ejercicio 8. Crea una función que nos indique si la cadena introducida es palíndromo. Entendemos como palíndromos:  radar, reconocer, rotor, salas, seres, etc. USA un bucle y la funión SUBSTR() para comprobar el carácter de una posición concreta en la cadena.
DROP FUNCTION IF EXISTS ejercicio8;
DELIMITER //
CREATE FUNCTION ejercicio8(Cadena CHAR(140)) RETURNS VARCHAR(140)
BEGIN
	DECLARE Contador INT DEFAULT 1; 
    DECLARE Iguales BOOLEAN DEFAULT TRUE;
    DECLARE CadenaReves CHAR(140) DEFAULT REVERSE(Cadena);
REPEAT
	IF SUBSTRING(Cadena, Contador, 1) != SUBSTRING(CadenaReves, Contador, 1) THEN
		SET Iguales = FALSE;
	END IF;
    SET Contador = Contador + 1;
UNTIL !Iguales OR Contador > CHAR_LENGTH(Cadena) END REPEAT;
IF Iguales THEN
	RETURN "Es palindromo";
ELSE
	RETURN "No es palindromo";
END IF;
END//
DELIMITER ;
SELECT ejercicio8("Reconocer");

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 9. Crea una función que nos indique si la cadena introducida es palíndromo sin tener en cuenta los espacios en blanco y signos de puntuación. En este caso serían palíndromos: "Añora la Roña", "La ruta, natural", etc.
DROP FUNCTION IF EXISTS ejercicio9;
DELIMITER //
CREATE FUNCTION ejercicio9(Cadena CHAR(140)) RETURNS VARCHAR(140)
BEGIN
	DECLARE Contador INT DEFAULT 1; 
    DECLARE CadenaLimpia CHAR(140) DEFAULT "";
    DECLARE Posicion CHAR(140) DEFAULT "";
    
REPEAT
	SET Posicion = SUBSTR(Cadena, Contador, 1);
	IF Posicion BETWEEN 'A' AND 'Z' OR Posicion BETWEEN 'a' AND 'z' OR Posicion BETWEEN '0' AND '9' THEN
		SET CadenaLimpia = CONCAT(CadenaLimpia, Posicion);
	END IF;
	SET Contador = Contador + 1;
UNTIL Contador > CHAR_LENGTH(Cadena) END REPEAT;

SET @CadenaDerecha = right(CadenaLimpia, char_length(CadenaLimpia)/2);
    SET @CadenaIzq = left(CadenaLimpia, char_length(CadenaLimpia)/2);
     IF REVERSE(@CadenaDerecha) = @CadenaIzq THEN
		 RETURN "Es palindromo";
	 ELSE
	 	RETURN "No es palindromo";
	 END IF;
END//
DELIMITER ;
SELECT ejercicio9("La ruta, natural");

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 10. Realiza una función que acepte un número entero lo más grande posible (DECIMAL(65)) y que nos devuelve verdadero o falso según dicho número sea primo o no. Recordemos la definición de número primo: "un número primo es un número natural mayor que 1 que tiene únicamente dos divisores distintos: él mismo y el 1". Para conocer si un número es divisible por otro, puedes usar la función MOD(N,M) que devuelve el resto de dividir N entre M. Si MOD(N,M)=0, entonces M es un divisor de N. Para encontrar los divisores de un número hay que empezar probando por 1 e ir incrementando, pero no hace falta llegar hasta el número N, sino que basta con llegar a raíz de N (https://es.wikipedia.org/wiki/N%C3%BAmero_primo#Tests_de_primalidad)

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 11. Crea un procedimiento que de un listado de ciudades ordenado por poblacion ascendente, nos de la ciudades que ocupan las posiciones 1, 10, 20, 30 ,..., 980, 990, 1000 (acabará aquí). Usa un cursor.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 12. Crea un procedimiento que de un listado de países ordenado por fecha de independencia de manera que para cada país muestre el incremento o decremento del PNB entre ese país y el país anterior de la lista. Para el primer país y cuando uno de los PNB sea nulo, mostrará n/a.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 13. Vamos a añadir un campo a la tabla país que indique la suma de la población de sus ciudades, actualizaremos este campo con los valores reales, añadiremos también los diparadores necesarios para mantener este nuevo campo actualizado ante modificaciones de la tabla de ciudades e incluiremos el código necesario para probarlo todo.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 14. Queremos realizar una auditoría sobre los cambios realizados en el código y el nombre de los países. Incluye el código que crea la tabla, los disparadores y las pruebas realizadas para ver que todo va bien.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 15. Crea un procedimiento que guarde y otro que borre los registros de la tabla de auditoría sobre la tabla países que tengan más de un número determinado de días.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 16. Realiza una auditoría de los campos EquipoLocal, EquipoVisitante, GolesLocal y GolesVisitante de la tabla partidos.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 17. De un listado de ciudades ordenado alfabéticamente y, si dos ciudades tienen el mismo nombre, ordenado por población; necesitamos saber cuántos grupos hay en los que cuatro o más ciudades pertenecen al mismo país.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 18.  Parametrizar el procedimiento anterior para que le podamos indicar el número máximo de repeticiones

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 19. Crea una tabla temporal donde se guardarán los datos de las repeticiones. Esta tabla será el resultado que devolverá el procedimiento

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 20. Modificar el procedimiento anterior para comprobar que el número de repeticiones sea mayor o igual que dos. Si no lo es se mostrará un error descriptivo.

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 21. Crea un procedimiento llamado Bucle1 al que le pasaremos tres números enteros mayores que cero como parámetro y que añade los siguientes registros a la tabla Bucles. Por ejemplo si la llamada es CALL Bucle1(1,2,3) se insertarán los siguientes registros: (1,1,1), (1,1,2), (1,1,3), (1,2,1), (1,2,2) y (1,2,3)
-- Codigo necesario
DROP DATABASE IF EXISTS Ejercicios;
CREATE DATABASE IF NOT EXISTS Ejercicios;
USE Ejercicios;

DROP TABLE IF EXISTS `Bucles`;
CREATE TABLE `Bucles` (
    `N1` INTEGER DEFAULT NULL,
    `N2` INTEGER DEFAULT NULL,	
    `N3` INTEGER DEFAULT NULL
);

TRUNCATE TABLE Bucles;
INSERT INTO Bucles VALUES(1, 2, 3);
SELECT * FROM Bucles;
TRUNCATE TABLE Bucles;
INSERT INTO Bucles VALUES(10, 20, 30);
SELECT * FROM Bucles;

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 22. Calcula la suma de todos los dígitos de todos los número presentes en una base de datos de números enteros positivos. Para probar el algoritmo llenaremos la BD con números enteros aleatorios positivos. Por ejemplo, si la base de datos contiene los número 12, 33 y 67 el resultado será 1+2 + 3+3 + 6+7= 22.
DROP DATABASE IF EXISTS EjEnteros;
CREATE DATABASE IF NOT EXISTS EjEnteros;
USE EjEnteros;

DROP TABLE IF EXISTS `Enteros`;
CREATE TABLE `Enteros` (
    `Numero` BIGINT DEFAULT NULL
);

TRUNCATE TABLE Enteros;
INSERT INTO Enteros VALUES(1);
SELECT * FROM Enteros;

DROP PROCEDURE IF EXISTS LlenarTabla;
DELIMITER //
CREATE PROCEDURE LlenarTabla (IN NumeroDeDatos INT)
BEGIN
   DECLARE Contador INT DEFAULT 2;

   TRUNCATE TABLE Enteros;
   WHILE Contador<=NumeroDeDatos DO
      INSERT INTO Enteros VALUES(ROUND(RAND()*9223372036854775807)); -- Valor máximo de un BIGINT
      SET Contador= Contador+1;
   END WHILE;
END// 
DELIMITER ;

CALL LlenarTabla(120);

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 23. Dada una BD de palabras, realiza un procedimiento que guarde en otra tabla con las letras del abecedario el número de apariciones de cada letra. Todas las letras se pasarán a minúsculas. No se tendrán en cuenta los caracteres que aparezcan en las palabras pero que no estén en la tabla Letras.
DROP DATABASE IF EXISTS PalabrasYLetras;
CREATE DATABASE IF NOT EXISTS PalabrasYLetras;
USE PalabrasYLetras;

DROP TABLE IF EXISTS `Palabras`;
CREATE TABLE `Palabras` (
    `Palabra` VARCHAR(255) NOT NULL DEFAULT ''
);

DROP TABLE IF EXISTS `Letras`;
CREATE TABLE `Letras` (
    `Letra` CHAR NOT NULL DEFAULT '',
    `Repeticiones` INT NOT NULL DEFAULT 0
);

TRUNCATE TABLE Palabras;
TRUNCATE TABLE Letras;
INSERT INTO Palabras VALUES('Hellow'), ('word'), ('Hola'), ('mundo'), ('Esto'), ('es'), ('una'), ('prueba');
INSERT INTO Letras VALUES('a',0);
UPDATE Letras SET Repeticiones= Repeticiones+1 WHERE Letra='a';

SELECT * FROM Palabras;
SELECT * FROM Letras;

DROP PROCEDURE IF EXISTS LlenarTablaLetras;
DELIMITER //
CREATE PROCEDURE LlenarTablaLetras ()
BEGIN
   DECLARE Contador INT;

   TRUNCATE TABLE Letras;
   SET Contador= ASCII('a');
   WHILE Contador<=ASCII('z') DO
      INSERT INTO Letras VALUES(CHAR(Contador),0);
      SET Contador= Contador+1;
   END WHILE;
   INSERT INTO Letras VALUES('ñ',0);
   INSERT INTO Letras VALUES('á',0);
   INSERT INTO Letras VALUES('é',0);
   INSERT INTO Letras VALUES('í',0);
   INSERT INTO Letras VALUES('ó',0);
   INSERT INTO Letras VALUES('ú',0);
   INSERT INTO Letras VALUES('ü',0);   
END// 
DELIMITER ;

CALL LlenarTablaLetras();

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 24 Crea subprograma (procedimiento o función alamacenados) que nos indique si un número es perfecto:
/*
Número perfecto: todo número natural que es igual a la suma de sus divisores propios (es decir, todos sus divisores excepto el propio número). Por ejemplo, 6 es un número perfecto ya que sus divisores propios son 1, 2, y 3 y se cumple que 1+2+3=6. Los números 28, 496 y 8128 también son perfectos.
*/

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 25. Crea un subprograma que nos saque por pantalla los números perfectos comprendidos entre un rango de números que le pasaremos como parámetro

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 26. Crea un subprograma que alamacene en una tabla los números perfectos comprendidos entre un rango de números que le pasaremos como parámetro

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 27. Crea subprograma que nos indique si un número es abundante:
/*
Número abundante: todo número natural que cumple que la suma de sus divisores propios es mayor que el propio número. Por ejemplo, 12 es abundante ya que sus divisores son 1, 2, 3, 4 y 6 y se cumple que 1+2+3+4+6=16, que es mayor que el propio 12.
*/

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 28. Crea un subprograma que nos saque por pantalla los números abundantes comprendidos entre un rango de números que le pasaremos como parámetro

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 29. Crea un subprograma que alamacene en una tabla los números abundantes comprendidos entre un rango de números que le pasaremos como parámetro

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 30. Crea un subprograma que alamacene en una tabla los números deficientes comprendidos entre un rango de números que le pasaremos como parámetro
/*
Número deficiente: todo número natural que cumple que la suma de sus divisores propios es menor que el propio número. Por ejemplo, 16 es un número deficiente ya que sus divisores propios son 1, 2, 4 y 8 y se cumple que 1+2+4+8=15, que es menor que 16.
*/

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 31. Crea subprograma que nos indique si un número es apocalíptico:
/*
Número apocalíptico: todo número natural n que cumple que 2^n (dos elevado a ene) contiene la secuencia 666. Por ejemplo, los números 157 y 192 son números apocalípticos. Nota: el número 2^192 es tan grande que aunque es apocalíptico, MySQL dice que no lo es, incluso aunque se declaren las variables como DECIMAL(65)
*/

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 32. Crea un subprograma que nos saque por pantalla los números apocalípticos comprendidos entre un rango de números que le pasaremos como parámetro

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 33. Crea un subprograma que alamacene en una tabla los números apocalípticos comprendidos entre un rango de números que le pasaremos como parámetro

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 34. Crea un subprograma que alamacene en una tabla todos los números entre un rango de números que le pasaremos como parámetro y que indicará en la misma tabla si cada número es feliz o infeliz:
/*
Número feliz: todo número natural que cumple que si sumamos los cuadrados de sus dígitos y seguimos el proceso con los resultados obtenidos el resultado es 1. Por ejemplo, el número 203 es un número feliz ya que 22+02+32=13; 12+32=10; 12+02=1.
Número infeliz: todo número natural que no es un número feliz. Por ejemplo, el número 16 es un número infeliz.
*/

-- ----------------------------------------------------------------------------------------------
-- Ejercicio 35. Crea un subprograma que alamacene en una tabla todos los números afortunados comprendidos entre uno y un números que le pasaremos como parámetro.
/*
Número afortunado: Tomemos la secuencia de todos los naturales a partir del 1: 1, 2, 3, 4, 5,… Tachemos los que aparecen en las posiciones pares. Queda: 1, 3, 5, 7, 9, 11, 13,… Como el segundo número que ha quedado es el 3 tachemos todos los que aparecen en las posiciones múltiplo de 3. Queda: 1, 3, 7, 9, 13,… Como el siguiente número que quedó es el 7 tachamos ahora todos los que aparecen en las posiciones múltiplos de 7. Así sucesivamente. Los números que sobreviven se denominan números afortunados.
*/








