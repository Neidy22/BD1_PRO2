use pro2;
DELIMITER $$
CREATE TRIGGER insert_estudiante AFTER INSERT ON estudiante
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla estudiante', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_curso AFTER INSERT ON curso
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla curso', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_carrera AFTER INSERT ON carrera
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla carrera', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_docente AFTER INSERT ON docente
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla docente', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_curso_habilitado AFTER INSERT ON curso_habilitado
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla curso habilitado', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_asignacion AFTER INSERT ON asignacion
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla asignación', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_detalle_asignacion AFTER INSERT ON detalle_asignacion
FOR EACH ROW
BEGIN
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla detalle_asignacion', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_desasignacion AFTER INSERT ON desasignacion
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla asignación', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_detalle_desasignacion AFTER INSERT ON detalle_desasignacion
FOR EACH ROW
BEGIN
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla detalle_asignacion', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_nota AFTER INSERT ON nota
FOR EACH ROW
BEGIN
	SELECT NOW() INTO @fecha;
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla nota', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_detalle_nota AFTER INSERT ON detalle_nota
FOR EACH ROW
BEGIN
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla detalle_nota', 'INSERT');
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_horario AFTER INSERT ON horario
FOR EACH ROW
BEGIN
    INSERT INTO historial(descripcion, tipo)
    VALUES('Acción en tabla horario', 'INSERT');
END $$
DELIMITER ;
