BEGIN;

-- =====================================================
-- TABLAS DE REFERENCIA GEOGRÁFICA
-- =====================================================

CREATE TABLE provincia (
    id_provincia SMALLINT PRIMARY KEY,
    nombre_provincia VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE canton (
    id_canton SMALLINT PRIMARY KEY,
    id_provincia SMALLINT NOT NULL,
    nombre_canton VARCHAR(60) NOT NULL,
    CONSTRAINT fk_canton_provincia
        FOREIGN KEY (id_provincia)
        REFERENCES provincia(id_provincia),
    CONSTRAINT uq_canton_provincia
        UNIQUE (id_canton, id_provincia),
    CONSTRAINT uq_nombre_canton_por_provincia
        UNIQUE (id_provincia, nombre_canton)
);

CREATE TABLE ubicacion (
    id_ubicacion INT PRIMARY KEY,
    id_provincia SMALLINT NOT NULL,
    id_canton SMALLINT NOT NULL,
    zona_logistica VARCHAR(20) NOT NULL,
    CONSTRAINT fk_ubicacion_provincia
        FOREIGN KEY (id_provincia)
        REFERENCES provincia(id_provincia),
    CONSTRAINT fk_ubicacion_canton_provincia
        FOREIGN KEY (id_canton, id_provincia)
        REFERENCES canton(id_canton, id_provincia),
    CONSTRAINT ck_zona_logistica
        CHECK (zona_logistica IN (
            'Central',
            'Brunca',
            'Chorotega',
            'Huetar_Caribe',
            'Pacifico_Central',
            'Huetar_Norte'
        )),
    CONSTRAINT uq_ubicacion
        UNIQUE (id_provincia, id_canton, zona_logistica)
);

-- =====================================================
-- TABLAS MAESTRAS DE CLASIFICACIÓN
-- =====================================================

CREATE TABLE tipo_cliente (
    id_tipo_cliente INT PRIMARY KEY,
    nombre_tipo_cliente VARCHAR(20) NOT NULL UNIQUE,
    estado_tipo_cliente VARCHAR(15) NOT NULL,
    CONSTRAINT ck_nombre_tipo_cliente
        CHECK (nombre_tipo_cliente IN ('individual', 'corporativo')),
    CONSTRAINT ck_estado_tipo_cliente
        CHECK (estado_tipo_cliente IN ('activo', 'inactivo'))
);

CREATE TABLE segmento_cliente (
    id_segmento_cliente INT PRIMARY KEY,
    nombre_segmento_cliente VARCHAR(50) NOT NULL UNIQUE,
    estado_segmento_cliente VARCHAR(15) NOT NULL,
    CONSTRAINT ck_nombre_segmento_cliente
        CHECK (nombre_segmento_cliente IN (
            'particular',
            'retail_comercio',
            'salud_farmaceutico',
            'tecnologia_electronica',
            'alimentos_bebidas',
            'educativo',
            'mayorista_distribucion',
            'industrial_manufactura',
            'servicios'
        )),
    CONSTRAINT ck_estado_segmento_cliente
        CHECK (estado_segmento_cliente IN ('activo', 'inactivo'))
);

-- =====================================================
-- TABLAS MAESTRAS
-- =====================================================

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    cedula_cliente VARCHAR(20) NOT NULL UNIQUE,
    nombre_cliente VARCHAR(150) NOT NULL,
    id_tipo_cliente INT NOT NULL,
    id_segmento_cliente INT NOT NULL,
    telefono VARCHAR(30),
    correo VARCHAR(100),
    fecha_registro_cliente DATE NOT NULL,
    estado_cliente VARCHAR(15) NOT NULL,
    CONSTRAINT fk_cliente_tipo_cliente
        FOREIGN KEY (id_tipo_cliente)
        REFERENCES tipo_cliente(id_tipo_cliente),
    CONSTRAINT fk_cliente_segmento_cliente
        FOREIGN KEY (id_segmento_cliente)
        REFERENCES segmento_cliente(id_segmento_cliente),
    CONSTRAINT ck_estado_cliente
        CHECK (estado_cliente IN ('activo', 'inactivo'))
);

CREATE TABLE sede_cliente (
    id_sede_cliente INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    nombre_sede VARCHAR(150) NOT NULL,
    id_ubicacion INT NOT NULL,
    direccion_sede VARCHAR(200) NOT NULL,
    estado_sede VARCHAR(15) NOT NULL,
    CONSTRAINT fk_sede_cliente_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),
    CONSTRAINT fk_sede_cliente_ubicacion
        FOREIGN KEY (id_ubicacion)
        REFERENCES ubicacion(id_ubicacion),
    CONSTRAINT ck_estado_sede
        CHECK (estado_sede IN ('activa', 'inactiva'))
);

CREATE TABLE centro_distribucion (
    id_centro_distribucion INT PRIMARY KEY,
    nombre_centro VARCHAR(150) NOT NULL,
    tipo_centro VARCHAR(20) NOT NULL,
    id_ubicacion INT NOT NULL,
    estado_centro VARCHAR(15) NOT NULL,
    CONSTRAINT fk_centro_ubicacion
        FOREIGN KEY (id_ubicacion)
        REFERENCES ubicacion(id_ubicacion),
    CONSTRAINT ck_tipo_centro
        CHECK (tipo_centro IN ('principal', 'regional')),
    CONSTRAINT ck_estado_centro
        CHECK (estado_centro IN ('activo', 'inactivo'))
);

CREATE TABLE ruta (
    id_ruta INT PRIMARY KEY,
    nombre_ruta VARCHAR(150) NOT NULL,
    zona_ruta VARCHAR(20) NOT NULL,
    distancia_km DECIMAL(10,2) NOT NULL,
    tipo_ruta VARCHAR(20) NOT NULL,
    estado_ruta VARCHAR(15) NOT NULL,
    CONSTRAINT ck_zona_ruta
        CHECK (zona_ruta IN (
            'Central',
            'Brunca',
            'Chorotega',
            'Huetar_Caribe',
            'Pacifico_Central',
            'Huetar_Norte'
        )),
    CONSTRAINT ck_distancia_km_no_negativa
        CHECK (distancia_km >= 0),
    CONSTRAINT ck_tipo_ruta
        CHECK (tipo_ruta IN ('urbana', 'interurbana', 'regional')),
    CONSTRAINT ck_estado_ruta
        CHECK (estado_ruta IN ('activa', 'inactiva'))
);

CREATE TABLE transportista (
    id_transportista INT PRIMARY KEY,
    id_centro_distribucion INT NOT NULL,
    cedula_transportista VARCHAR(20) NOT NULL UNIQUE,
    nombre_transportista VARCHAR(150) NOT NULL,
    medio_transporte VARCHAR(20) NOT NULL,
    zona_asignada VARCHAR(20) NOT NULL,
    telefono_contacto VARCHAR(30),
    correo_contacto VARCHAR(100),
    estado_transportista VARCHAR(15) NOT NULL,
    CONSTRAINT fk_transportista_centro
        FOREIGN KEY (id_centro_distribucion)
        REFERENCES centro_distribucion(id_centro_distribucion),
    CONSTRAINT uq_transportista_centro
        UNIQUE (id_transportista, id_centro_distribucion),
    CONSTRAINT ck_cedula_transportista_numerica
        CHECK (cedula_transportista ~ '^[0-9]+$'),
    CONSTRAINT ck_medio_transporte
        CHECK (medio_transporte IN ('motocicleta', 'carro', 'camion', 'bicicleta')),
    CONSTRAINT ck_zona_asignada
        CHECK (zona_asignada IN (
            'Central',
            'Brunca',
            'Chorotega',
            'Huetar_Caribe',
            'Pacifico_Central',
            'Huetar_Norte'
        )),
    CONSTRAINT ck_estado_transportista
        CHECK (estado_transportista IN ('activo', 'inactivo'))
);

CREATE TABLE tipo_envio (
    id_tipo_envio INT PRIMARY KEY,
    nombre_tipo_envio VARCHAR(100) NOT NULL,
    descripcion_tipo_envio VARCHAR(200),
    tiempo_prometido_base_horas INT NOT NULL,
    prioridad_servicio VARCHAR(10) NOT NULL,
    estado_tipo_envio VARCHAR(15) NOT NULL,
    CONSTRAINT ck_tiempo_prometido_base_horas_no_negativo
        CHECK (tiempo_prometido_base_horas >= 0),
    CONSTRAINT ck_prioridad_servicio
        CHECK (prioridad_servicio IN ('baja', 'media', 'alta')),
    CONSTRAINT ck_estado_tipo_envio
        CHECK (estado_tipo_envio IN ('activo', 'inactivo'))
);

-- =====================================================
-- TABLAS INTERMEDIAS
-- =====================================================

CREATE TABLE centro_ruta (
    id_centro_ruta INT PRIMARY KEY,
    id_centro_distribucion INT NOT NULL,
    id_ruta INT NOT NULL,
    estado_asignacion VARCHAR(15) NOT NULL,
    fecha_inicio_asignacion DATE NOT NULL,
    fecha_fin_asignacion DATE,
    CONSTRAINT fk_centro_ruta_centro
        FOREIGN KEY (id_centro_distribucion)
        REFERENCES centro_distribucion(id_centro_distribucion),
    CONSTRAINT fk_centro_ruta_ruta
        FOREIGN KEY (id_ruta)
        REFERENCES ruta(id_ruta),
    CONSTRAINT uq_centro_ruta
        UNIQUE (id_centro_distribucion, id_ruta, fecha_inicio_asignacion),
    CONSTRAINT uq_centro_ruta_fk
        UNIQUE (id_centro_distribucion, id_ruta),
    CONSTRAINT ck_estado_asignacion_centro_ruta
        CHECK (estado_asignacion IN ('activa', 'inactiva', 'cerrada')),
    CONSTRAINT ck_fechas_centro_ruta
        CHECK (fecha_fin_asignacion IS NULL OR fecha_fin_asignacion >= fecha_inicio_asignacion)
);

CREATE TABLE transportista_ruta (
    id_transportista_ruta INT PRIMARY KEY,
    id_transportista INT NOT NULL,
    id_centro_distribucion INT NOT NULL,
    id_ruta INT NOT NULL,
    estado_asignacion VARCHAR(15) NOT NULL,
    fecha_inicio_asignacion DATE NOT NULL,
    fecha_fin_asignacion DATE,
    CONSTRAINT fk_transportista_ruta_transportista_centro
        FOREIGN KEY (id_transportista, id_centro_distribucion)
        REFERENCES transportista(id_transportista, id_centro_distribucion),
    CONSTRAINT fk_transportista_ruta_centro_ruta
        FOREIGN KEY (id_centro_distribucion, id_ruta)
        REFERENCES centro_ruta(id_centro_distribucion, id_ruta),
    CONSTRAINT uq_transportista_ruta
        UNIQUE (id_transportista, id_centro_distribucion, id_ruta, fecha_inicio_asignacion),
    CONSTRAINT ck_estado_asignacion_transportista_ruta
        CHECK (estado_asignacion IN ('activa', 'inactiva', 'cerrada')),
    CONSTRAINT ck_fechas_transportista_ruta
        CHECK (fecha_fin_asignacion IS NULL OR fecha_fin_asignacion >= fecha_inicio_asignacion)
);

-- =====================================================
-- TABLA OPERATIVA PRINCIPAL
-- =====================================================

CREATE TABLE envio (
    id_envio INT PRIMARY KEY,
    id_sede_cliente INT NOT NULL,
    id_transportista_ruta INT NOT NULL,
    id_tipo_envio INT NOT NULL,
    fecha_registro_envio DATE NOT NULL,
    fecha_prometida_entrega DATE NOT NULL,
    fecha_real_entrega DATE,
    estado_envio VARCHAR(15) NOT NULL,
    monto_facturado DECIMAL(12,2) NOT NULL,
    costo_operativo_estimado DECIMAL(12,2),
    observaciones_envio VARCHAR(250),
    CONSTRAINT fk_envio_sede_cliente
        FOREIGN KEY (id_sede_cliente)
        REFERENCES sede_cliente(id_sede_cliente),
    CONSTRAINT fk_envio_transportista_ruta
        FOREIGN KEY (id_transportista_ruta)
        REFERENCES transportista_ruta(id_transportista_ruta),
    CONSTRAINT fk_envio_tipo_envio
        FOREIGN KEY (id_tipo_envio)
        REFERENCES tipo_envio(id_tipo_envio),
    CONSTRAINT ck_estado_envio
        CHECK (estado_envio IN (
            'registrado',
            'en_ruta',
            'entregado',
            'retrasado',
            'devuelto',
            'cancelado'
        )),
    CONSTRAINT ck_monto_facturado_no_negativo
        CHECK (monto_facturado >= 0),
    CONSTRAINT ck_costo_operativo_estimado_no_negativo
        CHECK (costo_operativo_estimado IS NULL OR costo_operativo_estimado >= 0),
    CONSTRAINT ck_fecha_prometida_mayor_igual_registro
        CHECK (fecha_prometida_entrega >= fecha_registro_envio),
    CONSTRAINT ck_fecha_real_mayor_igual_registro
        CHECK (fecha_real_entrega IS NULL OR fecha_real_entrega >= fecha_registro_envio)
);

-- =====================================================
-- DETALLE DE PAQUETES
-- =====================================================

CREATE TABLE paquete (
    id_paquete INT PRIMARY KEY,
    id_envio INT NOT NULL,
    tipo_paquete VARCHAR(30) NOT NULL,
    peso_kg DECIMAL(10,2) NOT NULL,
    alto_cm DECIMAL(10,2) NOT NULL,
    ancho_cm DECIMAL(10,2) NOT NULL,
    largo_cm DECIMAL(10,2) NOT NULL,
    valor_declarado DECIMAL(12,2),
    requiere_manejo_especial BOOLEAN NOT NULL,
    CONSTRAINT fk_paquete_envio
        FOREIGN KEY (id_envio)
        REFERENCES envio(id_envio),
    CONSTRAINT ck_tipo_paquete
        CHECK (tipo_paquete IN (
            'documento',
            'caja_pequena',
            'caja_mediana',
            'caja_grande',
            'fragil'
        )),
    CONSTRAINT ck_peso_kg_no_negativo
        CHECK (peso_kg >= 0),
    CONSTRAINT ck_alto_cm_no_negativo
        CHECK (alto_cm >= 0),
    CONSTRAINT ck_ancho_cm_no_negativo
        CHECK (ancho_cm >= 0),
    CONSTRAINT ck_largo_cm_no_negativo
        CHECK (largo_cm >= 0),
    CONSTRAINT ck_valor_declarado_no_negativo
        CHECK (valor_declarado IS NULL OR valor_declarado >= 0)
);

-- =====================================================
-- INCIDENCIAS
-- =====================================================

CREATE TABLE incidencia (
    id_incidencia INT PRIMARY KEY,
    id_envio INT NOT NULL,
    id_paquete INT,
    fecha_incidencia DATE NOT NULL,
    tipo_incidencia VARCHAR(30) NOT NULL,
    descripcion_incidencia VARCHAR(250),
    nivel_severidad VARCHAR(10) NOT NULL,
    estado_incidencia VARCHAR(15) NOT NULL,
    causante_incidencia VARCHAR(20) NOT NULL,
    CONSTRAINT fk_incidencia_envio
        FOREIGN KEY (id_envio)
        REFERENCES envio(id_envio),
    CONSTRAINT fk_incidencia_paquete
        FOREIGN KEY (id_paquete)
        REFERENCES paquete(id_paquete),
    CONSTRAINT ck_tipo_incidencia
        CHECK (tipo_incidencia IN (
            'paquete_danado',
            'retraso_operativo',
            'direccion_incorrecta',
            'ausencia_cliente',
            'articulo_incorrecto',
            'paquete_extraviado',
            'error_documentacion',
            'otro'
        )),
    CONSTRAINT ck_nivel_severidad
        CHECK (nivel_severidad IN ('baja', 'media', 'alta', 'critica')),
    CONSTRAINT ck_estado_incidencia
        CHECK (estado_incidencia IN ('abierta', 'en_proceso', 'resuelta')),
    CONSTRAINT ck_causante_incidencia
        CHECK (causante_incidencia IN (
            'transportista',
            'centro_distribucion',
            'cliente',
            'sistema',
            'externo',
            'no_identificado'
        ))
);

-- =====================================================
-- DEVOLUCIONES
-- =====================================================

CREATE TABLE devolucion (
    id_devolucion INT PRIMARY KEY,
    id_envio INT NOT NULL UNIQUE,
    fecha_devolucion DATE NOT NULL,
    motivo_devolucion VARCHAR(30) NOT NULL,
    costo_devolucion DECIMAL(12,2),
    estado_devolucion VARCHAR(15) NOT NULL,
    tipo_resolucion VARCHAR(20) NOT NULL,
    monto_reembolso DECIMAL(12,2),
    compensacion_adicional BOOLEAN NOT NULL DEFAULT FALSE,
    comentarios_devolucion VARCHAR(250),
    CONSTRAINT fk_devolucion_envio
        FOREIGN KEY (id_envio)
        REFERENCES envio(id_envio),
    CONSTRAINT ck_motivo_devolucion
        CHECK (motivo_devolucion IN (
            'direccion_incorrecta',
            'rechazo_del_paquete',
            'cliente_ausente',
            'paquete_danado',
            'articulo_incorrecto',
            'error_documentacion',
            'otro'
        )),
    CONSTRAINT ck_estado_devolucion
        CHECK (estado_devolucion IN ('abierta', 'en_proceso', 'cerrada')),
    CONSTRAINT ck_tipo_resolucion
        CHECK (tipo_resolucion IN (
            'reposicion',
            'reembolso',
            'credito_favor',
            'sin_resolucion',
            'otro'
        )),
    CONSTRAINT ck_monto_reembolso_no_negativo
        CHECK (monto_reembolso IS NULL OR monto_reembolso >= 0),
    CONSTRAINT ck_costo_devolucion_no_negativo
        CHECK (costo_devolucion IS NULL OR costo_devolucion >= 0)
);

COMMIT;
