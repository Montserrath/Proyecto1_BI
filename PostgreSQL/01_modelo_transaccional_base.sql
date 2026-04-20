BEGIN;
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
