CREATE SCHEMA dw;

-- =====================================================
-- DIMENSIONES
-- =====================================================

CREATE TABLE dw.dim_fecha (
    sk_fecha SERIAL PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    dia_semana VARCHAR(20) NOT NULL,
    numero_dia_mes SMALLINT NOT NULL,
    mes SMALLINT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    anio INT NOT NULL
);

CREATE TABLE dw.dim_cliente (
    sk_cliente SERIAL PRIMARY KEY,
    id_cliente_origen INT NOT NULL UNIQUE,
    nombre_cliente VARCHAR(150) NOT NULL,
    tipo_cliente VARCHAR(20) NOT NULL,
    segmento_cliente VARCHAR(50) NOT NULL
);

CREATE TABLE dw.dim_destino (
    sk_destino SERIAL PRIMARY KEY,
    id_sede_cliente_origen INT NOT NULL UNIQUE,
    nombre_sede VARCHAR(150) NOT NULL,
    provincia VARCHAR(30) NOT NULL,
    canton VARCHAR(60) NOT NULL,
    zona_logistica VARCHAR(20) NOT NULL
);

CREATE TABLE dw.dim_centro_distribucion (
    sk_centro_distribucion SERIAL PRIMARY KEY,
    id_centro_origen INT NOT NULL UNIQUE,
    nombre_centro VARCHAR(150) NOT NULL,
    tipo_centro VARCHAR(20) NOT NULL,
    provincia VARCHAR(30) NOT NULL,
    canton VARCHAR(60) NOT NULL,
    zona_logistica VARCHAR(20) NOT NULL
);

CREATE TABLE dw.dim_transportista (
    sk_transportista SERIAL PRIMARY KEY,
    id_transportista_origen INT NOT NULL UNIQUE,
    nombre_transportista VARCHAR(150) NOT NULL,
    medio_transporte VARCHAR(20) NOT NULL,
    zona_asignada VARCHAR(20) NOT NULL
);

CREATE TABLE dw.dim_ruta (
    sk_ruta SERIAL PRIMARY KEY,
    id_ruta_origen INT NOT NULL UNIQUE,
    nombre_ruta VARCHAR(150) NOT NULL,
    zona_ruta VARCHAR(20) NOT NULL,
    distancia_km DECIMAL(10,2) NOT NULL,
    tipo_ruta VARCHAR(20) NOT NULL
);

CREATE TABLE dw.dim_tipo_envio (
    sk_tipo_envio SERIAL PRIMARY KEY,
    id_tipo_envio_origen INT NOT NULL UNIQUE,
    nombre_tipo_envio VARCHAR(100) NOT NULL,
    tiempo_prometido_base_horas INT NOT NULL,
    prioridad_servicio VARCHAR(10) NOT NULL
);

CREATE TABLE dw.dim_tipo_paquete (
    sk_tipo_paquete SERIAL PRIMARY KEY,
    tipo_paquete VARCHAR(30) NOT NULL,
    requiere_manejo_especial BOOLEAN NOT NULL,
    rango_peso VARCHAR(20) NOT NULL,
    rango_valor_declarado VARCHAR(20) NOT NULL,
    CONSTRAINT uq_dim_tipo_paquete UNIQUE (
        tipo_paquete,
        requiere_manejo_especial,
        rango_peso,
        rango_valor_declarado
    )
);

CREATE TABLE dw.dim_clasificacion_incidencia (
    sk_clasificacion_incidencia SERIAL PRIMARY KEY,
    tipo_incidencia VARCHAR(30) NOT NULL,
    nivel_severidad VARCHAR(10) NOT NULL,
    estado_incidencia VARCHAR(15) NOT NULL,
    causante_incidencia VARCHAR(20) NOT NULL,
    CONSTRAINT uq_dim_clasificacion_incidencia UNIQUE (
        tipo_incidencia,
        nivel_severidad,
        estado_incidencia,
        causante_incidencia
    )
);
COMMIT;