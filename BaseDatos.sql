CREATE DATABASE evaluacion_docentes;
USE evaluacion_docentes;
CREATE TABLE Rol (
    id_rol INT PRIMARY KEY ,
    nombre VARCHAR(50) ,
    descripcion TEXT
);
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY,
    id_rol INT,
    activo BOOLEAN,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('docente', 'coordinador', 'administrador') NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);
CREATE TABLE Coordinacion (
    id_coordinacion INT PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE Facultad (
    id_facultad INT PRIMARY KEY ,
    id_coordinacion INT,
    nombre VARCHAR(50),
    FOREIGN KEY (id_coordinacion) REFERENCES Coordinacion(id_coordinacion)
);

CREATE TABLE Docente (
    id_docente INT PRIMARY KEY,
    id_usuario INT,
    cod_docente INT,
    nombre varchar(50),
    correo varchar(100),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Programas (
    id_programa INT PRIMARY KEY,
    id_docente INT,
    nombre VARCHAR(255) ,
    id_facultad INT,
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente)
);

CREATE TABLE Estudiantes (
    id_estudiante INT PRIMARY KEY ,
    nombre VARCHAR(50),
    correo VARCHAR(50),
    semestre INT,
    id_programa INT,
    FOREIGN KEY (id_programa) REFERENCES Programas(id_programa)
);

CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY ,
    codigo VARCHAR(50) UNIQUE ,
    nombre VARCHAR(50) ,
    id_programa INT,
    id_docente INT,
    FOREIGN KEY (id_programa) REFERENCES Programas(id_programa),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente)
);

CREATE TABLE Periodos_Academicos (
    id_periodo INT PRIMARY KEY,
    nombre VARCHAR(50) ,
    fecha_inicio DATE ,
    fecha_fin DATE 
);

CREATE TABLE Evaluaciones (
    id_evaluacion INT PRIMARY KEY ,
    id_docente INT,
    id_curso INT,
    id_periodo INT,
    autoevaluacion DECIMAL(3,2),
    evaluacion_decano DECIMAL(3,2),
    evaluacion_estudiantes DECIMAL(3,2),
    promedio_total DECIMAL(3,2),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso),
    FOREIGN KEY (id_periodo) REFERENCES Periodos_Academicos(id_periodo)
);
CREATE TABLE Docentes_No_Evaluados (
    id_docente_No_Evaluado INT PRIMARY KEY,
    id_evaluacion INT,
    id_facultad INT,
    id_coordinacion INT,
    id_programa INT,
    id_curso INT,
    FOREIGN KEY (id_evaluacion) REFERENCES Evaluaciones(id_evaluacion),
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_coordinacion) REFERENCES Coordinacion(id_coordinacion),
    FOREIGN KEY (id_programa) REFERENCES Programas(id_programa),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Estudiantes_No_Evaluaron (
    id_estudiante INT PRIMARY KEY ,
    id_programa INT,
    id_facultad INT,
    id_curso INT,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante),
    FOREIGN KEY (id_programa) REFERENCES Programas(id_programa),
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Comentarios (
    id_comentario INT PRIMARY KEY,
    tipo VARCHAR(50),
    id_docente INT,
    id_programa INT,
    id_coordinacion INT,
    comentario1 TEXT,
    comentario2 TEXT,
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente),
    FOREIGN KEY (id_programa) REFERENCES Programas(id_programa),
    FOREIGN KEY (id_coordinacion) REFERENCES Coordinacion(id_coordinacion)
);

CREATE TABLE Promedio_Evaluacion_Docente_Por_Curso (
    id_promedio INT PRIMARY KEY ,
    id_curso INT,
    id_docente INT,
    promedio_ev_docente DECIMAL(3,2),
    promedio_notas_curso DECIMAL(3,2),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente)
);





CREATE TABLE Permisos (
    id_permiso INT PRIMARY KEY,
    id_usuario INT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    modulo_permiso VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Acta_Compromiso (
    id_acta INT PRIMARY KEY,
    id_docente INT,
    id_facultad INT,
    id_promedio INT,
    retroalimentacion TEXT,
    fecha_generacion DATE,
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente),
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_promedio) REFERENCES Promedio_Evaluacion_Docente_Por_Curso(id_promedio)
);

CREATE TABLE Plan_De_Mejora (
    id_plan_mejora INT PRIMARY KEY,
    id_facultad INT,
    id_curso INT,
    id_docente INT,
    id_promedio INT,
    progreso INT,
    estado ENUM('Activo','Cerrado','Pendiente'),
    retroalimentacion TEXT,
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente),
    FOREIGN KEY (id_promedio) REFERENCES Promedio_Evaluacion_Docente_Por_Curso(id_promedio)
);

CREATE TABLE Notas_Plan_Mejora (
    id_notas_plan_mejora INT PRIMARY KEY,
    id_plan_mejora INT,
    nota TEXT,
    fecha DATE,
    FOREIGN KEY (id_plan_mejora) REFERENCES Plan_De_Mejora(id_plan_mejora)
);

CREATE TABLE Alertas_Bajo_Desempeno (
    id_alerta INT PRIMARY KEY,
    id_facultad INT,
    id_promedio INT,
    id_docente INT,
    id_curso INT,
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_promedio) REFERENCES Promedio_Evaluacion_Docente_Por_Curso(id_promedio),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Proceso_Sancion (
    id_proceso INT PRIMARY KEY,
    id_docente INT,
    id_facultad INT,
    id_promedio INT,
    sancion ENUM('Leve','Grave','Retiro_definitivo'),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente),
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_promedio) REFERENCES Promedio_Evaluacion_Docente_Por_Curso(id_promedio)
);