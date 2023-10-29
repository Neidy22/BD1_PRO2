use pro2;

DROP PROCEDURE IF EXISTS consultarPensum;
DELIMITER $$
CREATE PROCEDURE consultarPensum(
IN id_pensum INT
)
proc_pensum: BEGIN
	DECLARE result BOOLEAN;
    IF id_pensum IS NULL THEN
		CALL Mensaje("Error: Debes introducir un código de carrera");
        LEAVE proc_pensum;
	ELSE 
		SELECT EXISTS(SELECT id FROM carrera WHERE carrera.id = id_pensum) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error: No existe ninguna carrera con el código que ingresaste");
            LEAVE proc_pensum;
		END IF;
	END IF;
	SELECT codigo, nombre, obligatorio, crd_nec FROM curso WHERE curso.id_carrera = id_pensum OR curso.id_carrera = 0;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS consultarEstudiante;
DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
IN carnt BIGINT
)
proc_estudiante_cons: BEGIN
	DECLARE result BOOLEAN;
    IF carnt IS NULL THEN
		CALL Mensaje("Error: Debes introducir el número de carnet del estudiante a consultar");
        LEAVE proc_estudiante_cons;
	ELSE 
		SELECT EXISTS(SELECT carnet FROM estudiante WHERE estudiante.carnet = carnt) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error: Estudiante no encontrado, verifica el número de carnet");
            LEAVE proc_estudiante_cons;
		END IF;
	END IF;
    SELECT carnet, CONCAT(nombres,' ',apellidos) as nombre_completo, fecha_nacimiento, correo, telefono, direccion, dpi, id_carrera, creditos 
    FROM estudiante WHERE estudiante.carnet = carnt;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS consultarDocente;
DELIMITER $$
CREATE PROCEDURE consultarDocente(
IN id BIGINT
)
proc_docente_cons: BEGIN
	DECLARE result BOOLEAN;
    IF id IS NULL THEN
		CALL Mensaje("Error: Debes introducir el número de registro SIIF del docente a consultar");
        LEAVE proc_docente_cons;
	ELSE 
		SELECT EXISTS(SELECT siif FROM docente WHERE docente.siif = id) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error: Docente no encontrado, verifica el número de registro SIIF");
            LEAVE proc_docente_cons;
		END IF;
	END IF;
    SELECT siif, CONCAT(nombres,' ',apellidos) as nombre_completo, fecha_nacimiento, correo, telefono, direccion, dpi
    FROM docente WHERE docente.siif = id;
END $$
DELIMITER ;