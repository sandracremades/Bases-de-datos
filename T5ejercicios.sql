DROP TABLE IF EXISTS Vector;
CREATE TABLE Vector (
 Indice INTEGER NOT NULL, -- índice de un elemento del vector
 Elemento INT, -- Creamos un vector de enteros
PRIMARY KEY (Indice)
);
INSERT INTO Vector VALUES (-1, 5);
INSERT INTO Vector VALUES (0, NULL);
INSERT INTO Vector VALUES (1, 3);
INSERT INTO Vector VALUES (2, 8);
INSERT INTO Vector VALUES (3, 6);
INSERT INTO Vector VALUES (4, 8);


-- VECTORES
-- longitudv: devuelve la longitud de un vector

DROP FUNCTION IF EXISTS Longitudv;
DELIMITER //
CREATE FUNCTION Longitudv() RETURNS int
BEGIN
	RETURN(
	SELECT Elemento
    FROM Vector
    WHERE Indice = -1);
END //
DELIMITER ;

SELECT Longitudv();

-- numelemv: devuelve el número de elementos de un vector

DROP FUNCTION IF EXISTS numelemv;
DELIMITER //
CREATE FUNCTION numelemv() RETURNS int
BEGIN
	RETURN(
	SELECT COUNT(Elemento)
    FROM Vector
    WHERE Elemento IS NOT NULL AND Indice <> -1);
END //
DELIMITER ;

SELECT numelemv();

-- invertirv: invierte los elementos de un vectores (veremos el análisis e implementación de esta operación en clase)

DROP PROCEDURE IF EXISTS invertirv;
DELIMITER //
CREATE PROCEDURE invertirv()
BEGIN
    DECLARE CONTADOR INT;
    DECLARE CONTADOR2 INT DEFAULT 0;
    DECLARE Longitud INT DEFAULT longitudv();
    SET CONTADOR = Longitud;
    WHILE CONTADOR > 0 DO
        UPDATE Vector SET Indice = CONTADOR+100 WHERE Indice = Longitud - CONTADOR;
        SET CONTADOR = CONTADOR - 1;
    END WHILE;
    WHILE CONTADOR2 <= Longitud DO
        UPDATE Vector SET Indice = CONTADOR2-1 WHERE Indice-100 = CONTADOR2;
        SET CONTADOR2 = CONTADOR2 + 1;
    END WHILE;
END //
DELIMITER ;

CALL invertirv;

SELECT *
FROM Vector;

-- maxv: devuelve el elemento mayor de un vector

DROP FUNCTION IF EXISTS maxv;
DELIMITER //
CREATE FUNCTION maxv() RETURNS int
BEGIN
	RETURN(
	SELECT MAX(Elemento)
    FROM Vector
    WHERE Elemento IS NOT NULL AND Indice <> -1);
END //
DELIMITER ;

SELECT maxv();

-- minv: devuelve el elemento menor de un vector

DROP FUNCTION IF EXISTS minv;
DELIMITER //
CREATE FUNCTION minv() RETURNS int
BEGIN
	RETURN(
	SELECT MIN(Elemento)
    FROM Vector
    WHERE Elemento IS NOT NULL AND Indice <> -1);
END //
DELIMITER ;

SELECT minv();

-- sumv: devuelve la suma de todos los elementos de un vector

DROP FUNCTION IF EXISTS sumv;
DELIMITER //
CREATE FUNCTION sumv() RETURNS int
BEGIN
	RETURN(
	SELECT SUM(Elemento)
    FROM Vector
    WHERE Elemento IS NOT NULL AND Indice <> -1);
END //
DELIMITER ;

SELECT sumv();

-- mediav: devuelve la media de los elementos de un vector

DROP FUNCTION IF EXISTS mediav;
DELIMITER //
CREATE FUNCTION mediav() RETURNS int
BEGIN
	RETURN(
	SELECT AVG(Elemento)
    FROM Vector
    WHERE Elemento IS NOT NULL AND Indice <> -1);
END //
DELIMITER ;

SELECT mediav();

-- estaenv: nos indica si un elemento está en el vector

DROP FUNCTION IF EXISTS estaenv;
DELIMITER //
CREATE FUNCTION estaenv(Numero INT) RETURNS BOOL
BEGIN
	DECLARE Encontrados INT DEFAULT(
		SELECT COUNT(Elemento)
		FROM Vector
		WHERE Elemento = Numero);
	RETURN Encontrados <> 0;
END //
DELIMITER ;

SELECT estaenv(845);

-- cuentav: cuenta cuántas veces aparece un elemento en el vector

DROP FUNCTION IF EXISTS cuentav;
DELIMITER //
CREATE FUNCTION cuentav(Numero INT) RETURNS int
BEGIN
	DECLARE Encontrados INT DEFAULT(
		SELECT COUNT(Elemento)
		FROM Vector
		WHERE Elemento = Numero);
	RETURN Encontrados;
END //
DELIMITER ;

SELECT cuentav(8);

-- buscav: nos da el índice de la primera aparición de un elemento en un vector o NULL si el elemento no está en el vector

DROP FUNCTION IF EXISTS buscav;
DELIMITER //
CREATE FUNCTION buscav(Numero INT) RETURNS int
BEGIN
	DECLARE Posicion INT DEFAULT(
		SELECT Indice
		FROM Vector
		WHERE Elemento = Numero
        ORDER BY Indice 
        LIMIT 1);
	RETURN Posicion;
END //
DELIMITER ;

SELECT buscav(8);

-- buscaiv: nos da el índice de la última aparición de un elemento en el vector o NULL si el elemento no está en el vector (la i de buscaiv se refiere a búsqueda Inversa)

DROP FUNCTION IF EXISTS buscaiv;
DELIMITER //
CREATE FUNCTION buscaiv(Numero INT) RETURNS int
BEGIN
	DECLARE Posicion INT DEFAULT(
		SELECT Indice
		FROM Vector
		WHERE Elemento = Numero
        ORDER BY Indice DESC
        LIMIT 1);
	RETURN Posicion;
END //
DELIMITER ;

SELECT buscaiv(8);