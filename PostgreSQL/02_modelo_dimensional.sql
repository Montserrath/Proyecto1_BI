BEGIN;

DROP SCHEMA IF EXISTS dw CASCADE;
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

CREATE TABLE dw.dim_motivo_devolucion (
    sk_motivo_devolucion SERIAL PRIMARY KEY,
    motivo_devolucion VARCHAR(30) NOT NULL UNIQUE
);
-- =====================================================
-- TABLAS DE HECHOS
-- =====================================================

CREATE TABLE dw.fact_envio (
    sk_fact_envio SERIAL PRIMARY KEY,

    id_envio_origen INT NOT NULL UNIQUE,

    sk_fecha_registro INT NOT NULL,
    sk_fecha_prometida INT NOT NULL,
    sk_fecha_entrega_real INT,
    sk_cliente INT NOT NULL,
    sk_destino INT NOT NULL,
    sk_centro_distribucion INT NOT NULL,
    sk_transportista INT NOT NULL,
    sk_ruta INT NOT NULL,
    sk_tipo_envio INT NOT NULL,
    sk_motivo_devolucion INT,

    estado_envio VARCHAR(15) NOT NULL,

    cantidad_envios INT NOT NULL,
    monto_facturado DECIMAL(12,2) NOT NULL,
    costo_operativo_estimado DECIMAL(12,2),
    cantidad_paquetes INT NOT NULL,
    peso_total_kg DECIMAL(12,2) NOT NULL,
    valor_declarado_total DECIMAL(14,2) NOT NULL,
    tiempo_prometido_dias DECIMAL(12,2),
    tiempo_real_dias DECIMAL(12,2),
    diferencia_tiempo_dias DECIMAL(12,2),
    cantidad_incidencias INT NOT NULL,
    costo_devolucion DECIMAL(12,2),
    monto_reembolso DECIMAL(12,2),

    CONSTRAINT fk_fact_envio_fecha_registro
        FOREIGN KEY (sk_fecha_registro)
        REFERENCES dw.dim_fecha (sk_fecha),

    CONSTRAINT fk_fact_envio_fecha_prometida
        FOREIGN KEY (sk_fecha_prometida)
        REFERENCES dw.dim_fecha (sk_fecha),

    CONSTRAINT fk_fact_envio_fecha_entrega_real
        FOREIGN KEY (sk_fecha_entrega_real)
        REFERENCES dw.dim_fecha (sk_fecha),

    CONSTRAINT fk_fact_envio_cliente
        FOREIGN KEY (sk_cliente)
        REFERENCES dw.dim_cliente (sk_cliente),

    CONSTRAINT fk_fact_envio_destino
        FOREIGN KEY (sk_destino)
        REFERENCES dw.dim_destino (sk_destino),

    CONSTRAINT fk_fact_envio_centro
        FOREIGN KEY (sk_centro_distribucion)
        REFERENCES dw.dim_centro_distribucion (sk_centro_distribucion),

    CONSTRAINT fk_fact_envio_transportista
        FOREIGN KEY (sk_transportista)
        REFERENCES dw.dim_transportista (sk_transportista),

    CONSTRAINT fk_fact_envio_ruta
        FOREIGN KEY (sk_ruta)
        REFERENCES dw.dim_ruta (sk_ruta),

    CONSTRAINT fk_fact_envio_tipo_envio
        FOREIGN KEY (sk_tipo_envio)
        REFERENCES dw.dim_tipo_envio (sk_tipo_envio),

    CONSTRAINT fk_fact_envio_motivo_devolucion
        FOREIGN KEY (sk_motivo_devolucion)
        REFERENCES dw.dim_motivo_devolucion (sk_motivo_devolucion),

    CONSTRAINT ck_fact_envio_estado
        CHECK (estado_envio IN (
            'registrado',
            'en_ruta',
            'entregado',
            'retrasado',
            'devuelto',
            'cancelado'
        )),

    CONSTRAINT ck_fact_envio_cantidad_envios
        CHECK (cantidad_envios >= 0),

    CONSTRAINT ck_fact_envio_cantidad_paquetes
        CHECK (cantidad_paquetes >= 0),

    CONSTRAINT ck_fact_envio_cantidad_incidencias
        CHECK (cantidad_incidencias >= 0),

    CONSTRAINT ck_fact_envio_monto_facturado
        CHECK (monto_facturado >= 0),

    CONSTRAINT ck_fact_envio_costo_operativo
        CHECK (costo_operativo_estimado IS NULL OR costo_operativo_estimado >= 0),

    CONSTRAINT ck_fact_envio_peso_total
        CHECK (peso_total_kg >= 0),

    CONSTRAINT ck_fact_envio_valor_declarado
        CHECK (valor_declarado_total >= 0),

    CONSTRAINT ck_fact_envio_costo_devolucion
        CHECK (costo_devolucion IS NULL OR costo_devolucion >= 0),

    CONSTRAINT ck_fact_envio_monto_reembolso
        CHECK (monto_reembolso IS NULL OR monto_reembolso >= 0)
); 


CREATE TABLE dw.fact_incidencia (
    sk_fact_incidencia SERIAL PRIMARY KEY,

    id_incidencia_origen INT NOT NULL UNIQUE,

    sk_fecha_incidencia INT NOT NULL,
    sk_cliente INT NOT NULL,
    sk_destino INT NOT NULL,
    sk_centro_distribucion INT NOT NULL,
    sk_transportista INT NOT NULL,
    sk_ruta INT NOT NULL,
    sk_tipo_envio INT NOT NULL,
    sk_tipo_paquete INT,
    sk_clasificacion_incidencia INT NOT NULL,

    cantidad_incidencias INT NOT NULL,

    CONSTRAINT fk_fact_incidencia_fecha
        FOREIGN KEY (sk_fecha_incidencia)
        REFERENCES dw.dim_fecha (sk_fecha),

    CONSTRAINT fk_fact_incidencia_cliente
        FOREIGN KEY (sk_cliente)
        REFERENCES dw.dim_cliente (sk_cliente),

    CONSTRAINT fk_fact_incidencia_destino
        FOREIGN KEY (sk_destino)
        REFERENCES dw.dim_destino (sk_destino),

    CONSTRAINT fk_fact_incidencia_centro
        FOREIGN KEY (sk_centro_distribucion)
        REFERENCES dw.dim_centro_distribucion (sk_centro_distribucion),

    CONSTRAINT fk_fact_incidencia_transportista
        FOREIGN KEY (sk_transportista)
        REFERENCES dw.dim_transportista (sk_transportista),

    CONSTRAINT fk_fact_incidencia_ruta
        FOREIGN KEY (sk_ruta)
        REFERENCES dw.dim_ruta (sk_ruta),

    CONSTRAINT fk_fact_incidencia_tipo_envio
        FOREIGN KEY (sk_tipo_envio)
        REFERENCES dw.dim_tipo_envio (sk_tipo_envio),

    CONSTRAINT fk_fact_incidencia_tipo_paquete
        FOREIGN KEY (sk_tipo_paquete)
        REFERENCES dw.dim_tipo_paquete (sk_tipo_paquete),

    CONSTRAINT fk_fact_incidencia_clasificacion
        FOREIGN KEY (sk_clasificacion_incidencia)
        REFERENCES dw.dim_clasificacion_incidencia (sk_clasificacion_incidencia),

    CONSTRAINT ck_fact_incidencia_cantidad
        CHECK (cantidad_incidencias >= 0)
);

COMMIT;
