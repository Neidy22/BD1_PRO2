use pro2;
CREATE TABLE IF NOT EXISTS  carrera(
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS estudiante(
	carnet BIGINT PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    dpi BIGINT NOT NULL,
    id_carrera INT NOT NULL, 
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creditos INT NOT NULL,
    FOREIGN KEY (id_carrera) REFERENCES carrera(id)
);

CREATE TABLE IF NOT EXISTS curso(
	codigo INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    crd_nec INT NOT NULL,
    crd_otg INT NOT NULL, 
    obligatorio BOOLEAN NOT NULL, 
    id_carrera INT NOT NULL,
    FOREIGN KEY (id_carrera) REFERENCES carrera(id)
);

CREATE TABLE IF NOT EXISTS docente(
	siif INT PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    dpi BIGINT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS curso_habilitado(
	id INT AUTO_INCREMENT PRIMARY KEY,
    ciclo VARCHAR(2) NOT NULL,
    cupo_max INT NOT NULL,
    seccion CHAR NOT NULL,
    id_docente INT NOT NULL,
    id_curso INT NOT NULL,
    anio INT NOT NULL, 
    cantidad_asignados INT NOT NULL,
    FOREIGN KEY (id_docente) REFERENCES docente(siif),
    FOREIGN KEY (id_curso) REFERENCES curso(codigo)
);

CREATE TABLE IF NOT EXISTS horario(
	dia INT NOT NULL,
    rango VARCHAR(12) NOT NULL,
    id_curso INT NOT NULL,
    PRIMARY KEY (dia, id_curso),
    FOREIGN KEY (id_curso) REFERENCES curso_habilitado(id)
);

CREATE TABLE IF NOT EXISTS asignacion(
	id INT PRIMARY KEY,
    id_curso INT NOT NULL,
    ciclo VARCHAR(2),
    seccion CHAR(1),
    FOREIGN KEY (id_curso) REFERENCES curso(codigo)
);
CREATE TABLE IF NOT EXISTS desasignacion(
	id INT PRIMARY KEY,
    id_curso INT NOT NULL,
    ciclo VARCHAR(2),
    seccion CHAR(1),
    FOREIGN KEY (id_curso) REFERENCES curso(codigo)
);

CREATE TABLE IF NOT EXISTS nota(
	id INT PRIMARY KEY,
    id_curso INT NOT NULL,
    ciclo VARCHAR(2),
    seccion CHAR(1),
    anio INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES curso(codigo)
);

CREATE TABLE IF NOT EXISTS detalle_asignacion(
	id INT PRIMARY KEY,
    carnet BIGINT NOT NULL, 
    id_asign INT NOT NULL,
    FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
    FOREIGN KEY (id_asign) REFERENCES asignacion(id)
);

CREATE TABLE IF NOT EXISTS detalle_desasignacion(
	id INT PRIMARY KEY,
    carnet BIGINT NOT NULL, 
    id_desasign INT NOT NULL,
    FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
    FOREIGN KEY (id_desasign) REFERENCES desasignacion(id)
);

CREATE TABLE IF NOT EXISTS detalle_nota(
	id INT PRIMARY KEY,
    nota INT NOT NULL, 
    carnet BIGINT NOT NULL,
    id_nota INT NOT NULL,
    FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
    FOREIGN KEY (id_nota) REFERENCES nota(id)
);

CREATE TABLE IF NOT EXISTS acta(
	id INT PRIMARY KEY,
    id_curso INT NOT NULL,
    ciclo VARCHAR(2) NOT NULL,
    seccion CHAR NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES curso(codigo)
);

CREATE TABLE IF NOT EXISTS historial(
	id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR(200) NOT NULL,
    tipo VARCHAR(20) NOT NULL
);
