/*
Bases de Datos
Tema 4. Programando con SQL

Grupo: 1ºDAM

Procura que en tu código no haya tabuladores, sólo espacios en blanco. Puedes ejecutar:
Menú > Editar > Operciones de limpieza > TAB a espacio antes de entregar los ejercicios.
*/

-- -----------------------------------------------------------------------------
-- Tema 4. Programando con SQL
-- -----------------------------------------------------------------------------


-- 1 Listado de los paÃ­ses y el nÃºmero de ciudades de ese paÃ­s para los paÃ­ses que tienen mÃ¡s ciudades que EspaÃ±a. Simplifica la consulta usando variables de usuario.
set @NumCiudadesSpain = (SELECT COUNT(*)            -- NÃºmero de ciudades de EspaÃ±a.
                   FROM   Pais Join Ciudad
                   ON     Pais.Codigo = Ciudad.CodigoPais
                   WHERE  Pais.Nombre = 'Spain');
                   
SELECT Pais.Nombre AS Pais, COUNT(*) AS 'NÃºmero de ciudades'
FROM   Pais Join Ciudad
ON     Pais.Codigo = Ciudad.CodigoPais
GROUP BY Pais.Codigo
HAVING COUNT(*) > @NumCiudadesSpain;

-- 2. Crea un procedimiento que nos de el nombre y la poblaciÃ³n de las diez ciudades mÃ¡s pobladas
DROP PROCEDURE IF EXISTS CiudadesMasPobladas;
DELIMITER //
CREATE PROCEDURE CiudadesMasPobladas()
BEGIN 
	SELECT Nombre, Poblacion FROM Ciudad
	ORDER BY Poblacion DESC LIMIT 10;
END//
DELIMITER ;
CALL CiudadesMasPobladas();

CREATE VIEW CiudadesMasPobladas AS (
	SELECT Nombre, Poblacion FROM Ciudad
	ORDER BY Poblacion DESC LIMIT 10);
    
-- Mejor con una vista:
CREATE VIEW  CiudadesMasPobladas AS (
   SELECT Nombre, Poblacion FROM Ciudad
   ORDER BY Poblacion DESC LIMIT 10);

-- 3. Crea un procedimiento en el que asignemos variables de los tipos principales. Un tercio, mÃ¡s o menos, de las variables las iniciaremos en su creaciÃ³n, otro tercio con sentencias SET y el Ãºltimo tercio con sentencias SELECT INTO. Por Ãºltimo mostraremos en pantalla el valor de todas las variables. TambiÃ©n dejaremos una variable sin inicializar y sin asignar. Tipos de datos: INT, VARCHAR(50), BOOLEAN, CHAR, FLOAT, DOUBLE, DATE, DATETIME, TIME, YEAR, TEXT, ENUM() y DECIMAL().

DROP PROCEDURE IF EXISTS VariablesYTipos;
DELIMITER //
CREATE PROCEDURE VariablesYTipos()
BEGIN
 DECLARE Var1  INT         DEFAULT 10;
 DECLARE Var2  VARCHAR(50) DEFAULT 'Hola ola';
 DECLARE Var3  BOOLEAN     DEFAULT TRUE;
 DECLARE Var4  CHAR        DEFAULT 'A';
 DECLARE Var5  FLOAT;
 DECLARE Var6  DOUBLE;
 DECLARE Var7  DATE;
 DECLARE Var8  DATETIME;
 DECLARE Var9  TIME; 
 DECLARE Var10 YEAR;
 DECLARE Var11 TEXT;
 DECLARE Var12 ENUM('T','F');
 DECLARE Var13 DECIMAL(10,2);
 DECLARE Var14 INT;
 
 SET Var5  = 5.6;
 SET Var6  = 5.6;
 SET Var7 = CURDATE();
 SET Var8 = '2015-02-02 11:41:30';
 SET Var9 = '11:41:30';
 SELECT AnyIndep   INTO Var10
 FROM Pais WHERE Codigo='AGO'; -- YEAR sÃ³lo permite desde 1900 hasta 2155 Angola 1975
 SELECT 'Hola ola' INTO Var11;
 SELECT EsOficial  INTO Var12
 FROM LenguaPais
 WHERE codigoPais = 'ESP' AND Lengua = 'Spanish';
 SELECT PNB  INTO Var13
 FROM Pais
 WHERE codigo = 'ESP'; 
 
 SELECT Var1 AS  'Var1 -> INT',
     Var2 AS  'Var2 -> VARCHAR',
     Var3 AS  'Var3 -> BOOLEAN',
     Var4 AS  'Var4 -> CHAR';
 SELECT Var5 AS  'Var5 -> FLOAT',
     Var6 AS  'Var6 -> DOUBLE',
     Var7 AS  'Var7 -> DATE',
     Var8 AS  'Var8 -> DATETIME';
 SELECT Var9 AS  'Var9 -> TIME',
     Var10 AS 'Var10 -> YEAR',
     Var11 AS 'Var11 -> TEXT',
     Var12 AS 'Var12 -> ENUM',
     Var13 AS 'Var13 -> DECIMAL',
     Var14 AS 'Var14 -> INT sin valor';
END//
DELIMITER ;
CALL VariablesYTipos();

-- 4. Crea un procedimiento que calcule las soluciones de una ecuaciÃ³n de segundo grado: ax^2+bx+c=0. Tenemos dos soluciones: x1=(-b+SQRT(b^2-4ac))/2a y x2=(-b-SQRT(b^2-4ac))/2a

drop procedure if exists Ecuacion2G;
DELIMITER //
CREATE PROCEDURE Ecuacion2G(IN A DOUBLE, IN B DOUBLE, IN C DOUBLE, OUT X1 DOUBLE, OUT X2 DOUBLE)
BEGIN
	SET X1=(-B + SQRT(POW(B,2)-4*A*C))/(2 * A);
    SET X2 = (-B - SQRT(POW(B, 2)-4 * A * C)) / (2 * A);
END//
DELIMITER ;

-- 5. Disparamos un proyectil con una velocidad inicial V0 y con un ángulo Z. Calcula la altura máxima (ymax) y el alcance (xmax): xmax= V0^2 * sen(2*Z) / g    ymax= V0^2 * sen^2(Z) / 2g; donde es g es la aceleración de la gravedad: 9,81 m/s²

DROP PROCEDURE IF EXISTS Balistica;
DELIMITER //
CREATE PROCEDURE Balistica (IN V0 DOUBLE, IN Zgrados DOUBLE, OUT Xmax DOUBLE, OUT Ymax DOUBLE)
BEGIN
	DECLARE G DOUBLE DEFAULT 9.81; -- m/s^2
    DECLARE Zradianes DOUBLE; -- radianes
    
    SET Zradianes = Zgrados * 2 * PI() / 360;
	SET Xmax = POW(V0, 2) * SIN(2 * Zradianes) / g;
    SET ymax = POW(V0, 2) * POW(SIN(Zradianes), 2) / 2g;
END//
DELIMITER ;


-- -----------------------------------------------------------------
-- Constructores de control de flujo: IF, CASE
-- -----------------------------------------------------------------

-- 6. Crea un procedimiento que nos diga (mediante un SELECT) si el primer número que le pasamos como parámetro es mayor, menor o igual que el segundo (usa IF)

DROP PROCEDURE IF EXISTS EsMayorMenorIgualIF;
DELIMITER //
CREATE PROCEDURE EsMayorMenorIgualIF (IN IntA INT, IN IntB INT)
BEGIN
	IF IntA > IntB THEN SELECT CONCAT(IntA, ' es mayor que ', IntB) AS Resultado;
    ELSEIF IntA < IntB THEN SELECT CONCAT(IntA, ' es menor que ', IntB) AS Resultado;
    ELSEIF IntA = IntB THEN SELECT CONCAT(IntA, ' es igual que ', IntB) AS Resultado;
    ELSE SELECT('Algún valor es nulo') AS 'Resultado';
    END IF;
	
END//
DELIMITER ;

CALL EsMayorMenorIgualIF(5,10);
CALL EsMayorMenorIgualIF(15,10);
CALL EsMayorMenorIgualIF(10,10);
CALL EsMayorMenorIgualIF(5,NULL);

-- 7. Crea un procedimiento que nos diga si el primer número que le pasamos como parámetro es mayor, menor o igual que el segundo (usa CASE)

DROP PROCEDURE IF EXISTS EsMayorMenorIgualIF;
DELIMITER //
CREATE PROCEDURE EsMayorMenorIgualIF (IN IntA INT, IN IntB INT)
BEGIN
	CASE
		WHEN IntA > IntB THEN SELECT CONCAT(IntA, ' es mayor que ', IntB) AS Resultado;
		WHEN IntA < IntB THEN SELECT CONCAT(IntA, ' es menor que ', IntB) AS Resultado;
		WHEN IntA = IntB THEN SELECT CONCAT(IntA, ' es igual que ', IntB) AS Resultado;
		ELSE SELECT('Algún valor es nulo') AS 'Resultado';
    END CASE;
	
END//
DELIMITER ;

CALL EsMayorMenorIgualIF(5,10);
CALL EsMayorMenorIgualIF(15,10);
CALL EsMayorMenorIgualIF(10,10);
CALL EsMayorMenorIgualIF(5,NULL);

-- 8. Crea un procedimiento que nos haga redondeo selectivo de números positivos: no queremos decimales y dependiendo del número de dígitos de la cifra redondeamos todos los dígitos excepto los dos más significativos. Por ejemplo, 66,3 se redondea a 66; 123 a 120 y 127 a 130; 6123 a 6100 y 6177 a 6200. El número máximo de cifras que redondeamos es de 5. Nota: usar ROUND(Número, NúmeroNegativo)
-- Procedimiento:  RedondeoSelectivo, Parámetros: NumeroSinRedondear,  NumeroRedondeado

DROP PROCEDURE IF EXISTS RedondeoSelectivo;
DELIMITER //
CREATE PROCEDURE RedondeoSelectivo (IN NumeroSinRedondear DOUBLE, OUT NumeroRedondeado INT)
BEGIN
	CASE
		WHEN NumeroSinRedondear < 100 THEN SET NumeroRedondeado = ROUND(NumeroSinRedondear);
        WHEN NumeroSinRedondear < 1000 THEN SET NumeroRedondeado = ROUND(NumeroSinRedondear, -1);
        WHEN NumeroSinRedondear < 10000 THEN SET NumeroRedondeado = ROUND(NumeroSinRedondear, -2);
        WHEN NumeroSinRedondear < 100000 THEN SET NumeroRedondeado = ROUND(NumeroSinRedondear, -3);
        WHEN NumeroSinRedondear < 1000000 THEN SET NumeroRedondeado = ROUND(NumeroSinRedondear, -4);
        WHEN NumeroSinRedondear >= 10000000 THEN SET NumeroRedondeado = ROUND(NumeroSinRedondear, -5); 
        ELSE SET NumeroReadondeado = NULL;
        
	END CASE;

END//
DELIMITER ;


--------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS EscribeEsOficial1;
DELIMITER //
CREATE PROCEDURE EscribeEsOficial1 (IN EsOficial ENUM('T','F'))
BEGIN
   CASE EsOficial
      WHEN 'T' THEN SELECT 'Es oficial';
      WHEN 'F' THEN SELECT 'No es oficial';
      ELSE SELECT 'Es nulo';
   END CASE;
END// 
DELIMITER ;

DROP PROCEDURE IF EXISTS EscribeEsOficial2;
DELIMITER //
CREATE PROCEDURE EscribeEsOficial2 (IN EsOficial ENUM('T','F'))
BEGIN
   CASE
      WHEN EsOficial='T' THEN SELECT 'Es oficial';
      WHEN EsOficial='F' THEN SELECT 'No es oficial';
      ELSE SELECT 'Es nulo';
   END CASE;
END// 
DELIMITER ;

-- -----------------------------------------------------------------
-- LOOP, LEAVE, ITERATE, REPEAT … UNTIL, WHILE
-- -----------------------------------------------------------------

-- 9. Crea un procedimiento que diga “Hola ola” tantas veces como el número que le pasaremos como parámetro (usa un bulce LOOP)

    DROP PROCEDURE IF EXISTS HolaOlaLOOP;
    DELIMITER //
    CREATE PROCEDURE HolaOlaLOOP(IN Numero INT)
    BEGIN
        DECLARE Contador INT DEFAULT 0;
        
        Bucle: LOOP
            IF Contador >= Numero OR Numero IS NULL THEN LEAVE Bucle; END IF;
            SELECT 'Hola ola' AS 'Resultado';
            SET Contador = Contador + 1;
        END LOOP Bucle;
    END//
    
    DELIMITER ;
    
    CALL HolaOlaLOOP(6);
    
    
    -- 10. Crea un procedimiento que diga “Hola ola” tantas veces como el número que le pasaremos como parámetro (usa un bucle REPEAT UNTIL)
-- Procedimiento:  HolaOlaREPEAT, Parámetros: Numero

DROP PROCEDURE IF EXISTS HolaOlaREPEAT;
    DELIMITER //
    CREATE PROCEDURE HolaOlaREPEAT(IN Numero INT)
    BEGIN
        DECLARE Contador INT DEFAULT 0;
        
        REPEAT 
            SELECT 'Hola ola' AS 'Resultado';
            SET Contador = Contador + 1;
        UNTIL Contador >= Numero OR Numero IS NULL END REPEAT;
    END//
    
    DELIMITER ;
    
    CALL HolaOlaREPEAT(6);

DROP PROCEDURE IF EXISTS HolaOlaREPEAT;
    DELIMITER //
    CREATE PROCEDURE HolaOlaREPEAT(IN Numero INT)
    BEGIN
        DECLARE Contador INT DEFAULT 0;
        Bucle: REPEAT
            IF Numero >= 0 OR Numero IS NULL THEN LEAVE Bucle; END IF;
            SELECT 'Hola ola' AS 'Resultado';
            SET Contador = Contador + 1;
        UNTIL Contador >=Numero END REPEAT bucle;
    END//
    
    DELIMITER ;
    
    CALL HolaOlaREPEAT(6);


-- 11. Crea un procedimiento que diga “Hola ola” tantas veces como el número que le pasaremos como parámetro (usa un bulce WHILE)
-- Procedimiento:  HolaOlaWHILE, Parámetros: Numero

DROP PROCEDURE IF EXISTS HolaOlaWHILE;
    DELIMITER //
    CREATE PROCEDURE HolaOlaWHILE(IN Numero INT)
    BEGIN
        DECLARE Contador INT DEFAULT 0;
        
        WHILE Contador >= Numero AND Numero DO
            SELECT 'Hola ola' AS 'Resultado';
            SET Contador = Contador + 1;
        END WHILE;
    END//
    
    DELIMITER ;
    
    CALL HolaOlaREPEAT(6);
    
    
    
-- 12. Crea una consulta que muestre el nombre de los países que se han independizado entre dos años concretos (incluidos esos dos años). Crea un procedimiento que parametrice la consulta. Modifica el procedimiento para que de igual el orden en el que ponemos los años.
-- Consulta inicial:
SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
FROM   Pais
WHERE  AnyIndep BETWEEN 300 AND 1970
ORDER BY AnyIndep;

-- Parametrizamos la consulta:
SET @AnyA= 300, @AnyB=1970;
SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
FROM   Pais
WHERE  AnyIndep BETWEEN @AnyA AND @AnyB
ORDER BY AnyIndep;

-- Creamos el procedimiento:
-- Procedimieto:  PaisesIndependizadosEntreDosFechas. Parámetros: AnyA, AnyB

DROP PROCEDURE IF EXISTS PaisesIndependizadosEntreDosFechas;
    DELIMITER //
    CREATE PROCEDURE PaisesIndependizadosEntreDosFechas(IN AnyA INT, IN AnyB INT)
    BEGIN
        DECLARE Tmp INT;
        
        IF AnyA < AnyB THEN
            SET Tmp = AnyA;
            SET AnyA = AnyB;
            SET AnyB = Tmp;
        END IF;
        SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
        FROM   Pais
        WHERE  AnyIndep BETWEEN AnyA AND AnyB
        ORDER BY AnyIndep;
    END//
    DELIMITER ;
    
    
    
    -- 13. Crea un procedimiento llamado OrdenaInt al que le pasamos dos números enteros y que nos deja el menor en el primer parámetro y el mayor en el segundo. Simplifica el procedimiento de la consulta anterior
-- Procedimiento: OrdenaInt. Parámetros: IntA, IntB

DROP PROCEDURE IF EXISTS OrdenaInt;
    DELIMITER //
    CREATE PROCEDURE OrdenaInt(IN IntA INT, IN IntB INT)
    BEGIN
        DECLARE Tmp INT;
        
        IF IntA < AnyB THEN
            SET Tmp = IntA;
            SET IntA = IntB;
            SET IntB = Tmp;
        END IF;
    END//
    DELIMITER ;
    
    
    DROP PROCEDURE IF EXISTS PaisesIndependizadosEntreDosFechas;
    DELIMITER //
    CREATE PROCEDURE PaisesIndependizadosEntreDosFechas(IN AnyA INT, IN AnyB INT)
    BEGIN
        CALL OrdenaInt(IntA,IntB);
        SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
        FROM   Pais
        WHERE  AnyIndep BETWEEN AnyA AND AnyB
        ORDER BY AnyIndep;
    END//
    DELIMITER ;
    
    
    
    -- 14. En el Tema 2 realizamos la siguiente consulta. Parametriza la consulta para que acepte cualquier nombre de ciudad y comprueba que la ciudad existe y que sólo hay una ciudad con ese nombre. Muestra errores descriptivos
-- Listado de las ciudades que tienen la misma población que la ciudad El Limón. Quita del resultado la población de El Limón, que ya sabemos que tiene los mismos habitantes que El Limón.

SELECT Nombre AS 'Ciudades que tienen la misma población que la ciudad El Limón'
FROM   Ciudad
WHERE  Nombre <> 'El Limón' AND
       Poblacion = (SELECT Poblacion
                    FROM   Ciudad
                    WHERE  Nombre = 'El Limón'
                    LIMIT 1);
-- 11 Registros

-- Procedimiento: CiudadesConIgualPoblacion. Parámetro: CiudadParam

    DROP PROCEDURE IF EXISTS CiudadesConIgualPoblacion;
    DELIMITER //
    CREATE PROCEDURE PaisesIndependizadosEntreDosFechas(IN CiudadParam CHAR(35))
    BEGIN
        DECLARE NumCiudades INT;
        
        SET NumCiudades = (SELECT COUNT(*) FROM Ciudad WHERE Nombre = CiudadParam);
        IF NumCiudades = 0
            THEN SELECT CONCAT('No existe la ciudad: ', CiudadParam) AS 'ERROR:';
        ELSEIF NumCiudades > 1
            THEN SELECT CONCAT('Hay más de una ciudad con el nombre: ', CiudadParam) AS 'ERROR:';
        
        ELSE 
            SELECT Nombre AS 'Ciudades que tienen la misma población'
            FROM   Ciudad
            WHERE  Nombre <> CiudadParam AND
                    Poblacion = (SELECT Poblacion
                        FROM   Ciudad
                        WHERE  Nombre = CiudadParam);
            
        END IF;
    END//
    DELIMITER ;
    
    
    DROP PROCEDURE IF EXISTS CiudadesConIgualPoblacion;
    DELIMITER //
    CREATE PROCEDURE PaisesIndependizadosEntreDosFechas(IN CiudadParam CHAR(35))
    BEGIN
        DECLARE NumCiudades INT;
        
        SET NumCiudades = (SELECT COUNT(*) FROM Ciudad WHERE Nombre = CiudadParam);
        CASE
            WHEN NumCiudades = 0
                THEN SELECT CONCAT('No existe la ciudad: ', CiudadParam) AS 'ERROR:';
            WHEN NumCiudades > 1
                THEN SELECT CONCAT('Hay más de una ciudad con el nombre: ', CiudadParam) AS 'ERROR:';
            
            ELSE 
                SELECT Nombre AS 'Ciudades que tienen la misma población'
                FROM   Ciudad
                WHERE  Nombre <> CiudadParam AND
                        Poblacion = (SELECT Poblacion
                            FROM   Ciudad
                            WHERE  Nombre = CiudadParam);
            
        END CASE;
    END//
    DELIMITER ;
    
    -- Procedimiento: CiudadesConIgualPoblacion. Parámetro: CiudadParam
-- Prueba para comprobar que sólo hay una ciudad 'El Limón'. Cuidado que hacemos COUNT(*) =  0
-- mejor un EXISTS
-- Debe dar 1 para poder ejecutar la consulta anterior
SELECT COUNT(*)
FROM   Ciudad
WHERE  Nombre = 'El Limón';

-- 15. En el Tema 2 realizamos la siguiente consulta. Parametriza la consulta para que acepte cualquier nombre de País y comprueba que el país existe, que es del continente Africano, que sólo hay un país con ese nombre y que en ese país sólo se habla una lengua oficial. Muestra errores descriptivos

-- Capitales del continente africano con el mismo idioma oficial que el idioma oficial de egipto.
SELECT Ciudad.Nombre AS Capital
FROM   Ciudad JOIN Pais JOIN Lenguapais
ON     Ciudad.Id = Pais.Capital AND 
       Lenguapais.Codigopais = Pais.Codigo
WHERE  Continente = 'africa' AND EsOficial = 'T' AND Lengua =
   (SELECT Lengua
    FROM   Pais JOIN Lenguapais
    ON     Lenguapais.Codigopais = Pais.Codigo
    WHERE  Pais.Nombre = 'Egypt' AND EsOficial = 'T'
    LIMIT  1);  -- Se limita a una fila por si Egipto tuviese más de una lengua oficial
-- 10 Registros
-- Aquí comprobamos si Egipto sólo tiene un idioma oficial
SELECT COUNT(*)=1
FROM   Pais JOIN Lenguapais
ON     Lenguapais.Codigopais = Pais.Codigo
WHERE  Pais.Nombre = 'Egypt' AND EsOficial = 'T';

-- Procedimiento:  CapitalesIdiomaOficial. Parámetro: PaisParam

-- 16. Crea las funciones: ElMenorDeDos y ElMayorDeDos. Ambas funciones tienen dos parámetros de entrada de tipo entero. Una nos devolverá el menor de los dos valores que se le pasan y la otra el mayor. Si los valores son iguales, ambas funciones devolverán el valor que se le ha pasado

-- 17. Dado el siguiente procedimiento que devuelve la lista de países que están entre dos valores del PNB que se le pasan como parámetro. Si el primer valor es mayor que el segundo, el procedimiento no devuelve nada. Siguiendo el siguiente esquema: SET @A= Un_número_entero, @B= Otro_número_entero; CALL PaisesEntreDosPNB (…) y las funciones definidas anteriormente, realiza una llamada al procedimiento de manera que @A pueda ser mayor que @B.
DROP PROCEDURE IF EXISTS PaisesEntreDosPNB;
DELIMITER //
CREATE PROCEDURE PaisesEntreDosPNB (IN PNBA FLOAT(10,2), IN PNBB FLOAT(10,2))
BEGIN
   SELECT Nombre AS 'País', PNB
   FROM   Pais
   WHERE  PNB BETWEEN PNBA AND PNBB
   ORDER BY 2;
END// 
DELIMITER ;

CALL PaisesEntreDosPNB (1000,1200);
CALL PaisesEntreDosPNB (1200,1000);

SET @A=1000, @B=1200;
CALL PaisesEntreDosPNB ();

-- 18. Crea la función Factorial que nos devuelve el factorial de un número
/*
El factorial de un entero positivo n, se define como el producto de todos los números enteros positivos desde 1  hasta n. Por ejemplo, 5! = 1 x 2 x 3 x 4 x 5 = 120

La operación de factorial aparece en muchas áreas de las matemáticas, particularmente en combinatoria y análisis matemático. De manera fundamental, el factorial de n representa el número de formas distintas de ordenar n objetos distintos (elementos sin repetición).

Definición: La función factorial es formalmente definida mediante el producto
n! = 1 x 2 x 3 x 4 x ... x (n-1) x n
Todas las definiciones anteriores incorporan la premisa de que
0! = 1

La función factorial es fácilmente implementable en distintos lenguajes de programación. Se pueden elegir dos métodos, el iterativo, es decir, realiza un bucle en el que se multiplica una variable temporal por cada número natural entre 1 y n, o el recursivo, por el cual la función factorial se llama a sí misma con un argumento cada vez menor hasta llegar al caso base 0!=1*/
 
-- Función: Factorial. Parámetros: IntA

-- 19. Crea una base de datos de factoriales de un número
-- La base de datos:
DROP DATABASE IF EXISTS FactorialesDB;
CREATE DATABASE IF NOT EXISTS FactorialesDB;
USE FactorialesDB;

DROP TABLE IF EXISTS `Factoriales`;
CREATE TABLE `Factoriales` (
    `Numero`    INTEGER NOT NULL,
    `Factorial` DECIMAL(65),
    PRIMARY KEY (`Numero`)
);

-- Órdenes para gestionar la BD:
INSERT INTO Factoriales VALUES(5, 120);
TRUNCATE TABLE Factoriales;
CALL LlenaFactoriales(50);              -- Este es el procedimiento que hay que hacer
SELECT * FROM Factoriales;

-- 20. De cada país que tenga lenguas oficiales, queremos saber el número posible de formas de ordenar sus lenguas oficiales. Usa la función factorial
-- La consulta sin el factorial
SELECT Nombre AS 'País', COUNT(*) AS 'Número de lenguas oficiales'
FROM   Pais JOIN LenguaPais
ON     Pais.Codigo = LenguaPais.CodigoPais
WHERE  EsOficial='T'
GROUP BY Pais.Codigo;

-- 21.  De cada país, queremos saber el número posible de formas de ordenar sus ciudades. Usa la BD de Factoriales
-- La consulta sin el factorial
SELECT Pais.Nombre AS 'País', COUNT(Ciudad.Id) AS 'Número de ciudades'
FROM   Pais LEFT JOIN Ciudad
ON     Pais.Codigo = Ciudad.CodigoPais
GROUP BY Pais.Codigo;

-- 22.
-- -----------------------------------------------------------------
-- Ejercicio criba de Erastótenes
-- -----------------------------------------------------------------
/*
Número primo:
Un número primo es aquel número natural mayor que uno que admite únicamente dos divisores diferentes: el mismo número y el 1. A diferencia de los números primos, los números compuestos son naturales que pueden factorizarse. La propiedad de ser primo se denomina primalidad. 

El algoritmo RSA se basa en la obtención de la clave pública mediante la multiplicación de dos números grandes (mayores que 10^200) que sean primos. La seguridad de este algoritmo radica en que no se conocen maneras rápidas de factorizar un número grande en sus factores primos utilizando computadoras tradicionales.

https://es.wikipedia.org/wiki/Criba_de_Erat%C3%B3stenes

Tests de primalidad
La criba de Eratóstenes fue concebida por Eratóstenes de Cirene, un matemático griego del siglo III a. C. Es un algoritmo sencillo que permite encontrar todos los números primos menores o iguales que un número dado. Se basa en confeccionar una lista de todos los números naturales desde el 2 hasta ese número y tachar repetidamente los múltiplos de los números primos ya descubiertos.

Criba de Erastótenes. Algoritmo en pseudocódigo:

Entrada: Un número natural n
Salida: El conjunto de números primos anteriores a n (incluyendo n)

   Escriba todos los números naturales desde 2 hasta n
   Para i desde 2 hasta raíz cuadrada de n haga lo siguiente:
      Si i no ha sido marcado entonces:
         Para j desde i hasta n/i haga lo siguiente:
            Ponga una marca en i x j
   El resultado es: Todos los números sin marca
*/
-- Código de apoyo:
DROP DATABASE IF EXISTS Primos;
CREATE DATABASE IF NOT EXISTS Primos;
USE Primos;

DROP TABLE IF EXISTS `NumerosPrimos`;
CREATE TABLE `NumerosPrimos` (
    `Numero` INTEGER NOT NULL,
    `Marcado` BOOLEAN,
    PRIMARY KEY (`Numero`)
);

TRUNCATE TABLE NumerosPrimos;
INSERT INTO NumerosPrimos VALUES(7, FALSE);
UPDATE NumerosPrimos SET Marcado= TRUE WHERE Numero=7;
SELECT * FROM NumerosPrimos;
SELECT * FROM NumerosPrimos WHERE Marcado;
SELECT Marcado FROM NumerosPrimos WHERE Numero=7;

-- 22. Realiza un procedimiento que implemente la parte “Escriba todos los números naturales desde 2 hasta n”. No es necesario controlar posibles errores en el parámetro de entrada
-- Procedimiento: LlenarTabla. Parámetros: ValorMaximo

DROP PROCEDURE IF EXISTS LlenarTabla;
DELIMITER //
CREATE PROCEDURE LlenarTabla (IN ValorMaximo INT)
BEGIN
    DECLARE Contador INT DEFAULT 2;

    TRUNCATE TABLE NumerosPrimos;
    WHILE Contador <= ValorMaximo DO
        INSERT INTO NumerosPrimos VALUES(Contador, FALSE);
        SET Contador = Contador + 1;
    END WHILE;
END//
DELIMITER ;

-- 23. Implementa el algoritmo de la criba de Erastótenes
-- Procedimiento: CribaDeErastotenes. Parámetros: ValorMaximo

DROP PROCEDURE IF EXISTS CribaDeErastotenes;
DELIMITER //
CREATE PROCEDURE CribaDeErastotenes (IN ValorMaximo INT)
BEGIN
    DECLARE i INT DEFAULT 2;
    DECLARE j INT;

    WHILE i <= TRUNCATE(SQRT(ValorMaximo), 0) DO
        IF NOT (SELECT Marcado FROM NumerosPrimos WHERE Numero = i)
            THEN
                SET j = i;
                WHILE j <= ValorMaximo/i DO
                    UPDATE NumerosPrimos SET Marcado = TRUE WHERE Numero = i * j;
                    SET j = j + i;
                END WHILE;
        END IF;
        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;

CALL CribaDeErastotenes();
SELECT Numero FROM NumerosPrimos WHERE NOT Marcado;

-- 24. Crea un procedimiento que llamaremos TestDePrimalidad al que le pasaremos el valor máximo como parámetro y que llenará la tabla, llamará al algoritmo CribaDeEsrastotenes y mostrará en pantalla los números primos obtenidos

DROP TABLE IF EXISTS `NumerosPrimos`;
CREATE TABLE `NumerosPrimos` (
    `Numero` INTEGER NOT NULL,
    `Marcado` BOOLEAN,
    CONSTRAINT `PK_NumerosPrimos` PRIMARY KEY (`Numero`)
) ENGINE=MEMORY;

-- -----------------------------------------------------------------
-- Base de datos de la Liga
-- -----------------------------------------------------------------

-- 25. Queremos usar dos funciones: GolesLocal y GolesVisitante que nos de los goles marcados por el equipo local y por el equipo visitante de un partido. Crea la función GolesLocal
-- Resultado bien formado:
-- 3-2; 11-2; 03-2; 3-02; 03-02
SELECT *
FROM Partidos
WHERE Temporada='2018-2019' AND
      EquipoLocal='Real Madrid CF';

-- 26. Crea las funciones EsDigito que devuelve TRUE si el carácter que se le pasa es un dígito CaracterANumero que convierte un dígito en un número y simplifica la función GolesLocal2 que es una copia de la función GolesLocal
DROP FUNCTION IF EXISTS EsDigito;
DELIMITER //
CREATE FUNCTION EsDigito (Caracter CHAR)
    RETURNS BOOLEAN
BEGIN 
    RETURN Caracter BETWEEN "0" AND "9";
END//
DELIMITER ;
SELECT EsDigito("9");


DROP FUNCTION IF EXISTS CaracterANumero;
DELIMITER //
CREATE FUNCTION CaracterANumero (Caracter CHAR)
    RETURNS TINYINT
BEGIN
    RETURN ASCII(Caracter) - ASCII('0');
END//
DELIMITER ;
SELECT CaracterANumero("5");

DROP FUNCTION IF EXISTS GolesLocal2;
DELIMITER //
CREATE FUNCTION GolesLocal2 (Resultado CHAR(15))
    RETURNS INT
BEGIN 
    DECLARE Goles INT;
    
    SET Goles = CaracterANumero(SUBSTRING(Resultado, 1, 1));
    IF EsDigito(SUBSTRING(Resultado, 2, 1)) THEN
        SET Goles = Goles * 10 + 
            CaracterANumero(SUBSTRING(Resultado, 2, 1));
    END IF;
    RETURN Goles;
END//
DELIMITER ;

DROP FUNCTION IF EXISTS GolesVisitante;
DELIMITER //
CREATE FUNCTION GolesVisitante (Resultado CHAR(15))
    RETURNS INT
BEGIN
    DECLARE Goles, Puntero INT;
    
    IF SUBSTRING(Resultado, 2, 1) = "-" 
        THEN SET Puntero = 3;
        ELSE SET Puntero = 4;
    END IF;
    SET Goles = ASCII(SUBSTRING(Resultado, Puntero, 1)) - ASCII("0");
    IF LENGTH(Resultado) > Puntero THEN
        SET Goles = Goles * 10 + ASCII(SUBSTRING(Resultado, Puntero + 1, 1))- ASCII("0");
    END IF;
    RETURN Goles;
END//
DELIMITER ;
SELECT GolesVisitante("99-2")


-- 27. Crea la función GolesVisitante

-- 28. Partidos en los que un equipo ha ganado al otro por siete o más goles

-- 29. Las 20 mayores goleadas de la historia de la liga

-- 30. Partidos en los que un equipo ha ganado al otro por más de cinco goles y ha jugado el Real Madrid

-- 31. Nombre de todos los equipos

-- 32. Mayor goleador  de las 10 ultimas temporadas de la liga como equipo local

-- 33. Mayor goleador de las 10 ultimas temporadas completas de la liga como equipo visitante

SELECT Equipo AS 'Equipos', SUM(Goles) AS 'Goles'
FROM 
  (SELECT EquipoLocalX AS Equipo, SUM(GolesLocal(ResultadoBis)) AS 'Goles'
   FROM   Partidos
   WHERE Temporada BETWEEN '2009' AND '2018'
   GROUP BY EquipoLocalX
   UNION ALL
   SELECT EquipoVisitanteX, SUM(GolesVisitante(ResultadoBis))
   FROM   Partidos
   WHERE Temporada BETWEEN '2009' AND '2018'
   GROUP BY EquipoVisitanteX) AS Equipos
GROUP BY `Equipos`
ORDER BY `Goles` DESC;

-- Número de alirones de cada equipo como equipo local
SELECT EquipoLocalX, COUNT(*)
FROM   Partidos
WHERE  Resultado LIKE '%(A.L.)%'
GROUP BY EquipoLocalX
ORDER BY 2 DESC;

-- Número de alirones de cada equipo como equipo visitante
SELECT EquipoVisitanteX, COUNT(*)
FROM   Partidos
WHERE  Resultado LIKE '%(A.V.)%'
GROUP BY EquipoVisitanteX
ORDER BY 2 DESC;

-- Todos los alirones en la liga
SELECT Equipo, COUNT(*) AS 'Número de alirones'
FROM (
    SELECT EquipoLocalX AS 'Equipo'
    FROM   Partidos
    WHERE  Resultado LIKE '%(A.L.)%'
    UNION ALL
    SELECT EquipoVisitanteX
    FROM   Partidos
    WHERE  Resultado LIKE '%(A.V.)%') AS Tabla
GROUP BY Equipo
ORDER BY `Número de alirones` DESC;

-- -----------------------------------------------------------------
-- Modificación de la base de datos de la liga:
-- -----------------------------------------------------------------

ALTER TABLE Partidos ADD COLUMN GolesLocal TINYINT NOT NULL DEFAULT 0;
ALTER TABLE Partidos ADD COLUMN GolesVisitante TINYINT NOT NULL DEFAULT 0;

UPDATE Partidos
SET GolesLocal = GolesLocal(ResultadoBis);

UPDATE Partidos
SET GolesVisitante = GolesVisitante(ResultadoBis);

ALTER TABLE Partidos ADD COLUMN Alirones CHAR NOT NULL DEFAULT '';

UPDATE Partidos
SET Alirones = 'L'
WHERE Resultado LIKE '%(A.L.)%';

UPDATE Partidos
SET Alirones = 'V'
WHERE Resultado LIKE '%(A.V.)%';

ALTER TABLE Partidos DROP COLUMN ResultadoBis;
ALTER TABLE Partidos DROP COLUMN Resultado;

CREATE TABLE Equipos AS
    (SELECT DISTINCT EquipoLocalX AS NombreEquipo
    FROM Partidos)
    UNION DISTINCT 
    (SELECT DISTINCT EquipoVisitanteX
    FROM Partidos)
    ORDER BY NombreEquipo;
    
ALTER TABLE Equipos ADD IdEquipo INT NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST;
ALTER TABLE Equipos ADD INDEX Equipos(NombreEquipo);

ALTER TABLE Partidos ADD COLUMN EL INT NOT NULL DEFAULT 0;
ALTER TABLE Partidos ADD COLUMN EV INT NOT NULL DEFAULT 0;

SELECT * 
FROM Partidos JOIN Equipos
ON Partidos.EquipoLocalX = Equipos.NombreEquipo;

UPDATE Partidos JOIN Equipos
ON Partidos.EquipoLocalX = Equipos.NombreEquipo
SET EL = Equipos.IdEquipo;

SELECT * 
FROM Partidos JOIN Equipos
ON Partidos.EquipoVisitanteX = Equipos.NombreEquipo;

UPDATE Partidos JOIN Equipos
ON Partidos.EquipoVisitanteX = Equipos.NombreEquipo
SET EV = Equipos.IdEquipo;

ALTER TABLE Partidos DROP COLUMN EquipoLocal;
ALTER TABLE Partidos DROP COLUMN EquipoLocalX;
ALTER TABLE Partidos DROP COLUMN EquipoLocalBis;
ALTER TABLE Partidos DROP COLUMN EquipoVisitante;
ALTER TABLE Partidos DROP COLUMN EquipoVisitanteX;
ALTER TABLE Partidos DROP COLUMN EquipoVisitanteBis;

ALTER TABLE Partidos CHANGE COLUMN EV EquipoVisitante INT NOT NULL DEFAULT 0;
ALTER TABLE Partidos CHANGE COLUMN EL EquipoLocal INT NOT NULL DEFAULT 0;

ALTER TABLE Partidos ADD CONSTRAINT
EquipoLocalFK FOREIGN KEY (EquipoLocal) REFERENCES Equipos(IdEquipo);

ALTER TABLE Partidos ADD CONSTRAINT
EquipoVisitanteFK FOREIGN KEY (EquipoVisitante) REFERENCES Equipos(IdEquipo);

SELECT * FROM Partidos;
SELECT * FROM Equipos;