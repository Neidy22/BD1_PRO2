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

DROP PROCEDURE IF EXISTS crearCurso;
DELIMITER $$
CREATE PROCEDURE crearCurso(
-- params
IN codigo INT,
IN nombre VARCHAR(50),
IN crd_nec INT,
IN crd_otg INT, 
IN id_carrera INT, 
IN obligatorio BOOLEAN
)
proc_curso: BEGIN
	DECLARE result BOOLEAN;
    -- validar codigo
    IF codigo IS NULL THEN
		CALL Mensaje("Error: El código del curso es de carácter obligatorio");
        LEAVE proc_curso;
	ELSE
		-- validar que el código no exista 
        SELECT EXISTS(SELECT codigo FROM curso WHERE curso.codigo = codigo) INTO result;
        IF result THEN
			CALL Mensaje("Error: Ya existe un curso para este código");
            LEAVE proc_curso;
		END IF;
		-- validar que el codigo sea numérico
        SET result = validarNumeros(codigo);
        IF NOT result THEN
			CALL Mensaje("Error: El código de curso debe ser numérico");
            LEAVE proc_curso;
		END IF;
    END IF;
    -- validar nombre
    IF nombre IS NULL THEN
		CALL Mensaje("Error: El nombre del curso es de carácter obligatorio");
        LEAVE proc_curso;
	END IF;

    -- validar creditos necesarios
	IF crd_nec IS NULL THEN
		CALL Mensaje("Error: La cantidad de créditos necesarios del curso es de carácter obligatorio");
        LEAVE proc_curso;
	ELSE
		-- validar que sea 0 o un entero positivo
        SET result = validarNumeros(crd_nec);
        IF NOT result OR crd_nec < 0 THEN
			CALL Mensaje("Error: La cantidad de créditos necesarios debe ser un número entero positivo");
            LEAVE proc_curso;
		END IF;
	END IF;
    
    -- validar creditos que otorga
	IF crd_otg IS NULL THEN
		CALL Mensaje("Error: La cantidad de créditos que otorga el curso es de carácter obligatorio");
        LEAVE proc_curso;
	ELSE
		-- validar que sea 0 o un entero positivo
        SET result = validarNumeros(crd_otg);
        IF NOT result OR crd_otg < 0 THEN
			CALL Mensaje("Error: La cantidad de créditos que otorga debe ser un número entero positivo");
            LEAVE proc_curso;
		END IF;
	END IF;
    
    -- validar opcionalidad
    IF obligatorio IS NULL THEN
		CALL Mensaje("Error: La opcionalidad del curso es de carácter obligatorio");
        LEAVE proc_curso;
	END IF;
		
    -- validar carrera
    IF id_carrera IS NULL THEN
		CALL Mensaje("Error: El id de carrera es de carácter obligatorio");
        LEAVE proc_curso;
	ELSE
		SELECT EXISTS(SELECT id FROM carrera WHERE carrera.id = id_carrera) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error: La carrera no existe");
            LEAVE proc_curso;
		END IF;
	END IF;
    INSERT INTO curso(codigo, nombre, crd_nec, crd_otg, obligatorio, id_carrera)
    VALUES (codigo, nombre, crd_nec, crd_otg, obligatorio, id_carrera);
    CALL Mensaje("Curso registrado correctamente");
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS habilitarCurso;
DELIMITER $$ 
CREATE PROCEDURE habilitarCurso(
-- params
IN id_curso INT,
IN ciclo VARCHAR(2),
IN id_docente INT,
IN cupo_max INT,
IN seccion CHAR
)
proc_enable: BEGIN
	DECLARE result BOOLEAN;
    DECLARE anio INT;
    SET anio = YEAR(curdate());
    
    -- validar que el curso exista
    IF id_curso IS NULL THEN
		CALL Mensaje("Error: El código de curso es obligatorio");
        LEAVE proc_enable;
	ELSE 
		SELECT EXISTS(SELECT codigo FROM  curso WHERE curso.codigo = id_curso) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error: El curso que desea habilitar no existe, verifica el código del curso");
            LEAVE proc_enable;
		END IF;
	END IF;
    
    -- validar ciclo
    IF ciclo IS NULL THEN
		CALL Mensaje("Error: El ciclo del curso es obligatorio");
        LEAVE proc_enable;
    ELSE
		SET result = validarCiclo(ciclo);
        IF NOT result THEN
			CALL Mensaje("Error: El ciclo no válido, verifica el formato: 1S, 2S, VJ, VD");
			LEAVE proc_enable;
		END IF;
    END IF;
    
    -- validar el docente
    IF id_docente IS NULL THEN
		CALL Mensaje("Error: El siif del docente del curso es obligatorio");
        LEAVE proc_enable;
    ELSE
		SELECT EXISTS (SELECT siif FROM docente WHERE docente.siif = id_docente) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error: Docente no encontrado, verificar SIIF");
			LEAVE proc_enable;
		END IF;
    END IF;
    
    -- validar cupo máximo entero positivo
    IF cupo_max IS NULL THEN
		CALL Mensaje("Error: El cupo máximo del curso es obligatorio");
        LEAVE proc_enable;
    ELSE
		SET result = validarNumeros(cupo_max);
        IF NOT result OR cupo_max < 0 THEN
			CALL Mensaje("Error: Cupo máximo no válido, debe ser un entero positivo");
			LEAVE proc_enable;
		END IF;
    END IF;
    
    -- validar sección sea A-Z y que no se repita
    IF seccion IS NULL THEN
		CALL Mensaje("Error: La sección del curso es obligatoria");
        LEAVE proc_enable;
    ELSE
		SET result = validarSeccion(seccion);
        IF NOT result THEN
			CALL Mensaje("Error: Sección no válida, verifica el formato A-Z");
			LEAVE proc_enable;
		END IF;
        
        SELECT EXISTS (SELECT id FROM curso_habilitado 
        WHERE curso_habilitado.id_curso = id_curso AND curso_habilitado.ciclo = ciclo AND curso_habilitado.seccion = seccion AND curso_habilitado.anio = anio) 
        INTO result;
        
        IF result THEN
			CALL Mensaje("Error: Está sección ya fue habilitada para este período, busca una nueva sección");
			LEAVE proc_enable;
		END IF;
    END IF;
    
    INSERT INTO curso_habilitado(ciclo, cupo_max, seccion, id_docente, id_curso, anio, cantidad_asignados)
    VALUES(ciclo, cupo_max, seccion, id_docente, id_curso, anio, 0);
    CALL Mensaje("Curso habilitado exitosamente");
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS agregarHorario;
DELIMITER $$
CREATE PROCEDURE agregarHorario(
IN id_curso INT,
IN dia INT,
IN horario VARCHAR(15)
)
proc_add_hor: BEGIN
	DECLARE result BOOLEAN;
    -- validar id curso
    IF id_curso IS NULL THEN
		CALL Mensaje("Error: El id de curso es obligatorio");
        LEAVE proc_add_hor;
    ELSE
		SELECT EXISTS (SELECT id FROM curso_habilitado WHERE curso_habilitado.id = id_curso) INTO result; 
        IF NOT result THEN
			CALL Mensaje("Error: Id de curso no existe");
			LEAVE proc_add_hor;
		END IF;
	END IF;
        
    -- validar día 
    IF dia IS NULL THEN
		CALL Mensaje("Error: El campo de día es obligatorio");
        LEAVE proc_add_hor;
    ELSE
		SET result = validarNumeros(dia);
        IF NOT result OR dia<1 OR dia>7 THEN
			CALL Mensaje("Error: El campo de día debe ser numérico entre 1-7");
			LEAVE proc_add_hor;
		END IF;
    END IF;
    -- validar hora
    IF horario IS NULL THEN
		CALL Mensaje("Error: El de horario es obligatorio");
        LEAVE proc_add_hor;
    ELSE
		SET result = validarHorario(horario);
        IF NOT result THEN
			CALL Mensaje("Error: El horario debe cumplir el formato HH:MM - HH:MM");
			LEAVE proc_add_hor;
        END IF;
    END IF;
    INSERT INTO horario(dia, rango, id_curso) 
    VALUES (dia, horario, id_curso);
    CALL Mensaje("Horario asignado correctamente");
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS asignarCurso;
DELIMITER $$
CREATE PROCEDURE asignarCurso(
IN cod_curso INT,
IN ciclo VARCHAR(2),
IN seccion CHAR,
IN carnet BIGINT
)
proc_asignacion: BEGIN
	DECLARE result BOOLEAN;
    DECLARE id_habilitado INT;
    DECLARE cup_max INT;
    DECLARE asignados INT;
    DECLARE crd_nece INT;
    DECLARE crd_dispo INT;
    DECLARE carrera_curs INT;
    DECLARE carrera_estu INT;
    DECLARE anio INT;
    SET anio = YEAR(curdate());
    -- validar valores nulos
    
    -- validar que el carnet del estudiante exista
    SELECT EXISTS (SELECT carnet FROM estudiante WHERE estudiante.carnet = carnet) INTO result;
    IF NOT result THEN
		CALL Mensaje("Error: El estudiante no se encuentra registrado, verifica el carnet");
        LEAVE proc_asignacion;
	END IF;
    
    -- obtener datos del curso habilitado
    SELECT id, cupo_max, cantidad_asignados INTO id_habilitado, cup_max, asignados FROM curso_habilitado 
    WHERE curso_habilitado.id_curso = cod_curso AND curso_habilitado.ciclo = ciclo AND curso_habilitado.seccion = seccion AND curso_habilitado.anio = anio;
    
    IF id_habilitado IS NULL THEN
		CALL Mensaje("Error: El curso no ha sido habilitado para este período");
        LEAVE proc_asignacion;
	END IF;
    
    -- validar si el curso ya se ingreso en asignacion
    SELECT EXISTS(SELECT id FROM asignacion WHERE asignacion.id = id_habilitado) INTO result;
    IF NOT result THEN
		INSERT INTO asignacion(id, id_curso, ciclo, seccion)
        VALUES(id_habilitado, cod_curso, ciclo, seccion);
	END IF;
    
    -- validar que el estudiante no se haya asignado al curso
    SELECT EXISTS (
		SELECT id_asign, id_curso FROM detalle_asignacion d, asignacion a
        WHERE  d.carnet = carnet AND a.ciclo = ciclo AND a.id_curso = cod_curso 
    ) INTO result;
    
    IF result THEN
		CALL Mensaje("El estudiante ya se encuentra asignado al curso");
        LEAVE proc_asignacion;
	END IF;
    
    -- validar que exista cupo en el curso
    IF cup_max <= asignados THEN
		CALL Mensaje("Error: El curso alcanzó su cupo limite");
        LEAVE proc_asignacion;
	END IF;
    
    -- validar que cuente con los creditos necesarios
    SELECT crd_nec, id_carrera INTO crd_nece, carrera_curs FROM curso WHERE curso.codigo = cod_curso;
    SELECT creditos, id_carrera INTO crd_dispo, carrera_estu FROM estudiante WHERE estudiante.carnet = carnet;
    
    IF crd_dispo < crd_nece THEN
		CALL Mensaje("Error: No se puede asignar por falta de creditos");
        LEAVE proc_asignacion;
	END IF;
    
    -- validar que el curso corresponda a la carrera o area comun
	IF carrera_curs != carrera_estu AND carrera_curs > 0 THEN
		CALL Mensaje("Error: No se puede asignar un curso de otra carrera a la que pertenece el estudiante");
        LEAVE proc_asignacion;
	END IF;
    
    INSERT INTO detalle_asignacion(carnet, id_asign)
    VALUES (carnet, id_habilitado);
    -- actualizando los valores de los asignados
    UPDATE curso_habilitado 
    SET cantidad_asignados = asignados + 1
    WHERE curso_habilitado.id = id_habilitado;
    CALL Mensaje("Estudiante asignado al curso correctamente");
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS desasignarCurso;
DELIMITER $$
CREATE PROCEDURE desasignarCurso(
IN cod_curso INT,
IN ciclo VARCHAR(2),
IN seccion CHAR,
IN carnet BIGINT
)
proc_desasig: BEGIN
	DECLARE result BOOLEAN;
    DECLARE id_habilitado INT;
    DECLARE asignados INT;
    -- validar que el estudiante exista
    IF carnet IS NULL THEN
		CALL Mensaje("Error: El carnet es un campo obligatorio");
        LEAVE proc_desasig;
    ELSE
		SELECT EXISTS(SELECT carnet FROM estudiante WHERE estudiante.carnet = carnet) INTO result;
        IF NOT result THEN
			CALL Mensaje("Error: El estudiante no existe, verifica el carnet");
            LEAVE proc_desasig;
        END IF;
    END IF;
    
    -- validar que el estudiante este asignado
    SELECT EXISTS(
    SELECT id_asign, id_curso FROM  detalle_asignacion d, asignacion a 
    WHERE a.id_curso = cod_curso AND a.ciclo = ciclo AND a.seccion = seccion AND d.carnet = carnet
    ) INTO result;
    
    IF NOT result THEN
		CALL Mensaje("Error: El estudiante no se encuentra asignado al curso");
        LEAVE proc_desasig;
    END IF;
    
    SELECT id, cantidad_asignados INTO id_habilitado, asignados FROM curso_habilitado a
    WHERE a.id_curso = cod_curso AND a.ciclo = ciclo AND a.seccion = seccion AND a.anio = anio;
    
    
    -- actualizar desasignados
    SELECT EXISTS(SELECT id FROM desasignacion WHERE desasignacion.id = id_habilitado) INTO result;
    IF NOT result THEN
		INSERT INTO desasignacion(id, id_curso, ciclo, seccion)
		VALUES(id_habilitado, cod_curso, ciclo, seccion);
	END IF;
    
    INSERT INTO detalle_asignacion(carnet, id_desasign)
    VALUES (carnet, id_habilitado);
    
    UPDATE curso_habilitado 
    SET cantidad_asignados = asignados - 1
    WHERE curso_habilitado.id = id_habilitado;
    CALL Mensaje("Estudiante desasignado del curso correctamente");
    
END $$
DELIMITER ;