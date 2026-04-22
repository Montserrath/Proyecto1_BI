BEGIN;

-- =====================================================
-- LIMPIEZA PREVIA
-- =====================================================
DELETE FROM devolucion;
DELETE FROM incidencia;
DELETE FROM paquete;
DELETE FROM envio;
DELETE FROM transportista_ruta;
DELETE FROM centro_ruta;
DELETE FROM transportista;
DELETE FROM tipo_envio;
DELETE FROM ruta;
DELETE FROM centro_distribucion;
DELETE FROM sede_cliente;
DELETE FROM cliente;
DELETE FROM segmento_cliente;
DELETE FROM tipo_cliente;
DELETE FROM ubicacion;
DELETE FROM canton;
DELETE FROM provincia;

-- =====================================================
-- TABLAS DE REFERENCIA GEOGRÁFICA
-- =====================================================

INSERT INTO provincia (id_provincia, nombre_provincia) VALUES
(1, 'San Jose'),
(2, 'Alajuela'),
(3, 'Cartago'),
(4, 'Heredia'),
(5, 'Guanacaste'),
(6, 'Puntarenas'),
(7, 'Limon');

INSERT INTO canton (id_canton, id_provincia, nombre_canton) VALUES
(101, 1, 'San Jose'),
(102, 1, 'Perez Zeledon'),
(201, 2, 'Alajuela'),
(202, 2, 'San Carlos'),
(301, 3, 'Cartago'),
(401, 4, 'Heredia'),
(501, 5, 'Liberia'),
(601, 6, 'Puntarenas'),
(701, 7, 'Limon');

INSERT INTO ubicacion (id_ubicacion, id_provincia, id_canton, zona_logistica) VALUES
(1, 1, 101, 'Central'),
(2, 2, 201, 'Central'),
(3, 3, 301, 'Central'),
(4, 4, 401, 'Central'),
(5, 5, 501, 'Chorotega'),
(6, 6, 601, 'Pacifico_Central'),
(7, 1, 102, 'Brunca'),
(8, 7, 701, 'Huetar_Caribe'),
(9, 2, 202, 'Huetar_Norte');

-- =====================================================
-- CLASIFICACION DE CLIENTES
-- =====================================================

INSERT INTO tipo_cliente (id_tipo_cliente, nombre_tipo_cliente, estado_tipo_cliente) VALUES
(1, 'individual', 'activo'),
(2, 'corporativo', 'activo');

INSERT INTO segmento_cliente (id_segmento_cliente, nombre_segmento_cliente, estado_segmento_cliente) VALUES
(1, 'particular', 'activo'),
(2, 'retail_comercio', 'activo'),
(3, 'salud_farmaceutico', 'activo'),
(4, 'tecnologia_electronica', 'activo'),
(5, 'alimentos_bebidas', 'activo'),
(6, 'educativo', 'activo'),
(7, 'mayorista_distribucion', 'activo'),
(8, 'industrial_manufactura', 'activo'),
(9, 'servicios', 'activo');

-- =====================================================
-- CLIENTES
-- =====================================================

INSERT INTO cliente (
    id_cliente, cedula_cliente, nombre_cliente, id_tipo_cliente, id_segmento_cliente,
    telefono, correo, fecha_registro_cliente, estado_cliente
) VALUES
(1, '101110111', 'Andrea Mora', 1, 1, '87000001', 'andrea.mora@email.com', '2023-01-15', 'activo'),
(2, '101110112', 'Luis Cordero', 1, 1, '87000002', 'luis.cordero@email.com', '2023-02-10', 'activo'),
(3, '301230456', 'RetailMax Costa Rica', 2, 2, '22010001', 'logistica@retailmax.cr', '2023-01-05', 'activo'),
(4, '301230457', 'Farmared Nacional', 2, 3, '22010002', 'operaciones@farmared.cr', '2023-01-08', 'activo'),
(5, '301230458', 'TecnoSmart Distribucion', 2, 4, '22010003', 'despacho@tecnosmart.cr', '2023-01-12', 'activo'),
(6, '301230459', 'Alimentos del Valle', 2, 5, '22010004', 'rutas@alimentosdelvalle.cr', '2023-02-01', 'activo'),
(7, '301230460', 'EducaPlus', 2, 6, '22010005', 'compras@educaplus.cr', '2023-02-20', 'activo'),
(8, '301230461', 'Distribuidora NovaSur', 2, 7, '22010006', 'supply@novasur.cr', '2023-03-03', 'activo'),
(9, '301230462', 'Industrias Frontera', 2, 8, '22010007', 'logistica@frontera.cr', '2023-03-15', 'activo'),
(10, '301230463', 'Servicios Ejecutivos CR', 2, 9, '22010008', 'mensajeria@servicioscr.cr', '2023-04-01', 'activo');

-- =====================================================
-- SEDES DE CLIENTE
-- =====================================================

INSERT INTO sede_cliente (
    id_sede_cliente, id_cliente, nombre_sede, id_ubicacion, direccion_sede, estado_sede
) VALUES
(1, 1, 'Casa Andrea San Jose', 1, 'Barrio Escalante, San Jose', 'activa'),
(2, 2, 'Casa Luis Alajuela', 2, 'Centro de Alajuela', 'activa'),
(3, 3, 'RetailMax San Jose', 1, 'La Uruca, San Jose', 'activa'),
(4, 3, 'RetailMax Heredia', 4, 'Centro de Heredia', 'activa'),
(5, 4, 'Farmared Cartago', 3, 'Cartago centro', 'activa'),
(6, 5, 'TecnoSmart Alajuela', 2, 'Parque empresarial Alajuela', 'activa'),
(7, 6, 'Alimentos del Valle Puntarenas', 6, 'Puntarenas centro', 'activa'),
(8, 7, 'EducaPlus San Jose', 1, 'Sabana Sur, San Jose', 'activa'),
(9, 8, 'NovaSur Perez Zeledon', 7, 'San Isidro de El General', 'activa'),
(10, 9, 'Industrias Frontera Ciudad Quesada', 9, 'Ciudad Quesada centro', 'activa'),
(11, 10, 'Servicios Ejecutivos Limon', 8, 'Centro de Limon', 'activa'),
(12, 4, 'Farmared Liberia', 5, 'Liberia centro', 'activa');

-- =====================================================
-- CENTROS DE DISTRIBUCION
-- =====================================================

INSERT INTO centro_distribucion (
    id_centro_distribucion, nombre_centro, tipo_centro, id_ubicacion, estado_centro
) VALUES
(1, 'Hub Central San Jose', 'principal', 1, 'activo'),
(2, 'Hub Alajuela Norte', 'principal', 2, 'activo'),
(3, 'Centro Regional Liberia', 'regional', 5, 'activo'),
(4, 'Centro Regional Puntarenas', 'regional', 6, 'activo'),
(5, 'Centro Regional Perez Zeledon', 'regional', 7, 'activo'),
(6, 'Centro Regional Limon', 'regional', 8, 'activo'),
(7, 'Centro Regional Ciudad Quesada', 'regional', 9, 'activo');

-- =====================================================
-- RUTAS
-- =====================================================

INSERT INTO ruta (
    id_ruta, nombre_ruta, zona_ruta, distancia_km, tipo_ruta, estado_ruta
) VALUES
(1, 'Ruta Metropolitana Sur', 'Central', 22.0, 'urbana', 'activa'),
(2, 'Ruta Metropolitana Norte', 'Central', 18.5, 'urbana', 'activa'),
(3, 'Ruta Interurbana Cartago-San Jose', 'Central', 47.3, 'interurbana', 'activa'),
(4, 'Ruta Interurbana Heredia-Alajuela', 'Central', 35.8, 'interurbana', 'activa'),
(5, 'Ruta Urbana Liberia', 'Chorotega', 14.2, 'urbana', 'activa'),
(6, 'Ruta Regional Guanacaste Costa', 'Chorotega', 198.4, 'regional', 'activa'),
(7, 'Ruta Urbana Puntarenas', 'Pacifico_Central', 11.9, 'urbana', 'activa'),
(8, 'Ruta Costera Pacifico', 'Pacifico_Central', 89.5, 'interurbana', 'activa'),
(9, 'Ruta Interurbana Perez Zeledon', 'Brunca', 68.3, 'interurbana', 'activa'),
(10, 'Ruta Regional Brunca', 'Brunca', 210.6, 'regional', 'activa'),
(11, 'Ruta Urbana Limon', 'Huetar_Caribe', 12.7, 'urbana', 'activa'),
(12, 'Ruta Regional Caribe Norte', 'Huetar_Caribe', 145.0, 'regional', 'activa'),
(13, 'Ruta Interurbana San Carlos', 'Huetar_Norte', 55.0, 'interurbana', 'activa'),
(14, 'Ruta Regional Norte Frontera', 'Huetar_Norte', 175.2, 'regional', 'activa');

-- =====================================================
-- TRANSPORTISTAS
-- =====================================================

INSERT INTO transportista (
    id_transportista, id_centro_distribucion, cedula_transportista, nombre_transportista,
    medio_transporte, zona_asignada, telefono_contacto, correo_contacto, estado_transportista
) VALUES
(1, 1, '111111111', 'Carlos Perez', 'motocicleta', 'Central', '88000001', 'carlos.perez@novaruta.cr', 'activo'),
(2, 1, '111111112', 'Natalia Urena', 'carro', 'Central', '88000002', 'natalia.urena@novaruta.cr', 'activo'),
(3, 1, '111111113', 'Javier Soto', 'bicicleta', 'Central', '88000003', 'javier.soto@novaruta.cr', 'activo'),
(4, 2, '111111114', 'Pablo Vargas', 'motocicleta', 'Central', '88000004', 'pablo.vargas@novaruta.cr', 'activo'),
(5, 2, '111111115', 'Karla Ramirez', 'carro', 'Central', '88000005', 'karla.ramirez@novaruta.cr', 'activo'),
(6, 3, '111111116', 'Monica Chaves', 'carro', 'Chorotega', '88000006', 'monica.chaves@novaruta.cr', 'activo'),
(7, 3, '111111117', 'Daniel Brenes', 'camion', 'Chorotega', '88000007', 'daniel.brenes@novaruta.cr', 'activo'),
(8, 4, '111111118', 'Oscar Mena', 'carro', 'Pacifico_Central', '88000008', 'oscar.mena@novaruta.cr', 'activo'),
(9, 4, '111111119', 'Rocio Campos', 'camion', 'Pacifico_Central', '88000009', 'rocio.campos@novaruta.cr', 'activo'),
(10, 5, '111111120', 'Esteban Solis', 'carro', 'Brunca', '88000010', 'esteban.solis@novaruta.cr', 'activo'),
(11, 5, '111111121', 'Marvin Araya', 'camion', 'Brunca', '88000011', 'marvin.araya@novaruta.cr', 'activo'),
(12, 6, '111111122', 'Andrea Mena', 'carro', 'Huetar_Caribe', '88000012', 'andrea.mena@novaruta.cr', 'activo'),
(13, 6, '111111123', 'Luis Herrera', 'camion', 'Huetar_Caribe', '88000013', 'luis.herrera@novaruta.cr', 'activo'),
(14, 7, '111111124', 'Rebeca Alfaro', 'carro', 'Huetar_Norte', '88000014', 'rebeca.alfaro@novaruta.cr', 'activo'),
(15, 7, '111111125', 'Mauricio Quesada', 'camion', 'Huetar_Norte', '88000015', 'mauricio.quesada@novaruta.cr', 'activo');

-- =====================================================
-- TIPOS DE ENVIO
-- =====================================================

INSERT INTO tipo_envio (
    id_tipo_envio, nombre_tipo_envio, descripcion_tipo_envio,
    tiempo_prometido_base_horas, prioridad_servicio, estado_tipo_envio
) VALUES
(1, 'express_nacional', 'Entrega el mismo dia dentro de la zona Central', 4, 'alta', 'activo'),
(2, 'dia_siguiente', 'Entrega al dia habil siguiente con cobertura nacional', 24, 'alta', 'activo'),
(3, 'estandar_48h', 'Servicio regular nacional con plazo de 48 horas', 48, 'media', 'activo'),
(4, 'economico_72h', 'Opcion de menor costo para envios sin urgencia', 72, 'media', 'activo'),
(5, 'carga_regional', 'Envios de alto volumen hacia zonas regionales', 96, 'baja', 'activo'),
(6, 'envio_programado', 'Entrega en fecha pactada principalmente corporativa', 120, 'baja', 'activo');

-- =====================================================
-- RELACION CENTRO - RUTA
-- =====================================================

INSERT INTO centro_ruta (
    id_centro_ruta, id_centro_distribucion, id_ruta, estado_asignacion,
    fecha_inicio_asignacion, fecha_fin_asignacion
) VALUES
(1, 1, 1, 'activa', '2023-01-01', NULL),
(2, 2, 2, 'activa', '2023-01-01', NULL),
(3, 1, 3, 'activa', '2023-01-01', NULL),
(4, 2, 4, 'activa', '2023-01-01', NULL),
(5, 3, 5, 'activa', '2023-01-01', NULL),
(6, 3, 6, 'activa', '2023-01-01', NULL),
(7, 4, 7, 'activa', '2023-01-01', NULL),
(8, 4, 8, 'activa', '2023-01-01', NULL),
(9, 5, 9, 'activa', '2023-01-01', NULL),
(10, 5, 10, 'activa', '2023-01-01', NULL),
(11, 6, 11, 'activa', '2023-01-01', NULL),
(12, 6, 12, 'activa', '2023-01-01', NULL),
(13, 7, 13, 'activa', '2023-01-01', NULL),
(14, 7, 14, 'activa', '2023-01-01', NULL);

-- =====================================================
-- RELACION TRANSPORTISTA - RUTA
-- =====================================================

INSERT INTO transportista_ruta (
    id_transportista_ruta, id_transportista, id_centro_distribucion, id_ruta,
    estado_asignacion, fecha_inicio_asignacion, fecha_fin_asignacion
) VALUES
(1, 1, 1, 1, 'activa', '2023-01-01', NULL),
(2, 2, 1, 3, 'activa', '2023-01-01', NULL),
(3, 3, 1, 1, 'activa', '2023-01-01', NULL),
(4, 4, 2, 2, 'activa', '2023-01-01', NULL),
(5, 5, 2, 4, 'activa', '2023-01-01', NULL),
(6, 6, 3, 5, 'activa', '2023-01-01', NULL),
(7, 7, 3, 6, 'activa', '2023-01-01', NULL),
(8, 8, 4, 7, 'activa', '2023-01-01', NULL),
(9, 9, 4, 8, 'activa', '2023-01-01', NULL),
(10, 10, 5, 9, 'activa', '2023-01-01', NULL),
(11, 11, 5, 10, 'activa', '2023-01-01', NULL),
(12, 12, 6, 11, 'activa', '2023-01-01', NULL),
(13, 13, 6, 12, 'activa', '2023-01-01', NULL),
(14, 14, 7, 13, 'activa', '2023-01-01', NULL),
(15, 15, 7, 14, 'activa', '2023-01-01', NULL),
(16, 2, 1, 3, 'inactiva', '2022-06-01', '2022-12-31');

-- =====================================================
-- ENVIOS
-- =====================================================

INSERT INTO envio (
    id_envio, id_sede_cliente, id_transportista_ruta, id_tipo_envio,
    fecha_registro_envio, fecha_prometida_entrega, fecha_real_entrega,
    estado_envio, monto_facturado, costo_operativo_estimado, observaciones_envio
) VALUES
(1001, 3, 1, 1, '2024-03-01', '2024-03-01', '2024-03-01', 'entregado', 18500.00, 9200.00, 'Entrega express retail zona central'),
(1002, 3, 2, 2, '2024-03-01', '2024-03-02', '2024-03-02', 'entregado', 24500.00, 11800.00, 'Reposicion de inventario retail'),
(1003, 4, 5, 3, '2024-03-02', '2024-03-04', '2024-03-04', 'entregado', 27800.00, 14100.00, 'Despacho a Heredia'),
(1004, 5, 2, 2, '2024-03-02', '2024-03-03', '2024-03-03', 'entregado', 32500.00, 15200.00, 'Medicamentos urgentes'),
(1005, 6, 4, 1, '2024-03-03', '2024-03-03', '2024-03-03', 'entregado', 21200.00, 9800.00, 'Electronica express central'),
(1006, 7, 8, 3, '2024-03-03', '2024-03-05', '2024-03-05', 'entregado', 29600.00, 16800.00, 'Despacho alimentos puntarenas'),
(1007, 8, 1, 6, '2024-03-04', '2024-03-09', '2024-03-09', 'entregado', 35500.00, 17300.00, 'Materiales programados'),
(1008, 9, 10, 4, '2024-03-04', '2024-03-07', '2024-03-09', 'retrasado', 31800.00, 20100.00, 'Ruta larga zona sur'),
(1009, 10, 14, 5, '2024-03-05', '2024-03-09', '2024-03-09', 'entregado', 48200.00, 29200.00, 'Carga industrial zona norte'),
(1010, 11, 12, 3, '2024-03-05', '2024-03-07', '2024-03-08', 'retrasado', 26400.00, 15900.00, 'Demora por lluvia caribe'),
(1011, 12, 6, 3, '2024-03-06', '2024-03-08', '2024-03-08', 'entregado', 25100.00, 13700.00, 'Farmacia Liberia'),
(1012, 1, 3, 1, '2024-03-06', '2024-03-06', '2024-03-06', 'entregado', 9800.00, 4200.00, 'Documento personal'),
(1013, 2, 4, 2, '2024-03-07', '2024-03-08', '2024-03-08', 'entregado', 11800.00, 5600.00, 'Paquete personal'),
(1014, 3, 5, 6, '2024-03-07', '2024-03-12', '2024-03-12', 'entregado', 39200.00, 20100.00, 'Envio programado retail'),
(1015, 4, 5, 2, '2024-03-08', '2024-03-09', '2024-03-09', 'entregado', 28900.00, 14600.00, 'Reposicion sanitaria'),
(1016, 5, 2, 3, '2024-03-08', '2024-03-10', '2024-03-11', 'retrasado', 30100.00, 15400.00, 'Cartago con atraso leve'),
(1017, 6, 5, 4, '2024-03-09', '2024-03-12', '2024-03-12', 'entregado', 22400.00, 12700.00, 'Entrega economica'),
(1018, 7, 9, 5, '2024-03-09', '2024-03-13', '2024-03-13', 'entregado', 43600.00, 25900.00, 'Carga sector pesca'),
(1019, 8, 2, 1, '2024-03-10', '2024-03-10', '2024-03-10', 'entregado', 16500.00, 8300.00, 'Documentos corporativos'),
(1020, 9, 11, 5, '2024-03-10', '2024-03-14', '2024-03-17', 'retrasado', 52500.00, 33600.00, 'Carga regional Brunca'),
(1021, 10, 15, 5, '2024-03-11', '2024-03-15', '2024-03-15', 'entregado', 49700.00, 30100.00, 'Carga manufactura'),
(1022, 11, 13, 4, '2024-03-11', '2024-03-14', '2024-03-16', 'retrasado', 27100.00, 17200.00, 'Afectacion clima caribe'),
(1023, 3, 1, 1, '2024-03-12', '2024-03-12', '2024-03-12', 'entregado', 19400.00, 9700.00, 'Entrega express comercial'),
(1024, 4, 5, 3, '2024-03-12', '2024-03-14', '2024-03-14', 'entregado', 26700.00, 13900.00, 'Despacho Heredia'),
(1025, 5, 2, 2, '2024-03-13', '2024-03-14', '2024-03-15', 'retrasado', 33700.00, 16600.00, 'Medicamento con reprogramacion'),
(1026, 12, 7, 5, '2024-03-13', '2024-03-17', '2024-03-17', 'entregado', 45800.00, 27600.00, 'Carga regional Guanacaste'),
(1027, 9, 10, 6, '2024-03-14', '2024-03-19', '2024-03-21', 'retrasado', 36200.00, 22500.00, 'Programado con atraso en zona sur'),
(1028, 11, 12, 2, '2024-03-14', '2024-03-15', '2024-03-15', 'entregado', 18900.00, 11100.00, 'Entrega al dia siguiente'),
(1029, 6, 4, 1, '2024-03-15', '2024-03-15', '2024-03-15', 'entregado', 20500.00, 10100.00, 'Express electronica'),
(1030, 7, 8, 3, '2024-03-15', '2024-03-17', '2024-03-17', 'entregado', 28700.00, 16400.00, 'Despacho alimentos'),
(1031, 1, 1, 3, '2024-03-16', '2024-03-18', '2024-03-18', 'entregado', 11200.00, 5400.00, 'Paquete particular'),
(1032, 2, 5, 4, '2024-03-16', '2024-03-19', '2024-03-19', 'entregado', 13600.00, 6900.00, 'Entrega economica particular'),
(1033, 3, 2, 2, '2024-03-18', '2024-03-19', '2024-03-19', 'entregado', 24800.00, 11900.00, 'Surtido comercial'),
(1034, 10, 14, 5, '2024-03-18', '2024-03-22', '2024-03-22', 'entregado', 51400.00, 30800.00, 'Carga industrial recurrente'),
(1035, 11, 13, 5, '2024-03-19', '2024-03-23', '2024-03-24', 'retrasado', 47300.00, 29500.00, 'Carga caribe con afectacion vial'),
(1036, 9, 11, 5, '2024-03-20', '2024-03-24', '2024-03-24', 'devuelto', 41800.00, 28900.00, 'Cliente ausente y retorno'),
(1037, 12, 7, 4, '2024-03-20', '2024-03-23', '2024-03-23', 'entregado', 23100.00, 14200.00, 'Farmacia economico'),
(1038, 5, 2, 2, '2024-03-21', '2024-03-22', '2024-03-22', 'devuelto', 32900.00, 18100.00, 'Error de documentacion'),
(1039, 6, 5, 3, '2024-03-22', '2024-03-24', '2024-03-24', 'entregado', 27400.00, 14300.00, 'Electronica estandar'),
(1040, 3, 1, 1, '2024-03-22', '2024-03-22', '2024-03-22', 'devuelto', 17600.00, 9600.00, 'Direccion incorrecta'),
(1041, 7, 9, 5, '2024-03-23', '2024-03-27', '2024-03-27', 'entregado', 44900.00, 26400.00, 'Carga pesca'),
(1042, 10, 15, 6, '2024-03-23', '2024-03-28', '2024-03-28', 'entregado', 53800.00, 31500.00, 'Programado industrial'),
(1043, 11, 12, 4, '2024-03-24', '2024-03-27', '2024-03-29', 'retrasado', 25900.00, 16900.00, 'Demora por congestion portuaria'),
(1044, 8, 2, 1, '2024-03-24', '2024-03-24', '2024-03-24', 'entregado', 17100.00, 8500.00, 'Documentos academicos'),
(1045, 4, 5, 6, '2024-03-25', '2024-03-30', '2024-03-30', 'entregado', 40100.00, 20700.00, 'Distribucion planificada'),
(1046, 9, 10, 4, '2024-03-25', '2024-03-28', '2024-03-30', 'retrasado', 34400.00, 21800.00, 'Atraso zona sur'),
(1047, 10, 14, 5, '2024-03-26', '2024-03-30', '2024-03-30', 'entregado', 52200.00, 31400.00, 'Carga manufactura norte'),
(1048, 12, 6, 3, '2024-03-26', '2024-03-28', '2024-03-28', 'entregado', 24700.00, 13600.00, 'Farmacia Liberia nacional');

-- =====================================================
-- PAQUETES
-- =====================================================

INSERT INTO paquete (
    id_paquete, id_envio, tipo_paquete, peso_kg, alto_cm, ancho_cm, largo_cm,
    valor_declarado, requiere_manejo_especial
) VALUES
(1, 1001, 'documento', 0.30, 2.00, 25.00, 35.00, 15000.00, FALSE),
(2, 1002, 'caja_pequena', 3.20, 20.00, 20.00, 25.00, 28000.00, FALSE),
(3, 1002, 'caja_pequena', 2.80, 18.00, 18.00, 22.00, 22000.00, FALSE),
(4, 1003, 'caja_mediana', 8.50, 35.00, 30.00, 40.00, 65000.00, FALSE),
(5, 1004, 'fragil', 4.20, 20.00, 20.00, 30.00, 95000.00, TRUE),
(6, 1005, 'fragil', 2.10, 15.00, 18.00, 20.00, 185000.00, TRUE),
(7, 1006, 'caja_mediana', 11.50, 40.00, 35.00, 45.00, 42000.00, FALSE),
(8, 1007, 'documento', 0.40, 2.00, 25.00, 35.00, 12000.00, FALSE),
(9, 1007, 'caja_pequena', 1.80, 18.00, 18.00, 25.00, 18000.00, FALSE),
(10, 1008, 'caja_grande', 24.00, 60.00, 45.00, 70.00, 135000.00, TRUE),
(11, 1009, 'caja_grande', 32.00, 70.00, 55.00, 80.00, 240000.00, TRUE),
(12, 1010, 'caja_mediana', 9.30, 35.00, 30.00, 45.00, 56000.00, FALSE),
(13, 1011, 'caja_pequena', 4.40, 22.00, 22.00, 28.00, 30000.00, FALSE),
(14, 1012, 'documento', 0.20, 1.00, 23.00, 32.00, 8000.00, FALSE),
(15, 1013, 'caja_pequena', 2.50, 18.00, 20.00, 25.00, 16000.00, FALSE),
(16, 1014, 'caja_mediana', 12.00, 42.00, 35.00, 50.00, 68000.00, FALSE),
(17, 1014, 'fragil', 3.50, 20.00, 20.00, 24.00, 98000.00, TRUE),
(18, 1015, 'fragil', 2.60, 15.00, 18.00, 20.00, 87000.00, TRUE),
(19, 1016, 'caja_mediana', 10.20, 38.00, 34.00, 44.00, 47000.00, FALSE),
(20, 1017, 'caja_pequena', 3.10, 18.00, 18.00, 24.00, 26000.00, FALSE),
(21, 1018, 'caja_grande', 28.00, 65.00, 48.00, 75.00, 125000.00, TRUE),
(22, 1019, 'documento', 0.35, 2.00, 25.00, 35.00, 12000.00, FALSE),
(23, 1020, 'caja_grande', 30.00, 70.00, 55.00, 82.00, 145000.00, TRUE),
(24, 1021, 'caja_grande', 34.00, 75.00, 58.00, 86.00, 210000.00, TRUE),
(25, 1022, 'caja_mediana', 7.90, 32.00, 28.00, 40.00, 51000.00, FALSE),
(26, 1023, 'documento', 0.25, 2.00, 23.00, 32.00, 11000.00, FALSE),
(27, 1024, 'caja_pequena', 3.60, 20.00, 20.00, 25.00, 21000.00, FALSE),
(28, 1025, 'fragil', 2.70, 18.00, 18.00, 22.00, 92000.00, TRUE),
(29, 1026, 'caja_grande', 26.00, 62.00, 46.00, 72.00, 132000.00, TRUE),
(30, 1027, 'caja_mediana', 15.00, 45.00, 40.00, 55.00, 72000.00, FALSE),
(31, 1028, 'documento', 0.40, 2.00, 24.00, 34.00, 10000.00, FALSE),
(32, 1029, 'fragil', 1.90, 14.00, 16.00, 20.00, 165000.00, TRUE),
(33, 1030, 'caja_mediana', 9.80, 36.00, 30.00, 42.00, 43000.00, FALSE),
(34, 1031, 'caja_pequena', 2.20, 16.00, 18.00, 22.00, 14000.00, FALSE),
(35, 1032, 'caja_pequena', 3.00, 18.00, 20.00, 25.00, 18000.00, FALSE),
(36, 1033, 'caja_mediana', 8.90, 34.00, 30.00, 40.00, 52000.00, FALSE),
(37, 1034, 'caja_grande', 31.00, 72.00, 55.00, 82.00, 220000.00, TRUE),
(38, 1035, 'caja_grande', 29.50, 68.00, 50.00, 78.00, 168000.00, TRUE),
(39, 1036, 'caja_mediana', 13.20, 40.00, 35.00, 48.00, 69000.00, FALSE),
(40, 1037, 'caja_pequena', 3.40, 18.00, 18.00, 24.00, 24000.00, FALSE),
(41, 1038, 'fragil', 2.80, 18.00, 18.00, 22.00, 98000.00, TRUE),
(42, 1039, 'fragil', 2.20, 15.00, 18.00, 22.00, 176000.00, TRUE),
(43, 1040, 'documento', 0.25, 2.00, 24.00, 34.00, 9000.00, FALSE),
(44, 1041, 'caja_grande', 27.80, 63.00, 48.00, 74.00, 118000.00, TRUE),
(45, 1042, 'caja_grande', 33.00, 74.00, 58.00, 84.00, 205000.00, TRUE),
(46, 1043, 'caja_mediana', 8.40, 34.00, 30.00, 42.00, 47000.00, FALSE),
(47, 1044, 'documento', 0.30, 2.00, 23.00, 33.00, 8500.00, FALSE),
(48, 1045, 'caja_mediana', 11.60, 40.00, 34.00, 46.00, 62000.00, FALSE),
(49, 1046, 'caja_grande', 25.70, 60.00, 46.00, 72.00, 126000.00, TRUE),
(50, 1047, 'caja_grande', 35.00, 76.00, 60.00, 88.00, 228000.00, TRUE),
(51, 1048, 'caja_pequena', 4.00, 20.00, 20.00, 26.00, 29000.00, FALSE);

-- =====================================================
-- INCIDENCIAS
-- =====================================================

INSERT INTO incidencia (
    id_incidencia, id_envio, id_paquete, fecha_incidencia, tipo_incidencia,
    descripcion_incidencia, nivel_severidad, estado_incidencia, causante_incidencia
) VALUES
(1, 1008, 10, '2024-03-08', 'retraso_operativo', 'Congestion vial y lluvia en ingreso a zona sur', 'media', 'resuelta', 'externo'),
(2, 1010, 12, '2024-03-07', 'retraso_operativo', 'Demora por condiciones climaticas en Limon', 'alta', 'resuelta', 'externo'),
(3, 1020, 23, '2024-03-15', 'retraso_operativo', 'Desbordamiento en ruta regional Brunca', 'alta', 'resuelta', 'externo'),
(4, 1022, 25, '2024-03-15', 'direccion_incorrecta', 'Direccion incompleta en entrega Limon', 'media', 'resuelta', 'cliente'),
(5, 1025, 28, '2024-03-14', 'paquete_danado', 'Golpe leve en empaque de producto fragil', 'alta', 'resuelta', 'transportista'),
(6, 1035, 38, '2024-03-23', 'retraso_operativo', 'Afectacion por cierre temporal de via Caribe', 'critica', 'resuelta', 'externo'),
(7, 1036, 39, '2024-03-24', 'ausencia_cliente', 'Cliente ausente en segundo intento de entrega', 'media', 'resuelta', 'cliente'),
(8, 1038, 41, '2024-03-22', 'error_documentacion', 'Faltaba validacion documental de recepcion', 'alta', 'resuelta', 'sistema'),
(9, 1040, 43, '2024-03-22', 'direccion_incorrecta', 'Direccion registrada no correspondia al destinatario', 'media', 'resuelta', 'cliente'),
(10, 1043, 46, '2024-03-28', 'retraso_operativo', 'Retraso por congestion portuaria y lluvia', 'alta', 'resuelta', 'externo'),
(11, 1039, 42, '2024-03-23', 'paquete_danado', 'Caja fragil con golpe menor, se reemplazo embalaje', 'media', 'resuelta', 'centro_distribucion'),
(12, 1015, 18, '2024-03-09', 'otro', 'Reprogramacion interna por ajuste de ventana horaria', 'baja', 'resuelta', 'centro_distribucion');

-- =====================================================
-- DEVOLUCIONES
-- =====================================================

INSERT INTO devolucion (
    id_devolucion, id_envio, fecha_devolucion, motivo_devolucion,
    costo_devolucion, estado_devolucion, tipo_resolucion, monto_reembolso,
    compensacion_adicional, comentarios_devolucion
) VALUES
(1, 1036, '2024-03-24', 'cliente_ausente', 7800.00, 'cerrada', 'reembolso', 41800.00, FALSE, 'No se concreto entrega tras dos intentos'),
(2, 1038, '2024-03-22', 'error_documentacion', 6200.00, 'cerrada', 'reposicion', 0.00, TRUE, 'Se reprocesa envio con documentacion corregida'),
(3, 1040, '2024-03-22', 'direccion_incorrecta', 4100.00, 'cerrada', 'credito_favor', 0.00, FALSE, 'Se acredito monto para nuevo registro correcto');

COMMIT;