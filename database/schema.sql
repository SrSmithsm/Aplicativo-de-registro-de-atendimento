-- =====================================
-- TABELAS BASE
-- =====================================

CREATE TABLE pessoa (
    id_pessoa SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cadastro_completo BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    id_pessoa INT UNIQUE,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    email_verificado BOOLEAN DEFAULT FALSE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    id_pessoa INT UNIQUE,

    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE atendente (
    id_atendente SERIAL PRIMARY KEY,
    id_pessoa INT UNIQUE,
    setor VARCHAR(100),
    status VARCHAR(50),

    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

-- =====================================
-- FILA E RELACIONAMENTOS
-- =====================================

CREATE TABLE fila (
    id_fila SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_servico VARCHAR(100),
    status VARCHAR(50)
);

CREATE TABLE atendente_fila (
    id_atendente INT,
    id_fila INT,

    PRIMARY KEY (id_atendente, id_fila),

    FOREIGN KEY (id_atendente) REFERENCES atendente(id_atendente),
    FOREIGN KEY (id_fila) REFERENCES fila(id_fila)
);

CREATE TABLE prioridade (
    id_prioridade SERIAL PRIMARY KEY,
    descricao VARCHAR(100),
    nivel INT NOT NULL,
    peso_tempo_espera FLOAT DEFAULT 1.0
);

-- =====================================
-- AGENDAMENTO
-- =====================================

CREATE TABLE horario_disponivel (
    id_horario SERIAL PRIMARY KEY,
    id_fila INT,
    inicio TIMESTAMP NOT NULL,
    fim TIMESTAMP NOT NULL,
    ocupado BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_fila) REFERENCES fila(id_fila)
);

CREATE TABLE agendamento (
    id_agendamento SERIAL PRIMARY KEY,
    id_cliente INT,
    id_fila INT,
    id_prioridade INT,
    id_horario INT,
    status VARCHAR(50),

    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_fila) REFERENCES fila(id_fila),
    FOREIGN KEY (id_prioridade) REFERENCES prioridade(id_prioridade),
    FOREIGN KEY (id_horario) REFERENCES horario_disponivel(id_horario)
);

CREATE TABLE checkin (
    id_checkin SERIAL PRIMARY KEY,
    id_agendamento INT UNIQUE,
    horario_checkin TIMESTAMP,
    confirmado BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento)
);

-- =====================================
-- ATENDIMENTO
-- =====================================

CREATE TABLE atendimento (
    id_atendimento SERIAL PRIMARY KEY,
    id_cliente INT,
    id_atendente INT,
    id_fila INT,
    id_prioridade INT,
    id_agendamento INT,
    data_hora_inicio TIMESTAMP,
    data_hora_fim TIMESTAMP,
    status VARCHAR(50),

    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_atendente) REFERENCES atendente(id_atendente),
    FOREIGN KEY (id_fila) REFERENCES fila(id_fila),
    FOREIGN KEY (id_prioridade) REFERENCES prioridade(id_prioridade),
    FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento)
);

CREATE TABLE avaliacao (
    id_avaliacao SERIAL PRIMARY KEY,
    id_atendimento INT UNIQUE,
    nota INT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,

    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento)
);

-- =====================================
-- FILA EM TEMPO REAL
-- =====================================

CREATE TABLE senha (
    id_senha SERIAL PRIMARY KEY,
    id_fila INT,
    id_agendamento INT,
    numero INT NOT NULL,
    chamada_em TIMESTAMP,
    status VARCHAR(50),

    FOREIGN KEY (id_fila) REFERENCES fila(id_fila),
    FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento)
);

-- =====================================
-- NOTIFICAÇÕES
-- =====================================

CREATE TABLE notificacao (
    id_notificacao SERIAL PRIMARY KEY,
    id_usuario INT,
    tipo VARCHAR(50),
    mensagem TEXT,
    lida BOOLEAN DEFAULT FALSE,
    enviada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- =====================================
-- INTELIGÊNCIA / MÉTRICAS
-- =====================================

CREATE TABLE estimativa_atendimento (
    id_estimativa SERIAL PRIMARY KEY,
    id_fila INT,
    tempo_medio_minutos INT,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_fila) REFERENCES fila(id_fila)
);

-- =====================================
-- HISTÓRICO
-- =====================================

CREATE TABLE historico_status (
    id_historico SERIAL PRIMARY KEY,
    entidade VARCHAR(50),
    id_referencia INT,
    status_anterior VARCHAR(50),
    status_novo VARCHAR(50),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- ÍNDICES (performance)
-- =====================================

CREATE INDEX idx_agendamento_cliente ON agendamento(id_cliente);
CREATE INDEX idx_agendamento_fila ON agendamento(id_fila);
CREATE INDEX idx_atendimento_fila ON atendimento(id_fila);
CREATE INDEX idx_senha_fila ON senha(id_fila);
CREATE INDEX idx_notificacao_usuario ON notificacao(id_usuario);
