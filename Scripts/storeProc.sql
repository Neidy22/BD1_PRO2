use pro2;

DROP PROCEDURE IF EXISTS crearCarrera;
DELIMITER $$
CREATE PROCEDURE crearCarrera(
-- params
IN nombre varchar(50)
)
proc_carrera: BEGIN
	DECLARE result BOOLEAN;
    IF nombre IS NULL THEN
		CALL Mensaje("Error, debe ingresar nombre de carrera obligatoriamente");
        LEAVE proc_carrera;
	ELSE
		SET result = validarLetras(nombre);
        IF NOT result THEN
			CALL Mensaje("Error, el nombre de carrera únicamente puede contener letras");
			LEAVE proc_carrera;
		END IF;
	END IF;
    INSERT INTO carrera(nombre) 
    VALUES(nombre);
    CALL Mensaje("Carrera registrada con éxito");
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS registrarEstudiante;
delimiter $$
CREATE PROCEDURE registrarEstudiante(
-- parametros
IN carnet bigint,
IN nombres varchar(45),
IN apellidos varchar(45),
IN fechanac varchar(10),
IN email varchar(45),
IN tel int,
IN direccion varchar(45),
IN dpi bigint,
IN carrera int
)
proc_estudiante: BEGIN
-- instruciones
	DECLARE fech DATE;
    DECLARE fechan DATE;
    DECLARE result BOOLEAN;
    DECLARE id_c INT;
    SET  fechan = STR_TO_DATE(fechanac, '%d-%m-%Y');
    -- validar carnet
    IF carnet  IS NULL THEN 
		CALL Mensaje("Error, debe ingresar carnet obligatoriamente");
        LEAVE proc_estudiante;
	ELSE
		SET result = validarNumeros(carnet);
		IF NOT result THEN
			CALL Mensaje("Error, el carnet solo puede contener números");
			LEAVE proc_estudiante;
		END IF;
	END IF;
    
    -- validar nombres
	IF nombres IS NULL THEN 
		CALL Mensaje("Error, debe ingresar nombres obligatoriamente");
        LEAVE proc_estudiante; 
	ELSE 
		SET result = validarLetras(nombres);
        IF NOT result THEN
			CALL Mensaje("Error, los nombres solo puede contener letras");
			LEAVE proc_estudiante;
		END IF;
	END IF;
        
	-- validar apellidos
	IF apellidos IS NULL THEN 
		CALL Mensaje("Error, debe ingresar los apellidos obligatoriamente");
        LEAVE proc_estudiante; 
	ELSE 
		SET result = validarLetras(apellidos);
        IF NOT result THEN
			CALL Mensaje("Error, los apellidos solo puede contener letras");
			LEAVE proc_estudiante;
		END IF;
	END IF;
        
    -- validar fecha  nacimiento
	IF fechanac IS NULL THEN 
		CALL Mensaje("Error, debe ingresar fecha de nacimiento obligatoriamente");
        LEAVE proc_estudiante; 
	END IF;
    
	-- validar email
	IF email IS NULL THEN 
		CALL Mensaje("Error, debe ingresar correo obligatoriamente");
        LEAVE proc_estudiante; 
	ELSE
		SET result = validarEmail(email);
        IF NOT result THEN
			CALL Mensaje("Error, el formato del correo debe ser el siguiente usuario@organizacion.tipo");
			LEAVE proc_estudiante; 
		END IF;
	END IF;
    
    -- validar telefono
    IF tel IS NULL THEN
		CALL Mensaje("Error, debe ingresar el teléfono obligatoriamente");
        LEAVE proc_estudiante; 
	ELSE
		SET result = validarNumeros(tel);
        IF NOT result THEN
			CALL Mensaje("Error, télefono solo puede contener números, omitir el código de área");
			LEAVE proc_estudiante; 
		END IF;
	END IF;
			
	
    -- validar direccion
	IF direccion IS NULL THEN 
		CALL Mensaje("Error, debe ingresar direccion obligatoriamente");
        LEAVE proc_estudiante;
	END IF;
    
	-- validar dpi
	IF dpi IS NULL THEN 
		CALL Mensaje("Error, debe ingresar dpi obligatoriamente");
        LEAVE proc_estudiante; 
	ELSE 
		SET result = validarNumeros(dpi);
        IF NOT result THEN
			CALL Mensaje("Error, el dpi solo puede contener números");
			LEAVE proc_estudiante; 
		END IF;
	END IF;
    
	-- validar carrera
	IF carrera IS NULL THEN 
		CALL Mensaje("Error, debe ingresar carrera obligatoriamente");
        LEAVE proc_estudiante; 
	ELSE 
		SELECT EXISTS(SELECT id FROM carrera WHERE carrera.id = carrera) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error, la carrera no existe");
			LEAVE proc_estudiante; 
        END IF;
	END IF;
    SET fech = curdate();
    INSERT INTO estudiante(carnet, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, dpi, id_carrera, creditos)
    VALUES (carnet,nombres,apellidos,fechan,email,tel,direccion,dpi,carrera,0);
    CALL Mensaje("Estudiante Registrado correctamente");
END $$
delimiter ;


DROP PROCEDURE IF EXISTS Mensaje;
delimiter $$ 
CREATE PROCEDURE Mensaje(
IN msg varchar(200)
)
BEGIN 
	SELECT msg as Result;
END $$
delimiter ;

DROP PROCEDURE IF EXISTS dropData;
delimiter $$ 
CREATE PROCEDURE dropData(
)
BEGIN 
    DROP TABLE IF EXISTS detalle_asignacion;
    DROP TABLE IF EXISTS detalle_desasignacion;
    DROP TABLE IF EXISTS detalle_nota;
    DROP TABLE IF EXISTS asignacion;
    DROP TABLE IF EXISTS desasignacion;
    DROP TABLE IF EXISTS nota;
    DROP TABLE IF EXISTS acta;
    DROP TABLE IF EXISTS horario;
    DROP TABLE IF EXISTS curso_habilitado;
    DROP TABLE IF EXISTS estudiante;
    DROP TABLE IF EXISTS curso;
    DROP TABLE IF EXISTS historial;
    DROP TABLE IF EXISTS carrera;
    DROP TABLE IF EXISTS docente;
END $$
delimiter ;

DROP PROCEDURE IF EXISTS registrarDocente;
DELIMITER $$
CREATE PROCEDURE registrarDocente(
-- params
IN nombres VARCHAR(50),
IN apellidos VARCHAR(50),
IN fechanac VARCHAR(50),
IN email VARCHAR(100),
IN tel INT,
IN direccion VARCHAR(100),
IN dpi BIGINT,
IN siif INT
)
proc_docente: BEGIN
	DECLARE result BOOLEAN;
    DECLARE fechan DATE;
    -- DECLARE fech DATE;
    SET  fechan = STR_TO_DATE(fechanac, '%d-%m-%Y');
    
    -- validar siif
    IF siif IS NULL THEN
		CALL Mensaje("Error: El siif es un campo obligatorio");
        LEAVE proc_docente;
	ELSE
		SET result = validarNumeros(siif);
        IF NOT result THEN
			CALL Mensaje("Error: El siif debe ser un valor numérico!");
            LEAVE proc_docente;
		END IF;
        
        SELECT EXISTS(SELECT siif FROM docente WHERE docente.siif = siif) INTO result;
        IF result THEN
			CALL Mensaje("Error: Ya existe un registro para este docente");
            LEAVE proc_docente;
		END IF;
	END IF;
    
    -- validar nombres
	IF nombres IS NULL THEN 
		CALL Mensaje("Error, debe ingresar nombres obligatoriamente");
        LEAVE proc_docente; 
	END IF;
        
	-- validar apellidos
	IF apellidos IS NULL THEN 
		CALL Mensaje("Error, debe ingresar los apellidos obligatoriamente");
        LEAVE proc_docente; 
	END IF;
        
    -- validar fecha  nacimiento
	IF fechanac IS NULL THEN 
		CALL Mensaje("Error, debe ingresar fecha de nacimiento obligatoriamente");
        LEAVE proc_docente; 
	END IF;
    
	-- validar email
	IF email IS NULL THEN 
		CALL Mensaje("Error, debe ingresar correo obligatoriamente");
        LEAVE proc_docente; 
	ELSE
		SET result = validarEmail(email);
        IF NOT result THEN
			CALL Mensaje("Error, el formato del correo debe ser el siguiente usuario@organizacion.tipo");
			LEAVE proc_docente; 
		END IF;
	END IF;
    
    -- validar telefono
    IF tel IS NULL THEN
		CALL Mensaje("Error, debe ingresar el teléfono obligatoriamente");
        LEAVE proc_docente; 
	ELSE
		SET result = validarNumeros(tel);
        IF NOT result THEN
			CALL Mensaje("Error, télefono solo puede contener números, omitir el código de área");
			LEAVE proc_docente; 
		END IF;
	END IF;
    
    -- validar direccion
	IF direccion IS NULL THEN 
		CALL Mensaje("Error, debe ingresar direccion obligatoriamente");
        LEAVE proc_docente;
	END IF;
    
	-- validar dpi
	IF dpi IS NULL THEN 
		CALL Mensaje("Error, debe ingresar dpi obligatoriamente");
        LEAVE proc_docente; 
	ELSE 
		SET result = validarNumeros(dpi);
        IF NOT result THEN
			CALL Mensaje("Error, el dpi solo puede contener números");
			LEAVE proc_docente; 
		END IF;
	END IF;
    -- SET fech = curdate();
    INSERT INTO docente(siif, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, dpi)
    VALUES (siif,nombres,apellidos,fechan,email,tel,direccion,dpi);
    CALL Mensaje("Docente Registrado correctamente");    
END $$
DELIMITER ;
