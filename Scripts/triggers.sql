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