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