CREATE DATABASE IF NOT EXISTS sabores_del_mundo;
USE sabores_del_mundo;

-- Tabla de Roles
CREATE TABLE IF NOT EXISTS rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla de Permisos
CREATE TABLE IF NOT EXISTS permiso (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    nombre_permiso VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla de relación Rol-Permiso (N:M)
CREATE TABLE IF NOT EXISTS rol_permiso (
    id_rol INT NOT NULL,
    id_permiso INT NOT NULL,
    PRIMARY KEY (id_rol, id_permiso),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE CASCADE,
    FOREIGN KEY (id_permiso) REFERENCES permiso(id_permiso) ON DELETE CASCADE
);

-- Tabla de Usuarios
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    foto_perfil VARCHAR(255),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    biografia TEXT,
    id_rol INT NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

-- Tabla de Países/Orígenes
CREATE TABLE IF NOT EXISTS pais (
    id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    continente VARCHAR(50) NOT NULL
);

-- Tabla de Categorías
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla de Etiquetas
CREATE TABLE IF NOT EXISTS etiqueta (
    id_etiqueta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla de Unidades de Medida
CREATE TABLE IF NOT EXISTS unidad_medida (
    id_unidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    abreviatura VARCHAR(10) NOT NULL,
    descripcion TEXT
);

-- Tabla de Ingredientes
CREATE TABLE IF NOT EXISTS ingrediente (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla de Recetas
CREATE TABLE IF NOT EXISTS receta (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    tiempo_preparacion INT NOT NULL,
    dificultad ENUM('Fácil', 'Media', 'Difícil') NOT NULL,
    porciones INT NOT NULL,
    imagen_principal VARCHAR(255) NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

-- Tabla de relación Receta-Categoría (N:M)
CREATE TABLE IF NOT EXISTS receta_categoria (
    id_receta INT NOT NULL,
    id_categoria INT NOT NULL,
    PRIMARY KEY (id_receta, id_categoria),
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE CASCADE
);

-- Tabla de relación Receta-Etiqueta (N:M)
CREATE TABLE IF NOT EXISTS receta_etiqueta (
    id_receta INT NOT NULL,
    id_etiqueta INT NOT NULL,
    PRIMARY KEY (id_receta, id_etiqueta),
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_etiqueta) REFERENCES etiqueta(id_etiqueta) ON DELETE CASCADE
);

-- Tabla de relación Receta-Ingrediente (N:M) con cantidad y unidad de medida
CREATE TABLE IF NOT EXISTS receta_ingrediente (
    id_receta INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    id_unidad INT NOT NULL,
    PRIMARY KEY (id_receta, id_ingrediente),
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES ingrediente(id_ingrediente) ON DELETE CASCADE,
    FOREIGN KEY (id_unidad) REFERENCES unidad_medida(id_unidad)
);

-- Tabla de Pasos de Preparación
CREATE TABLE IF NOT EXISTS paso_preparacion (
    id_paso INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT NOT NULL,
    numero_paso INT NOT NULL,
    descripcion TEXT NOT NULL,
    imagen VARCHAR(255),
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    UNIQUE KEY (id_receta, numero_paso)
);

-- Tabla de Imágenes de Receta
CREATE TABLE IF NOT EXISTS imagen_receta (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    descripcion TEXT,
    es_principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE
);

-- Tabla de Comentarios
CREATE TABLE IF NOT EXISTS comentario (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT NOT NULL,
    id_usuario INT NOT NULL,
    texto TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_comentario_padre INT,
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_comentario_padre) REFERENCES comentario(id_comentario) ON DELETE SET NULL
);

-- Tabla de Valoraciones
CREATE TABLE IF NOT EXISTS valoracion (
    id_valoracion INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT NOT NULL,
    id_usuario INT NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    UNIQUE KEY (id_receta, id_usuario)
);

-- Tabla de Favoritos/Guardados
CREATE TABLE IF NOT EXISTS favorito (
    id_usuario INT NOT NULL,
    id_receta INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_receta),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_receta) REFERENCES receta(id_receta) ON DELETE CASCADE
);


INSERT INTO rol (nombre_rol, descripcion) VALUES
('Administrador', 'Control total del sistema'),
('Editor', 'Puede editar y aprobar contenido'),
('Moderador', 'Puede moderar comentarios y valoraciones'),
('Usuario Premium', 'Usuario con características adicionales'),
('Usuario Estándar', 'Usuario con funcionalidades básicas'),
('Chef Verificado', 'Chef profesional verificado'),
('Nutricionista', 'Especialista en nutrición'),
('Colaborador', 'Contribuye con contenido especial'),
('Invitado', 'Acceso limitado solo lectura'),
('Bloqueado', 'Usuario con restricciones por incumplimiento');

INSERT INTO permiso (nombre_permiso, descripcion) VALUES
('crear_receta', 'Permiso para crear nuevas recetas'),
('editar_receta', 'Permiso para editar recetas'),
('eliminar_receta', 'Permiso para eliminar recetas'),
('comentar', 'Permiso para comentar recetas'),
('valorar', 'Permiso para valorar recetas'),
('moderar_comentarios', 'Permiso para moderar comentarios'),
('gestionar_usuarios', 'Permiso para gestionar usuarios'),
('gestionar_categorias', 'Permiso para gestionar categorías'),
('ver_estadisticas', 'Permiso para ver estadísticas'),
('destacar_receta', 'Permiso para destacar recetas en portada');

INSERT INTO rol_permiso (id_rol, id_permiso) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), -- Administrador con todos los permisos
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 8), (2, 10), -- Editor
(3, 4), (3, 5), (3, 6), -- Moderador
(4, 1), (4, 2), (4, 4), (4, 5), -- Usuario Premium
(5, 1), (5, 4), (5, 5), -- Usuario Estándar
(6, 1), (6, 2), (6, 4), (6, 5), (6, 10), -- Chef Verificado
(7, 1), (7, 2), (7, 4), (7, 5), -- Nutricionista
(8, 1), (8, 2), (8, 4), (8, 5), -- Colaborador
(9, 4), (9, 5), -- Invitado
(10, 0); -- Bloqueado (sin permisos)

INSERT INTO usuario (nombre, apellidos, email, contraseña, foto_perfil, biografia, id_rol) VALUES
('María', 'García López', 'maria.garcia@email.com', 'password123', 'maria_perfil.jpg', 'Chef profesional con 10 años de experiencia en cocina mediterránea', 6),
('Juan', 'Martínez Ruiz', 'juan.martinez@email.com', 'password123', 'juan_perfil.jpg', 'Amante de la cocina casera y tradicional', 5),
('Ana', 'Fernández Soto', 'ana.fernandez@email.com', 'password123', 'ana_perfil.jpg', 'Nutricionista especializada en dietas saludables', 7),
('Carlos', 'López Gómez', 'carlos.lopez@email.com', 'password123', 'carlos_perfil.jpg', 'Apasionado de la cocina asiática', 5),
('Laura', 'Sánchez Vega', 'laura.sanchez@email.com', 'password123', 'laura_perfil.jpg', 'Repostera profesional', 6),
('Pedro', 'González Díaz', 'pedro.gonzalez@email.com', 'password123', 'pedro_perfil.jpg', 'Administrador del sitio', 1),
('Sofía', 'Rodríguez Martín', 'sofia.rodriguez@email.com', 'password123', 'sofia_perfil.jpg', 'Editora de contenido culinario', 2),
('Miguel', 'Pérez Castro', 'miguel.perez@email.com', 'password123', 'miguel_perfil.jpg', 'Moderador de la comunidad', 3),
('Elena', 'Díaz Vargas', 'elena.diaz@email.com', 'password123', 'elena_perfil.jpg', 'Chef especializada en cocina vegana', 6),
('Javier', 'Moreno Ramos', 'javier.moreno@email.com', 'password123', 'javier_perfil.jpg', 'Aficionado a la cocina internacional', 4);

INSERT INTO pais (nombre, continente) VALUES
('España', 'Europa'),
('Italia', 'Europa'),
('Francia', 'Europa'),
('México', 'América'),
('Japón', 'Asia'),
('China', 'Asia'),
('India', 'Asia'),
('Marruecos', 'África'),
('Estados Unidos', 'América'),
('Tailandia', 'Asia'),
('Perú', 'América'),
('Argentina', 'América');

INSERT INTO categoria (nombre, descripcion) VALUES
('Entrante', 'Platos para comenzar una comida'),
('Plato principal', 'Platos principales para una comida completa'),
('Postre', 'Platos dulces para finalizar una comida'),
('Bebida', 'Bebidas y cócteles'),
('Aperitivo', 'Pequeños bocados para picar'),
('Desayuno', 'Platos para el desayuno'),
('Saludable', 'Recetas bajas en calorías y nutritivas'),
('Vegetariano', 'Platos sin carne'),
('Vegano', 'Platos sin ingredientes de origen animal'),
('Sin gluten', 'Recetas aptas para celíacos');

INSERT INTO etiqueta (nombre, descripcion) VALUES
('Rápido', 'Recetas que se preparan en menos de 30 minutos'),
('Económico', 'Recetas con ingredientes asequibles'),
('Tradicional', 'Recetas de cocina tradicional'),
('Gourmet', 'Recetas elaboradas de alta cocina'),
('Picante', 'Recetas con un toque picante'),
('Festivo', 'Recetas para ocasiones especiales'),
('Para niños', 'Recetas que gustan a los niños'),
('Bajo en calorías', 'Recetas con pocas calorías'),
('Sin lactosa', 'Recetas sin lácteos'),
('Proteico', 'Recetas ricas en proteínas');

INSERT INTO unidad_medida (nombre, abreviatura, descripcion) VALUES
('Gramo', 'g', 'Unidad de masa'),
('Kilogramo', 'kg', 'Unidad de masa equivalente a 1000 gramos'),
('Mililitro', 'ml', 'Unidad de volumen'),
('Litro', 'l', 'Unidad de volumen equivalente a 1000 mililitros'),
('Cucharada', 'cda', 'Equivalente a aproximadamente 15 ml'),
('Cucharadita', 'cdta', 'Equivalente a aproximadamente 5 ml'),
('Taza', 'taza', 'Equivalente a aproximadamente 240 ml'),
('Unidad', 'ud', 'Cantidad unitaria de un ingrediente'),
('Pizca', 'pizca', 'Cantidad muy pequeña tomada con los dedos'),
('Al gusto', 'al gusto', 'Cantidad según preferencia personal');

INSERT INTO ingrediente (nombre, descripcion) VALUES
('Arroz bomba', 'Variedad de arroz ideal para paella'),
('Tomate', 'Fruto rojo de la tomatera'),
('Cebolla', 'Bulbo comestible de la familia de las liliáceas'),
('Ajo', 'Bulbo de la planta del mismo nombre'),
('Aceite de oliva', 'Aceite extraído de la aceituna'),
('Pollo', 'Carne de ave de corral'),
('Azafrán', 'Especia derivada de la flor del mismo nombre'),
('Pimentón', 'Condimento en polvo obtenido del pimiento rojo seco'),
('Harina de trigo', 'Polvo fino obtenido de la molienda del trigo'),
('Huevo', 'Alimento producido por aves'),
('Leche', 'Líquido blanco producido por las glándulas mamarias de las hembras de los mamíferos'),
('Sal', 'Condimento mineral'),
('Pimienta', 'Especia obtenida del fruto del pimentero'),
('Limón', 'Fruto cítrico'),
('Zanahoria', 'Raíz comestible de color naranja');

INSERT INTO receta (titulo, descripcion, tiempo_preparacion, dificultad, porciones, imagen_principal, id_usuario, id_pais) VALUES
('Paella Valenciana', 'Auténtica paella valenciana con arroz, azafrán, pollo, conejo y verduras de temporada.', 90, 'Media', 4, 'paella_valenciana.jpg', 1, 1),
('Pizza Napolitana', 'Pizza tradicional napolitana con masa fermentada, tomate San Marzano y mozzarella de búfala.', 60, 'Media', 2, 'pizza_napolitana.jpg', 2, 2),
('Sushi Variado', 'Selección de sushi tradicional japonés con diferentes pescados y mariscos.', 120, 'Difícil', 2, 'sushi_variado.jpg', 4, 5),
('Tacos al Pastor', 'Tacos mexicanos con carne de cerdo marinada en achiote y piña.', 45, 'Media', 4, 'tacos_pastor.jpg', 3, 4),
('Tiramisú', 'Postre italiano a base de café, queso mascarpone y bizcochos.', 30, 'Fácil', 6, 'tiramisu.jpg', 5, 2),
('Ratatouille', 'Guiso provenzal de verduras con berenjena, calabacín, pimiento y tomate.', 60, 'Media', 4, 'ratatouille.jpg', 9, 3),
('Hummus', 'Paté de garbanzos con tahini, aceite de oliva, limón y especias.', 15, 'Fácil', 4, 'hummus.jpg', 10, 8),
('Hamburguesa Casera', 'Hamburguesa gourmet con carne 100% vacuno, queso cheddar y salsa especial.', 30, 'Fácil', 2, 'hamburguesa.jpg', 8, 9),
('Pad Thai', 'Fideos de arroz salteados con verduras, huevo, cacahuetes y salsa de tamarindo.', 25, 'Media', 2, 'pad_thai.jpg', 7, 10),
('Ceviche Peruano', 'Pescado blanco marinado en limón con cebolla morada, cilantro y ají.', 20, 'Fácil', 4, 'ceviche.jpg', 6, 11);

INSERT INTO receta_categoria (id_receta, id_categoria) VALUES
(1, 2), -- Paella: Plato principal
(2, 2), -- Pizza: Plato principal
(3, 2), -- Sushi: Plato principal
(4, 2), -- Tacos: Plato principal
(5, 3), -- Tiramisú: Postre
(6, 2), -- Ratatouille: Plato principal
(6, 8), -- Ratatouille: Vegetariano
(7, 1), -- Hummus: Entrante
(7, 9), -- Hummus: Vegano
(8, 2), -- Hamburguesa: Plato principal
(9, 2), -- Pad Thai: Plato principal
(10, 1); -- Ceviche: Entrante


INSERT INTO receta_etiqueta (id_receta, id_etiqueta) VALUES
(1, 3), -- Paella: Tradicional
(2, 3), -- Pizza: Tradicional
(3, 4), -- Sushi: Gourmet
(4, 5), -- Tacos: Picante
(5, 6), -- Tiramisú: Festivo
(6, 8), -- Ratatouille: Bajo en calorías
(7, 2), -- Hummus: Económico
(7, 1), -- Hummus: Rápido
(8, 7), -- Hamburguesa: Para niños
(9, 5), -- Pad Thai: Picante
(10, 1); -- Ceviche: Rápido

INSERT INTO receta_ingrediente (id_receta, id_ingrediente, cantidad, id_unidad) VALUES
(1, 1, 400, 1), -- Paella: 400g de arroz bomba
(1, 6, 300, 1), -- Paella: 300g de pollo
(1, 7, 1, 9), -- Paella: 1 pizca de azafrán
(1, 5, 50, 3), -- Paella: 50ml de aceite de oliva
(2, 9, 500, 1), -- Pizza: 500g de harina
(2, 2, 300, 1), -- Pizza: 300g de tomate
(2, 4, 2, 8), -- Pizza: 2 dientes de ajo
(2, 5, 30, 3), -- Pizza: 30ml de aceite de oliva
(3, 1, 300, 1), -- Sushi: 300g de arroz
(3, 12, 5, 1), -- Sushi: 5g de sal
(4, 6, 400, 1), -- Tacos: 400g de carne
(4, 3, 1, 8), -- Tacos: 1 cebolla
(5, 10, 4, 8), -- Tiramisú: 4 huevos
(5, 11, 100, 3), -- Tiramisú: 100ml de leche
(6, 2, 3, 8), -- Ratatouille: 3 tomates
(6, 15, 2, 8), -- Ratatouille: 2 zanahorias
(7, 5, 30, 3), -- Hummus: 30ml de aceite de oliva
(7, 14, 1, 8), -- Hummus: 1 limón
(8, 6, 200, 1), -- Hamburguesa: 200g de carne
(8, 3, 0.5, 8), -- Hamburguesa: 1/2 cebolla
(9, 3, 1, 8), -- Pad Thai: 1 cebolla
(9, 10, 2, 8), -- Pad Thai: 2 huevos
(10, 14, 3, 8), -- Ceviche: 3 limones
(10, 12, 5, 1); -- Ceviche: 5g de sal

INSERT INTO paso_preparacion (id_receta, numero_paso, descripcion, imagen) VALUES
(1, 1, 'Calentar el aceite en una paellera y dorar el pollo troceado.', 'paso1_paella.jpg'),
(1, 2, 'Añadir el tomate y la cebolla picados y sofreír.', 'paso2_paella.jpg'),
(1, 3, 'Incorporar el arroz y remover para que se impregne bien.', 'paso3_paella.jpg'),
(1, 4, 'Añadir el caldo caliente, el azafrán y el pimentón. Cocer a fuego medio-alto.', 'paso4_paella.jpg'),
(1, 5, 'Bajar el fuego y cocer durante 15-18 minutos sin remover.', 'paso5_paella.jpg'),
(2, 1, 'Preparar la masa mezclando la harina, agua, sal y levadura. Amasar bien.', 'paso1_pizza.jpg'),
(2, 2, 'Dejar reposar la masa durante al menos 2 horas.', 'paso2_pizza.jpg'),
(2, 3, 'Estirar la masa formando un círculo fino.', 'paso3_pizza.jpg'),
(2, 4, 'Cubrir con salsa de tomate y los ingredientes elegidos.', 'paso4_pizza.jpg'),
(2, 5, 'Hornear a 250°C durante 10-12 minutos.', 'paso5_pizza.jpg');

INSERT INTO imagen_receta (id_receta, url_imagen, descripcion, es_principal) VALUES
(1, 'paella_valenciana.jpg', 'Paella valenciana terminada', 1),
(1, 'paella_ingredientes.jpg', 'Ingredientes para la paella', 0),
(1, 'paella_proceso.jpg', 'Proceso de cocción de la paella', 0),
(2, 'pizza_napolitana.jpg', 'Pizza napolitana recién horneada', 1),
(2, 'pizza_masa.jpg', 'Preparación de la masa de pizza', 0),
(3, 'sushi_variado.jpg', 'Plato de sushi variado', 1),
(3, 'sushi_preparacion.jpg', 'Preparación del sushi', 0),
(4, 'tacos_pastor.jpg', 'Tacos al pastor servidos', 1),
(5, 'tiramisu.jpg', 'Tiramisú en copa', 1),
(6, 'ratatouille.jpg', 'Ratatouille recién hecho', 1);

INSERT INTO comentario (id_receta, id_usuario, texto, fecha) VALUES
(1, 2, 'Receta muy sabrosa, la volveré a hacer', '2025-03-15 14:30:00'),
(1, 3, 'Muy buena explicación, pero yo añadiría un poco más de azafrán.', '2025-03-16 10:15:00'),
(1, 4, 'La mejor paella que he probado, gracias por compartir.', '2025-03-17 18:45:00'),
(2, 1, 'La masa quedó perfecta siguiendo estos pasos.', '2025-03-10 20:30:00'),
(2, 5, 'Yo la hice con masa integral y también quedó muy bien', '2025-03-11 12:20:00'),
(3, 6, 'Muy completa la explicación', '2025-03-05 16:40:00'),
(4, 7, 'Los tacos quedaron picantes y deliciosos.', '2025-03-20 19:10:00'),
(5, 8, 'El tiramisú es mi postre favorito y esta receta lo ha clavado'2025-03-25 15:30:00'),
(6, 9, 'Excelente opción vegetariana, muy lograda'2025-03-28 13:45:00'),
(7, 10, 'El hummus me quedó muy cremoso', '2025-03-30 11:20:00');

INSERT INTO valoracion (id_receta, id_usuario, puntuacion, fecha) VALUES
(1, 2, 5, '2025-03-15 14:35:00'),
(1, 3, 4, '2025-03-16 10:20:00'),
(1, 4, 5, '2025-03-17 18:50:00'),
(2, 1, 5, '2025-03-10 20:35:00'),
(2, 5, 4, '2025-03-11 12:25:00'),
(3, 6, 4, '2025-03-05 16:45:00'),
(4, 7, 5, '2025-03-20 19:15:00'),
(5, 8, 5, '2025-03-25 15:35:00'),
(6, 9, 4, '2025-03-28 13:50:00'),
(7, 10, 5, '2025-03-30 11:25:00');

-- Datos en la tabla favorito
INSERT INTO favorito (id_usuario, id_receta, fecha) VALUES
(1, 2, '2025-03-12 09:15:00'),
(1, 5, '2025-03-26 14:20:00'),
(2, 1, '2025-03-15 14:40:00'),
(3, 1, '2025-03-16 10:25:00'),
(4, 3, '2025-03-06 11:30:00'),
(5, 2, '2025-03-11 12:30:00'),
(6, 4, '2025-03-21 08:45:00'),
(7, 6, '2025-03-29 16:15:00'),
(8, 5, '2025-03-25 15:40:00'),
(9, 7, '2025-03-30 18:10:00');




-- 1. Obtener todas las recetas con sus categorías
SELECT r.id_receta, r.titulo, r.dificultad, r.tiempo_preparacion, 
       GROUP_CONCAT(DISTINCT c.nombre SEPARATOR ', ') AS categorias
FROM receta r
JOIN receta_categoria rc ON r.id_receta = rc.id_receta
JOIN categoria c ON rc.id_categoria = c.id_categoria
GROUP BY r.id_receta, r.titulo, r.dificultad, r.tiempo_preparacion
ORDER BY r.titulo;

-- 2. Recetas por país de origen
SELECT p.nombre AS pais, COUNT(r.id_receta) AS total_recetas
FROM receta r
JOIN pais p ON r.id_pais = p.id_pais
GROUP BY p.nombre
ORDER BY total_recetas DESC;

-- 3. Obtener los ingredientes de una receta específica
SELECT r.titulo, i.nombre AS ingrediente, ri.cantidad, um.nombre AS unidad_medida
FROM receta r
JOIN receta_ingrediente ri ON r.id_receta = ri.id_receta
JOIN ingrediente i ON ri.id_ingrediente = i.id_ingrediente
JOIN unidad_medida um ON ri.id_unidad = um.id_unidad
WHERE r.id_receta = 1 -- Paella Valenciana
ORDER BY i.nombre;

-- 4. pasos de preparación de una receta
SELECT r.titulo, pp.numero_paso, pp.descripcion
FROM receta r
JOIN paso_preparacion pp ON r.id_receta = pp.id_receta
WHERE r.id_receta = 1 -- Paella Valenciana
ORDER BY pp.numero_paso;

-- 5. recetas mejor valoradas
SELECT r.titulo, AVG(v.puntuacion) AS valoracion_media, COUNT(v.id_valoracion) AS total_valoraciones
FROM receta r
JOIN valoracion v ON r.id_receta = v.id_receta
GROUP BY r.titulo
HAVING COUNT(v.id_valoracion) >= 2
ORDER BY valoracion_media DESC, total_valoraciones DESC;

-- 6. Comentarios de una receta
SELECT r.titulo, u.nombre, u.apellidos, c.texto, c.fecha
FROM comentario c
JOIN receta r ON c.id_receta = r.id_receta
JOIN usuario u ON c.id_usuario = u.id_usuario
WHERE r.id_receta = 1 -- Paella Valenciana
ORDER BY c.fecha DESC;

-- 7. Recetas favoritas de un usuario
SELECT u.nombre, u.apellidos, r.titulo, f.fecha
FROM favorito f
JOIN usuario u ON f.id_usuario = u.id_usuario
JOIN receta r ON f.id_receta = r.id_receta
WHERE u.id_usuario = 1 -- María García
ORDER BY f.fecha DESC;

-- 8. Recetas por dificultad
SELECT dificultad, COUNT(*) AS total_recetas
FROM receta
GROUP BY dificultad
ORDER BY FIELD(dificultad, 'Fácil', 'Media', 'Difícil');

-- 9. Recetas por tiempo de preparación (rápidas, menos de 30 min)
SELECT titulo, tiempo_preparacion, dificultad
FROM receta
WHERE tiempo_preparacion <= 30
ORDER BY tiempo_preparacion;

-- 10. Usuarios con sus roles y permisos
SELECT u.nombre, u.apellidos, r.nombre_rol, GROUP_CONCAT(DISTINCT p.nombre_permiso SEPARATOR ', ') AS permisos
FROM usuario u
JOIN rol r ON u.id_rol = r.id_rol
JOIN rol_permiso rp ON r.id_rol = rp.id_rol
JOIN permiso p ON rp.id_permiso = p.id_permiso
GROUP BY u.nombre, u.apellidos, r.nombre_rol
ORDER BY r.nombre_rol, u.nombre;

-- 11. Recetas por nombre o ingredientes
SELECT DISTINCT r.titulo, r.dificultad, r.tiempo_preparacion
FROM receta r
LEFT JOIN receta_ingrediente ri ON r.id_receta = ri.id_receta
LEFT JOIN ingrediente i ON ri.id_ingrediente = i.id_ingrediente
WHERE r.titulo LIKE '%paella%' OR i.nombre LIKE '%arroz%'
ORDER BY r.titulo;

-- 12. Estadísticas de recetas por categoría
SELECT c.nombre AS categoria, COUNT(rc.id_receta) AS total_recetas,
       AVG(r.tiempo_preparacion) AS tiempo_promedio,
       COUNT(CASE WHEN r.dificultad = 'Fácil' THEN 1 END) AS recetas_faciles,
       COUNT(CASE WHEN r.dificultad = 'Media' THEN 1 END) AS recetas_medias,
       COUNT(CASE WHEN r.dificultad = 'Difícil' THEN 1 END) AS recetas_dificiles
FROM categoria c
LEFT JOIN receta_categoria rc ON c.id_categoria = rc.id_categoria
LEFT JOIN receta r ON rc.id_receta = r.id_receta
GROUP BY c.nombre
ORDER BY total_recetas DESC;

-- 13. Recetas más comentadas
SELECT r.titulo, COUNT(c.id_comentario) AS total_comentarios
FROM receta r
LEFT JOIN comentario c ON r.id_receta = c.id_receta
GROUP BY r.titulo
ORDER BY total_comentarios DESC
LIMIT 5;

-- 14. Usuarios más activos (por recetas, comentarios y valoraciones)
SELECT u.nombre, u.apellidos,
       COUNT(DISTINCT r.id_receta) AS recetas_creadas,
       COUNT(DISTINCT c.id_comentario) AS comentarios_realizados,
       COUNT(DISTINCT v.id_valoracion) AS valoraciones_realizadas,
       COUNT(DISTINCT f.id_receta) AS recetas_favoritas
FROM usuario u
LEFT JOIN receta r ON u.id_usuario = r.id_usuario
LEFT JOIN comentario c ON u.id_usuario = c.id_usuario
LEFT JOIN valoracion v ON u.id_usuario = v.id_usuario
LEFT JOIN favorito f ON u.id_usuario = f.id_usuario
GROUP BY u.nombre, u.apellidos
ORDER BY (recetas_creadas + comentarios_realizados + valoraciones_realizadas) DESC;

-- 15. Recetas vegetarianas o veganas
SELECT r.titulo, r.dificultad, r.tiempo_preparacion, 
       GROUP_CONCAT(DISTINCT c.nombre SEPARATOR ', ') AS categorias
FROM receta r
JOIN receta_categoria rc ON r.id_receta = rc.id_receta
JOIN categoria c ON rc.id_categoria = c.id_categoria
WHERE c.nombre IN ('Vegetariano', 'Vegano')
GROUP BY r.titulo, r.dificultad, r.tiempo_preparacion
ORDER BY r.titulo;
